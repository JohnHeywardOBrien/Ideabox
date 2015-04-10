
require 'bundler'
Bundler.require

require './idea'
require 'sqlite3'
require 'sinatra/activerecord'
require 'active_record'
require 'rake'


# dbconfig = YAML::load(File.open('database.yml'))
# ActiveRecord::Base.establish_connection(dbconfig)

require './lib/models/dc_cal'
require './lib/models/dc_cal_create'

# class DcCalERB < Sinatra::Base
#   get '/' do
#     @dccal = DcCal.find(1)
    
#     erb :dccal
#   end
# end

class IdeaBoxApp < Sinatra::Base
  set :method_override, true

  get '/' do
    @dccal = DcCal.find(1)
    erb :index, locals: {ideas: Idea.all}
  end
  
  not_found do
    erb :error
  end
  
  post '/' do
    # 1: create an idea
    idea = Idea.new(params['idea_title'], params['idea_description'])    
    # 2: store it
    idea.save
    # 3: send us back to index to see all ideas
    redirect '/'
  end
  
  delete '/:id' do |id|
    Idea.delete(id.to_i)
    redirect '/'
  end
  
  get '/:id/edit' do |id|
    idea = Idea.find(id.to_i)
    erb :edit, locals: {id: id, idea: idea}
  end
  
  put '/:id' do |id|
    data = {
      :title => params['idea_title'],
      :description => params['idea_description']
    }
    Idea.update(id.to_i, data)
    redirect '/'
  end


end

