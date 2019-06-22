# frozen_string_literal: true

module CodeCoverage
  # Generate a markdown table.
  class MarkdownTable
    COLUMN_SEPARATOR = '|'
    HEADER_SEPARATOR = '-'

    # Initialize table generator.
    def initialize
      @header = COLUMN_SEPARATOR.dup
      @header_separator = COLUMN_SEPARATOR.dup
      @lines = []
    end

    # Add each entry to the table header
    def header(*args)
      args.each_with_index do |item, index|
        @header << "#{item}#{COLUMN_SEPARATOR}"
        @header_separator << if index.zero?
                               ":#{HEADER_SEPARATOR}#{COLUMN_SEPARATOR}"
                             else
                               ":#{HEADER_SEPARATOR}:#{COLUMN_SEPARATOR}"
                             end
      end
    end

    # Return the number of lines without header items.
    #
    # @return [Integer] Number of lines.
    def size
      @lines.length
    end

    # Add a new line entry to the table.
    #
    # @param args [String]* Multiple comma separated strings for each column entry.
    def line(*args)
      line = COLUMN_SEPARATOR.dup
      args.each do |item|
        line << "#{item}#{COLUMN_SEPARATOR}"
      end
      @lines << line
    end

    # Combine all data to a markdown table string.
    # @return [String] Table.
    def to_markdown
      result = +"#{@header}\n#{@header_separator}\n"
      result << @lines.join("\n")
    end
  end
end
