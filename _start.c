/* Minimal _start: read argc/argv from the initial user stack and call main
   RISC-V user entry convention: stack layout at entry: argc (long), argv[], NULL, envp..., NULL
*/

extern int main(int, char **);
extern void _exit(int) __attribute__((noreturn));

void _start(void) {
     /* Kernel populates a0=argc, a1=argv for new process (see Process::exec).
         Read a0/a1 registers directly. */
     unsigned long a0_val, a1_val;
     __asm__ volatile ("mv %0, a0" : "=r" (a0_val));
     __asm__ volatile ("mv %0, a1" : "=r" (a1_val));
     int argc = (int)a0_val;
     char **argv = (char **)a1_val;
    int ret = main(argc, argv);
    _exit(ret);
}
