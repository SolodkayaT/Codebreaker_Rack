
require_relative 'spec_helper.rb'

RSpec.describe Racker do
	subject { Rack::MockRequest.new(Racker) }

	specify 'get responce 200' do
		expect(subject.get('/').status).to eq 200
	end

	specify 'get page with title "codebreaker"' do
		expect(subject.get('/').body).to match(/<title>Codebreaker<\/title>/)
	end


  specify 'get responce 404' do
    expect(subject.get('/not_found_page').status).to eq 404
  end

  specify 'page should have html tags' do
    expect(subject.get('/').body).to match(/<form method="POST" action="\/check">/)
    expect(subject.get('/').body).to match(/<input class="btn" type="submit" value="Show hint">/)
  end


end