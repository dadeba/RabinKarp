#!/usr/bin/ruby
class RabinKarp
  ALPHA = 101  ## could be any number

  def initialize(searchstring)
    @s = searchstring
    @m = @s.size

    @a = []
    (0..(@m-1)).each { |i|
      @a << ALPHA**(@m-(i+1))
    }

    @hsub = hash(@s)
  end

  def hash(s)
    h = 0
    (0..@m-1).each { |i|
      h = h + s[i][0]*@a[i]
    }
    return h
  end

  def newhash(h,s0,si)
#    ALPHA*(h - s0[0]*ALPHA**(@m-1)) + si[0]
    ALPHA*(h - s0[0]*@a[0]) + si[0]
  end

  def run(text)
    n = text.size
    return nil if n < @m
    m = @m
    h = hash(text[0..(m-1)])
    (0..(n-m-1)).each { |i|
      if h == @hsub then
        if @s == text[i..(i+m-1)] then
          return i
        end
      end
      h = newhash(h, text[i][0], text[i+m][0])
    }
    return nil
  end
end

text = open(ARGV[0],'r').read
exit if text == nil

matcher = RabinKarp.new(ARGV[1])
text.split("\n").each { |line|
  puts line if matcher.run(line+"\n")
}

# each
