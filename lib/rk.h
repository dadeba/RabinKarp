#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <iostream>

const uint64_t ALPHA = 101;

class RK {
 public:
  RK(const unsigned char pattern[], unsigned int mmm) {
    m = mmm;
    memcpy(s, pattern, m);
    init_a();
    hsub = hash(s);
  }

  RK(const unsigned char pattern[]) {
    m = strlen((char *)pattern);
    memcpy(s, pattern, m);
    init_a();
    hsub = hash(s);
  }

  void init_a(void)
  {
    nmatch = 0;
    for(uint64_t i = 0; i < m; i++) a[i] = (uint64_t)(pow((double)ALPHA, m-(i+1)));
  }

  void dump(void)
  {
    out_hex(s, m);
  }

  void out_hex(const unsigned char s[], unsigned int m)
  {
    for(uint64_t i = 0; i < m; i++) {
      printf("%02x", s[i]);
    }
    puts("");
  }

  uint64_t hash(const unsigned char s[])
  {
    uint64_t h = 0;
    for(uint64_t i = 0; i < m; i++) h += s[i]*a[i];
    return h;
  }

  uint64_t newhash(uint64_t h, unsigned char s0, unsigned char si)
  {
    return ALPHA*(h - s0*a[0]) + si;
  }

  uint64_t strcmp(const unsigned char *p) {
    uint64_t res = 0;
    for(uint64_t i = 0; i < m; i++) {
      res += s[i] ^ p[i];
    }
    return res;
  }

  /*
  int run(const unsigned char text[])
  {
    unsigned int n = strlen((char *)text);
    uint64_t h;

    if (n < m) return -1;

    h = hash(&text[0]);
    for(uint64_t i = 0; i < n-m; i++) {
      if (h == hsub) {
	if (strcmp(&text[i]) == 0) {
	  return i;
	}
      }
      h= newhash(h, text[i], text[i+m]);
    }
    
    return -1;
  }
  */

  int run(const unsigned char text[])
  {
    return run(text, strlen((char *)text));
  }

  int run(const unsigned char text[], unsigned int n)
  {
    uint64_t h;

    if (n < m) return -1;

    h = hash(&text[0]);
    for(uint64_t i = 0; i < n-m; i++) {
      if (h == hsub) {
	if (strcmp(&text[i]) == 0) {
	  nmatch++;
	  return i;
	}
      }
      h= newhash(h, text[i], text[i+m]);
    }
    
    return -1;
  }

  void status(void)
  {
    std::cout << "Match " << nmatch << "\n";
  }

 private:
  uint64_t a[128];
  unsigned char s[1024];
  unsigned int m;
  uint64_t hsub;
  unsigned int nmatch;
};
