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

  context 'GET /albums/:id' do
    before(:each) do 
      reset_albums_table
    end
    it 'should return info about album2' do
      response = get('/albums/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end
  end  

  context 'GET /albums' do
    before(:each) do 
      reset_albums_table
    end

    it 'should return list of albums' do
    response = get('/albums')

    expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

    expect(response.status).to eq(200)
    expect(response.body).to eq(expected_response)
    
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

  # context 'GET /' do
  #   it 'returns a list of names' do
  #     response = get('/')

  #     expect(response.body).to include('<p>Anna</p>')
  #     expect(response.body).to include('<p>Kim</p>')
  #     expect(response.body).to include('<p>James</p>')
  #     expect(response.body).to include('<p>David</p>')
  #   end
  # end  


  # context 'GET /' do
  #   it 'returns the html index' do
  #     response = get('/')

  #     expect(response.body).to include('h1>Hello!</h1>')
  #   end
  # end  
  # context 'GET /' do
  #   it 'returns the html message with name' do
  #     response = get('/', name: "Ozzy")

  #     expect(response.body).to include('h1>Hello Ozzy!</h1>')
  #   end
  # end  

  # context 'GET /' do
  #   it 'returns the html message with name' do
  #     response = get('/', name: "Obi")

  #     expect(response.body).to include('h1>Hello Obi!</h1>')
  #   end
  # end  
end