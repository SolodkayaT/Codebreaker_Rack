
require_relative 'spec_helper.rb'

RSpec.describe Racker do
	subject { Rack::MockRequest.new(Racker) }

  def game_to_lose
    11.times do
        fill_in 'guess', :with => '5555'
        click_button 'Enter'
      end
  end

  before { visit '/' }

	specify 'get responce 200' do
		expect(subject.get('/').status).to eq 200
	end

  specify 'get responce 404' do
    expect(subject.get('/not_found_page').status).to eq 404
  end

	specify 'get page with title "codebreaker"' do
		expect(subject.get('/').body).to match(/<title>Codebreaker<\/title>/)
	end

  specify 'game page should have Show hint, Restart, Show Statistic ' do
  	expect(page).to have_link('Show hint')
    expect(page).to have_link('Restart')
    expect(page).to have_link('Show statistic')
  end

  context '/play_again' do
    before do
      click_link('Restart')
    end
    specify { expect(page).to have_current_path('/') }
    specify { expect(page).to have_content('You have 10 chanses to break the code') }
    specify { expect(page).to have_content('You have 1 hint') }
    specify { expect(page).to have_button('Enter') }
    specify { expect(page).to have_link('Show hint') }
    specify { expect(page).to have_link('Restart') }
  end

  context 'click on page links' do
    it 'should return Wrong answer' do
      click_button('Enter')
      expect(page).to have_content('Wrong answer')
    end
  end

  context 'chanses to decrease' do
    it 'return 9 chanses to break the code' do
      fill_in with: '1324'
      click_button 'Enter'
      expect(page).to have_content('You have 9 chanses to break the code')
    end
  end

  context 'game lose' do
    before do
      game_to_lose
    end
      specify {expect(page).to have_content('You lose')}
      specify {expect(page).to have_content('Do you want to play again?')}
      specify {expect(page).to have_link('Yes')}
      specify {expect(page).to have_button('Save result')}
  end

  context 'play again' do
    before do
      game_to_lose
      click_link 'Yes'
    end
    specify {expect(page).to have_content('You have 10 chanses to break the code')}
    specify {expect(page).to have_content('You have 1 hint')}
  end

  context '/statistic page' do
    before do
      game_to_lose
      click_link 'Show statistic'
    end
    specify { expect(page).to have_content('Codebreaker statistic') }
    specify { expect(page).to have_content('Result') }
    specify { expect(page).to have_link('Return to Game') }
  end
end