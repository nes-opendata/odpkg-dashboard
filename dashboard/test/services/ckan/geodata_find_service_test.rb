require 'test_helper'

class Ckan::GeodataFindServiceTest < ActiveSupport::TestCase

  test 'CKANのAPIを呼び出すと正常な結果が返ってくる' do

    sample_json = File.read(File.join(Rails.root, 'test/fixtures/files/ckan_package_search.json'))

    api_service_stub = Proc.new do ## mock object of Ckan::ApiService
      Proc.new do
        Faraday.new do |builder|
          builder.response :multi_json, :symbolize_keys => true
          builder.adapter :test do |stub|
            stub.get('/action/package_search?q=organization%3A%28org1%29+AND+tags%3A%28spending%29&rows=999') do |env|
              [ 200, {}, sample_json]
            end
          end
        end
      end
    end

    Ckan::ApiService.stub :new, api_service_stub  do
      service = Ckan::GeodataFindService.new('org1', 'spending')
      results = service.call
      assert_equal "Data Explorer Examples", results[0][0]
      assert_equal "0c2bd47a-6ac5-412e-a337-1b45a952e07e", results[1][0][:id]
      assert_equal "December 2011", results[1][0][:name]
      assert_equal "November 2011", results[1][1][:name]
      assert_equal "September 2011", results[1][3][:name]
    end
  end
end
