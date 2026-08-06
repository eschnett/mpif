#include <mpif_strings.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Find the trimmed length of a Fortran string, given by the last non-blank
// character
size_t mpif_fstrlen(const char *restrict const str, const size_t str_length) {
  for (size_t n = str_length; n > 0; --n) {
    if (str[n - 1] != ' ')
      return n;
  }
  return 0;
}

// Duplicate a Fortran string to a C string. Allocate the result with
// `malloc`.
//
// Every caller is generated code with no cleanup path for a mid-conversion
// failure: the result goes straight to MPI, or into a loop building an array
// of them. Returning NULL on OOM would just move the crash into MPI or that
// loop with no diagnostic, so this aborts instead, in the one place that
// still knows what was being allocated.
char *mpif_strdup_f2c(const char *restrict const str, const size_t str_length) {
  const size_t len = mpif_fstrlen(str, str_length);
  char *restrict const res = malloc(len + 1);
  if (!res) {
    fprintf(stderr, "mpif: mpif_strdup_f2c: out of memory allocating %zu bytes\n",
            len + 1);
    abort();
  }
  memcpy(res, str, len);
  res[len] = '\0';
  return res;
}

// Duplicate a Fortran string to a C string, stripping leading blanks as well as
// trailing ones. Allocate the result with `malloc`.
//
// This is deliberately separate from `mpif_strdup_f2c` rather than a change to
// it, because MPI specifies the leading-blank stripping per argument and not
// uniformly. MPI-5.0 asks for it for info keys and values (section 10, "The Info
// Object", and MPI_INFO_SET) and for the commands and argument vectors of
// MPI_COMM_SPAWN and MPI_COMM_SPAWN_MULTIPLE. MPI_ADD_ERROR_STRING, by contrast,
// is specified to strip trailing blanks only, and for port names, service names,
// file names and datareps the standard says nothing at all. Note that MPICH's own
// Fortran binding strips both ends for every string argument, which is more than
// the standard requires.
//
// A string of nothing but blanks becomes the empty string, which is what
// MPI_COMM_SPAWN's `argv` explicitly requires.
char *mpif_strdup_f2c_trim(const char *restrict const str,
                           const size_t str_length) {
  const size_t end = mpif_fstrlen(str, str_length);
  size_t begin = 0;
  while (begin < end && str[begin] == ' ')
    ++begin;
  const size_t len = end - begin;
  char *restrict const res = malloc(len + 1);
  if (!res) {
    fprintf(stderr,
            "mpif: mpif_strdup_f2c_trim: out of memory allocating %zu bytes\n",
            len + 1);
    abort();
  }
  memcpy(res, str + begin, len);
  res[len] = '\0';
  return res;
}

// Copy a C string into a Fortran string
void mpif_strcpy_c2f(char *restrict const dest, const char *restrict const src,
                     const size_t dest_length, const size_t src_length) {
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
size_t mpif_fcount(const char *restrict const strarr, const size_t str_length) {
  for (size_t n = 0;; ++n) {
    const char *restrict const str = strarr + n * str_length;
    if (mpif_fstrlen(str, str_length) == 0)
      return n;
  }
}

// Find the first non-empty string in a 2d array of strings for a given array
// index. The outer array size is unknown. character(str_length)
// strarr(strarr_size, *) first_isempty(strarr(strarr_index, :))
size_t mpif_fcount2d(const char *restrict const strarr,
                     const size_t strarr_size, const size_t strarr_index,
                     const size_t str_length) {
  for (size_t n = 0;; ++n) {
    const char *restrict const str =
        strarr + strarr_index * str_length + n * str_length * strarr_size;
    if (mpif_fstrlen(str, str_length) == 0)
      return n;
  }
}
