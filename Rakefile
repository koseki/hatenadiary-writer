require "time"

DIR = File.dirname(__FILE__)
Dir.chdir(DIR)
$:.unshift("./lib")

# タスク引数に@を使えるようにします。rake load@2009-07-01
#   http://subtech.g.hatena.ne.jp/cho45/20080108/1199723301
Rake.application.top_level_tasks.map! do |a|
  name, vals = *a.split(/@/, 2)
  vals ? "#{name}[#{vals}]" : a
end


desc "指定した日付の記事をロードします。rake load@2009-06-30"
task :load,[:date] do |t, args|
  raise "Usage: rake load@YYYY-MM-DD" unless args.date
  system("perl ./hw.pl -c -l #{args.date}")
end

desc "はてなダイアリーを更新します(ちょっとした更新)。"
task :update do
  system("perl ./hw.pl -c -t")
end

desc "はてなダイアリーを更新します。"
task :release do
  system("perl ./hw.pl -c")
end

desc "初期化します。"
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

desc "touch.txtに現在時刻を書き込みます。現在までの修正はアップロードされなくなります。"
task :touch,[:date] do |t,args|
  date = args.date ? Time.parse(args.date) : Time.now
  open("./text/touch.txt", "w") do |io|
    io << date.strftime("%Y%m%d%H%M%S")
  end
end

desc "プレビューサーバを起動します。"
task :server,[:port] do |t,args|
  require "hatena_preview_server"
  HatenaPreviewServer.start("./text", args.port)
end

desc "更新されるファイル一覧を表示します。"
task :status do
  date = File.stat("./text/touch.txt").mtime
  # puts "touch.txt: " + date.rfc822
  FileList["text/*.txt"].each do |f|
    next unless f =~ %r{/\d{4}-\d{2}-\d{2}\.txt$}
    mtime = File.stat(f).mtime
    if date < mtime
      puts "#{f}\t#{mtime.rfc822}"
    end
  end

end