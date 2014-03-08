# c.mk

Generic Makefile for C/C++ projects.

## Features

### Executable/Library Generation

By default a shared library is generated. To make an executable, remove `-fPIC`
from `DISTCFLAGS` and `-shared` from `DISTLDFLAGS`.

### Multi-Extension Sources

Supported extensions are `c`, `C`, `cpp`, `cxx`, as defined in the `EXTS`
variable.

Make automatically detects what compiler to use for each, and the resulting
objects can be linked, taking advantage of C/C++ backwards compatibility.

### Automated Testing

Just place the test sources in `TESTDIR` and run `make test`. A test fails if
it returns an integer greater than zero.

By default `valgrind` is used on each test. This can be changed or removed in
the `TESTER` variable.

Currently, additional objects are not linked, so each needed source must be
`#include`'d.

### Environment Variables

Common variables usually set by package managers, `CFLAGS`, `CXXFLAGS`,
`LDFLAGS`, `PREFIX` and `DESTDIR`, can be overriden by exporting them to Make.

### Local Libraries

By default, `LIBSDIR` is scanned for sources to be compiled. If this isn't
desired, a simple solution is pointing `LIBSDIR` to `SRCDIR`.

