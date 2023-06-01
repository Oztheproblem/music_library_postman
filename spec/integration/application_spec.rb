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

  def reset_artists_table
    seed_sql = File.read('spec/seeds/artists_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end
  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

 
  context 'GET /albums/:id' do
    before(:each) do 
      reset_albums_table
      reset_artists_table
    end
    it 'should return info about album2' do
      response = get('/albums/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end
  end  


  context 'GET /artists/:id' do
    it 'should return info about artist id' do
      response = get('/artists/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>ABBA</h1>')
      expect(response.body).to include('Pop')
    end
  end  

  context 'Get /albums' do
    it 'returns a list of albums as HTML links' do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a><br />')
      expect(response.body).to include('<a href="/albums/3">Waterloo</a><br />')
      expect(response.body).to include('<a href="/albums/4">Super Trouper</a><br />')
    end
  end

  context 'Get /artists' do
    it 'returns a list of artists as HTML links' do
      response = get('/artists')
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/1">Pixies</a>')
    end
  end

  context 'POST /albums' do
    it 'should create a new album' do
    response = post(
      '/albums', 
      title: 'Voyage', 
      release_year: '2022', 
      artist_id: '2'
    )
    
    expect(response.status).to eq(200)
    expect(response.body).to eq('')

    response = get('/albums')

    expect(response.body).to include('Voyage')
    end
  end  

  context 'GET /' do
    it 'returns a hello page if password is correct' do
      response = get('/', password: 'abcd')

      expect(response.body).to include('Hello!')
    end

    it 'returns a forbidden page if password is incorrect' do
      response = get('/', password: 'abooo')

      expect(response.body).to include('Access Forbidden')
    end
  end 
end