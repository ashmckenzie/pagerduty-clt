require 'clamp'
require 'highline/import'

module Pagerduty
  module CLT
    class CLI < Clamp::Command

      class AbstractCommand < Clamp::Command
        option [ '-c', '--config_file' ], 'CONFIG', 'Config file', default: Pagerduty::CLT::Config::DEFAULT_CONFIG_FILE

        option '--version', :flag, 'show version' do
          puts Pagerduty::CLT::VERSION
          exit(0)
        end
      end

      class ConsoleCommand < AbstractCommand
        def execute
          begin
            require 'pry-byebug'
          rescue LoadError
            $logger.error 'pry-byebug not installed.'
            exit(1)
          end
          pry ::Pagerduty::CLT
        end
      end

      class AcknowledgeCommand < AbstractCommand
        parameter('PATTERN', 'pattern to match (on node)', required: false)
        option('--interactive', :flag, 'Interactively acknowledge', default: false)
        option('--everyone', :flag, 'ALL incidents, not just mine', default: false)
        option('--yes', :flag, "Don't confirm, just do it!", default: false)

        def execute
          options = { status: [ Status::TRIGGERED ], pattern: pattern }
          options[:user_id] = nil if everyone?
          ack_options = { confirm: !yes? }

          if interactive?
            Incidents.new.where(options).acknowledge!
          else
            Incidents.new.where(options).acknowledge_all!(ack_options)
          end
        end
      end

      class ReassignCommand < AbstractCommand
        parameter('USER_PATTERN', 'user to reassign incident(s) to', required: true)
        parameter('PATTERN', 'pattern to match (on node)', required: false)
        option('--yes', :flag, "Don't confirm, just do it!", default: false)

        def execute
          options = { status: Status::UNRESOLVED, pattern: pattern, user_id: nil }
          reassign_options = { confirm: !yes? }

          users = User.search(user_pattern)

          if users.count > 1
            puts Formatters::Users::Table.new(users).render
            user_id = ask("\n%s match(e)s, please enter a User ID: " % users.count)
            users = unless user_id.empty?
                      users.select { |user| user.match?(user_id) }
                    else
                      []
                    end
          end

          if users.count == 1
            user = users.first
          else
            $logger.error "Unable find User using pattern '#{user_pattern}'"
            exit(1)
          end

          Incidents.new.where(options).reassign_all!(user, reassign_options)
        end
      end

      class ResolveCommand < AbstractCommand
        parameter('PATTERN', 'pattern to match (on node)', required: false)
        option('--interactive', :flag, 'Interactively acknowledge', default: false)
        option('--everyone', :flag, 'All incidents, not just mine', default: false)
        option('--yes', :flag, "Don't confirm, just do it!", default: false)

        def execute
          options = { status: Status::UNRESOLVED, pattern: pattern }
          options[:user_id] = nil if everyone?
          resolve_options = { confirm: !yes? }

          if interactive?
            Incidents.new.where(options).resolve!
          else
            Incidents.new.where(options).resolve_all!(resolve_options)
          end
        end
      end

      class ListNeedingAttentionCommand < AbstractCommand
        option('--everyone', :flag, 'All incidents, not just mine', default: false)
        option([ '-f', '--format' ], 'FORMAT', 'Format', default: 'table')

        def execute
          options = { status: Status::UNRESOLVED }
          options[:user_id] = nil if everyone?

          incidents = Incidents.new.where(options)

          formater_klass = case format
          when 'table'
            Formatters::Incidents::Table
          when 'csv'
            Formatters::Incidents::CSV
          when 'json'
            Formatters::Incidents::JSON
          else
            fail("Unknown format type '#{format}'")
          end

          output = formater_klass.new(incidents).render

          if output
            puts output
            puts "\n%s match(es)" % incidents.count if format == 'table'
          end
        end
      end

      class SchedulesCommand < AbstractCommand
        option [ '-q', '--query' ], 'QUERY', 'Query'

        def execute
          options = { query: query }

          schedules = Schedules.new.where(options)
          table = Formatters::Schedules::Table.new(schedules).render
          puts table if table
        end
      end

      class OncallCommand < AbstractCommand
        option [ '-q', '--query' ], 'QUERY', 'Query'

        def execute
          options = { query: query }

          escalation_policies = EscalationPolicies.new.where(options)
          table = Formatters::OnCall::Table.new(escalation_policies).render
          puts table if table
        end
      end

      class MainCommand < AbstractCommand
        subcommand %w(c console), 'Run a console', ConsoleCommand
        subcommand %w(s schedules), 'Schedules', SchedulesCommand
        subcommand %w(o oncall), 'Who is currently on call', OncallCommand
        subcommand %w(l list), 'List incidents needing attention (triggered + acknowledged)', ListNeedingAttentionCommand
        subcommand %w(a ack acknowledge), 'Acknowledge incidents', AcknowledgeCommand
        subcommand %w(r resolve), 'Resolve incidents', ResolveCommand
        subcommand %w(ra reassign), 'Reassign incidents', ReassignCommand
      end
    end
  end
end
