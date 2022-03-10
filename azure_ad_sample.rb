#
# Azure AD 認証サンプル
#
require 'sinatra'
require 'json'
require './httpc'

config_data = JSON.parse(File.open("config.json").read)
client_id = config_data["CLIENT_ID"]
client_secret = config_data["CLIENT_SECRET"]
tenant = config_data["TENANT_ID"]

TOP_URL = "http://localhost:4567"
AUTH_URL = "http://localhost:4567/auth"
AUTH_ENDPOINT = "https://login.microsoftonline.com/#{tenant}/oauth2/v2.0/authorize"
TOKEN_ENDPOINT = "https://login.microsoftonline.com/#{tenant}/oauth2/v2.0/token"
LOGOUT_ENDPOINT = "https://login.microsoftonline.com/common/oauth2/v2.0/logout"
GRAPH_PROFILE_ENDPOINT = "https://graph.microsoft.com/v1.0/me"

httpc = AzureAD::HTTPClient.new

# 初期設定
configure do
  use Rack::Session::Pool
end

# サイトトップ
get '/' do
  '<a href="/auth">LOGIN</a>'
end

# 認証（AzureAD認証画面へリダイレクト）
get '/auth' do
  request_params = {
    client_id: client_id,
    response_type: "code",
    redirect_uri: AUTH_URL,
    scope: "User.Read openid",
    response_mode: "form_post"
  }
  redirect AUTH_ENDPOINT + "?" + URI.encode_www_form(request_params)  
end

# トークン請求＆取得
post '/auth' do
  code = params[:code]
  header = {
    "Content-Type": "application/x-www-form-urlencoded"
  }
  request_params = {
    client_id: client_id,
    client_secret: client_secret,
    code: code,
    redirect_uri: AUTH_URL,
    grant_type: "authorization_code"
  }
  res = httpc.post(TOKEN_ENDPOINT, request_params, header)
  session["token"] = JSON.parse(res.body)
  redirect to("/disp")
end

# GRAPH API使用処理
get '/disp' do
  header = {
    Authorization: "Bearer " + session["token"]["access_token"]
  }
  res = httpc.get(GRAPH_PROFILE_ENDPOINT, {}, header)
  JSON.pretty_generate(JSON.parse(res.body))
    .gsub(/\n/, "<br>\n").gsub("  ", " &nbsp;") + "<br><br>" + %(<a href="/logout">LOGOUT</a>)
end

# ログアウト
get '/logout' do
  session.clear
  request_params = {
    client_id: client_id,
    "post_logout_redirect_uri": TOP_URL
  }
  redirect LOGOUT_ENDPOINT + "?" + URI.encode_www_form(request_params)
end