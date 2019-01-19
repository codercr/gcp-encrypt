require 'fileutils'

working_directory = Dir.pwd
test_directory = File.join(working_directory, 'exe-tests')
FileUtils.rm_rf(test_directory) if Dir.exists?(test_directory)

RSpec.describe GcpEncrypt do
  let(:config_file) { File.join(Dir.pwd, '.gcp-encrypt.yml') }

  before do
    Dir.mkdir(test_directory)
    Dir.chdir(test_directory)
  end

  after do
    Dir.chdir(working_directory)
    FileUtils.rm_rf(test_directory)
  end

  it 'has a version number' do
    expect(GcpEncrypt::VERSION).not_to be nil
  end

  describe '#init' do
    subject { described_class.new.init }

    it 'creates configuration file' do
      stub_const('ARGV', %w(init))
      expect { subject }.to change { File.exists?(config_file) }.from(false).to(true)
      config = File.read(config_file)
      expect(config).to eq(GcpEncryptHelper.template_config)
    end

    it 'throws an exception if config file already exists' do
      GcpEncryptHelper.create_config_file
      expect { subject }.to raise_error(GcpEncrypt::AlreadyInitialized,
                                        '.gcp-encrypt.yml already exists')
    end
  end

  describe '#git_config' do
    subject { gcp_encrypt.git_config }

    let(:gcp_encrypt) { described_class.new }

    before do
      allow(gcp_encrypt).to receive(:system).and_return(true)
      GcpEncryptHelper.create_gitignore
    end

    include_examples 'requires configurations'

    context 'with configurations' do
      include_context 'with configuration file'

      before do
        allow(gcp_encrypt).to receive(:'`').with('git ls-files').and_return("test1.txt\ntest2.txt")
      end

      it 'throws an exception if git is not found' do
        expect(gcp_encrypt).to receive(:system).with('which git').and_return(false)
        expect { subject }.to raise_error(GcpEncrypt::GitNotFound, 'Could not find `git` executable')
      end

      it 'removes files from git' do
        expect(gcp_encrypt).to receive(:system).with('git rm --cached test1.txt').and_return(true)
        expect(gcp_encrypt).to receive(:system).with('git rm --cached test2.txt').and_return(true)
        subject
      end

      context 'when .gitignore is empty' do
        it 'adds files to .gitignore' do
          gitignore = GcpEncryptHelper.read_gitignore
          expect(gitignore).not_to match(/test1\.txt/)
          expect(gitignore).not_to match(/test2\.txt/)
          expect(gitignore).not_to match(/test3\.txt/)

          subject

          gitignore = GcpEncryptHelper.read_gitignore
          expect(gitignore).to match(/test1\.txt/)
          expect(gitignore).to match(/test2\.txt/)
          expect(gitignore).to match(/test3\.txt/)
        end
      end

      context 'when .gitignore is updated' do
        let(:files) { %w(test2.txt) }

        before do
          data = GcpEncryptHelper.load_fixture('configured_gitignore.txt')
          GcpEncryptHelper.create_gitignore(data: data)
        end

        it 'adds files to .gitignore' do
          gitignore = GcpEncryptHelper.read_gitignore
          expect(gitignore).to match(/some_file.txt/)
          expect(gitignore).to match(/another_file.txt/)
          expect(gitignore).to match(/test1\.txt/)
          expect(gitignore).to match(/test2\.txt/)
          expect(gitignore).to match(/test3\.txt/)

          subject

          gitignore = GcpEncryptHelper.read_gitignore
          expect(gitignore).not_to match(/test1\.txt/)
          expect(gitignore).to match(/test2\.txt/)
          expect(gitignore).not_to match(/test3\.txt/)
          expect(gitignore).to match(/some_file.txt/)
          expect(gitignore).to match(/another_file.txt/)
        end
      end

      context 'when configuration file has no files' do
        let(:files) { [] }

        it 'does not remove any files from git' do
          allow(gcp_encrypt).to receive(:'`').with('git ls-files').and_return("test1.txt\ntest2.txt")
          expect(gcp_encrypt).not_to receive(:system).with('git rm --cached test1.txt')
          expect(gcp_encrypt).not_to receive(:system).with('git rm --cached test2.txt')
          subject
        end

        context 'when .gitignore is empty' do
          it 'adds files to .gitignore' do
            gitignore = GcpEncryptHelper.read_gitignore
            expect(gitignore).to eq('')

            subject

            gitignore = GcpEncryptHelper.read_gitignore
            expect(gitignore).to match(/### GCP ENCRYPT BEGIN\n### GCP ENCRYPT END/m)
          end
        end
      end
    end
  end

  describe '#encrypt' do
    context 'when no files are passed in' do
      it 'encrypts all files'
    end

    context 'when files are passed in' do
      it 'encrypts only specified files'
    end

    context 'when encrypted file is newer' do
      it 'encrypts only specified files'
    end
  end
end
