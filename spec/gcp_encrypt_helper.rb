module GcpEncryptHelper
  DEFAULT_SETTINGS = {
    'project' => 'test-project',
    'location' => 'test-location',
    'keyring' => 'test-keyring',
    'key' => 'test-key',
  }.freeze

  DEFAULT_FILES = %w(
    test1.txt
    test2.txt
    test3.txt
  ).freeze

  def self.template_file
    root_path = File.join(File.dirname(__FILE__), '..')
    File.join(root_path, 'template', 'config.yml')
  end

  def self.template_config
    template = File.read(template_file)
    raise Exception, "Invalid template path" if template.size == 0
    template
  end

  def self.create_config_file(config: nil)
    f = File.open(GcpEncrypt::CONFIG_FILE, 'w+')
    f.write(YAML.dump(config || generate_config))
    f.close
  end

  def self.generate_config(settings: {}, files: nil)
    config = YAML.load(template_config)
    config['settings'] = DEFAULT_SETTINGS.merge(settings)
    config['files'] = files || DEFAULT_FILES
    config
  end

  def self.create_gitignore(data: nil)
    f = File.open('.gitignore', 'w+')
    f.write(data) unless data.nil?
    f.close
  end

  def self.read_gitignore
    f = File.open('.gitignore', 'r')
    data = f.read
    f.close
    data
  end

  def self.load_fixture(file)
    path = File.join(File.dirname(__FILE__), 'fixtures', file)
    f = File.open(path, 'r')
    fixture = f.read
    f.close
    fixture
  end
end
