# frozen_string_literal: true

require(File.expand_path('spec_helper', __dir__))
require('code_coverage/coverage_parser')

module CodeCoverage
  describe CoverageParser do
    before do
      @parser = CoverageParser.new
      @content = nil
    end

    it 'extracts all file coverage' do
      read_file('/assets/coverage_jacoco.json')
      items = @parser.parse(@content)
      expect(items.length).to(be(18))
    end

    context 'html not found' do
      it 'returns empty hash' do
        read_file('/assets/missing_json.html')
        items = @parser.parse(@content)
        expect(items.length).to(be_zero)
      end
    end

    context 'no files in json' do
      it 'returns empty json' do
        read_file('/assets/coverage_no_files.json')
        items = @parser.parse(@content)
        expect(items.length).to(be_zero)
      end
    end

    context 'jacoco' do
      it 'combines directory and file name' do
        read_file('/assets/coverage_jacoco_single.json')
        items = @parser.parse(@content)
        expect(items.length).to(be(1))
        expect(items.first.file).to(eq('com/example/kyaak/myapplication/MainActivity.java'))
      end

      it 'parses elements' do
        read_file('/assets/coverage_jacoco_single.json')
        items = @parser.parse(@content)
        expect(items.length).to(be(1))
        expect(items.first.line).to(be(75.0))
        expect(items.first.method).to(be(13.34))
        expect(items.first.instruction).to(be(65.44))
        expect(items.first.conditional).to(be(49.99))
      end
    end

    context 'cobertura' do
      it 'does not add parent name if file has directory' do
        read_file('/assets/coverage_cobertura_single.json')
        items = @parser.parse(@content)
        expect(items.length).to(be(1))
        expect(items.first.file).to(eq('src/cpp/default/builder_example/ExampleListener.cpp'))
      end

      it 'does not add python packages' do
        read_file('/assets/coverage_cobertura_python.json')
        items = @parser.parse(@content)
        expect(items.length).to(be(12))
        items.each do |item|
          expect(item.file).not_to(match(%r{.*\..*\/.*}))
        end
      end

      it 'does not add dot packages' do
        read_file('/assets/coverage_dot_package_single.json')
        items = @parser.parse(@content)
        expect(items.length).to(be(1))
        expect(items.first.file).to(eq('generator.py'))
      end
    end

    context
  end
end

def read_file(file)
  @content = File.read(File.dirname(__FILE__) + file)
end
