require File.expand_path("../../test_helper", __FILE__)

class ConfigurationTest < ActiveSupport::TestCase

  setup do
    @config = RedmineS3::Configuration.new
  end

  test "singleton" do
    config = RedmineS3::Configuration.get
    original_bucket = config.bucket

    config = RedmineS3::Configuration.get
    config.set({:bucket => "test123"})
    assert_equal "test123", config.bucket

    config = RedmineS3::Configuration.get
    assert_equal "test123", config.bucket

    config.set({:bucket => original_bucket})
  end

  test "configuration instances must not have shared state" do
    config1 = RedmineS3::Configuration.new
    config2 = RedmineS3::Configuration.new
    config1.set({:bucket => "config1"})
    config2.set({:bucket => "config2"})

    assert_equal "config1", config1.bucket
    assert_equal "config2", config2.bucket
  end

  test "fail on unknown config option" do
    assert_raises(RedmineS3::ConfigurationError) do
      @config.set({:foobar => "baz"})
    end
  end

  test "load configuration from file" do
    path = File.expand_path('../../../test/config/s3.yml', __FILE__)
    @config.load(path)
    assert_equal "access_key_id value", @config.access_key_id
    assert_equal "secret_access_key value", @config.secret_access_key
    assert_equal "bucket value", @config.bucket
    assert_equal "region value", @config.region
    assert_equal "uploads_folder value/", @config.uploads_folder
    assert_equal "thumbnails_folder value/", @config.thumbnails_folder
  end

  test "access_key_id getter" do
    assert_equal nil, @config.access_key_id
    @config.set({:access_key_id => "some value"})
    assert_equal "some value", @config.access_key_id
  end

  test "secret_access_key getter" do
    assert_equal nil, @config.secret_access_key
    @config.set({:secret_access_key => "some value"})
    assert_equal "some value", @config.secret_access_key
  end

  test "bucket getter" do
    assert_equal nil, @config.bucket
    @config.set({:bucket => "some value"})
    assert_equal "some value", @config.bucket
  end

  test "region getter" do
    assert_equal nil, @config.region
    @config.set({:region => "eu-central-1"})
    assert_equal "eu-central-1", @config.region
  end

  test "uploads_folder getter" do
    assert_equal "", @config.uploads_folder

    @config.set({:uploads_folder => nil})
    assert_equal "", @config.uploads_folder

    @config.set({:uploads_folder => "   "})
    assert_equal "", @config.uploads_folder

    @config.set({:uploads_folder => "foobar"})
    assert_equal "foobar/", @config.uploads_folder
  end

  test "thumbnails_folder getter" do
    assert_equal "thumbnails/", @config.thumbnails_folder

    @config.set({:thumbnails_folder => nil})
    assert_equal "thumbnails/", @config.thumbnails_folder

    @config.set({:thumbnails_folder => "   "})
    assert_equal "thumbnails/", @config.thumbnails_folder

    @config.set({:thumbnails_folder => "foobar"})
    assert_equal "foobar/", @config.thumbnails_folder
  end

end
