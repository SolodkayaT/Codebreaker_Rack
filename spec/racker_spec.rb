
require_relative 'spec_helper.rb'

RSpec.describe Racker do
	subject { Rack::MockRequest.new(Racker) }

	specify 'get responce 200' do
		expect(subject.get('/').status).to eq 200
	end

	specify 'get body with "codebreaker"' do
		expect(subject.get('/').body).to match(/<title>Codebreaker<\/title>/)
	end
end