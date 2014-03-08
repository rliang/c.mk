TARGET       := libfoo.so
INCS         :=
LDLIBS       :=
SRCDIR       := src
LIBSDIR      := libs
TESTDIR      := test
TESTER       := valgrind --leak-check=full --error-exitcode=1
TESTCFLAGS   := -O0 -pipe -g -Wall -Wextra
TESTLDFLAGS  :=
DISTCFLAGS   := -DNDEBUG -fPIC
DISTLDFLAGS  := -shared
CFLAGS       ?= -Os -pipe -march=native
CXXFLAGS     ?= $(CFLAGS)
LDFLAGS      ?=
PREFIX       ?= /usr/local
DESTDIR      ?= lib

EXTS         := '.*\.\(c\(pp\|xx\)?\|C\)'
DEPCFLAGS    := $(INCS) -I$(LIBSDIR) -MMD -MP
SRCS         := $(shell find $(SRCDIR) $(LIBSDIR) -type f -regex $(EXTS))
TESTSRCS     := $(shell find $(TESTDIR) -type f -regex $(EXTS))
OBJS         := $(addsuffix .o, $(basename $(SRCS)))
DEPS         := $(addsuffix .d, $(basename $(SRCS) $(TESTSRCS)))
TESTS        := $(basename $(TESTSRCS))
TESTLOGS     := $(addsuffix .log, $(TESTS))

all: CFLAGS += $(DISTCFLAGS) $(DEPCFLAGS)
all: CXXFLAGS += $(DISTCFLAGS) $(DEPCFLAGS)
all: LDFLAGS += $(DISTLDFLAGS)
all: $(TARGET)

test: CFLAGS := $(TESTCFLAGS) $(DEPCFLAGS)
test: CXXFLAGS := $(TESTCFLAGS) $(DEPCFLAGS)
test: LDFLAGS := $(TESTLDFLAGS)
test: $(TESTS) $(TESTLOGS)

install: $(TARGET)
	install -d $(PREFIX)/$(DESTDIR)
	install $< $(PREFIX)/$(DESTDIR)

clean:
	$(RM) $(OBJS) $(DEPS) $(TESTS) $(TESTLOGS) $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) $(LDLIBS) -o $@ $^

%.log: %
	$(TESTER) ./$< &> $@

-include $(DEPS)
