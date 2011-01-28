class TrayApplication

  include Java
  import java.awt.Desktop # added Desktop to import
  import java.awt.TrayIcon
  import java.awt.Toolkit

  module JavaLang                    # create a namespace for java.lang
    include_package "java.lang"      # we don't want to clash with Ruby Thread?
  end


  attr_accessor :icon_filename
  attr_accessor :menu_items

  def initialize(name = 'Tray Application')
    @menu_items = []
    @name       = name
  end

  def item(label, &block)
    item = java.awt.MenuItem.new(label)
    item.add_action_listener(block)
    @menu_items << item
  end

  def inbox_count
    Podio::UserStatus.current['inbox_new']
  end

  class MySwingWorker < javax.swing.SwingWorker
    def doInBackground
      puts "thread #{self.hashCode} working"
      sleep(1)
    end
  end

  class ThreadImpl
    include JavaLang::Runnable       # include interface as a 'module'
  
    attr_reader :runner   # instance variables
  
    def initialize
      @runner = JavaLang::Thread.current_thread # get access to main thread
      puts "...in thread #{JavaLang::Thread.current_thread.get_name}"
    end
  
    def run
      while true
        puts "...in thread #{JavaLang::Thread.current_thread.get_name}"
        sleep 10
      end
    end
  end

  def run
    popup = java.awt.PopupMenu.new
    @menu_items.each{|i| popup.add(i)}

    # Give the tray an icon and attach the popup menu to it
    image    = java.awt.Toolkit::default_toolkit.get_image(@icon_filename)
    tray_icon = TrayIcon.new(image, @name, popup)
    tray_icon.image_auto_size = true

    # Finally add the tray icon to the tray
    tray = java.awt.SystemTray::system_tray
    tray.add(tray_icon)

    thread0 = JavaLang::Thread.new(ThreadImpl.new).start

    icon = java.awt.TrayIcon::MessageType::INFO

    tray_icon.setToolTip('20 unread messages')
  end

  def browse(url)
    uri  = java::net::URI.new(url)
    desktop = Desktop.get_desktop
    desktop.browse(uri)
  end  

end