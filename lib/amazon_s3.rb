require 'amazon_s3/patches/attachment_patch'
require 'amazon_s3/patches/attachments_controller_patch'
require 'amazon_s3/patches/application_helper_patch'
require 'amazon_s3/thumbnail'
require 'amazon_s3/configuration'
require 'amazon_s3/connection'

AttachmentsController.send(:include, AmazonS3::AttachmentsControllerPatch)
Attachment.send(:include, AmazonS3::AttachmentPatch)
ApplicationHelper.send(:include, AmazonS3::ApplicationHelperPatch)
