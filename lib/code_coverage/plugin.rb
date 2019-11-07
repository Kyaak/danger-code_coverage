# frozen_string_literal: true

module Danger
  # Generate code coverage reports on pull requests based on jenkins code-coverage-api-plugin.
  #
  # @example Generate report for each changed file.
  #   code_coverage.report
  #
  # @example Use auth token.
  #   code_coverage.report(
  #     auth_user: 'user',
  #     auth_token: 'token'
  # )
  #
  # @see  Kyaak/danger-code_coverage
  # @tags danger, jenkins, coverage, code-coverage, analysis
  class DangerCodeCoverage < Plugin
    require 'open-uri'
    require 'code_coverage/markdown_table'
    require 'code_coverage/coverage_parser'
    require 'code_coverage/coverage_item'

    EMPTY_COLUMN = '-'
    TABLE_HEADER_TOTAL = '**Total**'
    TABLE_HEADER_FILE = '**File**'
    TABLE_HEADER_METHOD = '**Method**'
    TABLE_HEADER_LINE = '**Line**'
    TABLE_HEADER_CONDITIONAL = '**Conditional**'
    TABLE_HEADER_INSTRUCTION = '**Instruction**'
    TABLE_TITLE = '### Code Coverage :100:'

    # Initialize code_coverage plugin.
    def initialize(dangerfile)
      @target_files = nil
      @auth = nil
      @table = CodeCoverage::MarkdownTable.new
      @table.header(TABLE_HEADER_FILE,
                    TABLE_HEADER_TOTAL,
                    TABLE_HEADER_METHOD,
                    TABLE_HEADER_LINE,
                    TABLE_HEADER_CONDITIONAL,
                    TABLE_HEADER_INSTRUCTION)
      super(dangerfile)
    end

    # Create an overview report.
    #
    # @param args Configuration settings
    # @return [void]
    def report(*args)
      options = args.first
      sort_order = options && options[:sort]
      if sort_order && !sort_order.eql?(:ascending) && !sort_order.eql?(:descending)
        raise(ArgumentError.new('Invalid configuration, use [:ascending, :descending]'))
      end

      check_auth(options)

      items = coverage_items
      items.select! { |item| file_in_changeset?(item.file) }
      items.each(&method(:update_item))
      items.sort_by! do |item|
        if sort_order.eql?(:ascending)
          item.total
        else
          -item.total
        end
      end
      items.each(&method(:add_entry))

      return if @table.size.zero?

      markdown("#{TABLE_TITLE}\n\n#{@table.to_markdown}")
    end

    private

    def update_item(item)
      item.method = convert_entry(item.method)
      item.line = convert_entry(item.line)
      item.conditional = convert_entry(item.conditional)
      item.instruction = convert_entry(item.instruction)
      item.total = total(item)
    end

    def add_entry(item)
      @table.line(item.file,
                  item.total,
                  item.method,
                  item.line,
                  item.conditional,
                  item.instruction)
    end

    def convert_entry(value)
      return EMPTY_COLUMN unless value

      value
    end

    def total(item)
      count = 0
      sum = 0

      unless convert_entry(item.method).eql?(EMPTY_COLUMN)
        count += 1
        sum += convert_entry(item.method)
      end

      unless convert_entry(item.line).eql?(EMPTY_COLUMN)
        count += 1
        sum += convert_entry(item.line)
      end

      unless convert_entry(item.conditional).eql?(EMPTY_COLUMN)
        count += 1
        sum += convert_entry(item.conditional)
      end

      unless convert_entry(item.instruction).eql?(EMPTY_COLUMN)
        count += 1
        sum += convert_entry(item.instruction)
      end

      if count.zero?
        0.0
      else
        (sum / count).round(2)
      end
    end

    def auth_user(options)
      options && !options[:auth_user].nil? ? options[:auth_user] : nil
    end

    def auth_token(options)
      options && !options[:auth_token].nil? ? options[:auth_token] : nil
    end

    def check_auth(options)
      user = auth_user(options)
      token = auth_token(options)
      return unless user && token

      @auth = {
        user: user,
        token: token
      }
    end

    def file_in_changeset?(file)
      result = target_files.select { |value| value =~ %r{.*#{file}} }
      !result.empty?
    end

    def target_files
      @target_files ||= git.modified_files + git.added_files
    end

    def coverage_items
      content = coverage_json
      CodeCoverage::CoverageParser.new.parse(content)
    end

    def coverage_json
      options = { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE }
      options[:http_basic_authentication] = [@auth[:user], @auth[:token]] if @auth
      OpenURI.open_uri("#{ENV['BUILD_URL']}/coverage/result/api/json?depth=5", options).read
    end
  end
end
