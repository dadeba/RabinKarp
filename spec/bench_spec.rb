#!/usr/bin/ruby

require File.join(File.dirname(__FILE__), '/spec_helper')

describe RabinKarp do
  describe "(performance test)" do
    LOGS = {
      'grep'   => path("../gr.log"),
      'rk'     => path("../rk.log"),
      'regexp' => path("../re.log"),
    }

    def bench(pattern, file)
      def run_grep(pattern, file)
        system("grep #{pattern} #{file} > #{LOGS['grep']}")
      end

      def run_ruby(file, log, &match)
        src = Pathname(file).open("r")
        dst = log.open("w+")
        while line = src.gets
          dst.puts line if match.call(line)
        end
      ensure
        src.close
        dst.close
      end

      def run_rk(pattern, file)
        matcher = RabinKarp.new(pattern)
        run_ruby(file, LOGS['rk']) {|line| matcher.run(line) }
      end

      def run_regexp(pattern, file)
        pattern = /#{pattern}/
        run_ruby(file, LOGS['regexp']) {|line| line =~ pattern }
      end

      RBench.run(1) {
        report("grep")        { run_grep(pattern, file) }
        report("RabinKarp")   { run_rk(pattern, file) }
        report("Ruby#regexp") { run_regexp(pattern, file) }
      }
    end

    patterns = %w( each while end )
#    data = path("../../lib/rk.rb")
    data = path("data.txt")

    patterns.each do |pattern|
      it pattern do 
        bench(pattern, data)

        # check the results are valid or not
        LOGS.each_pair do |name, log|
          log.exist?.should == true
        end

        logs = LOGS.values
        logs.each_with_index do |log, i|
          next if i == 0
          `cmp #{logs[i-1]} #{log}`.should == ''
        end
      end
    end
  end
end
