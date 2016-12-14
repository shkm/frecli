require 'tmpdir'

RSpec.describe Frecli::Cache do
  ROOT_PATH = Dir.getwd
  let(:dir) { "#{ROOT_PATH}/tmp/test" }
  let(:file) { [dir, 'foo.json'].join('/') }

  before do
    stub_const 'Frecli::Cache::PATHS', foo: '/foo.json'
  end

  around(:each) do |spec|
    FileUtils.rm_rf(dir) if Dir.exist?(dir)

    Dir.chdir(ROOT_PATH, &spec)

    FileUtils.rm_rf(dir) if Dir.exist?(dir)
  end

  subject(:cache) { Frecli::Cache.new(dir, 30) }

  describe '#initialize' do
    context 'when a folder does not exist' do
      it 'creates the folder' do
        expect { subject }
          .to change { Dir.exist?(dir) }
          .from(false)
          .to(true)
      end
    end
  end

  describe '#cached? / #uncached?' do
    context 'when the path is not set in PATHS' do
      it 'raises a Frecli::Cache::PathNotFoundError.' do
        expect { subject.cached?(:nonexistant) }
          .to raise_error(Frecli::Cache::PathNotFoundError)
        expect { subject.uncached?(:nonexistant) }
          .to raise_error(Frecli::Cache::PathNotFoundError)
      end
    end

    context 'when the path is set' do
      context 'and the file does not exist' do
        it 'does not raise an error' do
          expect { subject.cached?(:foo) }.not_to raise_error
          expect { subject.uncached?(:foo) }.not_to raise_error
        end

        it 'returns false for #cached?' do
          expect(subject.cached?(:foo)).to eq false
        end

        it 'returns true for #uncached?' do
          expect(subject.uncached?(:foo)).to eq true
        end
      end

      context 'and the file exists' do
        before do
          FileUtils.mkdir_p dir
          FileUtils.touch file
        end

        context 'and the file is not cached within TTL' do
          before { FileUtils.touch file, mtime: Time.at(0) }

          it 'returns false for #cached?' do
            expect(subject.cached?(:foo)).to eq false
          end

          it 'returns true for #uncached?' do
            expect(subject.uncached?(:foo)).to eq true
          end
        end

        context 'and the file is cached within TTL' do
          it 'returns true for #cached?' do
            expect(subject.cached?(:foo)).to eq true
          end

          it 'returns false for #uncached?' do
            expect(subject.uncached?(:foo)).to eq false
          end
        end
      end
    end
  end

  describe '#cache!' do
    it 'stores a file containing the cached data' do
      objects = [FreckleApi::Project.new(id: 37_396, name: 'Gear GmbH')]

      subject.cache!(:foo, objects)

      expect(File.exist?(file)).to eq true
    end
  end

  describe '#get' do
    context 'when cache does not exist' do
      it "raises a Frecli::Cache::NotCachedError." do
        expect { subject.get(:foo) }
          .to raise_error(Frecli::Cache::NotCachedError)
      end
    end

    context 'when cache does exist' do
      before do
        objects = [FreckleApi::Project.new(id: 37_396, name: 'Gear GmbH')]

        subject.cache!(:foo, objects)
      end

      it 'deserializes cached data into an array' do
        expect(subject.get(:foo)).to be_a(Array)
      end

      it 'contains objects of the given class' do
        subject.get(:foo, as: FreckleApi::Project).each do |project|
          expect(project).to be_a(FreckleApi::Project)
        end
      end

      it 'contains objects with the expected data' do
        project = subject.get(:foo, as: FreckleApi::Project).first

        expect(project.id).to eq 37_396
        expect(project.name).to eq 'Gear GmbH'
      end
    end
  end
end
