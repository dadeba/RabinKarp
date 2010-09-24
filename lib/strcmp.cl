uint slice(uint x, int i)
{
  uint tmp[4];

  tmp[0] = (x >> 0 ) & 128;
  tmp[1] = (x >> 8 ) & 128;
  tmp[2] = (x >> 16) & 128;
  tmp[3] = (x >> 24) & 128;

  return tmp[i]
}

__kernel void matcher(
	 __global uint4 *text,
	 __global uint *st,
	 __global int *en,
	 __global int *res,
	 uint *pattern, int nbyte)
{
  unsigned int gid = get_global_id(0);
  int s = st[gid];
  int e = en[gid];

  for(int i = s; i < e; i++) {
    uint4 word32 = text[i];



  } 
}
