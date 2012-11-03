require "gen/version"
require "gen/cli"

module Gen
  def self.root
    File.expand_path '../..', __FILE__
  end
  def self.bin
    File.join root, 'bin'
  end
  def self.lib
    File.join root, 'lib'
  end
  def self.templates
    File.join root, 'templates'
  end
end
