/* Minimal _start: read argc/argv from the initial user stack and call main
   RISC-V user entry convention: stack layout at entry: argc (long), argv[], NULL, envp..., NULL
*/

extern int main(int, char **);
extern void _exit(int) __attribute__((noreturn));

static void sys_write_test(void) {
    const char *msg = "DEBUG: _start reached\n";
    unsigned long len = 22;
    register unsigned long a0 __asm__("a0") = 1; // stdout
    register unsigned long a1 __asm__("a1") = (unsigned long)msg;
    register unsigned long a2 __asm__("a2") = len;
    register unsigned long a7 __asm__("a7") = 64; // sys_write
    __asm__ volatile ("ecall" : "+r"(a0) : "r"(a1), "r"(a2), "r"(a7) : "memory");
}

void _start(long argc, char **argv) {
    sys_write_test();
    int ret = main((int)argc, argv);
    _exit(ret);
}
