require 'test_helper'

module V1
  class TokensControllerTest < ActionController::TestCase
    ##
    # Tests success of `create` method.
    ##
    test 'create_success' do
      post :create

      resp_json = JSON.parse(response.body)

      assert_equal JSON_TYPE, response.content_type
      assert_response :ok

      assert resp_json.key? 'token'
      t = Token.find(resp_json['token'])
      assert t.active?
    end
  end
end
