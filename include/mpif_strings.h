#ifndef MPIF_STRINGS_H
#define MPIF_STRINGS_H

#include <stdlib.h>

// Find the trimmed length of a Fortran string, given by the last non-blank character
size_t mpif_fstrlen(const char *str, size_t str_length);

// Duplicate a Fortran string to a C string. Allocate the result with `malloc`.
char* mpif_strdup_f2c(const char *str, size_t str_length);

// Copy a C string into a Fortran string
void mpif_strcpy_c2f(char *dest, const char *src, size_t dest_length, size_t src_length);

// Find the first non-empty string in an array of strings. The array size is unknown.
size_t mpif_fcount(const char *strarr, size_t str_length);

// Find the first non-empty string in a 2d array of strings. The outer array size is unknown.
size_t mpif_fcount2d(const char *strarr, size_t strarr_size, size_t strarr_index, size_t str_length);

#endif
