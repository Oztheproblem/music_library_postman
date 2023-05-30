require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  def reset_albums_table
    seed_sql = File.read('spec/seeds/albums_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /album' do
    before(:each) do 
      reset_albums_table
    end

    it 'should return list of albums' do
    response = get('/album')

    expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

    expect(response.status).to eq(200)
    expect(response.body).to eq(expected_response)
    
    end
  end  
end
