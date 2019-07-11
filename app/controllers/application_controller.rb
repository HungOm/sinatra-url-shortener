class ApplicationController < Sinatra::Base

  register Sinatra::ActiveRecordExtension
  require "open-uri"

  configure do
  	set :views, "app/views"
    set :public_dir, "public"
    #enables sessions as per Sinatra's docs. Session_secret is meant to encript the session id so that users cannot create a fake session_id to hack into your site without logging in. 
    enable :sessions
    set :session_secret, "secret"
  end

  # Renders the home or index page
  get '/' do

    @message = session[:message]

    erb :home, layout: :layout

  end

  # Renders the sign up/registration page in app/views/registrations/signup.erb
  get '/registrations/signup' do

    erb :'/registrations/signup'

  end

  post '/registrations' do
    user = User.create(name:params["name"], email: params["email"])
    # byebug
    user.password = params["psw"]
    byebug
    user.save

    session[:user_id] = user.id
    # byebug
    redirect '/users/home'
    
   
  end
  
  get '/sessions/login' do

    erb :'/sessions/login'
   
  end

  post '/sessions' do
    user = User.find_by(name: params["uname"])
    if user.password == params["psw"]
      session[:user_id] = user.id
      redirect '/users/home'
    else
      redirect '/sessions/login'
    end

  end

  get '/sessions/logout' do

    session.clear

    redirect "/"

  end

  # Renders the user's individual home/account page. 
  get '/users/home' do
    @user= User.find(session[:user_id])
    # @message
    # if @message.empty?
    #   @message = "Welcome to Recode url shortener page"
    # else
    #   @message
    # end
    erb :'/users/home'

  end


  post '/url' do
    url = params['url']

    n= open(url).status
    "#{n} --"


  end

  post '/url_shorten' do
    @user_input_url = params['url']
    
    if !Url.valid_url?(@user_input_url)
      session[:message] = "Invalid url. please type correct url e.g(http:// or https://www.facebook.com)"
      redirect '/'
    else
      @user_short_url = Url.get_short_url

      user =User.find_by(session[:user_id])
      if user.nil?
        raw_url = Url.find_or_create_by(url_s:@user_input_url,shortenedurl:@user_short_url)
        short_url = raw_url.shortenedurl
        @url = Url.generate_url(short_url)
      else

        raw_url = Url.create(url_s:url,shortenedurl:@user_short_url,user_id:session[:user_id])
        short_url = raw_url.shortenedurl
        @url = Url.generate_url(short_url)
      end
      session[:message] = "congratulations! \n Your short url is generated\n url: #{@url}"
      
      redirect '/'
    end

    

  end 

  get "/url/:id" do

    link = params[:id]
    # puts "#{link}"
    my_url =Url.find_by(shortenedurl:link)
    # "#{@url.url_s}"
    url_short = my_url.url_s
    open_url = Url.url_opener(url_short)
    redirect open_url

  end



end
