## helper functions

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  line = File.read("lib/#{name}.rb")[/^\s*VERSION\s*=\s*.*/]
  line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= ').*'/) { "#{$1}#{send(header_name)}'"}
end

begin
  # Rspec 2.0
  require 'rspec/core/rake_task'

  desc 'Default: run specs'
  task :default => :spec
  RSpec::Core::RakeTask.new do |t|
    t.pattern = "spec/**/*_spec.rb"
  end

  RSpec::Core::RakeTask.new('rcov') do |t|
    t.pattern = "spec/**/*_spec.rb"
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec']
  end

rescue LoadError
  puts "Rspec not available. Install it with: gem install rspec"
end

## release management tasks

desc "Commit, create tag v#{version} and build and push #{gem_file} to Rubygems"
task :release => :build do
  sh "git commit --allow-empty -a -m 'Release #{version}'"
  sh "git tag v#{version}"
  sh "git push"
  sh "git push origin v#{version}"
  sh "gem push pkg/#{gem_file}"
end

desc "Build #{gem_file} into the pkg directory"
task :build => :gemspec do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end

desc "Generate #{gemspec_file}"
task :gemspec do
  # read spec file and split out manifest section
  spec = File.read(gemspec_file)
  head, manifest, tail = spec.split(" # = MANIFEST =\n")

  # replace name version and date
  replace_header(head, :name)
  replace_header(head, :version)

  # determine file list from git ls-files
  files = `git ls-files`.
    split("\n").
    sort.
    reject { |file| file =~ /^\./ }.
    reject { |file| file =~ /^(rdoc|pkg)/ }.
    map { |file| " #{file}" }.
    join("\n")

  # piece file back together and write
  manifest = " s.files = %w[\n#{files}\n ]\n"
  spec = [head, manifest, tail].join(" # = MANIFEST =\n")
  File.open(gemspec_file, 'w') { |io| io.write(spec) }
  puts "Updated #{gemspec_file}"
end

