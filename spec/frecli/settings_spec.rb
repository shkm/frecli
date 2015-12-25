RSpec.describe Frecli::Settings do
  describe '#settings' do
    ROOT_PATH = "#{Dir.getwd}/spec/fixtures/settings"

    around(:each) do |spec|
      dir = [
        ROOT_PATH,
        'Users',
        'isaac',
        fixture
      ].join('/')

      Dir.chdir(dir, &spec)
    end

    let(:settings) { Frecli::Settings.settings(root_path: ROOT_PATH, reload: true) }

    context "when a .frecli file exists only in user's home" do
      let(:fixture) { 'project_without_settings' }

      it "stores the file's settings" do
        expect(settings).to eq(api_key: 'the_api_key')
      end
    end

    context 'when a .frecli directory exists' do
      let(:fixture) { 'project_with_frecli_folder' }

      it 'includes settings from all files in the folder' do
        expect(settings).to eq(
          api_key: 'the_api_key', # from home
          setting_one: 1,
          setting_two: 2
        )
      end
    end

    context 'when .frecli files exist in both home and current dir' do
      let(:fixture) { 'project_with_settings' }

      it "stores both files' settings" do
        expect(settings).to eq(api_key: 'the_api_key', foo: 'bar')
      end
    end

    context 'when multiple .frecli files exist' do
      let(:fixture) { 'project_with_override' }

      it 'overrides a previously set setting with the more specific one.' do
        expect(settings).to eq(api_key: 'overridden_api_key')
      end
    end
  end
end
