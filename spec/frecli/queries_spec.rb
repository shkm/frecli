RSpec.describe Frecli::Queries do
  subject { module Dummy; include Frecli::Queries; end }

  describe '.api' do
    it 'returns a FreckleApi instance' do
      expect(subject.api).to be_a(FreckleApi)
    end

    it 'caches the object' do
      expect(subject.api).to eq subject.api
    end
  end

  describe '.cache' do
    it 'returns a Frecli::Cache instance' do
      expect(subject.cache).to be_a(Frecli::Cache)
    end

    it 'caches the object' do
      expect(subject.cache).to eq subject.cache
    end
  end

  describe 'lookup' do
    # note: 'foo' is not an implemented method on FreckleApi.
    # as such, an exception is thrown when the API is called.
    let(:key) { 'foo' }
    context 'when passed given a key that is cached' do
      let(:records) { [{ name: 'foo' }] }

      before do
        stub_const 'Frecli::Cache::PATHS', key => '/foo.json'

        allow(subject.cache)
          .to receive(:uncached?)
          .with(key)
          .and_return(false)
        allow(subject.cache)
          .to receive(:get)
          .with(key, as: Hash)
          .and_return(records)
      end

      it 'does not call the api' do
        expect { subject.lookup(key) }.not_to raise_error
      end

      it 'returns the cached records' do
        expect(subject.lookup(key)).to eq records
      end
    end
  end
end
