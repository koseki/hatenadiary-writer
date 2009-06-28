require "time"

DIR = File.dirname(__FILE__)
Dir.chdir(DIR)

desc "指定した日付の記事をロードします。rake load@2009-06-30"
task :load,[:date] do |t, args|
  raise "Usage: rake load@YYYY-MM-DD" unless args.date
  system("perl ./hw.pl -c -l #{args.date}")
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


# タスク引数に@を使えるようにします。rake load@2009-07-01
#   http://subtech.g.hatena.ne.jp/cho45/20080108/1199723301
Rake.application.top_level_tasks.map! do |a|
  name, vals = *a.split(/@/, 2)
  vals ? "#{name}[#{vals}]" : a
end
