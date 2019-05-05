/* Some defines */
.equ MODE_FIQ, 0x11
.equ MODE_IRQ, 0x12
.equ MODE_SVC, 0x13

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

    /* Esta região deve ser coerente */
    ldr r0, =#0x0
    ldr r1, [r0]                    /* Endereço físico */
    ldr r0, =#0x00014c06
    ldr r2, [r0]                    /* Template descritor para coerência de memória */
    orr r1, r1, r2                  /* Combinar endereço e template */
    str r1, [r0]                    /* Escrever o valor modificado */

    /* Esta região não deve ser coerente */
    ldr r0, =#0x100000
    ldr r1, [r0]                    /* Endereço físico */
    ldr r0, =#0x00000c1e               
    ldr r2, [r0]                    /* Template descritor para não coerência de memória */
    orr r1, r1, r2                  /* Combinar endereço e template */
    str r1, [r0, #4]                /* Escrever o valor modificado */

    /*HABILITANDO CACHES*/
    mrc p15, 0, r0, c1, c0, 0       /* Read current control reg */
    orr r0, r0, #0x4                /* Setando bit 2 (C) */
    orr r0, r0, #0x1000             /* Setando bit 12 (I) */
    mcr p15, 0, r0, c1, c0, 0       /* Write reg back */
    
    /*HABLITAR SCU*/
    mrc p15, 4, r0, c15, c0, 0      /* Ler o endereço base de periph */
    ldr r1, [r0, #0x0]              /* Ler o registrador de controle da SCU */
    orr r1, r1, #0x1                /* Setar o bit 0 do registrador */
    str r1, [r0, #0x0]              /* Escrever o valor modificado */

    /*HABILITAR COERENCIA nos cores*/
    mrc p15, 4, r0, c15, c0, 0      /* Ler o endereço base de periph */
    ldr r1, [r0, #0x04]             /* Ler o registrador de configuração da SCU */
    orr r1, r1, #0xF0               /* Setando todos as CPUs sendo parte da coerência */
    str r1, [r0, #0x04]             /* Escrever o valor modificado */

    /*HABILITANDO TROCA DE MENSAGENS ENTRE CACHE E TLB PARA MANUTENCAO*/
    mrc p15, 0, r0, c1, c0, 1       /* Ler o registrador auxiliar de controle */
    orr r0, r0, #0x01               /* Setar o bit FW (bit 0) */
    mcr p15, 0, r0, c1, c0, 1       /* Escrever o valor modificado */

    /*SETANDO O BIT SMP*/
    mrc p15, 0, r0, c1, c0, 1       /* Ler o registrador auxiliar de controle */
    orr r0, r0, #0x040              /* Setar o bit SMP (6) */
    mcr p15, 0, r0, c1, c0, 1       /* Escrever o valor modificado */

.section .text
Reset_Handler:

    /* FIQ stack */
    msr cpsr_c, MODE_FIQ
    ldr r1, =_fiq_stack_start
    ldr sp, =_fiq_stack_end
    movw r0, #0xFEFE
    movt r0, #0xFEFE    

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

Abort_Exception:
    swi 0xFF

