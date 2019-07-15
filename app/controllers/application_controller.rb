require "open-uri"

class ApplicationController < Sinatra::Base
  # @number_of_shotened = 0

  register Sinatra::ActiveRecordExtension
  configure do
  	set :views, "app/views"
    set :public_dir, "public"
    #enables sessions as per Sinatra's docs. Session_secret is meant to encript the session id so that users cannot create a fake session_id to hack into your site without logging in. 
    enable :sessions
    set :session_secret, "secret"
  end


  # Renders the home or index page
  get '/' do
    @count = History.all.count
    # urls = Url.all
    # @count = urls.count
    @message = session[:message]
    if @message == nil 
      @message = "Please enter the new url"
    end
    erb :home, layout: :layout

  end

  # Renders the sign up/registration page in app/views/registrations/signup.erb
  get '/registrations/signup' do
    erb :'/registrations/signup'
  end

  post '/registrations' do
    user = User.create(name:params["name"], email:params["email"])
    user.password = params["psw"]
    user.save
    session[:user_id] = user.id
    puts session[:user_id]
    redirect '/users/home'
  end
  
  get '/sessions/login' do
    if session[:user_id]==nil
      erb :'/sessions/login'
    else
      session[:status_message] = "you're already logged in"
      redirect '/'
    end
  end

  post '/sessions' do
    user_s = User.find_by(name: params["uname"])
    if user_s == nil
      session[:status_message] = "Sorry there is no such user"
      redirect '/sessions/login'   
    elsif user_s.password == params["psw"]
      session[:status_message] = "Welcome back"
      session[:user_id] = user_s.id
      redirect '/users/home'
    else
      session[:status_message]="Sorry, your username or password is incorrect"
      redirect '/sessions/login'
    end
  end

  get '/sessions/logout' do

    session.clear

    redirect "/"

  end

  get '/users/home' do
    @count = History.all.count
    if session[:user_id]!= nil
      @last_five_urls= Url.order({ created_at: :desc }).limit(5)
      @message = session[:message]
      
      if @message == nil 
        @message = "Please enter the new url"
      end
      @user= User.find(session[:user_id])
      erb :'/users/home'
    else
      session[:status_message] = "Please register or log in"
      redirect '/'
    end

  end

  get '/users/links' do
    # display_links =Url.where(user)
    # @regx = /^[((^\w+:|^)\/\/127.0.0.1:9393\/url\/)].*/
    session[:status_message]="Navigate your links"
    if session[:user_id] != nil
      @all_urls = Url.where(user_id:session[:user_id]).order({created_at: :desc })
      erb :"users/display_links", layout: :layout
    else
      redirect "/users/home"
    end
  end


  post '/url_shorten' do
    # @count = count_shorten_times
    @user_input_url = params['url']
    @user =User.find_by(id:session[:user_id])
    def logged_in?
      if @user == nil || @user.name.nil?
        return false
      else
        return true
      end
    end
    
    if !Url.valid_url?(@user_input_url)
      session[:message] = "Invalid url. please type correct url e.g(http:// or https://www.facebook.com)"
      # redirect '/'
      if logged_in?
        redirect "/users/home"
      else
        redirect "/"
      end
    else
      # Url.add_count_shorten_times
      user_short_url = Url.get_short_url
      @my_short_url = Url.generate_url(user_short_url)
      check_url = Url.find_by(url_s:@user_input_url)

      if !logged_in?
        guess = Url.where(user_id:nil).count
        guess_id = guess + 1
        if check_url == nil
          raw_url = Url.create(url_s:@user_input_url,shortenedurl:@my_short_url)
          History.create(url_id:raw_url.id,user_id:guess_id)
          @url = raw_url.shortenedurl
        else
          @url = check_url.shortenedurl
        end
      else
        if check_url == nil
          raw_url = Url.create(url_s:@user_input_url,shortenedurl:@my_short_url,user_id:session[:user_id])
          History.create(url_id:raw_url.id,user_id:raw_url.user_id)
          @url = raw_url.shortenedurl
        else
          @url = check_url.shortenedurl
        end
      end
      session[:message] = "#{@url}"
      
      if logged_in?
        redirect "/users/home"
      else
        redirect "/"
      end
    end 

  end 

  get "/url/:id" do
    link =Url.generate_url(params[:id])
    my_url =Url.find_by(shortenedurl:link)
    url_short = my_url.url_s
    url = url_short.sub(/(^\w+:|^)\/\//, '')
    open_url = Url.url_opener(url)
    redirect open_url
  end

  get '/delete/:id' do 
    url =Url.find_by(id:params[:id])
    url.destroy
    session[:status_message] = "Your link is deleted"

    erb :'/users/destroy', layout: :layout
  end



end
