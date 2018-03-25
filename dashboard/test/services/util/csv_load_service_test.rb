require 'test_helper'

class Util::CsvLoadServiceTest < ActiveSupport::TestCase

  test 'CSVを取得すると正常な結果が返ってくる' do

    sample_csv = File.read(File.join(Rails.root, 'test/fixtures/files/kyoto_dist_id_h28-11-09.csv'))

    faraday_stub = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('/sample.csv') do |env|
          [ 200, {}, sample_csv]
        end
      end
    end
    res_stub = faraday_stub.get('/sample.csv')

    Faraday.stub :get,  res_stub do
      url = 'http://opendata.example.com/sample.csv'
      format = 'CSV'
      service = Util::CsvLoadService.new(url, format)
      results = service.call
      assert_equal ['dist_id', '名　称'], results[0]
      assert_equal ['1','北区'], results[1]
    end
  end
end
