require 'piwik'
require 'google_analytics'
require 'analytics'
require 'originating_ip_store'

Rails.application.config.after_initialize do
  INTERNAL_PIWIK = Piwik.new(CONFIG.internal_piwik_host, CONFIG.piwik_site_id)
  PUBLIC_PIWIK = Piwik.new(CONFIG.public_piwik_host, CONFIG.piwik_site_id)

  if INTERNAL_PIWIK.enabled?
    client = Analytics::PiwikClient.new(INTERNAL_PIWIK.url, async: Rails.env != 'test')
    ANALYTICS_REPORTER = Analytics::Reporter.new(client, INTERNAL_PIWIK.site_id)
  else
    ANALYTICS_REPORTER = Analytics::NullReporter.new
  end

  FEDERATION_REPORTER = Analytics::FederationReporter.new(ANALYTICS_REPORTER)

  CROSS_GOV_GA = GoogleAnalytics.new(
    CONFIG.cross_gov_google_analytics_tracker_id,
    CONFIG.cross_gov_domain_list.nil? ? [] : CONFIG.cross_gov_domain_list.split(' ')
  )
end
