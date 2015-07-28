require 'tzinfo'

module Pagerduty
  module CLT
    class Incident

      include Base
      include Status
      include PathHelper  # FIXME
      extend PathHelper   # FIXME

      attr_reader :raw

      def initialize raw
        @raw = raw
        @fetched = false
      end

      def self.find(id, fields: false)
        path = incident_path(id)
        options = {}
        options[:fields] = fields.join(',') if fields
        response = $connection.get(path, options)
        new(response)
      end

      def fetch!
        @fetched ||= begin
          inspect
          nil
        end
      end

      def inspect
        attrs = [ self.class.name, id, node.name, service.name, service.detail, user.name, status, created_at ]
        '<%s id:[%s] node:[%s] service:[%s] detail:[%s] assigned_to:[%s] status:[%s] created_at:[%s]>' % attrs
      end

      def inspect_short
        attrs = [ self.class.name, node.name, service.name, service.detail ]
        '<%s node:[%s] service:[%s] detail:[%s]>' % attrs
      end

      def id
        @id ||= raw.id
      end

      def status
        @status ||= raw.status
      end

      def status_short
        @status_short ||= begin
          case raw.status
          when Status::ACKNOWLEDGED then 'A'
          when Status::RESOLVED     then 'R'
          when Status::TRIGGERED    then 'T'
          end
        end
      end

      def user
        @user ||= raw.assigned_to_user ? User.new(raw.assigned_to_user) : NullUser.new
      end

      def link
        @link ||= raw.html_url
      end

      def created_at
        @created_at ||= nice_timestamp(raw.created_on)
      end

      def notes
        @notes ||= begin
          path = incident_notes_path(id)
          $connection.get(path).notes.map { |raw_note| Note.new(raw_note) }
        end
      end

      def node
        @node ||= begin
          hostname = raw.trigger_summary_data.HOSTNAME
          hostname ? Node.new(hostname) : NullNode.new
        end
      end

      def log_entries
        @log_entries ||= $connection.get(log_entries_path, 'include[]' => 'channel').log_entries.map do |raw_log_entry|
          LogEntry.new(raw_log_entry)
        end
      end

      def log_entries_path
        @log_entries_path ||= incident_log_entries_path(id)
      end

      def service
        @services ||= begin
          log_entry = triggers.detect { |trigger| [ 'nagios', 'api' ].include?(trigger.channel.type) }
          return Services::NullService.new(node) unless log_entry

          case log_entry.channel.type
          when 'nagios'
            Services::Nagios.new(node, log_entry.channel)
          when 'api'
            case triggers.first.channel.client.downcase
            when 'datadog'
              Services::Datadog.new(log_entry.channel)
            end
          else
            Services::NullService.new(node)
          end
        end
      end

      def match?(pattern)
        !!(node.name && node.name.match(pattern) || (service.name && service.name.match(pattern)) || (service.detail && service.detail.match(pattern)))
      end

      def acknowledged?
        @ackd ||= raw.status == Status::ACKNOWLEDGED
      end

      def acknowledge!
        if acknowledged?
          $logger.warn "Incident already acknowledged #{inspect_short}"
          return nil
        else
          $logger.debug "Acknowledging incident #{inspect_short}"
        end
        path = incident_acknowledge_path(id)
        $connection.put(path + '?requester_id=%s' % settings.user_id)
      end

      def resolved?
        @resolved ||= raw.status == Status::RESOLVED
      end

      def resolve!
        if resolved?
          $logger.warn "Incident already resolved #{inspect_short}"
          return nil
        else
          $logger.debug "Resolving incident #{inspect_short}"
        end
        path = incident_resolve_path(id)
        $connection.put(path + '?requester_id=%s' % settings.user_id)
      end

      private

        attr_accessor :fetched

        def triggers
          @triggers ||= log_entries.select { |log_entry| log_entry.type == 'trigger' }
        end

    end
  end
end
