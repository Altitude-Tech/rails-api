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
    # Test successful selection of all devices using fixtures
    ##
    test 'index get all devices' do
      expected = {
        devices: [
          {
            device_id: '1234',
            device_type: Device::TYPE_TEST,
            device_name: Device::TYPE_TEST_RAW
          },
          {
            device_id: '4567',
            device_type: Device::TYPE_TEST,
            device_name: Device::TYPE_TEST_RAW
          }
        ]
      }

      get(:index)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:success)
    end

    ##
    # Test error handling of invalid argument for start parameter
    ##
    test 'index invalid start' do
      expected = { error: I18n.t('controller.v1_devices.error.start') }

      get(:index, params: { start: 'invalid' })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling of too low value of start parameter
    ##
    test 'index too low start' do
      expected = { error: I18n.t('controller.v1_devices.error.start') }

      get(:index, params: { start: 0 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling of invalid argument for limit parameter
    ##
    test 'index invalid limit' do
      expected = { error: I18n.t('controller.v1_devices.error.limit', max: 500) }

      get(:index, params: { limit: 'invalid' })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling of too low value of limit parameter
    ##
    test 'index too low limit' do
      expected = { error: I18n.t('controller.v1_devices.error.limit', max: 500) }

      get(:index, params: { limit: 0 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling of too high value of limit parameter
    ##
    test 'index too high limit' do
      expected = { error: I18n.t('controller.v1_devices.error.limit', max: 500) }

      get(:index, params: { limit: 501 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test success of lower limit parameter
    ##
    test 'index lower limit' do
      expected = {
        devices: [
          {
            device_id: '1234',
            device_type: Device::TYPE_TEST,
            device_name: Device::TYPE_TEST_RAW
          }
        ]
      }

      get(:index, params: { limit: 1 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:success)
    end

    ##
    # Test success of upper limit parameter
    ##
    test 'index upper limit' do
      expected = {
        devices: [
          {
            device_id: '1234',
            device_type: Device::TYPE_TEST,
            device_name: Device::TYPE_TEST_RAW
          },
          {
            device_id: '4567',
            device_type: Device::TYPE_TEST,
            device_name: Device::TYPE_TEST_RAW
          }
        ]
      }

      get(:index, params: { limit: 500 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:success)
    end

    ##
    # Test retrieving out-of-bounds indicies
    ##
    test 'index start out-of-bounds' do
      expected = { error: I18n.t('controller.v1_devices.error.no_more') }

      get(:index, params: { start: 3 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test invalid device id
    ##
    test 'show get invalid device' do
      args = { model: 'device', key: 'id', value: 'invalid' }
      expected = {
        error: I18n.t('controller.v1.error.not_found', args)
      }

      get(:show, params: { id: 'invalid' })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:not_found)
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
      assert_response(:success)
    end

    test 'create successful' do
      data = BASE_DATA.deep_dup
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:success)
    end

    ##
    #
    ##
    test 'create invalid device id' do
      data = BASE_DATA.deep_dup
      data[:device_id] = 'invalid'
      expected = {
        error: I18n.t('controller.v1.error.invalid_value', key: 'device_id')
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
        error: I18n.t('controller.v1.error.invalid_value', key: 'device_id')
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
        error: I18n.t('controller.v1.error.invalid_value', key: 'device_type')
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
        error: I18n.t('controller.v1.error.invalid_value', key: 'device_type')
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
        error: I18n.t('controller.v1.error.unknown_key', key: 'foo')
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end
  end
end
