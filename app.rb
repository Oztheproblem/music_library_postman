# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums/new' do
    return erb(:new_album)
  end

  get '/artists/new' do
    return erb(:new_artists)
  end

  get '/albums/:id' do
    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new

    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)

    return erb(:album)
  end

 get '/artists/:id' do
  repo = ArtistRepository.new
  @artist = repo.find(params[:id])
  return erb(:artist)
end

 get '/albums' do
  repo = AlbumRepository.new
  @albums = repo.all
  return erb(:albums_list)

end

get '/artists' do
  repo = ArtistRepository.new
  @artists = repo.all
  return erb(:artist_list)

end

post '/artists' do
  def invalid_request_parameters?
    return true if params[:name].nil? || params[:genre].nil?
    # Uncomment the following line if you want to check for empty strings
    # return true if params[:title] == "" || params[:release_year] == "" || params[:artist_id] == ""
  end

  return status 400 if invalid_request_parameters?

  repo = ArtistRepository.new
  new_artist = Artist.new
  # new_artist.id = params[:id]
  new_artist.name = params[:name]
  new_artist.genre = params[:genre]
  repo.create(new_artist)  

  erb(:artist_post_created)
end

post '/albums' do
  def invalid_request_parameters?
    return true if params[:title].nil? || params[:release_year].nil? || params[:artist_id].nil?
    # Uncomment the following line if you want to check for empty strings
    # return true if params[:title] == "" || params[:release_year] == "" || params[:artist_id] == ""
  end

  return status 400 if invalid_request_parameters?

  repo = AlbumRepository.new
  new_album = Album.new
  new_album.title = params[:title]
  new_album.release_year = params[:release_year]
  new_album.artist_id = params[:artist_id]
  repo.create(new_album)

  erb :album_post_created
end




  get '/' do
    @password = params[:password]
   
   return erb(:index)
 end
end