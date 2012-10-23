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
      target, opts = create_before(name)

      Gen::CLI.source_root("templates/gem_cli")
      template(File.join("Gemfile.tt"),               File.join(target, "Gemfile"),                opts)
      template(File.join("Rakefile.tt"),              File.join(target, "Rakefile"),               opts)
      template(File.join("LICENSE.txt.tt"),           File.join(target, "LICENSE.txt"),            opts)
      template(File.join("README.md.tt"),             File.join(target, "README.md"),              opts)
      template(File.join(".gitignore.tt"),            File.join(target, ".gitignore"),             opts)
      template(File.join("newgem.gemspec.tt"),        File.join(target, "#{name}.gemspec"),        opts)
      template(File.join("lib/newgem.rb.tt"),         File.join(target, "lib/#{name}.rb"),         opts)
      template(File.join("lib/newgem/version.rb.tt"), File.join(target, "lib/#{name}/version.rb"), opts)
      template(File.join("lib/newgem/cli.rb.tt"),     File.join(target, "lib/#{name}/cli.rb"),     opts)
      
      template(File.join("bin/newgem.tt"),            File.join(target, 'bin', name),              opts)
      chmod(File.join(target, 'bin', name), 0755)
      directory(File.join(".bundle"),                 File.join(target, ".bundle"))

      create_after(target)
    end

    desc "motion", "create skelton for motion"
    def motion(name)
      name = name.chomp("/")
      target, opts = create_before(name)
      Gen::CLI.source_root("templates/motion")
      template(File.join("Rakefile.tt"),              File.join(target, "Rakefile"),               opts)
      template(File.join("LICENSE.txt.tt"),           File.join(target, "LICENSE.txt"),            opts)
      template(File.join("README.md.tt"),             File.join(target, "README.md"),              opts)
      template(File.join(".gitignore.tt"),            File.join(target, ".gitignore"),             opts)
      template(File.join("app/app_delegate.rb.tt"),   File.join(target, "app/app_delegate.rb"),    opts)
      directory(File.join("resources"),               File.join(target, "resources"))
      template(File.join("spec/main_spec.rb.tt"),     File.join(target, "spec/main_spec.rb"),      opts)

      create_after(target)
    end

    desc "sinatra", "create skelton sinatra app"
    def sinatra(name)
      name = name.chomp("/")
      target, opts = create_before(name)
      Gen::CLI.source_root("templates/sinatra")

      template_dir( target, ".bundle",        opts)
      template_file(target, ".gitignore.tt",  opts)
      template_file(target, "Gemfile.tt",     opts)
      template_file(target, "LiCENSE.txt.tt", opts)
      template_file(target, "README.md.tt",   opts)
      template_file(target, "Rakefile.tt",    opts)
      template_file(target, "app.rb.tt",      opts)
      template_dir( target, "app",            opts)
      template_dir( target, "config",         opts)
      template_file(target, "config.ru",      opts)
      template_dir( target, "db",             opts)
      template_dir( target, "doc",            opts)
      template_dir( target, "lib",            opts)
      template_dir( target, "log",            opts)
      template_dir( target, "public",         opts)
      template_dir( target, "script",         opts)
      template_dir( target, "test",           opts)
      template_dir( target, "tmp",            opts)
      create_after(target)
    end

    private
    def template_file(target, name, opts)
      name_out ||= name.sub(/\.tt$/, "")
      template(name, File.join(target, name_out), opts)
    end
    def template_dir(target, name, opts)
      directory(name, File.join(target, name), opts)
    end

    def create_before(name)
      name = name.chomp("/")
      target = File.join(Dir.pwd, name)
      constant_name = name.split('_').map(&:capitalize).join
      constant_name = constant_name.split('-').map(&:capitalize).join('::') if constant_name =~ /-/
      constant_array = constant_name.split('::')
      git_user_name = `git config user.name`.chomp
      git_user_email = `git config user.email`.chomp
      return target, {
        :name           => name,
        :constant_name  => constant_name,
        :constant_array => constant_array,
        :author         => git_user_name.empty? ? "TODO: Write your name" : git_user_name,
        :email          => git_user_email.empty? ? "TODO: Write your email address" : git_user_email
      }
    end
    def create_after(target)
      Dir.chdir(target) { `git init` }
    end
  end
end
