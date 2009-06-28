require "webrick"
require "text/hatena"
require "erb"

class HatenaPreviewServer
  DEFAULT_PORT = 8080

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
    server.start
  end
end

# WEBrick::HTTPServlet::AbstractServlet
class HatenaPreviewHandler < WEBrick::HTTPServlet::DefaultFileHandler
  include ERB::Util

  TEMPLATE = ERB.new(File.read(File.dirname(__FILE__) + "/hatena_preview_server.erb"), nil, "%-")

  def initialize(server, path)
    super
    @local_path = path
  end

  def do_GET(req,res)
    if @local_path !~ %r{/(\d{4}-\d{2}-\d{2})\.txt$}
      super
      return
    end
    date = Time.parse($1).strftime("%Y-%m-%d")
    
    src = File.read(@local_path)
    (title, body) = src.split(/\r\n|\r|\n/, 2)

    parser = Text::Hatena.new
    parser.parse(body)
    body = parser.html

    res['Content-Type'] = "text/html"
    res.body = TEMPLATE.result(binding)
  end
end