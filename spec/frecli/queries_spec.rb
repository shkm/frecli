RSpec.describe Frecli::Queries do
  let(:key) { 'foo' }

  before do
    stub_const 'Frecli::Cache::PATHS', key => '/foo.json'
  end

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
    let(:records) { [{ name: 'foo' }] }

    context 'when given a key that is cached' do

      before do
        allow(subject.cache)
          .to receive(:uncached?)
          .with(key)
          .and_return(false)
        allow(subject.cache)
          .to receive(:get)
          .with(key, as: Hash)
          .and_return(records)
      end

      it 'does not call the api.' do
        expect { subject.lookup(key) }.not_to raise_error
      end

      it 'returns the cached records.' do
        expect(subject.lookup(key)).to eq records
      end

      context 'and told to refresh' do
        before do
          allow(subject.api)
            .to receive(:send)
            .with(key)
            .and_return(records)
        end

        it 'calls the API.' do
          expect(subject.api)
            .to receive(:send)
            .with(key)

          subject.lookup(key, refresh: true)
        end

        it 're-caches the records' do
          expect(subject.cache)
            .to receive(:cache!)
            .with(key, records)

          subject.lookup(key, refresh: true)
        end
      end
    end

    context 'when given a key that is not cached.' do
      before do
        allow(subject.cache)
          .to receive(:uncached?)
          .with(key)
          .and_return(true)
        allow(subject.api)
          .to receive(:send)
          .with(key)
          .and_return(records)
        allow(subject.cache)
          .to receive(:get)
          .with(key, as: Hash)
          .and_return(records)
      end

      it 'calls the API.' do
        expect(subject.api)
          .to receive(:send)
          .with(key)

        subject.lookup(key)
      end

      it 'returns the cached records' do
        expect(subject.lookup(key)).to eq records
      end

      context 'and told not to fall back to the API' do
        it 'raises a Frecli::Cache::NotCachedError' do
          expect { subject.lookup(key, api_fallback: false) }
            .to raise_error(Frecli::Cache::NotCachedError)
        end
      end

      it 'caches the records' do
        expect(subject.cache)
          .to receive(:cache!)
          .with(key, records)

        subject.lookup(key, refresh: true)
      end
    end
  end
end
