require "time"

DIR = File.dirname(__FILE__)
Dir.chdir(DIR)

task :load do
  return unless date = ENV["DATE"]
  system("perl ./hw.pl -c -l #{date}")
end

task :touch do
  if ENV["DATE"]
    date = Time.parse(ENV["DATE"])
  else
    date = Time.now
  end
  open("touch.txt", "w") do |io|
    io << date.strftime("%Y%m%d%H%M%S")
  end
end
