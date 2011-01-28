require 'rubygems'
require 'podio'
require 'growl'

require 'tray_application'
require 'yaml'

api_config = YAML::load(File.open('api_config.yml'))

Podio.configure do |config|
  config.api_key = api_config['api_key']
  config.api_secret = api_config['api_secret']
  config.debug = true
end

Podio.client = Podio::Client.new
Podio.client.get_access_token(api_config['login'], api_config['password'])

app = TrayApplication.new("Podio")
inbox_count = app.inbox_count

app.icon_filename = 'logo.png'
app.item("Go to Inbox (#{inbox_count})")  {app.browse('https://podio.com/inbox')}
app.item('Go to Stream')  {app.browse('https://podio.com/stream')}
app.item('Exit')  {java.lang.System::exit(0)}

Growl.g 'Welcome to Podio desktop'

app.run

