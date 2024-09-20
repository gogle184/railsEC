RSpec.configure do |config|
  config.include ActionMailer::TestHelper
  config.include ActiveJob::TestHelper
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ActionView::RecordIdentifier
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers
end
