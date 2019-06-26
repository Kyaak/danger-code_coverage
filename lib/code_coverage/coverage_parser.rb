# frozen_string_literal: true

require('code_coverage/coverage_item')
require('json')

module CodeCoverage
  # Parse json files of code-coverage-api plugin and converts it into an array of [CoverageItem].
  # Empty array if not parseable.
  class CoverageParser
    # Parse json string into [CoverageItem] array.
    #
    # @param content Json string to parse.
    # @return [Array<CoverageItem>] Empty array of filled with [CoverageItem].
    def parse(content)
      raw_json =
        begin
          JSON.parse(content)
          # rubocop:disable Style/RescueStandardError
        rescue
          # rubocop:enable Style/RescueStandardError
          {}
        end
      parse_coverage(raw_json)
    end

    private

    def parse_coverage(raw_json)
      result = []
      results = raw_json['results']
      return result unless results

      report_files = results['children']
      return result unless report_files

      report_files.each do |report|
        projects = report['children']
        projects.each do |project|
          project['children'].each do |directory|
            directory['children'].each do |file|
              result << coverage_item(directory['name'], file)
            end
          end
        end
      end

      result
    end

    def coverage_item(parent_name, file_json)
      elements = file_json['elements']
      file_name = file_json['name']
      item_name = +''
      item_name << "#{parent_name}/" if !dirs?(file_name) && !dots?(parent_name)
      item_name << file_name

      item = CoverageItem.new
      item.file = item_name
      item.method = find_element_ratio(elements, 'Method')
      item.line = find_element_ratio(elements, 'Line')
      item.conditional = find_element_ratio(elements, 'Conditional')
      item.instruction = find_element_ratio(elements, 'Instruction')
      item
    end

    def find_element_ratio(elements, name)
      element = elements.select { |it| it['name'] == name }.first
      element['ratio'].round(2) if element
    end

    def dirs?(value)
      value =~ %r{.+\/\w+\..+}
    end

    def dots?(value)
      value =~ %r{.*\..*}
    end
  end
end
