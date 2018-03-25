require 'test_helper'

class ListsServiceTest < ActiveSupport::TestCase

  test 'Api::ListsService#callは組織の配列を返す' do
    service = Api::ListsService.new
    lists = service.call
    assert_equal lists[0],
                 {id: 'org1',
                  name: '組織1',
                  maps: {json: 'test-city1.geojson',
                         lat: 33.596302,
                         lng: 130.410784,
                         zoom: 12}}
  end

  test 'Api::ListsService#callで得られる組織の情報はSymbolをキーにする' do
    service = Api::ListsService.new
    lists = service.call
    assert_equal lists[0][:name], '組織1'
  end
end
