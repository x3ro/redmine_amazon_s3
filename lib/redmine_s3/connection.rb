require 'aws-sdk'

module RedmineS3
  class Connection
    @@client = nil
    @@config = Configuration.get

    class << self

      def establish_connection
        options = {
          :access_key_id => @@config.access_key_id,
          :secret_access_key => @@config.secret_access_key,
          :region => @@config.region
        }

        @client = Aws::S3::Client.new(options)
      end

      def client
        @@client || establish_connection
      end

      def bucket
        resource = Aws::S3::Resource.new(client: self.client)
        resource.bucket(@@config.bucket)
      end

      def create_bucket
        bucket.create unless bucket.exists?
      end

      def object(filename, target_folder = @@config.uploads_folder)
        bucket.object(target_folder + filename)
      end

      def put(disk_filename, original_filename, data, content_type='application/octet-stream', target_folder = @@config.uploads_folder)
        object = self.object(disk_filename, target_folder)
        options = {}
        #options[:acl] = "public-read" unless self.private?
        options[:content_type] = content_type if content_type
        options[:content_disposition] = "inline; filename=#{ERB::Util.url_encode(original_filename)}"
        options[:body] = data
        object.put(options)
      end

      def delete(filename, target_folder = @@config.uploads_folder)
        object = self.object(filename, target_folder)
        object.delete
      end

      def object_url(filename, target_folder = @@config.uploads_folder)
        object = self.object(filename, target_folder)
        if self.private?
          options = {}
          options[:expires_in] = self.expires_in unless self.expires_in.nil?
          object.presigned_url(:get, options)
        else
          object.public_url
        end
      end

      def get(filename, target_folder = @@config.uploads_folder)
        object = self.object(filename, target_folder)
        object.get.body
      end
    end
  end
end
