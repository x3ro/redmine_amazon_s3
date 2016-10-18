require File.expand_path("../../test_helper", __FILE__)

include AmazonS3

class ConfigurationTest < ActiveSupport::TestCase

  test "basic aws functionality" do
    if Configuration.get.access_key_id.nil?
      skip "Skipping AWS tests because it is not configured for the test environment"
    end

    # Use for debugging
    # Aws.config[:http_wire_trace] = true

    body = "#{File.read(__FILE__)}#{Random.new_seed}"
    filename = "foobar.rb"
    Connection.put(filename, __FILE__, body)
    assert Connection.object_url(filename).include? filename
    assert_equal body, Connection.get(filename)
    Connection.delete(filename)
  end

end
