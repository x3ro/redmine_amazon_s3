require 'redmine_s3/patches/attachment_patch'
require 'redmine_s3/patches/attachments_controller_patch'
require 'redmine_s3/patches/application_helper_patch'
require 'redmine_s3/thumbnail'
require 'redmine_s3/configuration'
require 'redmine_s3/connection'

AttachmentsController.send(:include, RedmineS3::AttachmentsControllerPatch)
Attachment.send(:include, RedmineS3::AttachmentPatch)
ApplicationHelper.send(:include, RedmineS3::ApplicationHelperPatch)
