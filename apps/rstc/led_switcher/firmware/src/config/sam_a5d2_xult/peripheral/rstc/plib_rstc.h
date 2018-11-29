#ifndef PLIB_RSTC_H
#define PLIB_RSTC_H
/*******************************************************************************
  Reset Controller Peripheral Library, RSTC PLIB

  Company:
    Microchip Technology Inc.

  File Name:
    plib_rstc.h

  Summary:
    RSTC PLIB instance header file

  Description:
    Interface and data type declarations for the RSTC PLIB.
    The RSTC PLIB provides access to and control of the associated
    reset controller.

  Remarks:
    None

*******************************************************************************/

// DOM-IGNORE-BEGIN
/*******************************************************************************
Copyright (c) 2018 released Microchip Technology Inc. All rights reserved.
Microchip licenses to you the right to use, modify, copy and distribute
Software only when embedded on a Microchip microcontroller or digital signal
controller that is integrated into your product or third party product
(pursuant to the sublicense terms in the accompanying license agreement).

You should refer to the license agreement accompanying this Software for
additional information regarding your rights and obligations.

SOFTWARE AND DOCUMENTATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF
MERCHANTABILITY, TITLE, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR PURPOSE.
IN NO EVENT SHALL MICROCHIP OR ITS LICENSORS BE LIABLE OR OBLIGATED UNDER
CONTRACT, NEGLIGENCE, STRICT LIABILITY, CONTRIBUTION, BREACH OF WARRANTY, OR
OTHER LEGAL EQUITABLE THEORY ANY DIRECT OR INDIRECT DAMAGES OR EXPENSES
INCLUDING BUT NOT LIMITED TO ANY INCIDENTAL, SPECIAL, INDIRECT, PUNITIVE OR
CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, COST OF PROCUREMENT OF
SUBSTITUTE GOODS, TECHNOLOGY, SERVICES, OR ANY CLAIMS BY THIRD PARTIES
(INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF), OR OTHER SIMILAR COSTS.
*******************************************************************************/
#ifdef __cplusplus  // Provide C++ Compatibility
    extern "C" {
#endif
// DOM-IGNORE-END

#include "device.h"
#include "plib_rstc_common.h"

// *****************************************************************************
// *****************************************************************************
// Section: Interface Routines
// *****************************************************************************
// *****************************************************************************
void             RSTC_Initialize(        void );
void             RSTC_Reset(             RSTC_RESET_TYPE type );
RSTC_RESET_CAUSE RSTC_ResetCauseGet(     void );
bool             RSTC_NRSTPinRead(       void );
void             RSTC_CallbackRegister(  RSTC_CALLBACK callback, uintptr_t context );
// *****************************************************************************
// *****************************************************************************
// Section: Local: **** Do Not Use ****
// *****************************************************************************
// *****************************************************************************
void             RSTC_InterruptHandler(  void );

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    }
#endif
// DOM-IGNORE-END

#endif // PLIB_RSTC_H