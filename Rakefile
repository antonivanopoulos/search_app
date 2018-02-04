task :default => [:run]

desc "start the search cli"
task "run" do
  $LOAD_PATH.unshift(File.dirname(__FILE__), "lib")
  require 'search_app'

  SearchApp.start
end
