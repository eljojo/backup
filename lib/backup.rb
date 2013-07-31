# encoding: utf-8

# Load Ruby Core Libraries
require 'fileutils'
require 'tempfile'
require 'syslog'
require 'yaml'
require 'etc'
require 'forwardable'
require 'thread'

require 'open4'
require 'thor'

##
# The Backup Ruby Gem
module Backup

  ##
  # Backup's internal paths
  LIBRARY_PATH       = File.join(File.dirname(__FILE__), 'backup')
  STORAGE_PATH       = File.join(LIBRARY_PATH, 'storage')
  SYNCER_PATH        = File.join(LIBRARY_PATH, 'syncer')
  DATABASE_PATH      = File.join(LIBRARY_PATH, 'database')
  COMPRESSOR_PATH    = File.join(LIBRARY_PATH, 'compressor')
  ENCRYPTOR_PATH     = File.join(LIBRARY_PATH, 'encryptor')
  NOTIFIER_PATH      = File.join(LIBRARY_PATH, 'notifier')
  TEMPLATE_PATH      = File.expand_path('../../templates', __FILE__)

  ##
  # Autoload Backup storage files
  module Storage
    autoload :Base,       File.join(STORAGE_PATH, 'base')
    autoload :Cycler,     File.join(STORAGE_PATH, 'cycler')
    autoload :S3,         File.join(STORAGE_PATH, 's3')
    autoload :Local,      File.join(STORAGE_PATH, 'local')
  end

  ##
  # Autoload Backup syncer files
  module Syncer
    autoload :Base, File.join(SYNCER_PATH, 'base')
    module Cloud
      autoload :Base,       File.join(SYNCER_PATH, 'cloud', 'base')
      autoload :LocalFile,  File.join(SYNCER_PATH, 'cloud', 'local_file')
      autoload :S3,         File.join(SYNCER_PATH, 'cloud', 's3')
    end
  end

  ##
  # Autoload Backup database files
  module Database
    autoload :Base,       File.join(DATABASE_PATH, 'base')
    autoload :MySQL,      File.join(DATABASE_PATH, 'mysql')
    autoload :PostgreSQL, File.join(DATABASE_PATH, 'postgresql')
    autoload :MongoDB,    File.join(DATABASE_PATH, 'mongodb')
    autoload :Redis,      File.join(DATABASE_PATH, 'redis')
    autoload :Riak,       File.join(DATABASE_PATH, 'riak')
  end

  ##
  # Autoload compressor files
  module Compressor
    autoload :Base,   File.join(COMPRESSOR_PATH, 'base')
    autoload :Gzip,   File.join(COMPRESSOR_PATH, 'gzip')
    autoload :Bzip2,  File.join(COMPRESSOR_PATH, 'bzip2')
    autoload :Custom, File.join(COMPRESSOR_PATH, 'custom')
    autoload :Pbzip2, File.join(COMPRESSOR_PATH, 'pbzip2')
    autoload :Lzma,   File.join(COMPRESSOR_PATH, 'lzma')
  end

  ##
  # Autoload encryptor files
  module Encryptor
    autoload :Base,    File.join(ENCRYPTOR_PATH, 'base')
    autoload :OpenSSL, File.join(ENCRYPTOR_PATH, 'open_ssl')
    autoload :GPG,     File.join(ENCRYPTOR_PATH, 'gpg')
  end

  ##
  # Require Backup base files
  %w{
    errors
    logger
    utilities
    archive
    binder
    cleaner
    config
    cli
    configuration
    model
    package
    packager
    pipeline
    splitter
    template
    version
  }.each {|lib| require File.join(LIBRARY_PATH, lib) }

end
