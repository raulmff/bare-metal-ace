// ------------------------------------------------------------
// Cortex-A MPCore - Interrupt Controller functions
// Header File
//
// Copyright ARM Ltd 2009. All rights reserved.
// ------------------------------------------------------------

#ifndef _TESTE_H_
#define _TESTE_H_

// ------------------------------------------------------------
// GIC
// ------------------------------------------------------------

// Typical calls to enable interrupt ID X:
// enable_irq_id(X)                 <-- Enable that ID
// set_irq_priority(X, 0)           <-- Set the priority of X to 0 (the max priority)
// set_priority_mask(0x1F)          <-- Set Core's priority mask to 0x1F (the lowest priority)
// enable_GIC()                     <-- Enable the GIC (global)
// enable_gic_processor_interface() <-- Enable the CPU interface (local to the core)
//
// OR
//
// Use init_GIC() which is a simple switch everything on function! :-)
//

//  Global enable of the Interrupt Distributor
void enable_caches(void);

#endif

// ------------------------------------------------------------
// End of MP_GIC.h
// ------------------------------------------------------------