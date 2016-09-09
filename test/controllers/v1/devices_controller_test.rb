##
# DevicesController tests
##

require 'test_helper'

module V1
  class DevicesControllerTest < ActionController::TestCase
    ##
    #
    ##
    BASE_DATA = {
      device_id: 2345,
      device_type: Device::TYPE_TEST
    }.freeze

    ##
    # Test invalid device id
    ##
    test 'show get invalid device' do
      args = { model: 'device', key: 'id', value: 'invalid' }
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.not_found', args),
        status: 400
      }

      get(:show, params: { id: 'invalid' })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test successful selection by device id
    ##
    test 'show get device' do
      expected = {
        device_id: '1234',
        device_type: Device::TYPE_TEST,
        device_name: Device::TYPE_TEST_RAW
      }

      get(:show, params: { id: 1234 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    test 'create successful' do
      data = BASE_DATA.deep_dup
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    #
    ##
    test 'create invalid device id' do
      data = BASE_DATA.deep_dup
      data[:device_id] = 'invalid'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'device_id'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    #
    ##
    test 'create missing device id' do
      data = BASE_DATA.deep_dup
      data.delete(:device_id)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'device_id'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    #
    ##
    test 'create invalid device type' do
      data = BASE_DATA.deep_dup
      data[:device_type] = 'invalid'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'device_type'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    #
    ##
    test 'create missing device type' do
      data = BASE_DATA.deep_dup
      data.delete(:device_type)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'device_type'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    #
    ##
    test 'create unknown param' do
      data = BASE_DATA.deep_dup
      data[:foo] = 'bar'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.unknown_key', key: 'foo'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end
  end
end
