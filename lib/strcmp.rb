#!/usr/bin/ruby
class Strcmp
  def initialize(searchstring)
    @s = searchstring
    @m = @s.size
  end

  def run(text)
    n = text.size
    m = @m
    return false if n < m

    (0..(n-m-1)).each do |i|
      if strcmp(@s, text[i..(i+m-1)]) == 0
        return i
      end
    end
    return false
  end

  private
  # return 0 if strings are same, otherwise return non-zero
  def strcmp(str1, str2)
      if str1 == str2
        return 0
      else
        return -1
      end
    end
end

class Strcmp2 < Strcmp
  private
  def array(str)
    tmp1 = []
    str.each_byte { |x|
      tmp1 << x
    }
    tmp1
  end
  # return 0 if strings are same, otherwise return non-zero
  def strcmp(str1, str2)                                                                                              
    tmp1 = array(str1)
    tmp2 = array(str2)

    res = 0
    tmp1.each_with_index { |x,i|
      res += x ^ tmp2[i]
    }
    return res
  end                                                                                                                  end

# each
