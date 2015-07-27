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

      # class ConsoleCommand < AbstractCommand
      #   def execute
      #     require 'pry-byebug'
      #     pry PD
      #   end
      # end

      class AcknowledgeCommand < AbstractCommand
        parameter('PATTERN', 'pattern to match (on node)', required: false)
        option('--everyone', :flag, 'ALL incidents, not just mine', default: false)
        option('--batch', :flag, 'Non-interactively acknowledge', default: false)
        option('--yes', :flag, "Don't confirm, just do it!", default: false)

        def execute
          status = [ Status::TRIGGERED ]
          options = { status: status, pattern: pattern }
          options[:user_id] = nil if everyone?
          ack_options = { confirm: !yes? }

          if batch?
            Incidents.new.where(options).acknowledge_all!(ack_options)
          else
            Incidents.new.where(options).acknowledge!
          end
        end
      end

      class ResolveCommand < AbstractCommand
        parameter('PATTERN', 'pattern to match (on node)', required: false)
        option('--everyone', :flag, 'All incidents, not just mine', default: false)
        option('--batch', :flag, 'Non-interactively acknowledge', default: false)
        option('--yes', :flag, "Don't confirm, just do it!", default: false)

        def execute
          status = [ Status::TRIGGERED, Status::ACKNOWLEDGED ]
          options = { status: status, pattern: pattern }
          options[:user_id] = nil if everyone?
          resolve_options = { confirm: !yes? }

          if batch?
            Incidents.new.where(options).resolve_all!(resolve_options)
          else
            Incidents.new.where(options).resolve!
          end
        end
      end

      class ListNeedingAttentionCommand < AbstractCommand
        option('--everyone', :flag, 'All incidents, not just mine', default: false)

        def execute
          status = [ Status::TRIGGERED, Status::ACKNOWLEDGED ]

          options = { status: status }
          options[:user_id] = nil if everyone?

          incidents = Incidents.new.where(options)
          table = Formatters::Incidents::Table.new(incidents).render
          puts table if table
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
        # subcommand %w(c console), 'Run a console', ConsoleCommand
        subcommand %w(o oncall), 'Who is currently on call', OncallCommand
        subcommand %w(s schedules), 'Schedules', SchedulesCommand
        subcommand %w(l list), 'List incidents needing attention (triggered + acknowledged)', ListNeedingAttentionCommand
        subcommand %w(a ack acknowledge), 'Acknowledge incidents', AcknowledgeCommand
        subcommand %w(r resolve), 'Resolve incidents', ResolveCommand
      end
    end
  end
end
