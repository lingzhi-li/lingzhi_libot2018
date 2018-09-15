
#https://hidden-hamlet-22447.herokuapp.com/

require 'sinatra'
require "sinatra/reloader" if development?
require 'twilio-ruby'

enable :sessions

configure :development do
  require 'dotenv'
  Dotenv.load
end

$greeting_array = ["Hello", "Hi", "What's up", "Hi there"]
$secretcode = "hahaha"


#Week1
get '/' do
redirect "/about"
end


get '/about' do

   session["visit"] ||= 0 #||= assign value as noun
	 session["visit"] = session["visit"] + 1
   random_greeting = $greeting_array.sample

  if session[:first_name].nil?
     myTime = Time.now
     random_greeting + " My app does mockinterview for you.You have visited " + session["visit"].to_s + " times as of "+ myTime.to_s

	else
		"Welcome back" + session[:first_name]
  end

end


get '/incoming/sms' do
  403
end

get '/test/conversation/:body/:from' do

  if params[:body].nil?
    "Please input...."
  else
    determin_response params[:body]
  end

end

def determin_response body
body = body.downcase.strip

if str_check body,"hi"
  "Hi, what's going on"
elsif str_check body,"who"
    "I am Li. I am a bot"
elsif str_check body,"what"
    "I can do mockinterview with you"
elsif str_check body,"where"
    "I am in Pittsburgh"
elsif str_check body,"when"
    "I was made in Fall 2018."
elsif str_check body,"why"
  " I was made for a class project in this class."
elsif str_check body,"joke"
    File.open("jokes.txt","r")
    array_of_lines = IO.readlines("jokes.txt")
    return "there is a funny joke, " + array_of_lines.sample #retun is compulsory
    File.close
elsif str_check body, "fact"
    File.open("facts.txt","r")
    array_of_lines = IO.readlines("facts.txt")
    return "there is a fun fact about me, " + array_of_lines.sample
    File.close #not sure if "file" should be uppercase
end

end

def str_check string, keyword
  string = string.downcase.strip
  if string.include? keyword #no quotation mark
    return true
  else
    return false

  end
end

error 403 do
 "Access Forbidden"
end



#=begin -Week2-Practice 7
get '/signup/:first_name/:number/:sec_code' do # note: keep variables name consistent with erb

 if params[:sec_code] == $secretcode
  session[:first_name] = params[:first_name]
 	session[:number] = params[:number]
  erb:signup #erb.name
 end

end

post '/signup' do

 if params[:first_name].nil? && params[:number].nil?
  "Please input your name and phone number"
else
  "Sign up successfully! You will receive a text message in a few minutes from a bot "
 end

end

=begin --Week2-Practice 6
get '/signup/:first_name/:number/:sec_code' do

  if params[:sec_code] == $secretcode
  session[:first_name] = params[:first_name]
	session[:number] = params[:number]
	'You have got a code! '+'Welcome onboard,'+ params[:first_name] + '!'+"Your number is" + params[:number]
  else
  return 403
end
end
=end
