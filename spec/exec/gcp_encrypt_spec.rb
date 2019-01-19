working_directory = Dir.pwd
test_directory = File.join(working_directory, 'exe-tests')
Dir.rmdir(test_directory) if Dir.exists?(test_directory)

RSpec.describe 'Exec gcp-encrypt' do
  subject { load File.join(working_directory, 'exe', 'gcp-encrypt') }

  it 'returns usage when no command is passed' do
    expect { subject }.to output(/Usage: gcp-encrypt <command> \[option\]/).to_stdout
  end

  it 'returns usage on invalid command' do
    stub_const('ARGV', %w(invalid))
    expect { subject }.to output(/Usage: gcp-encrypt <command> \[option\]/).to_stdout
  end

  it 'returns usage when `init -h` is passed' do
    stub_const('ARGV', %w(init -h))
    expect { subject }.to output(/Usage: gcp-encrypt <command> \[option\]/).to_stdout
  end

  it 'returns encrypt usage when `encrypt -h` is passed' do
    stub_const('ARGV', %w(encrypt -h))
    expect { subject }.to output(/Usage: gcp-encrypt encrypt \[-h\] \[file\] \[file\]/).to_stdout
  end

  it 'returns decrypt usage when `decrypt -h` is passed' do
    stub_const('ARGV', %w(decrypt -h))
    expect { subject }.to output(/Usage: gcp-encrypt decrypt \[-h\] \[file\] \[file\]/).to_stdout
  end

  describe 'init' do
    it 'calls GcpEncrypt#init' do
      stub_const('ARGV', %w(init))
      expect_any_instance_of(GcpEncrypt).to receive(:init)
      subject
    end
  end

  describe 'git-config' do
    it 'calls GcpEncrypt#git_config' do
      stub_const('ARGV', %w(git-config))
      expect_any_instance_of(GcpEncrypt).to receive(:git_config)
      subject
    end
  end

  describe 'version' do
    it 'return version' do
      stub_const('ARGV', %w(version))
      expect { subject }.to output(/gcp-encrypt v#{GcpEncrypt::VERSION}/).to_stdout
    end
  end
end
