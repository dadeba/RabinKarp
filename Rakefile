require 'rubygems'
require 'pathname'
require 'spec/rake/spectask'

desc 'Default: run spec examples'
task :default => 'spec'

desc 'spec'
task 'spec' do
  system("spec -cfs spec/")
end

task :data do
  Rake::Task["data:convert"].execute
  Rake::Task["data:index"].execute
end

namespace :data do
  desc "convert data file(utf8) into utf32"
  task :convert do
    abort "Error: missing #{u8}" unless u8.exist?
    if !u32.exist? or u8.mtime > u32.mtime
      do_convert(u8, u32)
      puts "Created #{u32}"
    else
      puts "Skip #{u32} (already exists)"
    end
  end

  desc "create an index file that tells start bytes of each lines"
  task :index do
    abort "Error: missing #{u32}" unless u32.exist?
    if !idx.exist? or u32.mtime > idx.mtime
      do_index(u32, idx)
      puts "Created #{idx}"
    else
      puts "Skip #{idx} (already exists)"
    end
  end

  desc "clean u32 data file"
  task :clean do
    tmps = [u32, idx]
    tmps.each{|p| p.unlink if p.exist?}
  end


  def dir
    Pathname(File.dirname(__FILE__)) + "data"
  end

  def u8
    dir + "data.u8"
  end

  def u32
    dir + "data.u32"
  end

  def idx
    dir + "data.idx"
  end

  def do_convert(src, dst)
    system("iconv -f utf8 -t utf32 #{src} > #{dst}")
  end

  def do_index(src, dst)
    dst.open("w+") do |f|
      bom = [255,254,  0,  0].pack('C*')
      ret = [ 10,  0,  0,  0].pack('C*')
      bin = src.open("r")
      pos = 0
      new = false

      while unicode = bin.read(4)
        case unicode
        when bom, ret
          new = true
        else
          f.puts pos if new
          new = false
        end
        pos += 4
      end
    end
  end
end

