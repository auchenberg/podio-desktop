require 'rubygems'
require 'podio'
require 'growl'

require 'tray_application'
require 'yaml'

app = TrayApplication.new("Podio")

app.icon_filename = 'logo.png'
app.item("Go to Inbox (Loading)")  {app.browse('https://podio.com/inbox')}
app.item('Go to Stream')  {app.browse('https://podio.com/stream')}
app.item('Exit')  {java.lang.System::exit(0)}

#Growl.g 'Welcome to Podio desktop'

app.run

