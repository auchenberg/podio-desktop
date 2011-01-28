require 'rubygems'
require 'ruby-growl'
require 'pp'

$g_host ||= "localhost"
$g_priority ||= 0

class Growl
  
  def self.g(*args, &block)
    growl = Growl.new $g_host, 'Podio desktop', [$0]

    args.push(block) if block

    messages =
      if args.empty?
        ['g!']
      else
        args.map { |i| i.pretty_inspect }
      end

    messages.each { |i| growl.notify $0, 'Podio desktop', i, $g_priority, false }

    if args.empty?
      nil
    elsif args.size == 1
      args.first
    else
      args
    end
  end

end
