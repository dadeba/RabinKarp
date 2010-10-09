#include "rk.h"

int main(int narg, char *argv[])
{
  FILE *fp;
  unsigned char pattern[1024];
  unsigned char buf[1024];
  RK *matcher;

  if (narg != 3) exit(-1);
  strcpy((char *)pattern, argv[1]);

  fp = fopen(argv[2], "r");
  if (fp == NULL) {
    exit(-1);
  }

  matcher = new RK(pattern);
  while(fgets((char *)buf, 1000, fp) != NULL) {
    if (matcher->run(buf) >= 0) {
      std::cout << buf;
    } 
  }
  fclose(fp);

  return 1;
}

