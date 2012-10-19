require 'thor'

module Gen
  class CLI < Thor
    include Thor::Actions
    
    def initialize(*args)
      super
    end

    desc "cli", "create gem for cli"
    def cli(name)
      name = name.chomp("/")
      target = File.join(Dir.pwd, name)
      constant_name = name.split('_').map(&:capitalize).join
      constant_name = constant_name.split('-').map(&:capitalize).join('::') if constant_name =~ /-/
      constant_array = constant_name.split('::')
      git_user_name = `git config user.name`.chomp
      git_user_email = `git config user.email`.chomp
      opts = {
        :name           => name,
        :constant_name  => constant_name,
        :constant_array => constant_array,
        :author         => git_user_name.empty? ? "TODO: Write your name" : git_user_name,
        :email          => git_user_email.empty? ? "TODO: Write your email address" : git_user_email
      }
      Gen::CLI.source_root("templates/gem_cli")
      template(File.join("Gemfile.tt"),               File.join(target, "Gemfile"),                opts)
      template(File.join("Rakefile.tt"),              File.join(target, "Rakefile"),               opts)
      template(File.join("LICENSE.txt.tt"),           File.join(target, "LICENSE.txt"),            opts)
      template(File.join("README.md.tt"),             File.join(target, "README.md"),              opts)
      template(File.join("gitignore.tt"),             File.join(target, ".gitignore"),             opts)
      template(File.join("newgem.gemspec.tt"),        File.join(target, "#{name}.gemspec"),        opts)
      template(File.join("lib/newgem.rb.tt"),         File.join(target, "lib/#{name}.rb"),         opts)
      template(File.join("lib/newgem/version.rb.tt"), File.join(target, "lib/#{name}/version.rb"), opts)
      template(File.join("lib/newgem/cli.rb.tt"),     File.join(target, "lib/#{name}/cli.rb"),     opts)

      template(File.join("bin/newgem.tt"),            File.join(target, 'bin', name),              opts)
      chmod(File.join(target, 'bin', name), 0755)
      directory(File.join(".bundle"),                 File.join(target, ".bundle"))
      Dir.chdir(target) { `git init` }
    end

  end
end
