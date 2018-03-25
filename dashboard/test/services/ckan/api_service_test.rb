require 'test_helper'

class Ckan::ApiServiceTest < ActiveSupport::TestCase

  test '設定したURL prefixを取得する' do
    url = 'http://opendata.example.com/api/3'
    service = Ckan::ApiService.new(url)
    api = service.call
    assert_equal URI.parse(url), api.url_prefix
  end
end
