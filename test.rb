require 'tray_application';

app = TrayApplication.new("Deskshot")
app.icon_filename = 'icon.png'
app.item('Take Screenshot')  {Screenshot.capture}
app.item('Exit')              {java.lang.System::exit(0)}
app.run