# The code

What mpif is made of, how the pieces fit, and why the arrangements that look odd
are the ones they are. What it still gets wrong or does not do is `MISSING.md`;
how to build, test and verify it is `CLAUDE.md`.

## Layout

    data/apis.json      the MPI Forum's machine-readable API description, 567 entries
    dev/mpiapi.jl       the generator: reads that, writes all of gen/
    gen/                generated and committed; never edit by hand
    src/                the hand-written half -- modules, callbacks, C helpers
    include/            mpif.h and the headers it includes, all hand-written
    test/               mpif's own tests, one executable each
    ci-scripts/         installing the implementations, running MPICH's suite
    fortran/            the ABI stubs header and the patches carried against it

`dev/mpiapi.jl` emits four files, and the split between them is the whole shape of
the binding:

    gen/mpif_functions.c          Fortran-callable C entry points, `mpi_send_`
    gen/mpif_functions.F90        module mpif_functions: interfaces to those
    gen/mpif_f08_functions.F90    module mpif_f08_raw + module mpif_f08_functions
    gen/mpif_f08_wrappers.F90     the mpi_f08 wrapper bodies, external procedures

A call therefore takes one of two routes to C. From `mpif.h` or the `mpi` module
it is direct -- the interface in `mpif_functions` names the external symbol
`mpi_send_`, which `gen/mpif_functions.c` defines and which calls C's `MPI_Send`.
From `mpi_f08` it is one step longer, the generic `MPI_Send` resolving to the
external specific `MPI_Send_f08`, which converts the derived-type handles and
calls the same `mpi_send_` under the alias `MPIF_Send`. Every routine exists twice
over besides, under its `MPI_` and its `PMPI_` name.

`src/mpi.F90` and `src/mpi_f08.F90` are thin by design: they `use` the modules
beneath them, which the next section names, and add only the generics that have to
be declared where both halves are visible -- the `TYPE(C_PTR)` overloads of
`MPI_Alloc_mem` and the window allocators, whose two specifics come from two
different modules.

## Namespace

Only what the MPI standard defines may be spelled `MPI_` or `mpi_`; everything
mpif invents is `mpif_` or `MPIF_`. Two modules are the standard's and keep their
names, `mpi` and `mpi_f08`; the seven mpif provides beneath them are
`mpif_constants`, `mpif_types`, `mpif_functions`, `mpif_cptr`,
`mpif_f08_constants`, `mpif_f08_types` and `mpif_f08_functions`. Their `.mod`
files follow, which also removes a real collision: MPICH installs an
`mpi_constants.mod` and Open MPI an `mpi_types.mod` and `mpi_f08_types.mod` of
their own, and mpif used to ship files of exactly those names.

The Fortran entry points that C provides -- `mpi_send_`, `mpi_alloc_mem_`, ... --
are of course named after the MPI routines they implement; that is what makes
them callable. Everything else on the C side is `mpif_`.

Two judgement calls worth recording:

- `MPI_Alloc_mem_cptr`, `MPI_Win_allocate_cptr`, `MPI_Win_allocate_shared_cptr`
  and `MPI_Win_shared_query_cptr` keep `MPI_`, because the standard names them:
  "The base procedure name of this overloaded function is MPI_ALLOC_MEM_CPTR."
- Their large-count counterparts do not exist in the standard -- section 19.1.5's
  rules for implied specific names cover the `_f08` and `_f` schemes, not a
  `_c_cptr` combination -- so those are `mpif_win_allocate_c_cptr` and friends.

The procedures behind `operator(==)` and `operator(/=)` on the handle types were
`MPI_Comm_equal` and so on, which the standard does not define; they are now
`mpif_comm_equal` and friends. They were already private to `mpif_f08_types`.

In `mpi_f08` the procedures a program calls are generics, and the specifics
behind them carry Table 19.1's `_f08` token: `MPI_Send_f08`, `MPI_Send_c_f08`.
Both are the standard's names, not mpif's, and the plain `MPI_Send_c` that used
to sit in that module is gone -- 19.1.4 makes invoking a `_c` specific erroneous
but for `MPI_Op_create_c` and `MPI_Register_datarep_c`. See "The mpi_f08 specific
procedure names" under "Verified as correct".

`PMPI_` is a third case, and a simpler one: the standard reserves the whole prefix
to the implementation -- "programs must not declare functions with names beginning
with any prefix of the form PMPI_" -- and says of the specific names behind the
PMPI generics that they "must be different from the specific procedure names for
the MPI_Xxxx procedures and are not specified by this standard". So nothing in the
`PMPI_` space is the standard's to claim, and mpif spells the P form of a name the
standard gives with `PMPI_`: `PMPI_Wtime`, and `PMPI_Alloc_mem_cptr` after
`MPI_ALLOC_MEM_CPTR`.

The P form of a name mpif invented keeps the `mpif_` prefix and takes the `p`
directly after it -- `mpif_pwin_allocate_c_cptr` for `mpif_win_allocate_c_cptr`,
`mpif_psizeof_logical1` for `mpif_sizeof_logical1`. One rule, and one that greps:
`mpif_p` finds every invented PMPI name. A `pmpif_` prefix would have been neither
`mpif_` nor anything the standard reserves, so it is not that.

## Verified as correct

How the parts that look surprising actually work, recorded so that they do not
get re-investigated. Several of these were defects once; what is here is the
mechanism that replaced them and the evidence it is right.

- **The mpi_f08 specific procedure names.** Table 19.1 says a Fortran call to an
  MPI routine "shall result in a call to a procedure with one of the specific
  procedure names and calling conventions" it lists, and for `mpi_f08` with
  choice buffers under `ignore_tkr` -- scheme 1A, mpif's -- that name carries an
  `_f08` token. Section 19.1.4 adds the large-count one: "the same name followed
  by `_c`, and then suffixed by the token specified in Table 19.1", so `_c`
  comes first and the standard's own longest-name example,
  `PMPI_Reduce_scatter_block_init_c_f08ts`, spells the order out. mpif's
  specifics are `MPI_Send_f08` and `MPI_Send_c_f08` accordingly, and their PMPI
  twins likewise.

  They are external procedures, in `gen/mpif_f08_wrappers.F90`, declared as
  interface bodies in `mpif_f08_functions` and defined outside any module. That
  is the point rather than an implementation detail. They used to be module
  procedures, which could have carried the same names but not what the names are
  for: 19.1.5 wants a profiling routine to "provide the same specific Fortran
  procedure names and calling conventions, and therefore ... interpose itself as
  the MPI library routine", and a module procedure's symbol is the compiler's to
  mangle. `test/profile_f08.f90` is that working -- it defines its own
  `MPI_Comm_rank_f08`, a `call MPI_Comm_rank(...)` written against the generic
  lands in it, and it reaches the real one through `PMPI_Comm_rank`. Before this
  there was nothing in `mpi_f08` to intercept, and the test could not have been
  written.

  Every base name is a generic now, 866 of them counting the PMPI half, because
  the plain `MPI_Send` is no longer a procedure at all -- only the name a call is
  written with. The specifics are public beside them, since a tool has to be able
  to name one.

  Two things this settled that had been assumed the other way:

  - **`MPI_Send_c` is gone from `mpi_f08`, and 156 like it.** Section 19.1.4:
    "It is erroneous to directly invoke the `_c` specific procedures in the
    Fortran mpi_f08 module with the exception of the following procedures:
    MPI_Op_create_c and MPI_Register_datarep_c." A.4 bears it out, giving the
    large-count binding as `MPI_Send(...) !(_c)` -- the same generic name, with
    the marker saying which of its two specifics is meant. So the only `_c` names
    a program may call are those two, whose large-count form no generic can
    select because only the callback's prototype distinguishes it; for them the
    standard says the variant "shall be called explicitly as MPI_Op_create_c".
    mpif provides exactly those two and no others, which is what MPICH provides.
    `test/op_create.f90` had been calling `MPI_Reduce_local_c` and now calls the
    generic.
  - **The `#ifdef` guards were half-applied.** 19.1.4 again: where "the type
    signatures of the two specific procedures are identical ... the
    implementation shall not provide the `_c` specific procedure". The guards
    gated only the generic that would pair the two, so on the platform meant to
    have no `_c` specific mpif emitted one anyway, reachable under the
    `MPI_Type_get_extent_c` name that has now gone. The guard covers the
    specific's interface, its public line and its body.

  One thing to know before touching the choice buffers: `!dir$ ignore_tkr` and
  `!gcc$ attributes no_arg_check` are on the interface bodies and not on the
  definitions. flang requires that -- "!DIR$ IGNORE_TKR may apply only in an
  interface or a module procedure" -- and it is right anyway, both directives
  relaxing the checking a *caller* gets, and a caller seeing the interface. While
  these were module procedures the interface and the definition were one
  declaration and the question did not arise; gcc accepted the directives in the
  bodies and flang refused to build, which is the sort of thing only building
  both catches.

  The declaration being written twice is the cost of the arrangement, so
  `dev/check-f08-bindings.jl` compares the two: 1180 specifics declared, 1180
  defined, identical, argument names and order included. gfortran compares them
  too and only warns, which a build this size buries.

  What this does not do is make `f08/profile1f90` pass. That test interposes
  `mpi_send_f08ts`, scheme **1B** -- the `TYPE(*), DIMENSION(..)` form -- and
  mpif is 1A. The `_f08ts` names arrive with assumed-rank or not at all; see
  "Assumed-rank choice buffers" in `MISSING.md`, which is still not being taken.
- **The PMPI profiling interface.** Every MPI procedure mpif provides has a
  `PMPI_` form, in all three interfaces, and each calls C's `PMPI_` entry point
  rather than its `MPI_` one. MPI-5.0 asks for this twice, in section 15.2.1 ("an
  alternate entry point name, with the prefix `PMPI_` for each MPI function in
  each provided language binding and language support method") and again for
  Fortran in 19.1.5 ("for all MPI procedures, a second procedure with the same
  calling conventions shall be supplied, except that the name is modified by
  prefixing with the letter 'P'").

  The generated half is one more turn of the loop in `dev/mpiapi.jl`, beside
  `for embiggen`: 590 more Fortran-callable C wrappers, 590 more interface bodies
  in `mpif_functions`, 590 more `mpi_f08` module procedures and 157 more generics,
  under the same eight `#ifdef` guards. Emitting the two copies from one pass is
  the point of doing it that way -- the name and the code that carries it are the
  same expression, where a second pass or a rewrite of the first copy's text could
  drift.

  How to check that it changed nothing else, and the way that does not work:
  `git diff gen/` reports thousands of deleted lines, because each PMPI block is
  its twin but for one letter and `git` finds it cheaper to align the two than to
  call the whole thing an insertion. That is a diff-presentation artifact and says
  nothing. What settles it is generating the MPI half alone -- change the loop to
  `for pmpi in [false]` and rerun -- after which `git diff gen/` is empty but for
  the new file headers and the `PMPI_Attr_*` defines, every one of the 590
  wrappers, interface bodies and f08 procedures being byte-identical to what was
  committed before.

  The hand-written half is 20 more entry points: the 10 removed MPI-1 routines of
  `src/mpif_removed.c`, the 7 `TYPE(C_PTR)` overloads of `src/mpif_cptr.F90` with
  their generics in `src/mpi.F90`, `MPI_Sizeof`, and
  `MPI_Status_f2f08`/`MPI_Status_f082f`. `MPI_Sizeof` and the status conversions
  forward to their twins, so that a body is written once; the removed MPI-1
  routines and the `_cptr` overloads cannot, the C entry point or the raw
  interface being the whole difference, and there each body is a macro or a call
  instantiated twice.

  Five things worth not re-deciding:

  - **The P form must call C's `PMPI_`, never `MPI_`.** A `pmpi_send_` that called
    `MPI_Send` would not be the way past a tool that had replaced `MPI_Send`, it
    would be a second way into it. The same goes for the group size, rank and
    dimension probes a few wrappers make on the caller's behalf, which is why
    `State` carries the prefix. The handle conversions are left alone:
    `MPI_Comm_fromint` is nothing a profiler can usefully replace, and there are
    some eight hundred of them.
  - **`PMPI_Sizeof` exists here and in neither implementation.** `nm` on MPICH's
    `libmpifort` finds no `pmpi_sizeof` in any spelling. The standard makes no
    exception for it, and closing the gap cost one interface block in
    `src/mpif_types.F90` -- a module procedure may be a specific of more than one
    generic -- plus a second set of 18 bodies for `mpif.h`, where the specifics
    are external and an external procedure may appear in only one interface body
    per scope.
  - **No PMPI form of a predefined callback**, and none wanted: no
    `PMPI_COMM_DUP_FN`, `PMPI_CONVERSION_FN_NULL` or any of the other twelve, in
    any of the three interfaces. A name shift protects an *entry point* a program
    calls and a tool may replace at link time, and these are not that. A.1.1,
    "Defined Constants", carries all twelve in a table headed "Predefined
    functions" whose third column is "ABI value in mpi.h", and the values are 0
    and 1: in the ABI they are constants, not entry points, which is why
    `src/mpif_callbacks.c` turns them into sentinels rather than calling them.
    Every clause of section 15.2.1 is about the other thing -- "may be accessed
    with a name shift", "an alternate entry point name ... for each MPI function",
    "not possible to replace the MPI_ version with a user-defined version at link
    time" -- and a predefined callback is passed as an actual argument, never
    called by the program.

    The one sentence that could be stretched is 19.1.5's "for all MPI procedures,
    a second procedure ... prefixed with the letter 'P'", and A.4.5 does give
    `MPI_COMM_DUP_FN` a Fortran binding in the same alphabetical list as
    `MPI_Comm_dup`. Its own next paragraph settles it: the point of the P names is
    that a profiling routine "can interpose itself as the MPI library routine",
    and it goes on to speak of "routines that have callback routine dummy
    arguments" -- callbacks are arguments to routines there, not routines wanting
    P forms. Section 2.6.2 sorts them the same way, excepting "user-defined
    callback functions ... and their predefined callbacks" from a rule about "all
    MPI Fortran subroutines".

    Nothing needs them either. A tools layer receives the callback as a
    `PROCEDURE(MPI_Comm_copy_attr_function)` dummy and forwards that dummy;
    `mpif_predefined_callback` matches on address and not on which entry point the
    call arrived through, so the sentinel reaches MPI whether the program went via
    `mpi_comm_create_keyval_` or `pmpi_comm_create_keyval_`. A program written
    wholly in PMPI names therefore writes
    `PMPI_Comm_create_keyval(MPI_COMM_DUP_FN, ...)`, mixing the prefixes in that
    one place, which is what a program against either implementation has to write
    and what the three `pmpi_*` tests assert.

    They were built once and taken out again. What suggested them was that MPICH
    defines `pmpi_comm_dup_fn_` and the rest -- but that is its generator emitting
    each Fortran wrapper twice, not a requirement, and it does *not* define the
    `mpi_f08` ones: its only `_MOD_pmpi_*` symbols are the four status converters,
    and Open MPI has none either. The 25 procedures cost 370 lines across four
    files and 25 entries in the recognition table, each entry a claim about an
    address, and their only caller was the test written to justify them.
  - **The registries are shared, deliberately.** One keyval registry, one
    errhandler pool, one grequest pool for both copies, so that a program which
    creates a keyval through `MPI_Comm_create_keyval` and frees it through
    `PMPI_Comm_free_keyval` cannot tell.
  - **What it does not carry**: the `mpi_f08` specific procedure names of
    Table 19.1, which is its own entry under "Missing features" in `MISSING.md`.

  The coverage is checkable in one line, and worth checking that way rather than
  by counting: differencing the `mpi_*_` and `pmpi_*_` symbol sets of the built
  library gives 614 against 600, with nothing in the second that is not in the
  first, and the fourteen in the first without a twin are exactly the predefined
  callbacks above.

  `dev/check-f08-bindings.jl` holds the generated PMPI declarations to A.4 under
  their twins' names, with the P stripped -- the appendices give no PMPI bindings,
  so "the same binding as its twin" is the only thing there is to check, and it is
  the thing a tools layer depends on. `test/pmpi_f.f`, `test/pmpi_f90.f90` and
  `test/pmpi_f08.f90` call the P forms from each interface, and
  `test/profile_f90.f90` is the one that asserts the point of the feature: it
  replaces `mpi_comm_rank_` and `mpi_barrier_` with its own, counts the calls, and
  reaches the real ones through PMPI. Its counter asserts in both directions --
  one means the interception happened, exactly one means PMPI did not come back
  through the interceptor.
- **Nothing is silently dropped.** Replaying the generator's filters over
  `apis.json` gives 430 kept functions, 589 including `_c` variants, and
  `gen/mpif_f08_functions.F90` contains exactly those 589. Every omission is
  attributable to a filter.
- The 102 functions skipped as `not f90_expressible` are the C-only handle
  converters (`MPI_Comm_c2f`, `MPI_Comm_fromint`, ...) and the whole `MPI_T`
  interface, which the standard defines for C only.
- **Buffer sentinels reach C intact.** `MPI_BOTTOM`, `MPI_IN_PLACE`,
  `MPI_ARGV_NULL`, `MPI_ARGVS_NULL`, `MPI_ERRCODES_IGNORE`, `MPI_STATUS_IGNORE`
  and `MPI_STATUSES_IGNORE` are Cray-pointer arrays whose pointers live in common
  blocks initialised from the C addresses in `src/mpif_constants.c`, so Fortran
  passes the genuine C sentinel through. Verified for the argv pair by handing
  them to a C probe with the wrappers' calling convention: both arrive as
  `base=0x0`.

  The addressing is only half of it: a sentinel also has to have a type the
  caller can pass, and any wrapper that does not simply forward it has to
  recognise it rather than dereference it. Both hold now. `mpi_f08`'s two status
  sentinels are the exception to the shared arrangement above -- they have common
  blocks of their own, for the gfortran bug described where they are declared in
  `src/mpif_f08_types.F90` -- but `src/mpif_constants.c` initialises those from
  the same C constants, so the addresses still agree across all three
  interfaces.
- `MPI_Wtime`, `MPI_Wtick`, `MPI_Aint_add` and `MPI_Aint_diff` are hand-written
  rather than generated, and are present. `MPI_Sizeof` is a hand-written generic
  in `src/mpif_types.F90`. `MPI_Status_f2f08` and `MPI_Status_f082f` are
  implemented and public in `src/mpif_f08_types.F90`.
- **`mpif_f08_raw` exists so that two kinds of argument reach C without a Fortran
  temporary, and both were defects before it did.** It is a second set of
  interfaces to the same C entry points, differing from `mpif_functions`' only in
  how they spell an argument or two, and the f08 wrappers of the affected routines call
  it instead of the `mpi` module. `dev/mpiapi.jl` decides per routine and per
  argument, from the declaration rather than from a list, so an argument that
  stops needing the second spelling stops getting it.

  A **status** is `TYPE(MPI_Status)` there where the `mpi` module says
  `INTEGER(MPI_STATUS_SIZE)`. It is eight default integers either way -- the ABI
  fixes `MPI_Status` as three named ints and five more, and mpif fixes
  `MPI_STATUS_SIZE` at 8 with `MPI_SOURCE`, `MPI_TAG` and `MPI_ERROR` at 1, 2 and
  3 -- so the caller's own status can be handed straight to C. Converting instead
  cost three defects: a one-status temporary that arrays overran, an `MPI_ERROR`
  copied back from uninitialised stack, and a `loc()` comparison per call to keep
  `MPI_STATUS_IGNORE` out of the conversion.

  An **assumed-size array of handles** is `TYPE(MPI_Datatype)` there. This is the
  `alltoallw` family and nothing else -- the only routines in the standard whose
  Fortran binding takes one, `sendtypes(*)` and `recvtypes(*)`, since their length
  is the group or neighbour count and appears in no argument. It rests on
  `TYPE(MPI_Datatype)` being `BIND(C)` around one default `INTEGER`, so an array of
  them is an `MPI_Fint[]`, which is the same claim already made for a status's
  eight. `%MPI_VAL` on such a dummy cost the fourth defect: a component reference
  of an assumed-size array has no extent the compiler knows, and gfortran repacked
  it into a temporary whose descriptor said `ubound = -1`, copying nothing. See the
  withdrawn `ABI_Datatype_from_mpi` entry in `MISSING.md`.

  **Explicit-shape handle arrays deliberately do not get this treatment.**
  `MPI_Waitall`'s `array_of_requests(count)` and the thirteen others keep
  `%MPI_VAL`: the compiler knows `count`, copies in and out correctly, and there
  is no defect to fix. The rule is about what the compiler can size, not about
  handles.
- **The `alltoallw` family works out its own array lengths, and none of the three
  answers is `MPI_Comm_size`.** `gen/mpif_functions.c` needs a count to convert
  `sendtypes` and `recvtypes`, and the standard gives a different one per case:
  the remote group's size for an intercommunicator, since the arrays are indexed
  over the group being sent to (MPI-5.0 6.8) and `MPI_COMM_SIZE` "returns the size
  of the local group" (7.6); the outdegree and indegree for the neighbour forms,
  which 8.6 defines per topology and which `MPI_Topo_test` therefore has to
  dispatch on; and the local size only for an intracommunicator. `sendtypes` is
  additionally not read at all under `MPI_IN_PLACE`, 6.8 saying it "is ignored",
  and is filled with `MPI_DATATYPE_NULL` in that case rather than left alone.

  The neighbour dispatch matches what MPICH's own `mpi_abi_util.h` does for the
  same question, `*indegree = *outdegree = 2 * ival` in the `MPI_CART` case
  included, which is worth knowing when reading either. A communicator with no
  topology leaves both degrees zero, so nothing is converted and the
  implementation reports `MPI_ERR_TOPOLOGY` itself; and since a degree of zero is
  legal, the VLAs are sized `n > 0 ? n : 1`.

  `test/` covers all four with `add_mpi_test`'s `NPROCS`, which exists for them:
  at one rank a group size, a remote group size and a neighbour count all
  coincide, so every wrong length is the right one.

  One thing `test/neighbor_alltoallw_f08.f90` deliberately does not assert, having
  tried it: *which* block a neighbour's data lands in. Tagging each send block with
  its index and predicting where it arrives fails, and correctly -- with `dims`
  from `MPI_Dims_create` most dimensions have extent one, so both of their
  neighbours are the calling process and several edges join the same pair. 8.6's
  model is a loop of `MPI_Isend` to `dsts[k]` and `MPI_Irecv` from `srcs[i]`, and
  its matching rule constrains the type signatures rather than which send satisfies
  which receive; send block 6 duly arrived in receive block 3. The test sends each
  rank's own number instead, which still pins down that block *i* came from source
  *i*.
- **`MPI_Sizeof` stays as it is, covering rank zero and rank one.**
  `src/mpif_types.F90` gives the generic a scalar and an assumed-size specific per
  type and kind, so an argument of rank two or more resolves to nothing. That is
  the deliberate stopping place, not an oversight: a Fortran generic needs a
  specific per type, kind *and* rank, so covering every rank would mean sixteen
  specifics apiece, and assumed-rank -- which would collapse them to one each --
  is not being taken (see "Assumed-rank choice buffers" in `MISSING.md`).
  MPICH's own binding
  generates exactly these two forms per type and stops in the same place, and
  `MPI_Sizeof` is deprecated in MPI-4.0 with its `mpi_f08` form removed, so the
  routine that would pay for the mechanism is the one least worth it. `mpif.h` and
  the `mpi` module keep it because the standard still has it there.

  Recorded here rather than as an error so that the question is not reopened.
  Should assumed-rank ever be taken for choice buffers, this comes with it for
  nothing and is worth doing then.
- **A user-defined reduction operator receives its buffers, from all three
  interfaces.** `MPI_User_function`'s `invec` and `inoutvec` were
  `INTEGER(KIND=MPI_ADDRESS_KIND)` by reference in `mpi_f08`, where MPI-5.0
  section 6.9.5 gives `TYPE(C_PTR), VALUE`; they now agree, in both the small and
  the large-count abstract interface. One indirection was the whole defect: the
  trampoline in `src/mpif_callbacks.c` passes the buffer address, as it must for
  the `<type> INVEC(LEN)` of `mpif.h` and the `mpi` module, and an
  address-sized-integer dummy asks for the address of a variable holding that
  address, so an f08 callback read the first bytes of the data as a pointer. The
  trampoline itself was right and is unchanged.

  Why nothing caught it is worth recording, because the obvious answer is wrong.
  MPICH's suite does exercise `MPI_Op_create` from `mpi_f08` -- `reducelocalf08`,
  `uallreducef08`, `exscanf08` and `redscatf08` -- and all four pass, before and
  after. They declare the callback `external` and write it `integer invec(*)`, so
  there is no explicit interface to check against `PROCEDURE(MPI_User_function)`
  and the abstract interface never comes into it; what they test is the
  trampoline. Only a callback with an explicit interface -- a module procedure,
  which is how the standard's own example writes one -- meets the declaration at
  all. `test/op_create.f90` is that callback, and it fails to compile without the
  fix: "Interface mismatch in dummy procedure 'user_fn': Type mismatch in
  argument 'invec' (INTEGER(8)/TYPE(c_ptr))". It then does the reduction, which
  is the other half -- that the buffers really are the data.

  `test/callback_intents_f08.f90` had `user_fn` written against mpif's
  declaration rather than the standard's, which is the one place its "written the
  way the standard writes it" claim did not hold; corrected with the same change.
- `ierror` is `OPTIONAL` throughout the f08 bindings.
- **Predefined handles need no help from mpif.** The wrappers call
  `MPI_Comm_toint` and the rest directly. They used to go through 22 generated
  `MPIF_*_toint` shims that short-circuited the predefined handles first, under
  the comment "Work around broken MPI implementations [only MPICH]", with
  hand-written copies of the same idea in `src/mpif_callbacks.c` and
  `src/mpif_removed.c`. Neither implementation needs that:

  - MPICH short-circuits any handle whose value is `> 0 && < 4096` before
    touching its handle tables, in `src/binding/abi/c_binding_abi.c`. Every
    predefined handle the ABI defines is in `0x20 .. 0x2eb`, so that covers all
    of them, and it is stock 5.0.1 -- 20 occurrences of the test in the pristine
    tarball, not something `ci-scripts/install-mpich.sh` patches in.
  - Open MPI does the same by a different route: all 22 of its converters,
    `ompi/mpi/c/*_{to,from}int_abi.c`, call `ompi_abi_handle_int_is_predefined`
    first, which is `OMPI_ABI_HANDLE_BASE_OFFSET > handle_int` with that offset
    16385. Not one of the 22 is missing it.

  Checked before removing, on MPICH: a C probe round-tripped all 103 predefined
  handles in `mpi_abi.h` through `MPI_<Handle>_toint` and
  `MPI_<Handle>_fromint`, before and after `MPI_Init`, with zero failures. Then
  the shims were replaced by direct calls and everything rebuilt: `test/` stayed
  34 of 34 and the MPICH suite stayed at 3 / 11 / 18 with an identical failure
  set, entry for entry. Open MPI was read rather than run, none being installed
  at the time.

  What this trades away is worth knowing. mpif now requires the implementation's
  converters to handle predefined handles, which the standard requires of them,
  where before it coped with one that did not. `src/mpif_removed.c` used to
  record a real symptom -- "forwarding MPI_INTEGER straight to MPI_Type_fromint
  yields an invalid datatype", the constructor then failing and the garbage
  aborting inside `MPI_Type_toint` -- without saying which version did that. If
  it comes back, this is the paragraph to reread.
- **No phantom `_c` bindings.** The generated f08 output has 159 `_c` forms and
  Appendix A.4 has the same 159, every generated one being in the appendix, so
  nothing here repeats the ABI header's invention of an `MPI_Psend_init_c`. Nor
  does any `_c` form add nothing: comparing each against its base, argument by
  argument and by declared type, no pair is indistinguishable -- though whether a
  compiler can tell a given pair apart is a question about kinds and therefore
  about the platform, which is the entry below. The
  two whose *argument lists* differ from their base, `MPI_Type_get_contents_c`
  and `MPI_Type_get_envelope_c`, differ in A.4 in the same way, gaining a count
  of large counts. `MPI_Psend_init` and `MPI_Precv_init` correctly have no `_c`
  form at all, and `dev/mpiapi.jl` asserts they never gain one.
- **`MPI_Count` is `int64_t` where `MPI_Aint` is a pointer, so a 32-bit platform
  is not a 64-bit one scaled down.** `include/mpif_constants.h` defined
  `MPI_OFFSET_KIND` and `MPI_COUNT_KIND` as `MPI_ADDRESS_KIND`, which is
  `kind(loc(...))`: right wherever a pointer is 64 bits and wrong everywhere
  else. The ABI header settles it in three lines -- `#define MPI_ABI_Aint
  intptr_t`, `#define MPI_ABI_Offset int64_t`, `#define MPI_ABI_Count
  MPI_ABI_Offset`. Both are now `selected_int_kind(18)`, which is that `int64_t`
  and nothing else; only `MPI_ADDRESS_KIND` follows the pointer.

  `docker/mpich-gcc-arm32v7.dockerfile` is where this shows, and it had a loud
  half and a quiet one. The loud half was 153 copies of "Ambiguous interfaces in
  generic interface": with `MPI_COUNT_KIND` four bytes, a large-count `_c`
  wrapper's signature was identical to its small-count companion's, so every
  generic in `mpi_f08` paired two specifics gfortran could not tell apart, and
  the library did not build at all. The quiet half would have outlived the fix:
  `gen/mpif_functions.c` declares `const MPI_Count* count` whatever Fortran
  thinks, so every large-count call and every file offset in all three interfaces
  was a four-byte Fortran integer read as eight bytes.

  Which large-count generics are legal is then a question the generator cannot
  answer, `gen/` being one committed file compiled everywhere. Eight routines
  are affected, and exactly one group of them is ambiguous on any given
  platform, a pointer being four bytes or eight:

  - `MPI_Win_create`, `MPI_Win_allocate`, `MPI_Win_allocate_shared` and
    `MPI_Win_shared_query`, whose only widening parameter is `disp_unit`, a
    plain INTEGER becoming an `MPI_Aint`. Legal on 64 bits only.
  - `MPI_Type_get_extent`, `MPI_Type_get_true_extent`, `MPI_Type_create_resized`
    and `MPI_File_get_type_extent`, whose extents go from `MPI_Aint` to
    `MPI_Count`. Legal on 32 bits only -- and previously emitted on neither,
    which was right for 64 bits and left a 32-bit program unable to reach the
    `_c` form through the base name at all.

  `dev/mpiapi.jl` emits those eight under `#ifdef` guards on
  `MPIF_ADDRESS_KIND_DIFFERS_FROM_INTEGER_KIND` and
  `MPIF_ADDRESS_KIND_DIFFERS_FROM_COUNT_KIND`, and `CMakeLists.txt` defines each
  macro by compiling the ambiguity itself -- a generic over two specifics
  differing only in the kind of one argument, which compiles if and only if the
  two kinds differ, so the probe is the very rule the compiler will apply to the
  generated code. The other 149 generics need no guard: their widening reaches a
  count from a default INTEGER, which distinguishes them everywhere.

  What the guards are *for* is asserted at compile time, one line per group, and
  neither line compiled on 32 bits before: `test/large_count_f08.f90` passes
  count-kind extents to `MPI_Type_get_extent` and `test/rma_disp_f08.f90` an
  address-kind `disp_unit` to `MPI_Win_create`. Each resolves to the generic on
  the platform where one is emitted and to the small specific on the platform
  where the two kinds are the same kind, so a guard that goes the wrong way is a
  build failure rather than a silent narrowing.

  `test/rma_disp_f08.f90` also made the point of the address kind with the literal
  `3000000000_MPI_ADDRESS_KIND`, which is a compile error where that kind is four
  bytes -- there is no displacement larger than a default INTEGER to write down,
  since an address is not larger either. It now asserts against `huge()`, which
  says the same thing on both: an address kind is never narrower than a default
  INTEGER, and holds its own maximum.

  `test/large_count_f08.f90` is also where the quiet half is caught, and was
  before this: it hands `MPI_Get_count` an `INTEGER(KIND=MPI_COUNT_KIND)` out
  argument, which C writes eight bytes into.
- **A function parameter embiggens when `apis.json` says `POLYFUNCTION`.** Which
  is to say the JSON answers this like every other question of the kind, the
  `POLY` prefix meaning "plain in the small form, large in the `_c` form"
  throughout the generator. `MPI_Register_datarep` is the only routine where the
  distinction is visible: its two conversion functions are `POLYFUNCTION` and its
  extent function is `FUNCTION`, so `MPI_Register_datarep_c` takes
  `MPI_Datarep_conversion_function_c` twice and `MPI_Datarep_extent_function`
  unchanged -- which is what A.4 gives it, and what `MPI_Op_create_c`'s
  `POLYFUNCTION` user_fn gives there.

  This was a `# TODO: Check properly` and a hardcoded exception list holding the
  one name `MPI_Datarep_extent_function`, which was this rule written out for the
  single case where it bites. The generator now reads the kind, and cross-checks
  it against the prototype's own parameters -- a callback has a `_c` form exactly
  when one of its arguments embiggens, by the same test `need_embiggen` applies to
  a routine -- so the two statements in the JSON have to agree on all 19 function
  parameters or the run stops. `gen/` came out byte-identical, and dropping the
  `FUNCTION` case changes it, so the rule is both right and load-bearing.
- **The f08 declarations match the appendices, all three sets of them.** Every
  one of the 584 bindings that A.4 and `gen/mpif_f08_functions.F90` have in
  common was compared argument by argument; so were the 18 callback
  `ABSTRACT INTERFACE`s of `src/mpif_f08_types.F90` against A.1.3 and the 11
  predefined callbacks of `src/mpif_f08_attr_fns.F90` against A.4.
  `dev/check-f08-bindings.jl` is the comparison, so it can be run again after any
  change to the generator or to either hand-written file. It compares intents,
  declared types, `VALUE`, and the argument names and their order, and it checks
  that the appendix was read correctly at all: there every argument is declared
  exactly once, so a parse that leaves one undeclared has misread the page and
  the run fails rather than reporting a clean bill.

  The two hand-written sets are the ones worth having in it. Nothing else holds
  them to the standard, which is how `MPI_User_function`'s buffers stayed wrong
  until someone wrote a reduction callback; adding them found a second divergence
  in the same pass, `MPI_Type_delete_attr_function`'s first argument being `type`
  where A.1.3 and `apis.json` both say `datatype` -- harmless, a dummy argument's
  name not being part of its characteristics, and fixed, along with the same slip
  in `MPI_TYPE_NULL_DELETE_FN`.

  The audit found four divergences, all now fixed and all real:

  - `INTENT(INOUT)` on `MPI_Cancel`'s request, where A.4.1 gives `INTENT(IN)`.
    The C entry point takes `MPI_Request*`, which is a property of the C
    binding: `MPI_Cancel` marks a request, it does not replace the handle. The
    wrapper now copies into a temporary. Before that, a caller holding a request
    `INTENT(IN)` and forwarding it did not compile -- "Dummy argument 'request'
    with INTENT(IN) in variable definition context", which is
    `test/cancel_intent_f08.f90`.
  - Intents on all 18 f08 callback abstract interfaces, where the standard gives
    none anywhere: its ABSTRACT INTERFACEs, in section 7.7.2 and collected in
    A.1.3, are plain `TYPE(MPI_Comm) :: oldcomm`. This is the generalized
    request `extra_state` defect over again, and it was general rather than
    confined to those three callbacks -- the comment claiming the attribute
    callbacks were different was simply wrong. INTENT is part of a dummy
    argument's characteristics, so a callback copied out of the standard could
    not be passed as a `PROCEDURE(...)` dummy at all once its interface was
    explicit: "INTENT mismatch in argument 'extra_state'".
    `test/callback_intents_f08.f90` writes one callback per interface the way
    the standard writes it and passes each to the dummy a generated wrapper
    declares, so the assertion is made at compile time.
  - `MPI_Abi_get_fortran_booleans` and `MPI_Abi_set_fortran_booleans` declared
    `logical_true` and `logical_false` as choice buffers, where A.4.14 and
    A.5.14 both give a plain `LOGICAL`. These are the two routines by which
    Fortran and MPI agree on what a `LOGICAL` looks like, so the value really is
    one default `LOGICAL` and a choice buffer was the wrong shape for it. The
    generator had the right code for this all along, behind an `if false &&`.
    This one has no test of its own and should not get one: `no_arg_check`
    disables the checking that would tell the two declarations apart, so a test
    would pass either way, which is what makes a test worthless here.
    `test/version_f08.f90` already calls it with plain `LOGICAL` actuals.
  - `buffer_addr` of `MPI_Buffer_detach`, `MPI_Comm_detach_buffer` and
    `MPI_Session_detach_buffer` declared `integer(MPI_ADDRESS_KIND)` in all six
    bindings -- the three routines and their `_c` forms -- where A.4 gives
    `TYPE(C_PTR), INTENT(OUT)` and A.5 gives `<type> BUFFER_ADDR(*)`, a choice
    buffer. Neither is an integer, so this was wrong in both bindings at once:
    an `mpi_f08` caller could not pass the `TYPE(C_PTR)` the standard asks for,
    and an `mpi` module caller could not pass anything but an address-sized
    integer -- which is what failed to build MPICH's `bsendf90`, "Type mismatch
    in argument 'buffer_addr' at (1); passed CHARACTER(1) to INTEGER(8)".

    `apis.json` gives the parameter the kind `C_BUFFER2` and the generator read
    that as an address. The four `C_BUFFER*` kinds are one question asked four
    times -- is this parameter an address or a buffer -- and the answers now sit
    together at `aint_kinds` in `dev/mpiapi.jl`: `C_BUFFER` is an address in the
    `mpi` module and a `TYPE(C_PTR)` in `mpi_f08`, `C_BUFFER2` is a choice buffer
    and a `TYPE(C_PTR)`, and `C_BUFFER3` and `C_BUFFER4` are choice buffers that
    nothing generated reaches, both belonging to callbacks. One C entry point
    still serves both bindings, taking `void*` and writing the address through
    whatever it is handed; the f08 wrapper hands it an address-sized temporary
    and converts with `transfer`, as the `C_BUFFER` one already did.

    `test/buffer_detach.f90` asserts both halves, and `dev/check-f08-bindings.jl`
    reported the six every run until this was fixed -- and did not before, because
    it compared intents and not types: `buffer_addr` has `INTENT(OUT)` on both
    sides. Extending it to types is what turned this from something noticed by
    accident into something the tool states, and it found the `MPI_Psend_init`
    count the same way. Only the A.4 half is checked by the tool, the appendix it
    reads being the `mpi_f08` one; the A.5 choice buffer has the test alone.

  The 207 remaining differences are all the same one, and expected: an input
  choice buffer is `INTENT(IN)` in the standard and has no intent here. See
  "Assumed-rank choice buffers" in `MISSING.md`.

  Two smaller things the comparison turned up, neither a defect. `mpi_f08` has
  six routines A.4 does not list -- `MPI_Attr_delete`, `MPI_Attr_get`,
  `MPI_Attr_put`, `MPI_Keyval_create`, `MPI_Keyval_free`, all MPI-1 forms that
  A.4.16 does not carry into `mpi_f08`, and `MPI_F_sync_reg`, which is not in the
  standard at all. And A.4 gives `MPI_TYPE_NULL_DELETE_FN`'s `ierror`
  `INTENT(OUT)` where its own abstract interface
  `MPI_Type_delete_attr_function` gives none and where the other twelve
  predefined callbacks give none; that is an inconsistency in the standard, and
  mpif follows the abstract interface.
