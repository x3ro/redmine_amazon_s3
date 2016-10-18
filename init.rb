require 'amazon_s3'
require_dependency 'amazon_s3_hooks'

Redmine::Plugin.register :redmine_s3 do
  name 'S3'
  author 'tka'
  description 'Use Amazon S3 as a storage engine for attachments'
  version '0.1.0'
end
