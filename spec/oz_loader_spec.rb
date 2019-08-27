require 'rspec'
require 'oz/utils/oz_loader'

class TestObject
end

describe Oz::OzLoader do
  let!(:script_dir) {"#{__dir__}/fixtures/test_scripts"}
  let!(:file1){"#{__dir__}/fixtures/test_scripts/some_file"}
  let!(:file2){"#{__dir__}/fixtures/test_scripts/another_dir/another_file"}

  context 'Self Methods (static context), called using Oz::OzLoader.' do
    before{ ENV['OZ_CORE_DIR'] = './' }
    context :check_gems do
      it 'allows me to check if a gem is installed' do
        result = Oz::OzLoader.check_gems(%w[psych json], 'TestModule')
        expect(result).to be true
      end

      it 'raises an error if a gem is not detected in the users sdk, telling me which gems were not detected' do
        expect{
          Oz::OzLoader.check_gems(%w[psych json bloof], 'TestModule')
        }.to raise_error(RuntimeError){ |error|
          expect(error.message).to include('TestModule')
        }.and output(/bloof: false/).to_stderr
      end

      it 'notifies me which gems were installed when it detects gems that were not' do
        expect{
          Oz::OzLoader.check_gems(%w[psych json bloof], 'TestModule')
        }.to raise_error(RuntimeError){ |error|
          expect(error.message).to include('TestModule')
        }.and output(/json: true/).to_stderr
      end

    end
    context :ensure_installed do
      it 'will ensure that gems are installed as well as checking their presence' do
        # No test here because anything i wrote could only run once, exists for docs
      end
    end

    context :require_all do
      it 'will require all ruby files in a given directory at non-recursive depth (each subfolder must be added manually)' do
        # implicitly tested by :project_modules, so can't validate in this test.
        Oz::OzLoader.require_all(script_dir)
      end
    end

    context :recursively_require_all_base_pages do
      it 'will require all files containing base_page in a directory recursively' do
        Oz::OzLoader.recursively_require_all_base_pages("#{script_dir}/pages")
        expect(defined? SomeBasePage).to be_truthy, 'SomeBasePage was not defined should have been'
        expect(defined? AnotherBasePage).to be_truthy, 'AnotherBasePage was not defined, should have been'
      end
    end

    context :recursively_require_all_root_pages do
      it 'will require all files containing root_page in a directory recursively' do
        Oz::OzLoader.recursively_require_all_root_pages("#{script_dir}/pages")
        expect(defined? SomeRootPage).to be_truthy, 'SomeRootPage was not defined should have been'
        expect(defined? AnotherRootPage).to be_truthy, 'AnotherRootPage was not defined, should have been'
      end
    end

    context :recursively_require_all_edge_pages do
      it 'will require all remaining pages in a directory recursively' do
        Oz::OzLoader.recursively_require_all_edge_pages("#{script_dir}/pages")
        expect(defined? SomePage).to be_truthy, 'SomePage was not defined should have been'
        expect(defined? AnotherPage).to be_truthy, 'AnotherPage was not defined, should have been'
      end
    end

    context :append_to_world do
      it 'abstracts logic for extending the main execution object of various frameworks' do
        # I can't think of a great way to test this, but it's equivalent to World in cucumber...
      end

      it 'is skipped for the purpose of rspec testing' do
        Oz::OzLoader.rspec = true
        expect{Oz::OzLoader.append_to_world(TestObject)}.to output(/Using RSpec, skipping world injection/).to_stdout
      end
    end

    context :project_modules do
      it 'does not allow you to append an array' do
        expect{Oz::OzLoader.project_modules << ['foo', 'bar', 'bazz']}.to raise_error(ArgumentError)
      end

      it 'allows you to declare the directories in which oz will look for overrides and extensions with require_all' do
        Oz::OzLoader.project_modules << script_dir
        Oz::OzLoader.load
        expect(require file1).to be(false), "#{file1} was not required by require all. Should have been."
      end

      it 'allows you to add multiple directories with concat' do
        Oz::OzLoader.project_modules.concat([script_dir, "#{script_dir}/another_dir"])
        Oz::OzLoader.load
        expect(require file1).to be(false), "#{file1} was not required by require all. Should have been."
        expect(require file2).to be(false), "#{file2} was not required by require all. Should have been."
      end
    end

    context :page_stores do
      it 'does not allow you to append an array' do
        expect{Oz::OzLoader.page_stores << %w[foo bar bazz]}.to raise_error(ArgumentError)
      end

      it 'allows you declare directories in which oz will call the page load methods' do
        fork do
          Oz::OzLoader.page_stores << "#{script_dir}/pages"
          Oz::OzLoader.load
          expect(defined? SomeBasePage).to be_truthy, 'SomeBasePage was not defined should have been'
          expect(defined? AnotherBasePage).to be_truthy, 'AnotherBasePage was not defined, should have been'
          expect(defined? AnotherPage).to be_truthy, 'AnotherPage was not defined, should have been'
          expect(defined? SomePage).to be_truthy, 'SomePage was not defined, should have been'
          expect(defined? AnotherRootPage).to be_truthy, 'AnotherRootPage not was defined, should have been'
          expect(defined? SomeRootPage).to be_truthy, 'SomeRootPage was not defined, should have been'
        end
      end

      it 'allows you to add multiple directories with concat (see project_modules)' do
      end
    end

    context :load_libs do
      it 'can be overridden to add further loading logic to oz loader' do
        module Oz
          module OzLoader
            def load_libs
              puts 'Loaded extra libs'
            end
          end
        end
        # This does not actually work in unit tests because this oz loader is container in the example group just here for doc purposes.
      end
    end

  end
end