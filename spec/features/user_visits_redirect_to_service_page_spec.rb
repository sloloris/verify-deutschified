require 'feature_helper'
require 'api_test_helper'

def hidden_field_value(id)
  page.find("##{id}", visible: false).value
end

def verify_redirect_to_service(title)
  expect(@api_request).to have_been_made.once
  expect(page).to have_title(title)
  expect(hidden_field_value('SAMLResponse')).to eql('a saml message')
  expect(hidden_field_value('RelayState')).to eql('a relay state')
end

def check_session_reset
  expect(page.get_rack_session.keys).to eql(['session_id'])
  expect(cookie_value(CookieNames::SESSION_ID_COOKIE_NAME)).to eql 'no-current-session'
  expect(cookie_value(CookieNames::SECURE_COOKIE_NAME)).to eql 'no-current-session'
end

RSpec.describe 'When the user visits the redirect to service page' do
  before(:each) do
    set_session_cookies!
    page.set_rack_session(transaction_simple_id: 'test-rp')
    @api_request = stub_response_for_rp
  end

  context 'without javascript' do
    it 'supports the welsh language for signing in' do
      visit 'redirect-to-service/signing-in-cy'
      expect(page).to have_css 'html[lang=cy]'
    end

    it 'supports the welsh language for start again' do
      visit 'redirect-to-service/start-again-cy'
      expect(page).to have_css 'html[lang=cy]'
    end

    it 'supports the welsh language for error' do
      visit 'redirect-to-service/error-cy'
      expect(page).to have_css 'html[lang=cy]'
    end

    it 'should redirect to service when path is signing-in' do
      visit redirect_to_service_signing_in_path
      verify_redirect_to_service(I18n.t('hub.redirect_to_service.signing_in.title'))

      click_button I18n.t('navigation.continue')
      expect(page).to have_current_path('/test-rp')
    end

    it 'should redirect to service when path is start-again' do
      visit redirect_to_service_start_again_path
      verify_redirect_to_service(I18n.t('hub.redirect_to_service.start_again.title'))

      click_button I18n.t('navigation.continue')
      expect(page).to have_current_path('/test-rp')
    end

    it 'should redirect to service when path is error' do
      visit redirect_to_service_error_path
      verify_redirect_to_service(I18n.t('hub.redirect_to_service.start_again.title'))

      click_button I18n.t('navigation.continue')
      expect(page).to have_current_path('/test-rp')
    end

    it 'should clear session when visiting start again' do
      visit redirect_to_service_start_again_path
      check_session_reset
    end

    it 'should clear session when signing in' do
      visit redirect_to_service_signing_in_path
      check_session_reset
    end
  end

  context 'with javascript' do
    it 'should redirect to service when path is signing-in', js: true do
      visit redirect_to_service_signing_in_path

      expect(page).to have_current_path('/test-rp')
      expect(@api_request).to have_been_made.once
    end
  end
end