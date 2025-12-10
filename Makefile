

CC = riscv64-unknown-elf-gcc
AR = riscv64-unknown-elf-ar
INCLUDE_AXLIBC = -I../../ulib/axlibc/include
# Disable builtin memcpy/memset to avoid infinite recursion with our inline implementations
CFLAGS = -march=rv64gc -mabi=lp64d -O2 -ffreestanding -fno-common -Wall -W -pedantic -std=c99 -fno-builtin-memcpy -fno-builtin-memset $(INCLUDE_AXLIBC)
LDFLAGS = -march=rv64gc -mabi=lp64d -nostdlib -static -T ../user.ld

BUILDDIR := .
OUTDIR := ../bin
# Link against axlibc only - axlibc now uses inline ecall (no arceos_posix_api, no syscall_lib)
AXLIBC := ../../target/riscv64gc-unknown-none-elf/release/libaxlibc.a

.PHONY: all clean
all: $(OUTDIR)/kilo

$(OUTDIR)/kilo: _start.o mini_allocator.o kilo.o | $(OUTDIR)
	$(CC) $(LDFLAGS) -o $@ _start.o mini_allocator.o kilo.o $(AXLIBC) -lgcc

kilo.o: kilo.c
	$(CC) $(CFLAGS) -c -o $@ kilo.c

_start.o: _start.c
	$(CC) $(CFLAGS) -c -o $@ _start.c

mini_allocator.o: mini_allocator.c
	$(CC) $(CFLAGS) -c -o $@ mini_allocator.c



$(OUTDIR):
	mkdir -p $(OUTDIR)

clean:
	rm -f *.o $(OUTDIR)/kilo
