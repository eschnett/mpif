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
  // stride is exactly what the levels below cover *and* `dense` still holds,
  // hvector otherwise -- until `count` elements are accounted for. The last
  // level may cover the dimension only partly, which is a section like
  // a(1:3) of a larger a.
  MPI_Count elems_per_cur = 1;
  MPI_Count bytes_per_cur = (MPI_Count)cdesc->elem_len;
  int done = 0;

  // `dense` is the invariant extent(cur) == bytes_per_cur, and it is what
  // makes the contiguous branch legal: MPI_Type_contiguous places replica i
  // at i*extent(cur), not at i*bytes_per_cur, and the two part company as
  // soon as one level is strided -- an hvector of n copies at stride sm over
  // an extent-e type has extent sm*(n-1) + e, short of the span sm*n it
  // covers. Contiguous above such a level places every replica but the first
  // short, which is wrong data and no error; an hvector is right whatever the
  // inner extent is, its blocks landing at exact byte offsets. So the walk
  // drops to hvector for good once the invariant is gone. This is the one
  // place it departs from MPICH's shape, which compares against the span and
  // gets this wrong; see MISSING.md.
  //
  // Seeded from the base type rather than assumed: the innermost level is
  // contiguous only if extent(oldtype) is the descriptor's element length
  // too, which a resized `oldtype` would not be.
  MPI_Count cur_lb, cur_extent;
  err = PMPI_Type_get_extent_c(cur, &cur_lb, &cur_extent);
  if (err != MPI_SUCCESS)
    goto fail;
  int dense = (cur_lb == 0 && cur_extent == bytes_per_cur);

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
    if (dense && (MPI_Count)cdesc->dim[i].sm == bytes_per_cur) {
      err = PMPI_Type_contiguous_c(extent, cur, &next);
    } else {
      err = PMPI_Type_create_hvector_c(extent, 1, (MPI_Count)cdesc->dim[i].sm,
                                       cur, &next);
      // An hvector level restores extent == span only when the stride is the
      // inner extent, which is the contiguous case; so once lost, lost.
      dense = 0;
    }
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
