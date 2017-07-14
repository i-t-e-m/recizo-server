require 'slack'

Slack.configure do |config|
  File.open('lib/tasks/secrets/environment.json') do |file|
    @jd = JSON.load(file)
  end
  config.token = @jd['SLACK_TOKEN']
end