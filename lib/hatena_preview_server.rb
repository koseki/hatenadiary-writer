require "webrick"
require "text/hatena"
require "erb"
require "github_client"
require "pp"
require "hatena_preview_handler"
require "github_browser_servlet"

class HatenaPreviewServer
  DEFAULT_PORT = 8080

  SOURCES = %w{github_browser_servlet.rb hatena_preview_handler.rb}
  AUTO_RELOAD = true

  def self.start(root, port) 
    port ||= DEFAULT_PORT

    server = WEBrick::HTTPServer.new({
      :DocumentRoot => "./text",
      :BindAddress => '0.0.0.0',
      :Port => port
    })
    ['INT', 'TERM'].each do |signal|
      Signal.trap(signal){ server.shutdown }
    end

    WEBrick::HTTPServlet::FileHandler.add_handler("txt", HatenaPreviewHandler)
    server.mount("/github", GithubBrowserServlet)
    server.start
  end


  def self.autoreload
    mtime = {}
    loop do
      begin
        dir = File.dirname(__FILE__)
        SOURCES.each do |f|
          path = dir + "/" + f
          mt = File.stat(path).mtime
          if mtime[f] != mt
            mtime[f] = mt
            puts "reload #{f}"
            load path
          end
        end
        sleep 1
      rescue => e
        p e
        sleep 5
      end
    end
  end

  if AUTO_RELOAD
    Thread.new do
      HatenaPreviewServer.autoreload
    end
  end

end
