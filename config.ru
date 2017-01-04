require "./lib/racker"
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'qwerty'
use Rack::Static, :urls => ["/stylesheets"], :root => "public"

run Racker