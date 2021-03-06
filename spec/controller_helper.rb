require 'webmock/rspec'

def set_session_and_cookies_with_loa(loa_requested, transaction_simple_id = 'test-rp')
  session[:requested_loa] = loa_requested
  session[:verify_session_id] = 'my-session-id-cookie'
  session[:transaction_simple_id] = transaction_simple_id
  session[:transaction_entity_id] = 'http://www.test-rp.gov.uk/SAML2/MD'
  session[:transaction_homepage] = 'www.example.com'
  session[:start_time] = Time.now.to_i * 1000
  cookies[CookieNames::SESSION_COOKIE_NAME] = 'my-session-cookie'
  cookies[CookieNames::SESSION_ID_COOKIE_NAME] = 'my-session-id-cookie'
end

def set_selected_idp(selected_idp)
  session[:selected_provider] = SelectedProviderData.new(JourneyType::VERIFY, selected_idp)
end

def set_selected_country(selected_country)
  session[:selected_provider] = SelectedProviderData.new(JourneyType::EIDAS, selected_country)
end

def set_session_supports_eidas
  session[:transaction_supports_eidas] = true
end
