require 'aws-sdk'

module RedmineS3
  class Connection
    @@client = nil
    @@s3_options = {
      :access_key_id     => nil,
      :secret_access_key => nil,
      :bucket            => nil,
      :folder            => '',
      :private           => false,
      :expires           => nil,
      :proxy             => false,
      :thumb_folder      => 'tmp'
    }

    class << self
      def load_options
        file = ERB.new( File.read(File.join(Rails.root, 'config', 's3.yml')) ).result
        YAML::load( file )[Rails.env].each do |key, value|
          @@s3_options[key.to_sym] = value
        end
      end

      def establish_connection
        load_options unless @@s3_options[:access_key_id] && @@s3_options[:secret_access_key]
        options = {
          :access_key_id => @@s3_options[:access_key_id],
          :secret_access_key => @@s3_options[:secret_access_key],
          :region => self.region
        }

        @client = Aws::S3::Client.new(options)
      end

      def client
        @@client || establish_connection
      end

      def bucket
        load_options unless @@s3_options[:bucket]
        resource = Aws::S3::Resource.new(client: self.client)
        resource.bucket(@@s3_options[:bucket])
      end

      def create_bucket
        bucket.create unless bucket.exists?
      end

      def folder
        str = @@s3_options[:folder]
        if str.present?
          str.match(/\S+\//) ? str : "#{str}/"
        else
          ''
        end
      end

      def region
        @@s3_options[:region]
      end


      def expires_in
        @@s3_options[:expires_in]
      end

      def private?
        @@s3_options[:private]
      end

      def proxy?
        @@s3_options[:proxy]
      end

      def thumb_folder
        str = @@s3_options[:thumb_folder]
        if str.present?
          str.match(/\S+\//) ? str : "#{str}/"
        else
          'tmp/'
        end
      end

      def object(filename, target_folder = self.folder)
        bucket.object(target_folder + filename)
      end

      def put(disk_filename, original_filename, data, content_type='application/octet-stream', target_folder = self.folder)
        object = self.object(disk_filename, target_folder)
        options = {}
        options[:acl] = "public-read" unless self.private?
        options[:content_type] = content_type if content_type
        options[:content_disposition] = "inline; filename=#{ERB::Util.url_encode(original_filename)}"
        options[:body] = data
        object.put(options)
      end

      def delete(filename, target_folder = self.folder)
        object = self.object(filename, target_folder)
        object.delete
      end

      def object_url(filename, target_folder = self.folder)
        object = self.object(filename, target_folder)
        if self.private?
          options = {}
          options[:expires_in] = self.expires_in unless self.expires_in.nil?
          object.presigned_url(:get, options)
        else
          object.public_url
        end
      end

      def get(filename, target_folder = self.folder)
        object = self.object(filename, target_folder)
        object.get.body
      end
    end
  end
end
