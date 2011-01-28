  require 'tray_application'

  app = TrayApplication.new("Podio")

  app.icon_filename = 'logo.png'
  app.item('Go to Inbox')  {app.browse('https://podio.com/inbox')}
  app.item('Go to Stream')  {app.browse('https://podio.com/stream')}
  app.item('Exit')  {java.lang.System::exit(0)}
  app.run