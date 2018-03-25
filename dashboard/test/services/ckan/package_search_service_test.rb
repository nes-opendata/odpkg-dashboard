require 'test_helper'

class Ckan::PackageSearchServiceTest < ActiveSupport::TestCase

  test 'CKANのAPIを呼び出すと正常な結果が返ってくる' do

    sample_json = File.read(File.join(Rails.root, 'test/fixtures/files/ckan_package_search.json'))

    api_service_stub = Proc.new do ## mock object of Ckan::ApiService
      Proc.new do
        Faraday.new do |builder|
          builder.response :multi_json, :symbolize_keys => true
          builder.adapter :test do |stub|
            stub.get('/action/package_search?q=spending&rows=999') do |env|
              [ 200, {}, sample_json]
            end
          end
        end
      end
    end

    Ckan::ApiService.stub :new, api_service_stub  do
      service = Ckan::PackageSearchService.new('spending')
      results = service.call
      assert_equal 'active', results[0][:state]
    end
  end
end
