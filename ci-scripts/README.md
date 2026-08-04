# `ci-scripts/`

What CI and the Docker images run, and what the local scripts in `scripts/` call
into so that all three build mpif the same way. Nothing here is specific to a
runner: every script takes its prefixes as arguments or reads them from the
environment, so the same recipe works on a GitHub runner, inside a Docker build
and on a laptop.

## Two parts, and why

    ci-scripts/            building and installing an MPI
    ci-scripts/suite/      running MPICH's Fortran test suite against it

The division is not tidiness. Both are expensive -- building an MPI from source
takes minutes per variant, and building MPICH's suite takes minutes more -- and
both are cached, in CI by a key and in Docker by layers. Everything the MPI build
reads has to be in that cache key, and nothing else may be, or an unrelated edit
throws the build away.

The three files under `suite/` are read only after an MPI exists and cannot change
it: the runner, the list of expected failures and the `mpiexec` filter. Keeping
them in a directory of their own is what lets both caches say "the MPI build
depends on `ci-scripts/` and not on `ci-scripts/suite/`":

- `.github/workflows/ci.yaml` hashes this directory and `fortran/**` into the key
  for the MPI installation cache, excluding `suite/` and this README:

      hashFiles('ci-scripts/**', '!ci-scripts/suite/**', '!ci-scripts/README.md', 'fortran/**')

  Not `ci-scripts/*`, which looks like it stops at this directory's own files and
  does not: that pattern matches the *directory* `suite`, and `@actions/glob`
  expands a matched directory to all of its descendants, so the suite's files stay
  in the key and every edit to the expected-failures list rebuilds MPI on twelve
  variants. It took a CI run to notice, and the way to tell is in the log: the
  cache step prints the key, so if a suite-only commit changes that hash, the
  pattern is wrong again.
- each `docker/*.dockerfile` copies `ci-scripts/*.sh ci-scripts/*.txt
  ci-scripts/*.patch` before the MPI build, and `ci-scripts/suite` only at the end,
  after the MPI and mpif are both built.

Both are patterns rather than lists of filenames, and deliberately. A key that
names its inputs rots silently: a new install input left out of it would be served
an MPI built without it. A pattern covers a new file automatically, and in Docker
a file that is somehow missing fails the build rather than the run.

This is worth keeping right, and it has been wrong twice. First both the key and
the `COPY` took all of `ci-scripts/**`, so editing one reason in
`mpich-suite-xfail.txt` rebuilt MPI on all twelve CI variants and rebuilt every
Docker image from the MPI up. Then the key was narrowed to `ci-scripts/*`, which
fixed nothing for the reason above, while the Docker half really was fixed -- the
same intention expressed twice, right in one place and wrong in the other, and only
a CI run told them apart.

So: a new file that the MPI build reads belongs here, and a new file that only the
suite needs belongs in `suite/`. Putting a suite file here costs a rebuild;
putting an install file in `suite/` is the one that is dangerous, since CI would
then cache an MPI that does not reflect it.

## The files

Building and installing an MPI:

| file | what it does |
|------|--------------|
| `install-mpich.sh` | download, patch, configure, build and install MPICH for the standard ABI |
| `install-openmpi.sh` | the same for Open MPI |
| `install-mpi-header.sh` | install the MPI Forum's official ABI `mpi.h` over the implementation's own |
| `prune-install.sh` | delete everything the standard ABI does not define, from a list |
| `mpich-prune.txt`, `openmpi-prune.txt` | those lists |
| `mpich-abi-util-one-copy.patch` | local fix carried against MPICH 5.0.1; see MISSING.md |
| `openmpi-info-set-empty-value.patch` | local fix carried against Open MPI's ABI branch; see MISSING.md |
| `check-mpi-install.sh` | assert that what was installed is the standard ABI and nothing else |
| `check-headers.sh` | check that every Cray pointer in `mpif_constants.h` is the variable C initialises; run by the `checks` job in CI, and needs no MPI or compiler |
| `flang-darwin-shim.sh` | works around flang's `-Wl,` handling on macOS, for MPICH's libtool |

Both install scripts take the prefix to install into, and both understand
`MPI_PREPARE_ONLY=1`, which stops after preparing the source tree -- that is what
lets CI cache the downloaded and `autogen`'ed tree separately from the build.

Running the suite, in `suite/`:

| file | what it does |
|------|--------------|
| `test-mpich-suite.sh` | download, build and run MPICH's Fortran suite against an installed mpif, then compare the result with the list below |
| `mpich-suite-xfail.txt` | every expected failure, per variant, with the reason it is expected. A variant is `<mpi>/<toolchain>/<os>/<os-version>/<arch>`, detected by the runner above; the version is in the key because the images and CI's runners are different releases and disagree |
| `mpiexec-filter.sh` | drop the launcher banner Open MPI prints on every run, which the suite would otherwise read as test output |

`test-mpich-suite.sh` takes the MPI prefix and the mpif prefix. It reads
`MPICH_VERSION` out of `install-mpich.sh` one directory up, so the suite always
matches the MPICH the recipe here knows how to build.

## Where else these are used

- `.github/workflows/ci.yaml` -- twelve variants natively, and the authority on
  what mpif supports, plus one built in a container: the 32-bit i386 one, which a
  matrix entry cannot express because the suite's variant key ends in `uname -m`
  and a `-m32` build on an x86_64 runner still says `x86_64`.
- `docker/*.dockerfile` -- seven Linux variants: MPICH and Open MPI, gcc and
  flang, on amd64, arm64v8, the i386 that CI runs in a container, and the arm32v7
  that CI has no runner for and that qemu makes too slow to run per push. The two
  32-bit ones are MPICH-only, Open MPI having dropped 32-bit environments.
- `scripts/macos-*.sh` -- the same recipes locally; see "Working on this" in
  MISSING.md.
