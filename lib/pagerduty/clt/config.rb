require 'dotenv'
require 'hashie'

module Pagerduty
  module CLT
    class Config
      include PathHelper   # FIXME

      DEFAULT_CONFIG_FILE = File.join(ENV['HOME'], '.pagerduty_env')

      def initialize(config_file = DEFAULT_CONFIG_FILE)
        @config_file = config_file
        Dotenv.load(config_file)
      end

      def settings
        @settings ||= Hashie::Mash.new(hash)
      end

      def me
        @me ||= begin
          path = users_path(settings.user_id)
          User.new($connection.get(path).user)
        end
      end

      private

        attr_reader :config_file

        def hash
          {
            account: {
              name:    ENV['PAGERDUTY_ACCOUNT_NAME']    || fail("Missing ENV['PAGERDUTY_ACCOUNT_NAME'], add to #{config_file}"),
              token:   ENV['PAGERDUTY_ACCOUNT_TOKEN']   || fail("Missing ENV['PAGERDUTY_ACCOUNT_TOKEN'], add to #{config_file}")
            },
            user_id:   ENV['PAGERDUTY_USER_ID']         || fail("Missing ENV['PAGERDUTY_USER_ID'], add to #{config_file}")
          }
        end

    end
  end
end
