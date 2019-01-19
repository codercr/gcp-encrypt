RSpec.shared_examples 'requires configurations' do
  context 'without configuration' do
    before do
      File.delete(GcpEncrypt::CONFIG_FILE) if File.exists?(GcpEncrypt::CONFIG_FILE)
    end

    it 'throws an exception if configuration file is not found' do
      expect(File.exists?(config_file)).to be_falsey
      expect { subject }.to raise_error(GcpEncrypt::ConfigurationFileNotFound,
                                        '.gcp-encrypt.yml was not found')
    end
  end
end

RSpec.shared_context 'with configuration file' do
  let(:settings) do
    GcpEncryptHelper::DEFAULT_SETTINGS
  end

  let(:files) do
    GcpEncryptHelper::DEFAULT_FILES
  end

  let(:config) { GcpEncryptHelper.generate_config(settings: settings, files: files) }

  before { GcpEncryptHelper.create_config_file(config: config) }
end
