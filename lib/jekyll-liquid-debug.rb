require "liquid"
require "kramdown"
require "optparse"
require "hash_dot"
require "yaml"
require_relative "jekyll-liquid-debug/version"

class JekyllLiquidDebug
  class Parser
    def self.parse(options)
      # Hash to contain all settings
      # it is needed to set default values, to help use Struct make Hash dottable.
      # because Struct does not have method to check whether key exists
      args = {file:false, html:false, kmd:false, outhtml:false, outmd:false,
              yaml:false,
      }
      OptionParser.new do |opt|
        opt.banner = "Usage: jekyll-liquid-debug [options]"
        opt.separator ""
        opt.separator "Input files:"

        opt.on("-f", "--file [FILE]", String, "input liquid template") do |v|
          args[:file] = Parser.func_set_file(v)
        end

        opt.on("-t", "--html [FILE]", String, "input html template") do |v|
          args[:html] = Parser.func_set_file(v)
        end

        opt.on("-y", "--yaml [FILE]", String, "input YAML file, parsed to `site.[var]'") do |v|
          args[:yaml] = Parser.func_set_file(v)
        end

        opt.on("-k", "--md [FILE]", String, "input raw markdown file, precedent for option `-t'") do |v|
          args[:kmd] = Parser.func_set_file(v)
        end

        opt.on("--out-html", TrueClass, "output html file, overwrite may happen") do |v|
          args[:outhtml] = true
        end

        opt.on("--out-md", TrueClass, "output markdown file, overwrite may happen") do |v|
          args[:outmd] = true
        end

        opt.separator ""
        opt.separator "Common options:"
        opt.on_tail("-h", "--help", "Show help message") do
          puts opt
          exit
        end
        opt.on_tail("-v", "--version", "Show version") do
          puts "Version #{VERSION}"
          exit
        end
        opt.on_tail("--feature", "Show development feature") do
          FEATURE.each { |x| puts x }
          exit
        end
      end.parse!(options)

      return args
    end

    def self.func_set_file(file)
      if File.file?(file)
        return file
      else
        puts "Fatal: < #{file} > is not a file"
        exit
      end
    end
  end


  def self.run
    args = Parser.parse(ARGV)
    # make Hash dottable
    args = Struct.new(*args.keys).new(*args.values)

    if args.kmd
      puts "Note: using input markdown file < #{args.kmd} >"
      # read input markdown
      fmd = File.open(args.kmd).read

      if args.yaml
        puts "Note: using input YAML file < #{args.yaml} >"
        site = YAML.load_file(args.yaml).to_dot
        fmd = Liquid::Template.parse(fmd).render("site" => site)
      end

      # html conversion
      content = Kramdown::Document.new(fmd).to_html
      fbase = File.basename(args.kmd,".*")
    elsif args.html
      puts "Note: using input html file < #{args.html} >"
      fmd = false
      content = File.open(args.html).read
      fbase = File.basename(args.html,".*")
    else
      puts "Note: using default markdown file < jekyll-markdown.md >"
      fmd = File.open(File.expand_path("../../data/jekyll-markdown.md",__FILE__)).read
      content = Kramdown::Document.new(fmd).to_html
      fbase = 'jekyll-markdown'
    end

    # output html
    if args.outhtml
      name = fbase + ".html"
      puts "Note: writing < html > to file < #{name} >"
      File.new(name,'w').write(content)
    end

    # output markdown
    if args.outmd
      if args.html
        name = "jekyll-markdown.md"
        FileUtils.cp(File.expand_path("../../data/jekyll-markdown.md",__FILE__), '.')
      else
        name = fbase + ".md"
        File.new(name,'w').write(fmd)
      end
      puts "Note: writing < markdown > to file < #{name} >"
    end

    if args.file
      liquid = File.open(args.file).read
      puts Liquid::Template.parse(liquid).render("content" => content)
    end
  end
end
