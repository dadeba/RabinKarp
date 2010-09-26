// RabinKarp("ok").run("hello") // => None
// RabinKarp("ok").run("U,ok?") // => Some(2)

case class RabinKarp(word:String) {
  import scala.math.pow

  val alpha = 101
  val len   = word.length
  val hsub  = hash(word)

  def hash(s:String) = {
    var h = 0
    val l = s.length
    for (i <- 0 until l)
      h += (pow(alpha, l-i-1) * s.codePointAt(i)).asInstanceOf[Int]
    h
  }

  def rolling_hash(code:Int, len:Int, s1:String, s2:String):Int = {
    var h = code
    val a = s1.codePointAt(0)
    val b = s2.codePointAt(0)
    h -= (pow(alpha, len-1)*a).asInstanceOf[Int]
    h *= alpha
    h += b
    h
  }

  def run(text:String):Option[Int] = {
    var h = 0
    val n = text.length
    val last = n - len

    if (last < 0) return None
    for (i <- 0 to last) {
      h = i match {
	case 0 => hash(substr(text,0,len))
	case _ => rolling_hash(h, len, substr(text,i-1), substr(text,i-1+len))
      }
      if ((h == hsub) && (substr(text,i,len) == word))
	return Some(i)
    }
    return None
  }

  private def substr(text:String, start:Int, length:Int = 1) =
    text.substring(start, start+length)
}
