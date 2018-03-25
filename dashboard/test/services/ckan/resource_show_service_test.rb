require 'test_helper'

class Ckan::ResourceShowServiceTest < ActiveSupport::TestCase

  test 'CKANのAPIを呼び出すと正常な結果が返ってくる' do

    sample_json = File.read(File.join(Rails.root, 'test/fixtures/files/ckan_resource_show.json'))

    api_service_stub = Proc.new do ## mock object of Ckan::ApiService
      Proc.new do
        Faraday.new do |builder|
          builder.response :multi_json, :symbolize_keys => true
          builder.adapter :test do |stub|
            stub.get('/action/resource_show?id=0c2bd47a-6ac5-412e-a337-1b45a952e07e') do |env|
              [ 200, {}, sample_json]
            end
          end
        end
      end
    end

    Ckan::ApiService.stub :new, api_service_stub  do
      service = Ckan::ResourceShowService.new('0c2bd47a-6ac5-412e-a337-1b45a952e07e')
      results = service.call
      assert_equal 'active', results[:state]
      assert_equal '0c2bd47a-6ac5-412e-a337-1b45a952e07e', results[:id]
      assert_equal 'December 2011', results[:name]
    end
  end
end
