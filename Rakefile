require "time"

DIR = File.dirname(__FILE__)
Dir.chdir(DIR)

task :load do
  return unless date = ENV["DATE"]
  system("perl ./hw.pl -c -l #{date}")
end

task :update do
  system("perl ./hw.pl -c -t")
end

task :init do
  mkdir "text" unless File.exist?("text")

  # config.txtはhw.plと同じディレクトリに置く。
  # hw.plを直接実行する時にconfig.txtのパスを指定しなくても済むように。
  unless File.exist?("config.txt") 
    open("config.txt", "w") do |io|
      io << <<EOT
id:yourid
txt_dir:./text
touch:./text/touch.txt
client_encoding:utf-8
server_encoding:euc-jp
EOT
    end
  end

  # クッキーのパーミッションを閉じる。
  touch "cookie.txt" unless File.exist?("cookie.txt")
  chmod(0600, "cookie.txt")
end

task :touch do
  if ENV["DATE"]
    date = Time.parse(ENV["DATE"])
  else
    date = Time.now
  end
  open("./text/touch.txt", "w") do |io|
    io << date.strftime("%Y%m%d%H%M%S")
  end
end
