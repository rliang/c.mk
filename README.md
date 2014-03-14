# c.mk

Generic Makefile for C/C++ projects.

## C++

To use it in C++ projects issue the following command:

```sh
for i in 'CC/CXX' 'CFLAGS/CXXFLAGS' '\.c/\.cpp'; do sed -i "s/$i/g" Makefile; done
```

Or any other C++ source extension instead of `.cpp`.

## Executable/Library Generation

By default a shared library is generated. To make an executable, remove `-fPIC`
from the `R|DCFLAGS` variables and `-shared` from `R|DLDFLAGS`.

## Automated Testing

Just place the test sources in `test` and run `make test`. All project sources
are linked, but without `main()`.

A test fails if its program returns an integer greater than zero.

## Environment Variables

Common variables usually set by package managers, `CFLAGS`, `CXXFLAGS`,
`LDFLAGS`, `PREFIX` and `DESTDIR`, can be overriden by exporting them to Make.

