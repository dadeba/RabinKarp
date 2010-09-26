int strcmp(char *p1, char *p2, int m)
{
  int res = 0;
  for(int i = 0; i < m; i++) {
    res += p1[i] ^ p2[i];
  }

  return res;
}

__kernel void rk(
	 __global char8 *text, 
	 __global int *st, __global int *en,
	 __global char pattern[8], int ns,
	 __global int *result)
{
  unsigned int gid = get_global_id(0);
  int s = st[gid];
  int e = en[gid];
  char ss[4];

  ss[0] = pattern[0];
  ss[1] = pattern[1];
  ss[2] = pattern[2];
  ss[3] = pattern[3];

  for(int i = s; i < e; i++) {
    char8 a, b;
    char buf[8];

    a = text[i];
    b = text[i];

    buf[0] = a.s0;
    buf[1] = a.s1;
    buf[2] = a.s2;
    buf[3] = a.s3;
    if (strcmp(ss, buf, 4) != 0) result[gid] = 8*i;

    buf[0] = a.s1;
    buf[1] = a.s2;
    buf[2] = a.s3;
    buf[3] = a.s4;
    if (strcmp(ss, buf, 4) != 0) result[gid] = 8*i+1;

    buf[0] = a.s2;
    buf[1] = a.s3;
    buf[2] = a.s4;
    buf[3] = a.s5;
    if (strcmp(ss, buf, 4) != 0) result[gid] = 8*i+2;

    buf[0] = a.s3;
    buf[1] = a.s4;
    buf[2] = a.s5;
    buf[3] = a.s6;
    if (strcmp(ss, buf, 4) != 0) result[gid] = 8*i+3;

    buf[0] = a.s4;
    buf[1] = a.s5;
    buf[2] = a.s6;
    buf[3] = a.s7;
    if (strcmp(ss, buf, 4) != 0) result[gid] = 8*i+4;

    buf[0] = a.s5;
    buf[1] = a.s6;
    buf[2] = a.s7;
    buf[3] = b.s0;
    if (strcmp(ss, buf, 4) != 0) result[gid] = 8*i+5;

    buf[0] = a.s6;
    buf[1] = a.s7;
    buf[2] = b.s0;
    buf[3] = b.s1;
    if (strcmp(ss, buf, 4) != 0) result[gid] = 8*i+6;

    buf[0] = a.s7;
    buf[1] = b.s0;
    buf[2] = b.s1;
    buf[3] = b.s2;
    if (strcmp(ss, buf, 4) != 0) result[gid] = 8*i+7;
  }
}

