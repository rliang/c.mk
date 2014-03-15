TARGET   := libfoo.so
RCFLAGS  := -Os -march=native -DNDEBUG -fPIC
RLCFLAGS := -s -shared
DCFLAGS  := -O0 -g -fPIC
DLDFLAGS := -shared
TCFLAGS  := -O0 -g
TLDFLAGS :=
CFLAGS   += -Ilibs
LDFLAGS  += -Llibs
PREFIX   ?= /usr/local/
DESTDIR  ?= lib

OSRCS := $(wildcard src/*.c src/**/*.c)
ROBJS := $(patsubst src/%.c, build/release/%.o, $(OSRCS))
DOBJS := $(patsubst src/%.c, build/debug/%.o, $(OSRCS))
TSRCS := $(wildcard test/*.c test/**/*.c)
TOBJS := $(patsubst src/%.c, build/test/%.o, $(OSRCS))
TESTS := $(patsubst test/%.c, build/test/%.out, $(TSRCS))

release: build/release/$(TARGET)
build/release/$(TARGET): $(ROBJS)
	$(CC) $(RLDFLAGS) $(LDFLAGS) -o $@ $^
build/release/%.o: src/%.c | $(sort $(dir $(ROBJS)))
	$(CC) $(RCFLAGS) $(CFLAGS) -MMD -MP -o $@ -c $<

debug: build/debug/$(TARGET)
build/debug/$(TARGET): $(DOBJS)
	$(CC) $(DLDFLAGS) $(LDFLAGS) -Llibs -o $@ $^
build/debug/%.o: src/%.c | $(sort $(dir $(DOBJS)))
	$(CC) $(DCFLAGS) $(CFLAGS) -MMD -MP -o $@ -c $<

test: $(TESTS)
build/test/%.out: $(TOBJS) test/%.c
	$(CC) $(TCFLAGS) $(CFLAGS) $(TLDFLAGS) $(LDFLAGS) -o $@ $^
	./$@
build/test/%.o: src/%.c | $(sort $(dir $(TOBJS)))
	$(CC) $(TCFLAGS) $(CFLAGS) -MMD -MP -D'main(a)'='unused(a)' -o $@ -c $<

$(sort $(dir $(ROBJS) $(DOBJS) $(TOBJS) $(TESTS))):
	mkdir -p $@

-include $(addsuffix .d, $(basename $(ROBJS) $(DOBJS) $(TOBJS)))

install: release
	install -d $(PREFIX)/$(DESTDIR)
	install build/release/$(TARGET) $(PREFIX)/$(DESTDIR)

clean:
	rm -r build

