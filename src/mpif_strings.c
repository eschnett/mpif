#include <mpif_strings.h>

#include <stdlib.h>
#include <string.h>

// Find the trimmed length of a Fortran string, given by the last non-blank character
size_t mpif_fstrlen(const char *restrict const str, const size_t str_length)
{
  for (size_t n=str_length; n>0; --n) {
    if (str[n-1] != ' ')
      return n;
  }
  return 0;
}

// Duplicate a Fortran string to a C string. Allocate the result with `malloc`.
char* mpif_strdup_f2c(const char *restrict const str, const size_t str_length)
{
  const size_t len = mpif_fstrlen(str, str_length);
  char *restrict const res = malloc(len + 1);
  memcpy(res, str, len);
  res[len] = '\0';
  return res;
}

// Copy a C string into a Fortran string
void mpif_strcpy_c2f(char *restrict const dest, const char *restrict const src, const size_t dest_length, const size_t src_length)
{
  if (src_length >= dest_length) {
    memcpy(dest, src, dest_length);
  } else {
    memcpy(dest, src, src_length);
    memset(dest + src_length, ' ', dest_length - src_length);
  }
}

// Find the first non-empty string in an array of strings.
// character(str_length) strarr(*)
// first_isempty(strarr(:))
size_t mpif_fcount(const char *restrict const strarr, const size_t str_length)
{
  for (size_t n = 0;; ++n) {
    const char *restrict const str = strarr + n * str_length;
    if (mpif_fstrlen(str, str_length) == 0)
      return n;
  }
}

// Find the first non-empty string in a 2d array of strings for a given array index. The outer array size is unknown.
// character(str_length) strarr(strarr_size, *)
// first_isempty(strarr(strarr_index, :))
size_t mpif_fcount2d(const char *restrict const strarr, const size_t strarr_size, const size_t strarr_index, const size_t str_length)
{
  for (size_t n = 0;; ++n) {
    const char *restrict const str = strarr + strarr_index * str_length + n * str_length * strarr_size;
    if (mpif_fstrlen(str, str_length) == 0)
      return n;
  }
}
