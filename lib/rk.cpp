#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <iostream>

const uint64_t ALPHA = 101;

class RK {
 public:
  RK(const char pattern[]) {
    strcpy(s,pattern);
    m = strlen(pattern);
    for(uint64_t i = 0; i < m; i++) a[i] = (uint64_t)(pow((double)ALPHA, m-(i+1)));
    hsub = hash(s);
  }

  uint64_t hash(const char s[])
  {
    uint64_t h = 0;
    for(uint64_t i = 0; i < m; i++) h += s[i]*a[i];
    return h;
  }

  int strcmp(const char *p) {
    uint64_t res = 0;
    for(uint64_t i = 0; i < m; i++) {
      res += s[i] ^ p[i];
    }
    return res;
  }

  int run(const char text[])
  {
    unsigned int n = strlen(text);
    uint64_t h;
    char tmp[1024];

    if (n < m) return 0;

    h = hash(&text[0]);
    for(uint64_t i = 0; i < n-m; i++) {
      if (h == hsub) {
	if (strcmp(&text[i]) == 0) {
	  return i;
	}
      }
      h = ALPHA*(h - text[i]*a[0]) + text[i+1];
      //      h= hash(&text[i+1]);
    }
    
    return 0;
  }
  
 private:
  uint64_t a[128];
  char s[1024];
  unsigned int m;
  uint64_t hsub;
};


int main(int narg, char *argv[])
{
  FILE *fp;
  char pattern[1024];
  char buf[1024];
  RK *matcher;

  if (narg != 3) exit(-1);
  strcpy(pattern, argv[1]);

  fp = fopen(argv[2], "r");
  if (fp == NULL) {
    exit(-1);
  }

  matcher = new RK(pattern);
  while(fgets(buf, 1000, fp) != NULL) {
    if (matcher->run(buf)) {
      std::cout << buf;
    } 
  }
  fclose(fp);
}

