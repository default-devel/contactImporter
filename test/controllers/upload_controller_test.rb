require "test_helper"

class Contact::UploadControllerTest < ActionDispatch::IntegrationTest
  test "should get import" do
    get contact_upload_import_url
    assert_response :success
  end

  test "should get review" do
    get contact_upload_review_url
    assert_response :success
  end

  test "should get update" do
    get contact_upload_update_url
    assert_response :success
  end
end
