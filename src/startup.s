/* Some defines */
.equ MODE_FIQ, 0x11
.equ MODE_IRQ, 0x12
.equ MODE_SVC, 0x13
.equ TTB_COHERENT, 0x00014c06 /* Template descriptor for coherent memory */
.equ TTB_NONCOHERENT, 0x00000c1e /* Template descriptor for non-coherent memory */

.section .vector_table, "x"
.global _Reset
.global _start
_Reset:
    b Reset_Handler
    b Abort_Exception /* 0x4  Undefined Instruction */
    b . /* 0x8  Software Interrupt */
    b Abort_Exception  /* 0xC  Prefetch Abort */
    b Abort_Exception /* 0x10 Data Abort */
    b . /* 0x14 Reserved */
    b . /* 0x18 IRQ */
    b . /* 0x1C FIQ */

.section .text
Reset_Handler:
    /* FIQ stack */
    msr cpsr_c, MODE_FIQ
    ldr r1, =_fiq_stack_start
    ldr sp, =_fiq_stack_end
    movw r0, #0xFEFE
    movt r0, #0xFEFE

    mrc p15, 0, r1, c1, c0, 0   /* Read Control Register configuration data */
    orr r1, r1, #(0x800)    /* Disable I Cache */
    orr  r1, r1, #(0x8)    /* @ Disable D Cache */
    mcr p15, 0, r1, c1, c0, 0   /* Write Control Register configuration data */

fiq_loop:
    cmp r1, sp
    strlt r0, [r1], #4
    blt fiq_loop

    /* IRQ stack */
    msr cpsr_c, MODE_IRQ
    ldr r1, =_irq_stack_start
    ldr sp, =_irq_stack_end

irq_loop:
    cmp r1, sp
    strlt r0, [r1], #4
    blt irq_loop

    /* Supervisor mode */
    msr cpsr_c, MODE_SVC
    ldr r1, =_stack_start
    ldr sp, =_stack_end

stack_loop:
    cmp r1, sp
    strlt r0, [r1], #4
    blt stack_loop

    /* Start copying data */
    ldr r0, =_text_end
    ldr r1, =_data_start
    ldr r2, =_data_end

data_loop:
    cmp r1, r2
    ldrlt r3, [r0], #4
    strlt r3, [r1], #4
    blt data_loop

    /* Initialize .bss */
    mov r0, #0
    ldr r1, =_bss_start
    ldr r2, =_bss_end

bss_loop:
    cmp r1, r2
    strlt r0, [r1], #4
    blt bss_loop

    bl main
    b Abort_Exception

enable_scu:
    mrc p15, 4, r0, c15, c0, 0  /* Read periph base address */
    ldr r1, [r0, #0x0]          /* Read the SCU Control Register */
    orr r1, r1, #0x1            /* Set bit 0 (The Enable bit) */
    str r1, [r0, #0x0]          /* Write back modifed value */
    bx  lr

enable_caches:
    mrc p15, 0, r1, c1, c0, 0   /* Read Control Register configuration data */
    orr r1, r1, #(0x1 << 12)    /* Disable I Cache */
    orr  r1, r1, #(0x1 << 2)    /* @ Disable D Cache */
    mcr p15, 0, r1, c1, c0, 0   /* Write Control Register configuration data */

.export enable_caches

Abort_Exception:
    swi 0xFF