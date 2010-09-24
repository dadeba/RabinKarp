#!/usr/bin/ruby

require File.join(File.dirname(__FILE__), '/spec_helper')

describe RabinKarp do
  describe "(performance test)" do
    GREP_LOG = path("../grep.log")
    RK_LOG = path("../rk.log")

    def bench(pattern, file)
      def run_grep(pattern, file)
        system("grep #{pattern} #{file} > #{GREP_LOG}")
      end

      def run_rk(pattern, file)
        matcher = RabinKarp.new(pattern)
        src = Pathname(file).open("r")
        dst = RK_LOG.open("w+")
        while line = src.gets
          dst.puts line if matcher.run(line)
        end
      ensure
        src.close
        dst.close
      end

      RBench.run(1) {
        report("grep")      { run_grep(pattern, file) }
        report("RabinKarp") { run_rk(pattern, file) }
      }
    end

    patterns = %w( each while end )
    data = path("data.txt")

    patterns.each do |pattern|
      it pattern do 
        # bench("each", "../../lib/rk.rb")
        bench(pattern, data)

        # check the results are valid or not
        RK_LOG.exist?.should == true
        GREP_LOG.exist?.should == true

        `cmp #{RK_LOG} #{GREP_LOG}`.should == ''
      end
    end
  end
end
