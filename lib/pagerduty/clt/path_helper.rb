module Pagerduty
  module CLT
    module PathHelper

      def users_path(id)
        'users/%s' % [ id ]
      end

      def escalation_policies_path
        'escalation_policies/on_call'
      end

      def escalation_policy_path(query)
        '%s?query=%s' % [ escalation_policies_path, query ]
      end

      def incidents_path
        'incidents'
      end

      def incident_path(id)
        '%s/%s' % [ incidents_path, id ]
      end

      def incident_acknowledge_path(id)
        '%s/%s/acknowledge' % [ incidents_path, id ]
      end

      def incident_resolve_path(id)
        '%s/%s/resolve' % [ incidents_path, id ]
      end

      def incident_notes_path(id)
        '%s/%s/notes' % [ incidents_path, id ]
      end

      def incident_log_entries_path(id)
        '%s/%s/log_entries' % [ incidents_path, id ]
      end
    end
  end
end
