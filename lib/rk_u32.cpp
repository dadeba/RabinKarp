#include <iconv.h>
#include <errno.h>
#include "rk.h"

int main(int narg, char *argv[])
{
  FILE *fp, *fp2, *fp3;
  unsigned char buf[1024], buf2[1024];
  unsigned char pattern[1024];
  size_t s, e, n, nout, rlen;
  RK *matcher;
  iconv_t e2u32;
  const int ncbuf = 1024;
  char *ob, *op;

  if (narg < 2) exit(-1);

  //              dst      src
  e2u32 = iconv_open("UTF-32", "eUC-JP");

  nout = ncbuf;
  op = ob = (char *)malloc(nout);
  n = strlen(argv[1]);
  rlen = iconv(e2u32, (char **)&argv[1], &n, &op, &nout);
  if (rlen == -1) {
    printf("%d(%s)\n", rlen, strerror(errno));
    exit (-1);
  }
  nout = ncbuf - nout;
  memcpy((char *)pattern, ob, nout);
  free(ob);

  // first 4bytes is BOM
  nout = nout - 4;
  matcher = new RK(&pattern[4], nout);

  /*
  fp = fopen("data/word.u32", "r");
  if (fp == NULL) {
    puts("XXXX");
    exit(1);
  }
  fread(pattern, 20, 1, fp);
  fclose(fp);
  matcher = new RK(&pattern[4], 12);
  matcher->dump();
  */

  fp3 = fopen("result", "w");

  fp  = fopen("data/data.u32", "r");
  fp2 = fopen("data/data.idx", "r");
  s = 0;
  while(fgets((char *)buf, 1000, fp2) != NULL) {
    sscanf((char *)buf, "%i", &e);
    n = e - s;
    //    std::cout << "read " << n << " bytes" << "\n";
    fread(buf2, n, 1, fp);
    if (matcher->run(buf2, n) >= 0) {
      fwrite(buf2, n, 1, fp3);
      //      nout = 10240;
      //      char *outbuf = (char *)malloc(nout);
      //      iconv(fr, (char **)&buf2, &n, &outbuf, &nout);
      //      fwrite(outbuf, nout, 1, fp3);
      //      free(outbuf);
    }

    s = e;
  }

  fclose(fp3);

  matcher->status();
}

