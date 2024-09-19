RSpec.configure do |config|
  config.include ActionMailer::TestHelper
  config.include ActiveJob::TestHelper
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ActionView::RecordIdentifier
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  config.before(:each, :js, type: :system) do
    driven_by(:selenium, using: :headless_chrome, screen_size: [1400, 1400])
  end
end
