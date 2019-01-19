# frozen_string_literal: true

require 'yaml'
require_relative 'gcp_encrypt/version'

class GcpEncrypt
  class AlreadyInitialized < StandardError;
  end
  class ConfigurationFileNotFound < StandardError;
  end
  class GitNotFound < StandardError;
  end

  CONFIG_FILE = '.gcp-encrypt.yml'
  GIT_IGNORE_START = "### GCP ENCRYPT BEGIN"
  GIT_IGNORE_END = "### GCP ENCRYPT END"

  def init
    raise AlreadyInitialized, "#{CONFIG_FILE} already exists" if File.exists?(CONFIG_FILE)
    f = File.open(CONFIG_FILE, 'w+')
    f.write(template_config)
    f.close
  end

  def git_config
    raise GitNotFound, 'Could not find `git` executable' unless system('which git')
    git_files = `git ls-files`.split("\n")
    files.each do |file|
      if git_files.include?(file)
        system("git rm --cached #{file}")
      end
    end

    update_gitignore
  end

  def config
    @config ||= load_configurations
  end

  def files
    config['files']
  end

  private

  def template_config
    File.read(File.join(root_path, 'template', 'config.yml'))
  end

  def root_path
    @root_path ||= File.join(File.dirname(__FILE__), '..')
  end

  def load_configurations
    raise ConfigurationFileNotFound, "#{CONFIG_FILE} was not found" unless File.exists?(CONFIG_FILE)
    YAML.safe_load(File.read(CONFIG_FILE))
  end

  def update_gitignore
    current_gitignore = File.exists?('.gitignore') ? File.read('.gitignore') : ''
    gitignore_lines = current_gitignore.split("\n")

    gitignore = ''
    started = false
    finished = false
    gitignore_lines.each_with_index do |line|
      if finished
        gitignore += "#{line}\n"
      elsif started
        if line == GIT_IGNORE_END
          files.each do |file|
            gitignore += "#{file}\n"
          end
          gitignore += "#{line}\n"
          finished = true
        end
      else
        gitignore += "#{line}\n"
        started = true if line == GIT_IGNORE_START
      end
    end

    unless started
      gitignore += "\n" unless gitignore.size == 0
      gitignore += "#{GIT_IGNORE_START}\n"
      files.each do |file|
        gitignore += "#{file}\n"
      end
      gitignore += "#{GIT_IGNORE_END}\n"
    end

    f = File.open('.gitignore', 'w+')
    f.write(gitignore)
    f.close
  end
end
