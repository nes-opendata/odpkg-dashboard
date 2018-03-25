require 'test_helper'

class ListServiceTest < ActiveSupport::TestCase

  test "Api::ListService#callはpolygon_tagとpoint_tagで検索した結果を返す" do

    price_json = File.read(File.join(Rails.root, 'test/fixtures/files/ckan_package_price.json'))
    location_json = File.read(File.join(Rails.root, 'test/fixtures/files/ckan_package_location.json'))

    api_service_stub = Proc.new do ## mock object of Ckan::ApiService
      Proc.new do
        Faraday.new do |builder|
          builder.response :multi_json, :symbolize_keys => true
          builder.adapter :test do |stub|
            stub.get('/action/package_search?q=organization%3A%28org1%29+AND+tags%3A%28price%29&rows=999') do |env|
              [ 200, {}, price_json]
            end
            stub.get('/action/package_search?q=organization%3A%28org1%29+AND+tags%3A%28location%29&rows=999') do |env|
              [ 200, {}, location_json]
            end
          end
        end
      end
    end

    Ckan::ApiService.stub :new, api_service_stub  do
      service = Api::ListService.new("org1")
      list = service.call
      assert_equal ["Data Explorer Examples"], list[:groups]
      assert_equal "CSV ", list[:polygons][0][:name]
      assert_equal "UK Cycle Storage Locations", list[:points][0][:name]
    end
  end

  test 'Api::ListService#callは不正な名前にはServiceErrorを返す' do
    assert_raise(ServiceError) do
      service = Api::ListService.new('invalid_name!!')
      service.call
    end
  end
end
