# frozen_string_literal: true

require(File.expand_path('spec_helper', __dir__))
MARKDOWN_FIRST_TABLE_INDEX = 4
JAVA_ALL_BASELINE = '/var/lib/jenkins/workspace/projectname/b2b-app-android-analyze/repository/'

module Danger
  describe Danger::DangerCodeCoverage do
    it 'should be a plugin' do
      expect(Danger::DangerCodeCoverage.new(nil)).to(be_a(Danger::Plugin))
    end

    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @plugin = @dangerfile.code_coverage
      end

      describe 'report' do
        it 'does not add table if no files in json' do
          mock_coverage_json('/assets/coverage_no_files.json')
          mock_file_in_changeset(true)

          @plugin.report
          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to(be_zero)
        end

        it 'adds header' do
          mock_coverage_json('/assets/coverage_jacoco_single.json')
          mock_file_in_changeset(true)

          @plugin.report
          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to(be(1))
          lines = markdowns.first.message.split("\n")
          headers = lines[2].split('|')
          expect(headers[1]).to(eq('**File**'))
          expect(headers[2]).to(eq('**Total**'))
          expect(headers[3]).to(eq('**Method**'))
          expect(headers[4]).to(eq('**Line**'))
          expect(headers[5]).to(eq('**Conditional**'))
          expect(headers[6]).to(eq('**Instruction**'))
        end

        it 'adds entry values' do
          mock_coverage_json('/assets/coverage_jacoco_single.json')
          mock_file_in_changeset(true)

          @plugin.report
          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to(be(1))
          lines = markdowns.first.message.split("\n")
          entries = lines[4].split('|')
          expect(entries[1]).to(eq('com/example/kyaak/myapplication/MainActivity.java'))
          expect(entries[3]).to(eq('13.34'))
          expect(entries[4]).to(eq('75.0'))
          expect(entries[5]).to(eq('49.99'))
          expect(entries[6]).to(eq('65.44'))
        end

        it 'adds dash for missing value' do
          mock_coverage_json('/assets/coverage_jacoco_no_conditional.json')
          mock_file_in_changeset(true)

          @plugin.report
          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to(be(1))
          lines = markdowns.first.message.split("\n")
          entries = lines[4].split('|')
          expect(entries[1]).to(eq('com/example/kyaak/myapplication/MainActivity.java'))
          expect(entries[3]).to(eq('13.34'))
          expect(entries[4]).to(eq('75.0'))
          expect(entries[5]).to(eq('-'))
          expect(entries[6]).to(eq('65.44'))
        end

        it 'adds total' do
          mock_coverage_json('/assets/coverage_jacoco_single.json')
          mock_file_in_changeset(true)

          @plugin.report
          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to(be(1))
          lines = markdowns.first.message.split("\n")
          entries = lines[4].split('|')
          expect(entries[2]).to(eq('50.94'))
        end

        it 'ignores empty column in total' do
          mock_coverage_json('/assets/coverage_jacoco_no_conditional.json')
          mock_file_in_changeset(true)

          @plugin.report
          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to(be(1))
          lines = markdowns.first.message.split("\n")
          entries = lines[4].split('|')
          expect(entries[2]).to(eq('51.26'))
        end

        it 'sorts lines by total value descending' do
          mock_coverage_json('/assets/coverage_jacoco_multiple_unordered.json')
          mock_file_in_changeset(true)

          @plugin.report
          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to(be(1))
          lines = markdowns.first.message.split("\n")
          first = lines[4].split('|')
          second = lines[5].split('|')
          third = lines[6].split('|')

          expect(first[1]).to(include('MainActivity2.java'))
          expect(second[1]).to(include('MainActivity3.java'))
          expect(third[1]).to(include('MainActivity.java'))
        end
      end
    end
  end
end

def mock_coverage_json(file)
  content = File.read(File.dirname(__FILE__) + file)
  @plugin.stubs(:coverage_json).returns(content)
end

def mock_target_files(list)
  @plugin.stubs(:target_files).returns(list)
end

def mock_file_in_changeset(value)
  @plugin.stubs(:file_in_changeset?).returns(value)
end
