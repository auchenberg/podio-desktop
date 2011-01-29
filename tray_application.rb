class TrayApplication
  require 'os_helper'
  if OsHelper.is_osx?
    require 'growl'
  end
  include Java
  import java.awt.Desktop # added Desktop to import
  import java.awt.TrayIcon
  import java.awt.Toolkit

  module JavaLang                    # create a namespace for java.lang
    include_package "java.lang"      # we don't want to clash with Ruby Thread?
  end

  API_CONFIG = YAML::load(File.open('api_config.yml'))

  attr_accessor :icon_filename
  attr_accessor :menu_items
  attr_accessor :tray

  def initialize(name = 'Tray Application')
    @menu_items = []
    @name       = name
  end

  def item(label, &block)
    item = java.awt.MenuItem.new(label)
    item.add_action_listener(block)
    @menu_items << item
  end

  class ThreadImpl
    include JavaLang::Runnable       # include interface as a 'module'
  
    attr_reader :runner   # instance variables

    def initialize(app)
      @runner = JavaLang::Thread.current_thread # get access to main thread
      @app = app
    end
  
    def run
      while true
        api_config = API_CONFIG

        Podio.configure do |config|
          config.api_key = api_config['api_key']
          config.api_secret = api_config['api_secret']
          config.debug = false
        end

        Podio.client = Podio::Client.new

        Podio.client.get_access_token(api_config['login'], api_config['password'])

        count = Podio::UserStatus.current['inbox_new']
        @app.menu_items.first.set_label "Go to Inbox (#{count})"
        icon = @app.tray.trayIcons.first
	    if count > 0
        icon.setToolTip("Podio \n#{count} unread messages")
		    icon.set_image(java.awt.Toolkit::default_toolkit.get_image('logo_unread.png'))
        if OsHelper.is_osx? #There must be a better pattern than this, right?
          Growl.g "You have #{count} unread messages"
        end
	    else
		    icon.setToolTip('No unread messages')
            icon.set_image(java.awt.Toolkit::default_toolkit.get_image('logo.png'))
		    #tray_icon = java.awt.Toolkit::default_toolkit.get_image('logo.png')    
	    end
        sleep 30
      end
    end
  end

  def menu_items
    @menu_items
  end
  

  def run
    popup = java.awt.PopupMenu.new
    @menu_items.each{|i| popup.add(i)}

    # Give the tray an icon and attach the popup menu to it
    image = java.awt.Toolkit::default_toolkit.get_image(@icon_filename)
    tray_icon = TrayIcon.new(image, @name, popup)
    tray_icon.image_auto_size = true

    # Finally add the tray icon to the tray
    @tray = java.awt.SystemTray::system_tray
    @tray.add(tray_icon)

    thread0 = JavaLang::Thread.new(ThreadImpl.new(self)).start

    tray_icon.setToolTip('Podio')
  end

  def browse(url)
    uri  = java::net::URI.new(url)
    desktop = Desktop.get_desktop
    desktop.browse(uri)
  end  

end
