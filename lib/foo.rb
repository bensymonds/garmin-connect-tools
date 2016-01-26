require 'mechanize'

class Foo
  MAX_ACTIVITIES = 100
  FAKE_USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/1337 Safari/537.36"
  URLS = {
    login: 'https://sso.garmin.com/sso/login?service=https%3A%2F%2Fconnect.garmin.com%2Fpost-auth%2Flogin&webhost=olaxpw-connect04&source=https%3A%2F%2Fconnect.garmin.com%2Fen-US%2Fsignin&redirectAfterAccountLoginUrl=https%3A%2F%2Fconnect.garmin.com%2Fpost-auth%2Flogin&redirectAfterAccountCreationUrl=https%3A%2F%2Fconnect.garmin.com%2Fpost-auth%2Flogin&gauthHost=https%3A%2F%2Fsso.garmin.com%2Fsso&locale=en_US&id=gauth-widget&cssUrl=https%3A%2F%2Fstatic.garmincdn.com%2Fcom.garmin.connect%2Fui%2Fcss%2Fgauth-custom-v1.1-min.css&clientId=GarminConnect&rememberMeShown=true&rememberMeChecked=false&createAccountShown=true&openCreateAccount=false&usernameShown=false&displayNameShown=false&consumeServiceTicket=false&initialFocus=true&embedWidget=false&generateExtraServiceTicket=false',
    post_auth: 'https://connect.garmin.com/post-auth/login',
    search: 'http://connect.garmin.com/proxy/activity-search-service-1.0/json/activities',
  }

  LOGIN_PARAMS = {
    username: "bensymonds",
    password: "",
    embed: 'true',
    lt: 'e1s1',
    _eventId: 'submit',
    displayNameRequired: 'false',
  }

  attr_reader :agent

  def initialize
    @agent = Mechanize.new
  end

  def test
    login
    json = JSON.parse(get(URLS[:search], start: 0, limit: 10))
    debugger
    a = 1
  end

  def login
    get(URLS[:login])
    post(URLS[:login], LOGIN_PARAMS)
    ticket = agent.cookies.detect { |c| c.name == "CASTGC"}.value.gsub(/^TGT-/, "ST-0")
    get(URLS[:post_auth], ticket: ticket)
  end

  def get(url, params = {})
    headers = {
      'User-Agent' => FAKE_USER_AGENT
    }

    response = @agent.get(url, params, nil, headers)
    raise response.body unless response.code == "200"
    response.body
  end

  def post(url, params)
    headers = {
      'User-Agent' => FAKE_USER_AGENT
    }

    response = @agent.post(url, params, headers)
    raise unless response.code == "200"
    response.body
  end
end
