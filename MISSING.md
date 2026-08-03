# Missing features and known errors

A working note on `dev/mpiapi.jl`, the generator that produces
`gen/mpif_functions.c`, `gen/mpif_functions.F90` and
`gen/mpif_f08_functions.F90` from the MPI standard's `apis.json`, and on what
mpif still gets wrong or does not do. Entries are removed once they are resolved,
so this file is only ever the outstanding list -- plus the decisions not to do
something, which stay, since an unrecorded decision is indistinguishable from an
oversight. Nothing in the source tree refers to it.

Findings are checked against `data/apis.json`, the generated output, the official
ABI header and the MPI 5.0 standard, rather than by reading the generator alone.

Signatures are the JSON's business: it is what the generator reads, and what any
hand-written binding should be checked against. The standard is what makes the
JSON legible, since its keys and kinds are otherwise undocumented -- `C_BUFFER`
is an address in `MPI_Alloc_mem` and `C_BUFFER2` a choice buffer in
`MPI_Buffer_detach`, and only the standard says which. Keep a copy at
`doc/mpi50-report.pdf` (git-ignored); `pdftotext -layout` makes it greppable.

## Errors

None outstanding. Every entry that was here has been fixed, and the ones worth not
re-investigating are under "Verified as correct" below. What remains in this file
is features mpif does not have, blockers outside it, and decisions.

## External blockers

### The ABI header gets the partitioned-communication count wrong, twice — carried as a local patch

`MPI_Psend_init` and `MPI_Precv_init` take an `MPI_Count` count. MPI-5.0's C
binding is

    int MPI_Psend_init(const void *buf, int partitions, MPI_Count count,
                       MPI_Datatype datatype, int dest, int tag, MPI_Comm comm,
                       MPI_Info info, MPI_Request *request)

and both implementations agree with it. MPICH declares and defines exactly that in
`src/binding/abi/c_binding_abi.c`. Open MPI generates it from a type class that
exists to say so:

    @Type.add_type('PARTITIONED_COUNT')
    class TypePartitionedCount(Type):
        def type_text(self, enable_count=False):
            return 'MPI_Count'

-- `MPI_Count` whatever `enable_count` is, where the `DISP` class immediately
below it returns `'MPI_Aint' if enable_count else 'int'`, which is what a type
that really does have two forms looks like.

The header mpif installs is alone in disagreeing. It comes from the MPI Forum's
ABI stubs, <https://github.com/mpi-forum/mpi-abi-stubs>, fetched by
`ci-scripts/install-mpi-header.sh`, and it declares the count `int` and then
declares `MPI_Psend_init_c` and `MPI_Precv_init_c` taking `MPI_Count`, along with
their `PMPI_` counterparts. **Neither name exists in MPI-5.0**: the string appears
nowhere in the standard, in any language, and neither implementation defines one,
because a routine whose only form already takes a count has nothing for a `_c`
form to add. That is also why Appendix A.4 lists one Fortran binding for each and
not two.

The two errors hid each other -- the base form looked small, and a large form was
offered that does not exist -- and between them they made the generated wrapper
unsafe rather than merely limited: it took the count from Fortran as an
`MPI_Count` and passed it to a prototype declaring `int`, so the call site
materialised 32 bits where the callee reads 64. Small counts survived because the
compiler extends the value into the register, which is the compiler being helpful
rather than anything guaranteed.

`fortran/mpi.h.patch` therefore corrects the four base prototypes and deletes the
four phantom declarations, alongside the Fortran handle-conversion declarations
the stubs omit that it already carried. **Drop those hunks once the stubs header
is fixed**; `patch` will report them as already applied. Not reported upstream
yet, and worth reporting.

Nothing in mpif may generate or call the phantom names. `dev/mpiapi.jl` asserts
that neither routine ever takes the `_c` path rather than leaving it to be noticed
that nothing does, since a header declaring the name makes it look as though
something should.

### MPICH: partitioned communication is not implemented

`MPI_Psend_init` aborts inside MPI whatever the bindings do: `MPID_Psend_init` is
an `MPIR_Assert(0)` at `src/mpid/ch3/src/mpid_part.c:12`, so the ch3 device this
build uses implements none of partitioned communication. Nothing on this side can
be judged by running it, which is why `test/partitioned_f08.f90` asserts at
compile time and never executes its calls.

### MPICH: `MPI_Type_create_f90_*` returns a datatype the ABI cannot use

`MPI_Type_create_f90_real`, `MPI_Type_create_f90_integer` and
`MPI_Type_create_f90_complex` all report `MPI_SUCCESS` and hand back a handle
that `MPI_Type_toint` turns into 512 -- `0x200`, which is `MPI_DATATYPE_NULL`.
Anything done with it then fails: `MPI_Type_contiguous` and
`MPI_Type_get_envelope` both report "Invalid datatype".

Pure C, no Fortran involved; the reproducer is
`bug-mpich-f90-datatypes/mpich-abi-f90-datatype-bug.c`, which round-trips each of
the three and, for contrast, a predefined type and a derived one -- both of which
survive.

The ABI wrapper in `src/binding/abi/c_binding_abi.c` looks right: it calls
`internal_Type_create_f90_real` and converts the result with
`ABI_Datatype_from_mpi`. The conversion is where it goes wrong.
`ABI_Datatype_from_mpi`, in `src/binding/abi/mpi_abi_util.h`, treats a datatype
MPICH considers predefined by reverse-searching `abi_datatype_builtins[]` for it,
and the datatypes `MPI_Type_create_f90_*` returns are predefined internally
without being in that table.

That is the same function and the same table as the blocker below on attributes
for predefined datatypes, so the two are one defect in the ABI's datatype
conversion rather than two. It also explains a cluster in
`ci-scripts/suite/mpich-suite-xfail.txt`: the seven entries whose symptom is
"Assertion failed in file src/binding/abi/mpi_abi_util.h at line 140" are that
function's `MPIR_Assert(0)`, reached when the reverse search finds nothing.

`trf90`, `trf08`, `createf90`, `createf08` and `createf90types` fail on this, on
every MPICH variant. Nothing to fix on this side. Not reported upstream yet, and
worth reporting together with the attribute one.

### MPICH: the generalized request tests require `extra_state` to alias the caller's variable

`greqf`, `greqf90` and `greqf08` -- MPICH's tests, but run against both
implementations, so they fail on all twelve variants -- each set
`extrastate = 1`, start a generalized
request whose `free_fn` does `extrastate = extrastate - 1`, wait on it, and then
require the *caller's* variable to read 0. The f08 one goes so far as to call
`dummyupdate(extrastate)` first, to stop the compiler remembering what was
stored -- so the dependency is deliberate, not an accident of the test.

The standard does not say that. `extra_state` is `IN` in the
`MPI_GREQUEST_START` parameter table and `INTENT(IN)` in its f08 binding; the
callbacks are "passed the extra_state argument that was associated with the
request by the starting call MPI_GREQUEST_START" (section 13.2), which describes
a value being handed over; and the C prototypes all take `void *extra_state` by
value, so a C callback provably cannot write back to the caller's variable at
all -- only through it. Chapter 19, Support for Fortran, says nothing about
`extra_state` anywhere, so there is no Fortran-specific licence either. The one
phrase that points the other way, "extra_state can be used to maintain
user-defined state for the request", means in C what it says: point it at
something.

What makes the tests pass under MPICH's own binding is how that binding is
built rather than a decision about semantics. `mpi_grequest_start_` in
`src/binding/fortran/mpif_h/fortran_binding.c` passes the Fortran actual
argument's address straight through as the C `extra_state` value and hands the
Fortran procedures to MPI unwrapped, so a callback's `extrastate` dummy lands on
the caller's variable as a side effect.

mpif copies instead, so the three tests fail. They report "Free routine not
called", which is wrong and worth knowing before chasing it: the test sets
`freefncall = 0`, declares `common /fnccalls/ freefncall` in `free_fn`, and then
never increments it, so the counter is always zero and the diagnostic always
takes that branch. The real assertion is the `extrastate .ne. 0` above it, and
`free_fn` does run. Matching the tests would mean holding a pointer into the
caller's frame for the lifetime of the request, which is a dangling pointer as
soon as the request outlives the scope it was started in -- a hazard MPICH's
binding has and mpif would be adopting on purpose. `test/grequest_f08.f90` asserts the opposite
of what MPICH's tests assert, and deliberately.

This is the same shape as the `spawnargvf90` entry below: a suite test that
codifies its own implementation rather than the standard. Nothing to fix on this
side.

### Registered datareps are not implemented, by either implementation

`MPI_Register_datarep` forwards its Fortran callbacks correctly now, and nothing
will ever call them. Both implementations decline the feature before mpif's
trampolines can matter:

- MPICH's ROMIO rejects a non-NULL conversion function outright --
  `src/mpi/romio/mpi-io/io_impl.c` returns `MPI_ERR_CONVERSION` with "Read and
  Write datarep conversions are currently not supported by MPI-IO" if either
  `read_conversion_fn` or `write_conversion_fn` is non-NULL. It will register a
  datarep whose conversions are both `MPI_CONVERSION_FN_NULL` and whose extent
  function is real, but `MPI_File_set_view` then refuses the name: the same file
  accepts only `native`, `external32` and `internal`, anything else being
  `MPI_ERR_UNSUPPORTED_DATAREP`, "Only native data representation currently
  supported". So even a datarep MPICH accepts can never be used, and the extent
  callback never fires either.
- Open MPI is worse than briefer: it accepts the call and does nothing.
  `ompi/mca/io/ompio/io_ompio_component.c`'s `register_datarep` is
  `return OMPI_ERROR;` and nothing else, but that line is dead code --
  `mca_io_base_register_datarep` calls `io_register_datarep` only on components
  whose type version is `2, 0, 0`, and `ompio` registers itself as
  `MCA_IO_BASE_VERSION_3_0_0`. No component is ever consulted, `ret` stays
  `OMPI_SUCCESS`, and `MPI_Register_datarep` is a silent no-op. Registering the
  same datarep twice therefore also succeeds, where MPICH reports
  `MPI_ERR_DUP_DATAREP`. Worth reporting upstream, and not yet.

That is the whole feature, not an edge of it, so there is nothing to work around
and nothing to report: both are honest about it in the error message. What mpif
can be held to is that it no longer refuses the call before MPI sees it, which
is what `test/datarep_f08.f90` asserts on the one combination ROMIO accepts --
and that is all it asserts, since anything past registration diverges between
the two implementations -- and
that the trampolines marshal correctly, which `test/datarep_c.c` asserts by
calling them directly. The second is the substitute for an end-to-end test and
should be replaced by one if an implementation ever grows the feature.

### MPICH: attributes on predefined datatypes abort in ABI builds — carried as a local patch

<https://github.com/pmodels/mpich/issues/7916>

`MPI_Type_set_attr` and `MPI_Type_get_attr` abort inside MPICH for any
predefined datatype when it is built for the standard ABI:
`MPII_Attr_delete_c_proxy` converts the handle back with
`ABI_Handle_from_mpi`, whose datatype case reverse-searches
`abi_datatype_builtins[]` and asserts when the handle is not found. Derived
datatypes and communicator attributes are unaffected. The reproducer sent with
the issue is `bug-mpich-7916/mpich-abi-attr-bug.c`; it is pure C, with no
Fortran involved.

The table is searched and comes up empty because there are two of them.
`src/binding/abi/mpi_abi_util.c`, which defines `abi_datatype_builtins[]`,
`abi_op_builtins[]` and the `ABI_init_builtins()` that fills them, is listed in
`mpi_abi_sources`, and that is compiled into both `libmpi_abi` and
`libpmpi_abi`. Where weak symbols are unavailable those really are two
libraries, so each gets its own copy: `MPI_Init` is in `libmpi_abi` and fills
that one, while `libpmpi_abi`, which holds the implementation and therefore the
attribute proxies, keeps a table of zeros. The forward direction never notices,
because the entry points that convert an incoming handle are in `libmpi_abi` --
which is why setting the attribute works and only the callback aborts.

That makes it a macOS problem in practice. `configure` asks for weak symbols and
gives up on them, since `#pragma weak PFoo = Foo` makes gcc ICE on Mach-O
(`internal compiler error: in assemble_alias`), so `NEEDSPLIB=yes` and the
separate profiling library gets built. A Linux build has weak symbols, one
library and one table, and cannot hit this.

Fixed upstream on `main` by
[2eb9a812](https://github.com/pmodels/mpich/commit/2eb9a812025d5b22703fd35398714ba1c9e4f218)
("abi: double inclusion of mpi_abi_util.c under noweak", 2026-06-13), which
moves the file into a new `mpi_abi_core_sources` that goes into the profiling
library alone. The commit predates the issue by seven weeks and does not
reference it, and the issue is still open; nothing has been released with the
fix, 5.0.1 being the latest tag. It is therefore carried locally as
`ci-scripts/mpich-abi-util-one-copy.patch`, applied by
`ci-scripts/install-mpich.sh`. **Drop the patch once a release picks the fix
up**; `git apply` refuses fuzz, so it will fail loudly rather than land
somewhere unintended, and the prepared-tree stamp covers the patches, so
removing it re-prepares rather than reusing an older tree.

The patch is a local copy rather than the upstream commit downloaded by URL,
which is what this script does for its other fix, because the upstream one does
not apply to 5.0.1: `main` has renamed the convenience-library variables in
`Makefile.am` (`@mpllib@` to `@mpl_lib@` and so on) and dropped
`fortran_binding_abi.c` from `mpi_abi_sources`, and both change the context the
commit's hunks expect. The change itself is unaltered.

Two other routes were considered and rejected. There is no configure switch that
does away with the second library: `NEEDSPLIB` is derived from whether weak
symbols work rather than asked for, weak aliases cannot be made to work on
Mach-O, and dropping `libpmpi_abi` would take the `PMPI_` entry points with it,
which the ABI requires. Calling `ABI_init_builtins()` from
`ABI_Datatype_from_mpi` itself would also work, and would need no `automake`
rerun, but it papers over the duplication rather than removing it and diverges
from what upstream did.

### OpenMPI: an empty info value is rejected — carried as a local patch

https://github.com/open-mpi/ompi/issues/14246

`MPI_Info_set(info, "key", "")` returned `MPI_ERR_INFO_VALUE` (33) under Open MPI
and `MPI_SUCCESS` under MPICH. The ABI defines that class as "Value longer than
MPI_MAX_INFO_VAL", and the standard gives the empty value a defined meaning on
two reserved keys -- for both `"mpi_memory_alloc_kinds"` and
`"mpi_assert_memory_alloc_kinds"`, "A value corresponding to the empty string
represents no memory allocation kinds" -- so there was no way to say that through
an info object.

Fixed upstream on `main` by
[5e21b7b2](https://github.com/open-mpi/ompi/commit/5e21b7b21f8b4e52c06b5527eb344958325cbb30)
(pull request 14247), which removes the zero-length test on the value and leaves
the empty *key* rejected. That commit is not on the ABI branch mpif builds from,
so it is carried locally as `ci-scripts/openmpi-info-set-empty-value.patch`,
applied by `ci-scripts/install-openmpi.sh`. **Drop the patch once the ABI branch
picks the fix up**; `git apply` refuses fuzz, so it will fail loudly rather than
land somewhere unintended, and the prepared-tree stamp covers the patches, so
removing it re-prepares rather than reusing an older tree.

The patch is a local copy rather than the upstream `.patch` downloaded by URL,
which is what `install-mpich.sh` does for its own fix, because the upstream one
does not apply to the ABI branch: the branch templates the constant as
`@MPI_MAX_INFO_VAL@` where main writes `MPI_MAX_INFO_VAL`, and the commit's other
hunks touch a changelog and tests the branch does not have in the same state.

It reaches Fortran through the stripping of leading and trailing blanks that the
standard requires of info keys and values: a value of nothing but spaces becomes
the empty string. `test/info_blanks_f08.f90` avoids asserting on it so that
mpif's own tests do not fail on an implementation that has not taken the fix.
The reproducer sent with the issue is
`bug-ompi-info-value/ompi-empty-info-value.c`; it is pure C, and exits 0 on
MPICH and 1 on an unpatched Open MPI.

### OpenMPI: `MPI_Info_create_env` changes across `MPI_Init`

The info object it returns before `MPI_Init` differs from the one it returns
after, which is what fails `infocrenvf` and `infocrenvf90` -- those compare two
env infos created at different points and expect them to agree. On this machine:

    key         before MPI_Init      after MPI_Init
    maxprocs    0                    1
    soft        0                    1
    host        Redshift.local       Redshift
    wdir        (not set)            (set)

`MPI_Info_create_env` describes how the process was started, which does not
change when MPI is initialised, so the two should agree. MPICH's do, and it
passes the test.

Not an mpif problem: a pure C program that creates an env info before and after
`MPI_Init` and prints both shows the same divergence, with no Fortran involved.
Not reported upstream yet.

### OpenMPI: object names where the standard asks for an empty string

MPI-5.0 section 7.8 gives `MPI_WIN_GET_NAME` and `MPI_TYPE_GET_NAME` "the name
previously stored on the *object*, or an empty string if no such name exists", and
excepts only predefined datatypes: "Named predefined datatypes have the default
names of the datatype name." Open MPI names two things the standard leaves
nameless, which is six suite tests. `bug-ompi-object-names/ompi-object-names.c`
prints both and exits nonzero on the first; it is pure C, no Fortran involved:

    fresh window              MPICH len= 0 ""          Open MPI len=13 "rdma window 3"
    fresh derived datatype    MPICH len= 0 ""          Open MPI len= 0 ""
    dup of a named datatype   MPICH len= 0 ""          Open MPI len=17 "Dup a vector type"

- **A fresh window has a name.** `MPI_Win_create` and then `MPI_Win_get_name`
  yields `"rdma window 3"`, where nobody has called `MPI_Win_set_name`. The
  standard is explicit, so this is a defect, and it is what `winnamef`,
  `winnamef90` and `winnamef08` report as "Did not get empty name from new
  window". Setting and getting a name works, so only the default is wrong.
- **`MPI_TYPE_DUP` invents one.** Duplicating a datatype named `"a vector type"`
  gives the duplicate the name `"Dup a vector type"` -- not a copy of the name but
  a new one, stored by nobody. `typesnamef`, `typesnamef90` and `typesnamef08`
  require the duplicate's name to be empty and report "(type2) Expected length 0,
  got 17".

  This half is weaker: the standard does not say whether `MPI_TYPE_DUP` carries
  the name over, and "exactly the same properties as oldtype" could be read either
  way. What it does say is "previously stored", and "Dup a vector type" was never
  stored by anyone, so a synthesised name is hard to defend under either reading.
  MPICH leaves it empty and the test codifies that; between the two, mpif can only
  follow whichever implementation it is built against.

Nothing to fix on this side either way. The window half is worth reporting
upstream and is not yet; the dup half is worth asking about, since the standard
could settle it in a sentence.

### OpenMPI on macOS: a nonblocking collective write is lost when the aio queue fills

`f08/io/i_fcoll_test` writes a 32³ integer array to a file through a
`MPI_Type_create_darray` view with `MPI_File_iwrite_all`, reads it back with
`MPI_File_iread_all`, and finds every element zero. Open MPI says why on the way
past, once per process:

    mca_fbtl_posix_ipwritev: error in aio_write():  Resource temporarily unavailable
    mca_fbtl_posix_ipreadv: error in aio_read(): errno 35 Resource temporarily unavailable

EAGAIN from `aio_write` means the system's asynchronous I/O queue is full, and
macOS keeps it small -- `sysctl kern.aioprocmax` is 16 on this machine, against a
Linux default in the tens of thousands, which is why this is a macOS entry.
`ompi/mca/fbtl/posix/fbtl_posix_ipwritev.c` prints the message and gives up, so
the data never reaches the file, and `MPI_Wait` reports `MPI_SUCCESS` anyway --
silence would be bad enough, and success is worse.

`bug-ompi-aio-eagain/ompi-aio-eagain.c` is the reproducer, in C on four processes:
MPICH round-trips the array, Open MPI loses all of it. The noncontiguous view is
the necessary part -- a contiguous one issues few enough requests to stay under the
limit and passes -- which is why the test's `darray` is in the probe.

Nothing to fix on this side. Worth reporting upstream, and not yet. It accounts
for `i_fcoll_test` on `openmpi/*/darwin/*` only; the same test also fails on every
Linux variant and under flang on macOS, and those are still untriaged, with the
aio message conspicuously absent from the reason.

### OpenMPI: left to itself it picks an interface it cannot use

Not an mpif problem, and not really a blocker so much as a trap -- but the trap
sprang twice, in different ways, and the second one had eleven suite tests
attributed to the architecture for months.

Everything here runs on one host, and Open MPI given a free choice of interface
takes a non-loopback one and then fails on it:

- **macOS**: it cannot configure the socket -- `setsockopt(TCP_NODELAY) failed:
  Invalid argument (22)`, followed by its own warning that this "may end up
  hanging". It does, in any test that communicates across a spawned
  intercommunicator, and each one then burns runtests' 180-second timeout rather
  than failing, so the suite looks stuck rather than broken. A pure C
  spawn-and-send reproduces it.
- **Linux on GitHub's x86_64 runners**: it picked the `docker0` bridge those
  images have, at 172.17.0.1, which is not an interface anything here wants.

`--mca btl_tcp_if_include lo0` on macOS and `lo` on Linux settles that half, and is
passed in all three places that run the suite: the CI step,
`scripts/macos-test-mpich-suite.sh` and each `docker/openmpi-*.dockerfile`.

### OpenMPI: a spawned child is not reachable over TCP on the x86_64 runners

This is what fails the eleven Open MPI spawn tests that spent months attributed to
the architecture. Each of them spawns children, prints "No Errors" -- so the test's
own logic passes -- and then the job dies:

    [runner:00000] *** An error occurred in Socket closed
    [runner:00000] *** reported by process [3394764801,0]
    [runner:00000] *** on a NULL communicator
    [runner:00000] *** MPI_ERRORS_ARE_FATAL (processes in this communicator will
    [runner:00000] ***    now abort, and MPI will try to terminate your MPI job)

preceded, when Open MPI is allowed to say so, by a warning that it "failed to TCP
connect to a peer MPI process" at `connect() to 127.0.0.1:1025 failed`. So the
child is not reachable where the parent looks, and the teardown of the spawned
intercommunicator is where that becomes fatal.

Why only the x86_64 runners is not established. The arm64 ones, with the same Open
MPI built from the same pinned commit and the same mpif, do not warn and do not
abort; subtract the eleven and the two x86_64 rows equal their aarch64 twins,
5 / 9 / 20 under gcc and 5 / 9 / 16 under llvm. Nothing Fortran-specific is in
sight, and nothing on this side can be held to it, but it has not been reproduced
in C either, for want of an x86_64 Linux Open MPI to hand.

Two wrong turns are worth recording, because both were confident and both were
CI's to refute.

The first was the interface. With `docker0` in play the warning named 172.17.0.1
and looked like a bridge problem; the loopback flag in the entry above was
expected to cure it. It did not -- the warning came back naming 127.0.0.1.

The second was the warning itself. Silencing it with
`--mca btl_base_warn_peer_error 0` -- Open MPI's own knob, on by default -- was
supposed to leave eleven passing tests passing, on the evidence that their output
was "No Errors" plus that warning and nothing else. It was not nothing else:
`runtests` prints at most ten lines of a test's output and then "... ...", and the
abort above began at line eleven. Silencing the warning only uncovered it, and the
tests failed just the same. **A diagnosis from `runtests`' console report is a
diagnosis of the first ten lines** -- which is now fixed at the source rather than
remembered: `ci-scripts/suite/test-mpich-suite.sh` prints the whole recorded output
of every unexpected failure, from the TAP file, which is not truncated.

So the eleven are expected failures again, in
`ci-scripts/suite/mpich-suite-xfail.txt` under `openmpi/*/*/*/x86_64`, with the
abort as the reason rather than the warning.

The arithmetic that says the diagnosis is right: subtracting the eleven leaves the
two Open MPI x86_64 rows in the baseline below identical to their aarch64 twins,
5 / 9 / 20 under gcc and 5 / 9 / 16 under llvm, which is what "the same
implementation on the same OS" should look like.

### MPICH: suite tests that cannot pass against a conforming binding

Six of the suite's tests ask for something MPI-5.0 does not have, something only
MPICH provides, or something the standard explicitly leaves to the implementation.
None of them can pass here, and none is a defect on this side;
`ci-scripts/suite/mpich-suite-xfail.txt` carries each with a reason pointing at
this entry. The `spawnargvf90` entry below is a seventh of the same species,
separate only because it is a disagreement between two copies of one test rather
than with the standard.

- **`bsendf`, `bsendf90`** attach a `character dummy_buf(400)` and say why in a
  comment: "we test a basic buffered send of 10 INTEGERs and assume a buffer of
  400 CHARACTERs are sufficient to account for MPI_BSEND_OVERHEAD". Against the
  standard ABI it is not. `MPI_BSEND_OVERHEAD` is 512 there -- a bound over all
  implementations, where MPICH's own value is 96 and Open MPI's 128 -- and an ABI
  build of MPICH checks against the ABI's number, so attaching 400 bytes fails
  before anything is sent: "Buffer size of 400 is smaller than
  MPI_BSEND_OVERHEAD (512)". The test would have to ask the constant rather than
  guess it. This one is MPICH-only, and not because MPICH is stricter than the
  ABI asks: Open MPI's `mca_pml_base_bsend_attach` has no size check beyond
  `size <= 0`, which is why `bsendf` has always passed there and why `bsendf90`
  is expected to now that it builds.

  `bsendf90` was previously an mpif defect on top of this -- it failed to build
  at all, on all twelve variants, on the `buffer_addr` declaration recorded under
  "The f08 intents match Appendix A.4". Fixing that is what let it get as far as
  the attach, and its expected failure is now MPICH-only and identical to
  `bsendf`'s.
- **`dgraph_wgtf`, `dgraph_unwgtf` and their f90 and f08 copies** ask
  `MPI_Dist_graph_create` for a bidirectional ring with `reorder = .true.`, and
  then check the neighbours `MPI_Dist_graph_neighbors` returns against the
  caller's rank *in MPI_COMM_WORLD*. That is only valid if the reorder did not
  reorder. MPI-5.0 says the opposite in the description of the routine: "If
  reorder = false, all MPI processes will have the same rank in comm_dist_graph as
  in comm_old. If reorder = true then the MPI library is free to remap to other
  MPI processes (of comm_old) in order to improve communication on the edges of
  the communication graph."

  Open MPI takes the licence, through the `treematch` topology component --
  `ompi/mca/topo/treematch/topo_treematch_dist_graph_create.c`, which walks hwloc's
  view of the machine and permutes ranks for locality, falling back to the
  identity when it cannot. In the arm64 Docker image it permutes, deterministically
  and whether or not the run oversubscribes, and the same four processes in C give:

      reorder=1   world rank 0 -> graph rank 2      srcs 0 3    <-- not neighbours of 0
      reorder=1   world rank 1 -> graph rank 0      srcs 2 1
      reorder=1   world rank 2 -> graph rank 1      srcs 0 3
      reorder=0   world rank 1 -> graph rank 1      srcs 0 2    <-- correct ring
      reorder=0   world rank 2 -> graph rank 2      srcs 3 1
      reorder=0   world rank 3 -> graph rank 3      srcs 0 2

  So the topology itself is right and the test's premise is wrong: with the reorder
  off every neighbour is one step away, and with it on the ranks the test compares
  are from two different communicators. Pure C, no Fortran, nothing for mpif to
  fix. MPICH never remaps -- `topo_base_dist_graph_create.c` records `reorder` and
  leaves the group alone -- which is what the test was written against.

  Whether Open MPI remaps depends on the machine, so this is scoped in
  `ci-scripts/suite/mpich-suite-xfail.txt` to the one variant where it has been
  seen rather than to Open MPI at large; CI's Open MPI runners pass these tests
  today, and may stop at any time without anything having changed on this side.
- **`allctypesf`, `allctypesf90`, `allctypesf08`** run every predefined datatype
  past `MPI_Type_get_name`, `MPI_LB` and `MPI_UB` among them. Those two were
  removed in MPI-3.0 and appear nowhere in the ABI header -- `grep MPI_LB
  mpi.h` finds nothing -- so mpif does not define them either, and the test
  reports "Datatype MPI_LB not available in Fortran". Under `mpi_f08` it gets as
  far as "For datatype MPI_LB found name MPI_DATATYPE_NULL", which is the
  undeclared name defaulting to zero.
- **`attrmpi1f08`** hands `MPI_COMM_NULL_COPY_FN` to `MPI_Keyval_create`. The
  first is the MPI-2 callback, whose attribute arguments are address-sized; the
  second is the MPI-1 routine, whose callbacks take plain INTEGERs. Mixing them
  cannot typecheck, and does not: "Interface mismatch in dummy procedure
  'copy_fn': Type mismatch in argument 'attribute_val_in'
  (INTEGER(4)/INTEGER(8))". It fails to build.
- **`statusconv`** has a C file declaring
  `void c_f08_status_(MPI_F08_status *f08_status)`. The ABI spells that type
  `MPI_F08_Status`, with a capital S; `MPI_F08_status` is MPICH's own name for
  it. It fails to build, in C, before Fortran is involved.
- **`profile1f90`** does `use :: mpi_f08, my_noname => mpi_send_f08ts`.
  `mpi_send_f08ts` is MPICH's implementation-specific specific name for the
  choice-buffer form; section 19.1.5 of the standard defines the `_f08` and `_f`
  schemes and nothing that obliges an implementation to provide this one. It
  fails to build, and would need the PMPI interface as well.

### MPICH: the f08 copy of `spawnargvf90` contradicts the standard and its own f90 copy

Both copies spawn with `inargv(5) = " Ss"`. The f90 one expects the child to see
`"Ss"`, and passes; the f08 one expects `" Ss"`, and fails with
`Found arg Ss but expected  Ss`. MPI-5.0 is explicit for `argv` -- "In Fortran,
leading and trailing spaces are always stripped, so that a string consisting of
all spaces is considered an empty string" -- and MPICH's own binding strips both
ends, so the f08 file is an inconsistent hand-conversion of the f90 one.

`f08/spawn/spawnargvf90` and `f08/spawn/spawnargvf03` therefore fail, and will
keep failing while mpif follows the standard. Nothing to fix on this side.

## Missing features

### Assumed-rank choice buffers

The bindings declare choice buffers as `integer :: buf(*)` guarded by
`!dir$ ignore_tkr` and `!gcc$ attributes no_arg_check`, with no
`TYPE(*), DIMENSION(..)` and no `ASYNCHRONOUS` anywhere. This is conforming --
it is the standard's `.FALSE.` option, which `MPI_SUBARRAYS_SUPPORTED` and
`MPI_ASYNC_PROTECTS_NONBLOCKING` advertise -- so it belongs here as an
improvement rather than an error.

This is also the one place where the f08 intents diverge from Appendix A.4, and
deliberately: the standard gives an input choice buffer
`TYPE(*), DIMENSION(..), INTENT(IN)` and mpif gives it no intent at all, in 207
arguments across the bindings. Omitting it is what lets a wrapper hand the buffer
on to a dummy that has none, and it forbids nothing a conforming program may do.
`dev/check-f08-bindings.jl` counts these and passes them over; taking the
assumed-rank option would bring the intents with it.

**Not being taken for the time being** -- a decision, so that the question is not
reopened by whoever reads the rest of this section and finds it inviting. The
`.FALSE.` option conforms, both implementations offer the same one to `mpif.h` and
the `mpi` module, and the cost of the other is a second mechanism to carry
alongside this one for compilers without Fortran 2018. Everything below is what
taking it would involve, kept because the shape of the work is worth knowing and
because the reasons could change; nothing below is a plan.

The cost is two suite tests, and the suite says exactly what it is. MPICH's
`f08/subarray` directory walks one array through fifteen cases, and the only two
that fail are `test14` and `test15`:

    test8   Send/Recv  2d array column slice iar_2d(:,2:6:2)        No Errors
    test9   Send/Recv  2d array column slice iar_2d(1:7:3,2:6:2)    No Errors
    test12  Isend/Irecv array slice iar(2:7)                        No Errors
    test14  Isend/Irecv 2d column slice iar_2d(:,2:6:2)             Found 27 errors
    test15  Isend/Irecv 2d column slice iar_2d(1:7:3,2:6:2)         Found 9 errors

The pattern is the mechanism: `test8` and `test9` pass the same noncontiguous
slices to a *blocking* call, where the compiler's copy-in/copy-out is correct;
`test12` passes a *contiguous* slice to a nonblocking one, where no copy is made;
`test14` and `test15` combine noncontiguous with nonblocking, and the copy dies at
the wrapper's return, before `MPI_Wait`. 27 and 9 are the element counts of the two
slices, so nothing arrives at all. Both tests declare the array `ASYNCHRONOUS`,
which is the program's half of the contract, and then neither consults
`MPI_SUBARRAYS_SUPPORTED` before relying on it -- so they cannot pass against a
conforming `.FALSE.` implementation, and they are in
`ci-scripts/suite/mpich-suite-xfail.txt` with that reason rather than as untriaged.

Taking the other option would mean declaring choice buffers
`TYPE(*), DIMENSION(..), ASYNCHRONOUS` in the nonblocking, split-collective and
persistent routines and setting both constants to `.true.`. The gain is that
noncontiguous subarrays become valid buffers in nonblocking calls; today the
compiler passes them by in-and-out-copy through a scratch array, which is fine
for blocking calls and invalid for nonblocking ones, where the copy dies before
the request completes. It would also confine mpif to compilers with Fortran 2018
assumed-rank support, so the two mechanisms would have to coexist, selected by
the same kind of `check_fortran_source_compiles` probe that already picks
`ignore_tkr` over `no_arg_check`.

Both implementations take that option, and both draw the line in the same place
as mpif does -- `.TRUE.` in `mpi_f08` only, `.FALSE.` in the `mpi` module and
`mpif.h`, which the standard allows and which is why
`include/mpif_constants.h`'s `.false.` stays right whatever happens here.

- MPICH sets both `.true.` unconditionally in
  `src/binding/fortran/use_mpi_f08/mpi_f08_compile_constants.f90`, and `.FALSE.`
  in `use_mpi/mpifnoext.h`.
- Open MPI decides at configure time: `config/ompi_setup_mpi_fortran.m4` starts
  both at `.false.` and raises them to `.true.` only if `OMPI_FORTRAN_HAVE_TS`,
  its TS 29113 probe, succeeds. `ompi/include/mpif-config.h.in` hardcodes
  `.false.`.

Their implementations are the same shape, and it is the shape mpif would have to
grow, because the interesting work is not the Fortran declaration but what C
does with the descriptor it then receives:

- MPICH has 291 `MPIR_*_cdesc` entry points in
  `use_mpi_f08/wrappers_c/f08_cdesc.c`, about 7,900 lines, over a 107-line
  `cdesc.c`. Each takes a `CFI_cdesc_t *`, and where `!CFI_is_contiguous(buf)`
  it calls `cdesc_create_datatype`, which walks the descriptor's dimensions and
  builds an `MPI_Type_create_hvector` chain per stride, passes count 1, and
  frees the temporary immediately after the call -- safe for a nonblocking call
  because the request holds its own reference.
- Open MPI has 144 `*_ts.c.in` templates and a 138-line
  `use-mpi-f08/base/ts.c`, whose `OMPI_CFI_2_C` does the same job.

Everything either of them calls is public C API, so mpif can do it without help
from the implementation. What mpif would have to change beyond writing that
layer:

- The route to C. An f08 wrapper currently calls the `mpi` module's binding,
  which calls the C symbol: `MPI_Send` -> `MPIF_Send` -> `mpi_send_`. An
  assumed-rank dummy cannot go that way, since the f90 layer's dummy is
  `integer :: buf(*)` and passing to it reintroduces the copy. The 150 routines
  with a choice buffer would need `bind(C)` interfaces straight to new C entry
  points taking `CFI_cdesc_t *`, which pulls in the `bind(C)` entry below for
  those routines.
- The sentinels. `MPI_BOTTOM` and `MPI_IN_PLACE` reach C as plain addresses
  today; behind a descriptor the recognition moves into the cdesc wrapper, as
  MPICH's comparison against `&MPIR_F08_MPI_BOTTOM` shows. "Buffer sentinels
  reach C intact" below would have to be re-verified on the new path rather than
  inherited.
- `ASYNCHRONOUS` is the cheap half and the data is already in hand: `apis.json`
  marks 142 buffer parameters across 96 routines `asynchronous`, and
  `dev/mpiapi.jl` never reads the field -- the word appears nowhere in `gen/` or
  `include/`.

For scale, `apis.json` has 150 routines with a choice buffer and 222 buffer
parameters between them.

### The PMPI profiling interface

There is none. `nm` on the built library finds no `pmpi_` symbol at all, for any
of the 585 entry points, and the generator emits none.

`include/mpif_functions.h` is worse than silent about it: it declares four PMPI
names it does not define,

    double precision, external :: MPI_Wtick, PMPI_Wtick
    double precision, external :: MPI_Wtime, PMPI_Wtime
    integer(MPI_ADDRESS_KIND), external :: MPI_Aint_add, PMPI_Aint_add
    ... PMPI_Aint_diff

so an `mpif.h` program that calls one gets a link error rather than a diagnostic:
`Undefined symbols: "_pmpi_wtime_"`. The `mpi` and `mpi_f08` modules do not
declare them at all, which is what `f08/timer/wtimef90` hits --
`Function 'pmpi_wtick' has no IMPLICIT type`.

Because mpif prunes the implementation's own Fortran library, its `pmpi_*`
symbols are not available as a fallback either. Generating the PMPI names
alongside the MPI ones should be mechanical: each would be the same wrapper under
a second symbol, calling the same C entry point.

### Fortran-set attribute values are not visible to C as a pointer

An attribute set from Fortran and read from C comes back as the value where
MPI-5.0 requires the address of it. Section 19.3.7:

> MPI supports two types of attributes: address-valued (pointer) attributes, and
> integer-valued attributes. C attribute functions put and get address-valued
> attributes. Fortran attribute functions put and get integer-valued attributes.
> When an integer-valued attribute is accessed from C, then `MPI_XXX_get_attr`
> will return the address of (a pointer to) the integer-valued attribute, which
> is a pointer to `MPI_Aint` if the attribute was stored with Fortran
> `MPI_XXX_SET_ATTR`, and a pointer to `int` if it was stored with the deprecated
> Fortran `MPI_ATTR_PUT`.

mpif's wrapper hands MPI the value itself -- `mpi_comm_set_attr_` calls
`MPI_Comm_set_attr(comm, keyval, (void*)*attribute_val)` -- so what MPI stores is
an address-valued attribute whose "address" is the user's number. A conforming C
reader then dereferences it. Of the nine cross-language cases the test suite
enumerates, that is cases 4 and 7 -- Fortran sets, C gets -- and only those:

- Fortran sets and Fortran gets is self-consistent, since `mpif_attr_value`
  returns user-defined attributes verbatim;
- C sets and Fortran gets is right, and for the reason the same section gives:
  "When an address-valued attribute is accessed from Fortran, then
  MPI_XXX_GET_ATTR will convert the address into an integer";
- the deprecated `MPI_ATTR_PUT` form has the same defect one size down, C
  expecting a pointer to `int`.

Four suite tests fail on it, on all twelve variants: `attrlangf90` and
`attrlangf08`, whose whole subject is the nine cases, and `fandcattrf90` and
`fandcattrf08`, whose header says the rule out loud -- "The C attribute copy
function should be passed a pointer to the Fortran attribute value (e.g., it
should dereference it to check its value)". Both crash rather than report,
`attrlangf90` in `cmpif2read_` at the `MPI_Aint` it was given to dereference:

    frame #0: cmpif2read_(..., msg="F2 to c dup") at attrlangc.c:453
    frame #1: f2toctest_ at attrlangf90.f90:747
    stop reason = EXC_BAD_ACCESS (address=0x1b69b4be86b2915)

which is the value the Fortran side stored. That is the whole diagnosis, and it
was confirmed by a probe rather than read off the crash: Fortran sets an
address-sized attribute, C reads it and finds the value; C sets one, Fortran reads
it and finds the address, correctly.

What a fix needs, and why it is a feature rather than a correction:

- **Storage owned by mpif.** The value has to live somewhere with a stable
  address for as long as the attribute exists, and mpif has to hand MPI that
  address instead of the value. One `MPI_Aint` per (object, keyval) pair, not per
  keyval: the same keyval carries a different value on every communicator.
- **A language tag.** `MPI_XXX_GET_ATTR` from Fortran must return the value for a
  Fortran-set attribute and the address for a C-set one, so the wrapper has to
  know which it is looking at. The standard's own advice to implementors says as
  much -- "This requires that attributes be tagged either as 'C' or 'Fortran'" --
  and mpif cannot see the implementation's tag through the ABI, so it needs its
  own record of the pairs it set.
- **A lifetime.** The storage has to be released when the attribute is deleted or
  the object freed, which means noticing `MPI_XXX_DELETE_ATTR`, `MPI_XXX_SET_ATTR`
  overwriting a value, and the object's own free. mpif already keeps a keyval
  registry for the attribute callbacks in `src/mpif_callbacks.c`, so there is
  somewhere for this to go, but the key is wider and the frees are new.
- **The copy callbacks.** `MPI_COMM_DUP` invokes the copy callback for each
  attribute, and a C callback on a Fortran-set attribute is passed the same
  pointer, so a duplicated attribute needs storage of its own. `fandcattrf90`
  tests exactly this.

There is no test in `test/` for it, deliberately: a test asserting what mpif
cannot do yet would be a failing test rather than an assertion, and the four suite
tests above already state the requirement. Write one with the fix.

### `bind(C)`

Nothing is declared `bind(C)`. All 585 entry points rely on the compiler
lowercasing names and appending a single underscore, and on hidden character
lengths being appended at the end of the argument list as `size_t`. That is
correct for gfortran 8 and later and for flang, and an unstated assumption
otherwise -- gfortran before 8 passed hidden lengths as `int`.

### Publishing the Fortran type information to the MPI library

Not needed as things stand, and recorded here only so the question is not
reopened. mpif builds against an implementation that has its own Fortran
bindings -- MPICH is configured `--enable-fortran` -- so the implementation
already knows the Fortran type sizes and boolean representation, and
`test/version_c.c` asserts as much: it aborts if either
`MPI_Abi_get_fortran_booleans` reports `is_set == 0` or
`MPI_Abi_get_fortran_info` returns `MPI_INFO_NULL`. mpif's own boolean values
come from Fortran directly, through the common blocks in
`src/mpif_logical.F90`, so nothing has to be published for those either.

`MPI_Abi_set_fortran_info` and `MPI_Abi_set_fortran_booleans` would only be
needed to make mpif the *sole* provider of that information, so that the
implementation could be built with `--enable-fortran=no`. That is worth
remembering as an option -- it would also sidestep the flang/libtool problems on
macOS -- but it is a change of approach rather than a missing feature, and
MPICH's `MPIR_Abi_set_fortran_info_impl` returns `MPI_ERR_ABI` if the values are
already set, so the two cannot simply be combined.

### Generated callback interfaces and definitions

Two hand-maintained pieces describe callbacks that `apis.json` already
describes, and can therefore drift from it:

- the f08 abstract interfaces (`MPI_User_function`,
  `MPI_Comm_copy_attr_function`, ...) in `src/mpif_f08_types.F90`, all 18 of
  which are in the JSON;
- the predefined callbacks in `src/mpif_attr_fns.F90`, all 14 of which are in
  the JSON as `predefined_function` entries.

An audit of the latter against the JSON found the types all correct and three
divergences, all now corrected. They were what stood between the JSON and these
two pieces being generated, so what is left of that job is the generating:

- `MPI_NULL_DELETE_FN`'s last argument was `ierr` where the JSON says `ierror`,
  and A.5 with it -- `MPI_NULL_DELETE_FN(COMM, KEYVAL, ATTRIBUTE_VAL,
  EXTRA_STATE, IERROR)` against `IERR` for `MPI_NULL_COPY_FN` and `MPI_DUP_FN`
  two lines above. So the standard is inconsistent across its own three MPI-1
  callbacks and the JSON is faithful to it; mpif now is too, all three names
  matching, which for external subprograms is a matter of documentation rather
  than of linkage.
- `MPI_TYPE_NULL_DELETE_FN`'s `ierror` has kind `ERROR_CODE_SHOW_INTENT`, which
  was in none of the generator's kind lists, so generating these would have hit
  `@assert false`. It is now in `int_kinds` beside `ERROR_CODE`, which is all it
  is: the suffix is about A.4 showing an INTENT(OUT) that the abstract interface
  does not, and mpif follows the abstract interface. Whether a callback's
  arguments carry intents at all is a question about callbacks and not about this
  kind -- they do not, in any of the 18.
- `MPI_CONVERSION_FN_NULL`'s `userbuf` and `filebuf` have kind `C_BUFFER3`, which
  `aint_kinds` mapped to `integer(MPI_ADDRESS_KIND)`. That is right where the
  parameter really is an address, as in `MPI_Alloc_mem`, and wrong here: A.5 gives
  a conversion callback `<TYPE> USERBUF(*)`, a choice buffer, and A.1.3 gives
  `TYPE(C_PTR), VALUE`. `C_BUFFER3` and `C_BUFFER4` have moved out of
  `aint_kinds` to join `C_BUFFER2` among the kinds that are a choice buffer in the
  `mpi` module and a `TYPE(C_PTR)` in `mpi_f08`. The earlier worry that "the kind
  alone does not say which" turned out to be unfounded: these two kinds appear on
  callbacks and nowhere else, so they do say. `dev/mpiapi.jl` asserts exactly that
  where it drops callbacks and predefined functions, so the claim is checked on
  every run rather than believed, and `gen/` is byte-identical across the change.

The abstract interfaces themselves are no longer among the divergences, in either
respect. Their intents went first -- there are none, in any of the 18, which is
how MPI-5.0 declares every callback it has -- and the last of their types
followed: `MPI_User_function`'s `invec` and `inoutvec` and the datarep conversion
functions' `userbuf` and `filebuf` are `TYPE(C_PTR), VALUE` as the standard gives
them, where all four used to be `integer(MPI_ADDRESS_KIND)` by reference.

What is left is the risk of drift, and it is smaller than it was: the argument for
generating these two pieces was that nothing checked them, and now
`dev/check-f08-bindings.jl` does -- the abstract interfaces against A.1.3 and the
f08 predefined callbacks against A.4, on the same terms as the generated
wrappers. That is where the argument-name slip above was found. `mpif.h`'s and the
`mpi` module's own predefined callbacks, in `src/mpif_attr_fns.F90`, are the one
set still checked by nothing but the audit recorded here; A.5 gives them, so the
same tool could reach them, and the `ierr`/`ierror` correction above is the kind of
thing it would have said rather than left to an audit. `src/mpif_f08_attr_fns.F90` also copies whatever the
abstract interfaces say, and `test/callback_intents_f08.f90` holds those two
together at compile time, one callback per interface written the way the standard
writes it.

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

## Verified as correct

Recorded so that they do not get re-investigated:

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
- **`MPI_Sizeof` stays as it is, covering rank zero and rank one.**
  `src/mpif_types.F90` gives the generic a scalar and an assumed-size specific per
  type and kind, so an argument of rank two or more resolves to nothing. That is
  the deliberate stopping place, not an oversight: a Fortran generic needs a
  specific per type, kind *and* rank, so covering every rank would mean sixteen
  specifics apiece, and assumed-rank -- which would collapse them to one each --
  is not being taken (see "Assumed-rank choice buffers"). MPICH's own binding
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
  argument and by declared type, no pair is indistinguishable -- which also means
  no generic interface pairs two specifics a compiler could not tell apart. The
  two whose *argument lists* differ from their base, `MPI_Type_get_contents_c`
  and `MPI_Type_get_envelope_c`, differ in A.4 in the same way, gaining a count
  of large counts. `MPI_Psend_init` and `MPI_Precv_init` correctly have no `_c`
  form at all, and `dev/mpiapi.jl` asserts they never gain one.
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
  "Assumed-rank choice buffers".

  Two smaller things the comparison turned up, neither a defect. `mpi_f08` has
  six routines A.4 does not list -- `MPI_Attr_delete`, `MPI_Attr_get`,
  `MPI_Attr_put`, `MPI_Keyval_create`, `MPI_Keyval_free`, all MPI-1 forms that
  A.4.16 does not carry into `mpi_f08`, and `MPI_F_sync_reg`, which is not in the
  standard at all. And A.4 gives `MPI_TYPE_NULL_DELETE_FN`'s `ierror`
  `INTENT(OUT)` where its own abstract interface
  `MPI_Type_delete_attr_function` gives none and where the other twelve
  predefined callbacks give none; that is an inconsistency in the standard, and
  mpif follows the abstract interface.

## Working on this

How to reproduce and verify what is above, and the traps that cost the most time.

### Building and testing

    bash scripts/macos-build-mpif.sh   <mpich|openmpi> <gcc|llvm>   # build and install mpif
    bash scripts/macos-test-mpif.sh    <mpich|openmpi> <gcc|llvm>   # test/, rebuilt from scratch
    bash scripts/macos-test-mpich-suite.sh <mpich|openmpi> <gcc|llvm>  # MPICH's Fortran suite

`test/` is mpif's own and should be entirely green; the MPICH suite is the broad
one, and the counts it reports are recorded under "Suite baseline" below. To run
one directory of the suite rather than all of it:

    cd mpi/tests-<variant>-gcc/mpich-5.0.1/test/mpi/f90/rma
    MPIF_REAL_MPIEXEC=<mpi-prefix>/bin/mpiexec ../../runtests -tests=testlist \
        -mpiexec=<repo>/ci-scripts/suite/mpiexec-filter.sh -maxnp=4

Set `MPIF_KEEP_TESTS=1` to stop `runtests` deleting each executable after it
runs, which is what a debugger needs to turn "test failed" into a backtrace.

Neither of the first two scripts installs the MPI they build against; that is
`scripts/macos-install-mpi.sh <mpich|openmpi> <gcc|llvm>`, and it builds the
implementation from source, so it costs a good deal more than the others. It is
what to run when `find_package(MPI)` starts reporting that
`mpi/<mpi>-<toolchain>/include` does not exist.

The suite has failures that are expected, so what fails a run is a difference
from `ci-scripts/suite/mpich-suite-xfail.txt` rather than a failure --- in either
direction, so a test that starts passing is caught as well as one that starts
failing, and the list cannot rot into a blanket exception. The file names every
expected failure with the reason it is there, "untriaged" included, and the
comparison is by name because counts hide a swap. `.github/workflows/ci.yaml`,
every `docker/*.dockerfile` and `scripts/macos-build.sh` all gate on it; none of
them swallows the result any more.

A variant with no `triaged` line in that file is compared and reported but
cannot fail the run, which is how a variant nobody has measured stays honest
rather than being papered over. The variant is detected rather than passed in --
Open MPI by the `ompi_info` it installs and MPICH by `mpiexec.hydra`, the
toolchain from what mpif's own `mpifort` reports, the OS, its version and the
architecture from the system -- and a component it cannot work out becomes
`unknown`, which matches no entry, so the run is loudly wrong rather than quietly
lenient.

The key is `<mpi>/<toolchain>/<os>/<os-version>/<arch>`, and the version is in it
because environments that agree on everything else still disagree: the Docker
images run Ubuntu 26.04 where CI's runners run 24.04 and the two part company over
`MPI_Dist_graph_create` and `i_fcoll_test`, and this repository's own macOS is 26
where the runners are 15. So a local run here and a CI run no longer share a row,
which is the point -- they were never the same environment.

One check needs no build at all:

    julia dev/check-f08-bindings.jl   # every mpi_f08 declaration against MPI-5.0

It reads `doc/mpi50-report.pdf` through `pdftotext -layout` and compares intents,
declared types, `VALUE`, argument names and argument order against the appendix
that gives them -- `gen/mpif_f08_functions.F90` against A.4, the callback abstract
interfaces of `src/mpif_f08_types.F90` against A.1.3, and the predefined callbacks
of `src/mpif_f08_attr_fns.F90` against A.4 -- exiting nonzero on anything it
cannot account for. It reports no unexplained divergence today. Widening what it
compares is what got it there each time: comparing types found the
`MPI_Psend_init` count and the six `buffer_addr` declarations, which intents alone
had passed, and comparing the hand-written declarations at all found
`MPI_Type_delete_attr_function`'s argument name. Run it after changing how any f08
argument is declared, generated or not.

It is Julia because `dev/mpiapi.jl` is, the two being the same job from opposite
ends -- one writes the declarations, the other checks them -- and a dev directory
with one language in it needs no explaining. It was Python first; the port was
checked by running both over the same tree, on a clean tree and with three defects
put back, and taking byte-identical output as the standard to meet.

### Stale build artifacts were the biggest time sink

Four separate "regressions" during one session turned out to be stale artifacts,
including a `dyld: Symbol not found: ___mpi_cptr_MOD_mpi_alloc_mem_cptr` that
looked alarming and meant nothing. The rule that removes the whole class: **the
three scripts above delete their build directory and start over every time.**
There is nothing to clean by hand, and no state to reason about.

- `scripts/macos-build-mpif.sh` removes `build-<variant>` and the mpif
  installation.
- `scripts/macos-test-mpif.sh` removes `build-<variant>-tests`.
- `scripts/macos-test-mpich-suite.sh` unpacks the suite again and reconfigures
  it, so `mpi/tests-<variant>/mpich-<version>` is new on every run.

What survives is downloaded source only -- the MPI source tree under
`mpi/src-<variant>`, whose reuse the install script's stamp guards, and the
MPICH tarball. Both cost a download and no correctness.

The cost is a few minutes per run, which buys back far more than it spends:

- `runtests` rebuilds a test only when its executable is **missing**, so an
  executable left from an older mpif is relinked, or simply rerun, against the
  new library. Selective cleaning is what this section used to prescribe, and it
  is easy to get subtly wrong -- deleting libtool's `.o` files while leaving the
  `.lo` stamps that stand for them breaks `util/libmtest_f77.la` with
  `ar: .libs/mtest_f77.o: No such file or directory`, and every test in the suite
  then "fails to build". The `util/` libraries matter as much as the tests:
  `libmtest_f08.a` holds `MTest_Init` and is compiled against mpif's modules.
- `ctest` on its own does **not** rebuild. `ctest --test-dir build-<variant>-tests`
  will happily rerun a binary built against a previous mpif and report a pass.
  Use `scripts/macos-test-mpif.sh`, which reconfigures and rebuilds first.

### Verifying a fix

`test/` is built `-O0`, and that hides a whole class of defect: anything whose
symptom is the *caller's* code being optimised differently. An INTENT the
standard does not give a dummy argument is the example that has already bitten --
INTENT(OUT) on a status let gfortran delete the caller's store to
`status%MPI_ERROR`, which no -O0 test could see. `test/status_error_f08.f90` is
therefore compiled `-O2` on purpose. Consider the same for any test whose
assertion is about what the caller is allowed to assume.

Every fix recorded above was checked by putting the bug back: revert the change,
rebuild, and confirm the new test fails -- ideally with the same message the
original failure gave. This has caught two tests that passed either way and
were therefore worthless, `test/comm_get_attr_f08.f90` among them, where a
user-defined keyval turned out not to reproduce the bug at all and
`MPI_APPNUM` was needed instead.

For a bug that lives in the generator, revert by editing `dev/mpiapi.jl` and
rerunning `julia dev/mpiapi.jl`; never edit `gen/` directly.

For memory errors, note that ASan is close to useless here: the faulting write is
usually inside libmpi, which is not instrumented, and is often a hand-rolled copy
loop rather than an intercepted libc call. A guard page works instead -- `mmap`
two pages, `mprotect` the second `PROT_NONE`, and place the buffer so its last
byte ends the first page. That is how the `MPI_Info_get_string` overrun and the
`array_of_commands` scan were both pinned down.

### Worth doing next, roughly in order

1. **Fortran-set attribute values as C sees them**, the one mpif defect the suite
   still reports, above under "Missing features". Four tests, a specification that
   says exactly what is wanted, and a design question -- where the storage lives
   and how its lifetime is tied to the attribute -- that is the whole of the work.
2. **The PMPI interface**, which does not exist at all and which `mpif.h`
   currently promises four names it cannot link.
3. **`i_fcoll_test`, the last two untriaged entries**, on CI's Linux runners and
   under flang on macOS. `ci-scripts/suite/mpich-suite-xfail.txt` has the symptom.
   The macOS Open MPI case is solved and above; these two are not that, and the
   Linux one is odd in that the test passes on Ubuntu 26.04 and fails on 24.04.
   Start where the spawn eleven were solved: the "## Test output" block in the
   run's tap file.

Two things are decided and not on this list, so that they are not picked up by
mistake: assumed-rank choice buffers are not being taken for now, and `MPI_Sizeof`
stays as it is, covering rank zero and rank one. Both are recorded where they
belong -- the first in its own section, the second under "Verified as correct".

Three things are worth reporting upstream and are not yet, all Open MPI: the
`MPI_Info_create_env` divergence across `MPI_Init`, the name on a fresh window,
and the lost nonblocking collective write on macOS. Two have reproducers in
`bug-ompi-*/` already.

### Suite baseline

All twelve variants, from the CI run of `baa7f65`, as failures out of 104 f77,
122 f90 and 136 f08 tests. `ci-scripts/suite/mpich-suite-xfail.txt` is the authority: it names
every one of these with its reason, and the suite run fails on any difference
from it. The table is for telling a change from the background noise at a
glance.

The MPICH rows wobble by one or two between runs, because the five `flaky`
entries in the list are genuinely nondeterministic -- in the run these numbers
come from, `typecntsf` failed on `mpich/gcc/linux/aarch64` and passed on
`mpich/gcc/linux/x86_64`, while `typecntsf90` did the opposite. Read the MPICH
rows as approximate to that extent; the list, which excuses those five either
way, is what is exact.

| variant                          | f77 | f90 | f08 |
|----------------------------------|-----|-----|-----|
| mpich/gcc/darwin/15/arm64        |   3 |  11 |  18 |
| mpich/gcc/linux/24.04/x86_64     |   3 |  12 |  19 |
| mpich/gcc/linux/24.04/aarch64    |   4 |  11 |  20 |
| mpich/llvm/darwin/15/arm64       |   3 |  11 |  15 |
| mpich/llvm/linux/24.04/x86_64    |   4 |  12 |  16 |
| mpich/llvm/linux/24.04/aarch64   |   4 |  12 |  16 |
| openmpi/gcc/darwin/15/arm64      |   5 |   9 |  20 |
| openmpi/gcc/linux/24.04/x86_64   |   8 |  14 |  23 |
| openmpi/gcc/linux/24.04/aarch64  |   5 |   9 |  20 |
| openmpi/llvm/darwin/15/arm64     |   5 |   9 |  16 |
| openmpi/llvm/linux/24.04/x86_64  |   8 |  14 |  19 |
| openmpi/llvm/linux/24.04/aarch64 |   5 |   9 |  16 |

Every Open MPI f90 row is one lower than the run it comes from: `bsendf90` used
to fail to build everywhere and now builds, and fails only on MPICH -- see
"suite tests that cannot pass against a conforming binding". That is inferred
rather than measured, from `bsendf`, which is the same test with the same
400-byte buffer and has always been expected to fail on MPICH alone; CI is what
confirms it, on all four Open MPI variants at once. The MPICH rows are measured,
`mpich/gcc/darwin/26/arm64` reporting no differences after the change.

The two Open MPI x86_64 rows are the measured ones again: the eleven spawn tests
there fail, on the abort recorded under "a spawned child is not reachable over TCP
on the x86_64 runners", and subtracting them is what would make those rows equal to
their aarch64 twins. Two attempts to remove them -- the interface, then the warning
-- were both refuted by CI, which is what the rows are for.

Fifty-four entries cover them, for fifty-two distinct language-and-test pairs --
five of them `flaky` rather than `xfail`. All but two are accounted for, each
either by an entry here or by a reason that stands on its own; the two are
`i_fcoll_test` on CI's Linux runners and under flang on macOS. The rows above are
CI's, so they do not count the six `dgraph` entries, which belong to a Docker
variant.

Triage has taken twenty-four untriaged pairs down to two, and resolved them into
three mpif bugs, two MPICH ones, three Open MPI ones, a decision, a test asserting
more than the standard says -- the `dgraph` pair, where Open MPI is within its
rights -- and eleven that were never failures at all, the spawn tests that a
launcher warning was failing for them. Every one came from running the test rather
than reading it, or from reading what the run printed: the four attribute tests
crash in a C frame that names the defect, `test14` and `test15` sit in a directory
whose thirteen passing neighbours say what the mechanism is, the two Open MPI name
cases and the aio one reproduce in C in a dozen lines, and the spawn eleven needed
nothing but the "## Test output" block that every CI run had been recording all
along. The earlier version of this section had four rows and
claimed every failure was attributable, both of which were wrong: MPICH looked
far worse than Open MPI only because those rows predated the handle-table patch,
and most of the failures had never been diagnosed.

Three things the twelve-way measurement settled that guesswork had got wrong:

- **The architecture belongs in the key**, though not for the reason it was put
  there. Eleven Open MPI spawn tests failed on `linux/x86_64` and passed on
  `linux/aarch64`, and two MPICH tests differ the other way; keyed on
  `mpi/toolchain/os` alone, each set would read as an unexpected pass on whichever
  runner ran second. The spawn eleven turned out not to be about the ISA at all --
  a warning the x86_64 runners produce and the arm64 ones do not, for reasons not
  established -- so read the component as "a different environment" rather than as
  a claim about the instruction set. The two MPICH tests keep it in the key.
- **`alltoallwf08`, `nonblockingf08`, `nonblocking_inpf08` and `vw_inplacef08`
  are a gcc problem, not an MPICH one.** They fail under gcc on *both*
  implementations and pass under llvm on both, so the selector is `*/gcc/*/*`.
  This section used to call them "the four that flang passes and gfortran does
  not" and guess they were about compiler-made buffer copies for noncontiguous
  subarrays; under MPICH they abort inside `mpi_abi_util.h:140`, which is not
  that. The guess is withdrawn; the symptom is recorded.
- **`mpich/gcc/darwin/arm64` transfers between machines.** Its list was measured
  here, on MacPorts gcc 15.2 with twelve cores, and CI's macos-15 runner --
  Homebrew compilers, about three cores -- reports no differences against it.
  That is the evidence that the key needs nothing finer than architecture.

Every variant is declared `triaged`, so any difference now fails the run.
That rests on a single measurement each, which is thin for a flaky test, so
expect some churn: a flaky entry surfaces as an unexpected pass, which is the
mechanism working rather than failing. Three entries are already marked as seen
on one variant only and therefore suspect.

`test/`, mpif's own suite, was 32 of 32 and is now 39 of 39, `buffer_detach` and
`op_create` being the most recent additions. Green on all twelve variants in CI up
to `waitall_f08`; the two new ones have been run on `mpich/gcc/darwin/arm64` and
`openmpi/gcc/darwin/arm64`, the other ten being CI's to confirm.

Passing the f08 status through to C instead of converting it moved nothing, and
was not meant to: it removes the temporary, the conversion and all 77 `loc()`
comparisons, leaving what the wrappers do observably the same. The numbers being
unchanged is the result to want from it.

`mprobef08` accounts for the last f08 failure removed, one on each variant. It
had two causes, and the second is the interesting one: mpif declared
`TYPE(MPI_Status), INTENT(OUT)` where the standard declares plain
`TYPE(MPI_Status)`, and INTENT(OUT) tells the compiler that the caller's stored
`status%MPI_ERROR` cannot be read, so at -O2 the store is deleted before the call
happens. The suite compiles with -O2 and caught it; `test/` compiles with -O0 and
did not.

Exporting the predefined attribute callbacks from the `mpi` and `mpi_f08`
modules moved f90 and f08 and left f77 exactly where it was, which is the
confirmation that it was the modules at fault: `mpif.h` had always declared them.
Six f90 tests and four f08 tests went green on both implementations --
`attrmpi1f90`, `commattr2f90`, `commattr3f90`, `commattr4f90`, `typeattr3f90`,
`winattr2f90`, and the `f08` counterparts of four of those -- and nothing
regressed.

The toolchains agree exactly on f77 and f90, and differ by four tests in f08,
where flang does better than gfortran. It is the same four on both MPI
implementations, and none fail under flang that pass under gfortran:

    alltoallwf08   nonblockingf08   nonblocking_inpf08   vw_inplacef08

Their shape is a lead rather than a diagnosis. All four are nonblocking or
in-place collectives, which is exactly the case "Assumed-rank choice buffers"
above describes: with `MPI_SUBARRAYS_SUPPORTED` false, a noncontiguous actual
argument reaches the wrapper as a compiler-made copy, and for a nonblocking call
that copy dies before the request completes. Two compilers need not make the same
copy, so a difference here is more likely to be about what each chooses to copy
than about mpif. Worth confirming before reading anything into it.

If that lead ever is confirmed, these four are a cost of declining assumed-rank
rather than a defect to fix -- four suite tests that pass a noncontiguous subarray
to a nonblocking call, which `MPI_SUBARRAYS_SUPPORTED == .FALSE.` tells a program
not to do. `ci-scripts/suite/mpich-suite-xfail.txt` carries them as `*/gcc/*/*` with
that symptom either way.

One caution about these numbers: the Open MPI run needs the loopback workaround
that `scripts/macos-test-mpich-suite.sh` applies by default -- without it the
spawn tests hang rather than fail, each burning `runtests`' 180-second timeout,
and the run appears stuck.
