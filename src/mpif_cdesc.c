// The descriptor walker behind the TS 29113 choice buffers; see
// include/mpif_cdesc.h for the contract and CODE.md "The cdesc layer" for the
// design. The shape is MPICH's cdesc_create_datatype
// (src/binding/fortran/use_mpi_f08/wrappers_c/cdesc.c), reimplemented against
// the public large-count API with the differences noted below.

#include <mpif_cdesc.h>

#ifdef MPIF_HAVE_CFI

// Everything here calls the PMPI_ names: the datatypes built for a
// noncontiguous section are plumbing, not calls the program made, and a
// profiling layer interposed on MPI_Type_create_hvector should not see one
// per strided argument. MPICH's walker does the same.

int mpif_cdesc_create_datatype(const CFI_cdesc_t *cdesc, MPI_Count oldcount,
                               MPI_Datatype oldtype, MPI_Datatype *newtype) {
  int err;

  // The descriptor counts elements of elem_len bytes and the caller counts
  // oldtype units, and the two agree only up to a factor: a
  // character(len=8) buffer under MPI_CHARACTER is 8 oldtype units per
  // element. Fold the factor into the base type, so the walk below can
  // treat one descriptor element as one unit. MPICH asserts the factor is 1
  // (and only under error checking); a fraction that does not divide out is
  // an error here rather than a silently wrong stride.
  MPI_Count size;
  err = PMPI_Type_size_c(oldtype, &size);
  if (err != MPI_SUCCESS)
    return err;
  if (size <= 0 || cdesc->elem_len % (size_t)size != 0)
    return MPI_ERR_ARG;
  MPI_Count factor = (MPI_Count)cdesc->elem_len / size;

  MPI_Datatype cur = oldtype;
  int owned = 0; // whether `cur` was created here and is ours to free
  MPI_Count count = oldcount;
  if (factor > 1) {
    if (count % factor != 0)
      return MPI_ERR_ARG;
    count /= factor;
    err = PMPI_Type_contiguous_c(factor, oldtype, &cur);
    if (err != MPI_SUCCESS)
      return err;
    owned = 1;
  }

  // Walk the dimensions innermost first. Each level wraps `cur` in a type
  // covering one more dimension -- contiguous where the dimension's byte
  // stride is exactly what the levels below cover, hvector otherwise --
  // until `count` elements are accounted for. The last level may cover the
  // dimension only partly, which is a section like a(1:3) of a larger a.
  MPI_Count elems_per_cur = 1;
  MPI_Count bytes_per_cur = (MPI_Count)cdesc->elem_len;
  int done = 0;
  for (int i = 0; i < cdesc->rank && !done; ++i) {
    if (count % elems_per_cur != 0) {
      // The count stops mid-`cur`: describing that would take an indexed
      // type over a partial row, which nothing has needed yet.
      err = MPI_ERR_ARG;
      goto fail;
    }
    MPI_Count extent = count / elems_per_cur;
    if (extent > cdesc->dim[i].extent)
      extent = cdesc->dim[i].extent;
    else
      done = 1;
    MPI_Datatype next;
    if ((MPI_Count)cdesc->dim[i].sm == bytes_per_cur)
      err = PMPI_Type_contiguous_c(extent, cur, &next);
    else
      err = PMPI_Type_create_hvector_c(extent, 1, (MPI_Count)cdesc->dim[i].sm,
                                       cur, &next);
    if (err != MPI_SUCCESS)
      goto fail;
    if (owned)
      PMPI_Type_free(&cur);
    cur = next;
    owned = 1;
    elems_per_cur *= cdesc->dim[i].extent;
    bytes_per_cur = (MPI_Count)cdesc->dim[i].sm * cdesc->dim[i].extent;
  }
  if (!done) {
    // (oldcount, oldtype) describes more data than the descriptor holds.
    err = MPI_ERR_ARG;
    goto fail;
  }

  // Only the outermost type is committed; the constructors accept
  // uncommitted inputs, so the intermediate levels never need to be.
  err = PMPI_Type_commit(&cur);
  if (err != MPI_SUCCESS)
    goto fail;
  *newtype = cur;
  return MPI_SUCCESS;

fail:
  if (owned)
    PMPI_Type_free(&cur);
  return err;
}

#else

// ISO C requires something in a translation unit.
typedef int mpif_cdesc_unused;

#endif
