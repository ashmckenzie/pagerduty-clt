module Pagerduty
  module CLT
    module Formatters
      module Users
        class Table

          include Formatters::Helper

          def initialize(users)
            @users = users
          end

          def render
            return nil if users.empty?
            TerminalTable.new(headings: columns, rows: rows, max_width: 80).render
          end

          private

            attr_reader :users

            def columns
              {
                id:    { label: '#', max_width: 7 },
                name:  { label: 'Name', max_width: 33 },
                email: { label: 'Email', max_width: 30 }
              }
            end

            def rows
              users.map do |user|
                {
                  id:    user.id,
                  name:  user.name,
                  email: user.email
                }
              end
            end
        end
      end
    end
  end
end
