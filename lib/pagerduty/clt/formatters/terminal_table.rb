require 'pry-byebug'

module Pagerduty
  module CLT
    module Formatters
      class TerminalTable

        def initialize(headings: {}, rows: [], max_width: 80)
          @headings = headings
          @rows = rows
          @max_width = max_width
        end

        def render
          [ header, formatted_rows, divider ].join("\n")
        end

        private

          attr_reader :headings, :rows, :max_width

          def divider
            '+%s+' % ('-' * (max_width - 2))
          end

          def header
            pieces = [ divider ]
            pieces << '| %s |' % width_adjusted_headings.join(' | ')
            pieces << divider
            pieces.join("\n")
          end

          def total_set_column_widths
            headings.values.inject(0) { |a, x| a += x[:max_width] if x[:max_width] != -1 ; a }
          end

          def auto_width_columns_count
            headings.values.inject(0) { |a, x| a += 1 if x[:max_width] == -1 ; a }
          end

          def adjust_heading_column(key)
            width = total_set_column_widths + (headings.keys.count * 2) + (headings.keys.count + 1)
            headings[key][:max_width] = (max_width - width) / auto_width_columns_count
          end

          def width_adjusted_headings
            headings.map do |key, values|
              adjust_heading_column(key) if values[:max_width] == -1
              m, l = [ values[:max_width], values[:label].length ]
              padding_right = (m > l) ? (m - l) : 0

              '%s%s' % [ values[:label], (' ' * padding_right) ]
            end
          end

          def formatted_rows
            width_adjusted_rows.map { |row| '| %s |' % adjusted_row(row).join(' | ') }
          end

          def adjusted_row(row)
            headings.keys.map do |key|
              value = row[key]
              '%s%s' % [ value, (' ' * (max_width_for_heading(key) - value.length)) ]
            end
          end

          def max_width_for_heading(key)
            [ headings[key][:max_width], headings[key][:label].length ].max
          end

          def width_adjusted_rows
            rows.map do |row|
              row.each_with_object({}) do |x, a|
                key, value = x
                max_width = headings[key][:max_width]
                a[key] = truncate(value || '', max_width)
              end
            end
          end

          def truncate(string, max)
            string.length > max ? "#{string[0...(max - 2)]}.." : string
          end
      end
    end
  end
end
