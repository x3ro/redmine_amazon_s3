
namespace :amazon_s3 do
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.verbose = true
    t.warning = false
    t.test_files = FileList['plugins/amazon_s3/test/unit/*_test.rb']
  end
end
