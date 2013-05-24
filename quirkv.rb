require 'sinatra'
require 'haml'

get '/' do
  haml :app
end

__END__

@@ app
%html
  %h2 hello world!
