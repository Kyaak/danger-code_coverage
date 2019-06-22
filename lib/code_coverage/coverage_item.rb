# frozen_string_literal: true

module CodeCoverage
  # Container class for coverage data per file.
  class CoverageItem
    attr_accessor :file,
                  :line,
                  :conditional,
                  :method,
                  :instruction,
                  :total
  end
end
