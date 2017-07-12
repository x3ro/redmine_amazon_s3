require 'open-uri'


module AmazonS3
  module PdfImageLoaderPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do

        def get_image_file(image_uri)
          network_aware_get_image_file(image_uri)
        end
      end
    end

    module InstanceMethods
      @@k_path_cache = Rails.root.join("tmp").to_s
      # Get image file from remote URL
      # [@param string :image_uri] image URI path
      #
      def network_aware_get_image_file(image_uri)
        image_uri = File.join(File.dirname(image_uri),  ERB::Util.url_encode(File.basename(image_uri)))
        uri = URI.parse(image_uri)
        extname = File.extname(uri.path)

        #use a temporary file....
        tmpFile = Tempfile.new(['tmp_', extname], @@k_path_cache)
        tmpFile.binmode

        tmpFile.print uri.read
        tmpFile
        ensure
          tmpFile.close  unless tmpFile.nil?
        end
      end
    end
  end
