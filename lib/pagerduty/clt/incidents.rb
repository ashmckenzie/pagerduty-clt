module Pagerduty
  module CLT
    class Incidents

      include Base
      include Status
      include PathHelper   # FIXME

      def all
        where
      end

      def where(status: DEFAULT_STATUS, pattern: nil, fields: false, user_id: false, sort_by: 'created_on:desc')
        user_id = (user_id == false) ? settings.user_id : user_id
        incidents = get(status, pattern, fields, user_id, sort_by)
        incident_list = IncidentList.new(incidents)
        incident_list
      end

      private

        def get(status, pattern, fields, user_id, sort_by)
          options = {
            status:  status.join(','),
            sort_by: sort_by
          }

          options[:fields] = fields.join(',') if fields
          options[:assigned_to_user] = user_id unless user_id.nil?
          pattern = Regexp.new(pattern) if pattern

          response = $connection.get(incidents_path, options)

          response.incidents.map do |raw_incident|
            incident = Incident.new(raw_incident)
            if pattern && !incident.match?(pattern)
              $logger.debug "No match on /#{pattern.to_s}/ for #{raw_incident.inspect}"
              next
            else
              incident
            end
          end.compact
        end
    end
  end
end
