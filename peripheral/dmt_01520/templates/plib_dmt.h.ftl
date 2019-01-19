/*******************************************************************************
  Real Time Counter (${DMT_INSTANCE_NAME}) PLIB

  Company:
    Microchip Technology Inc.

  File Name:
    plib_${DMT_INSTANCE_NAME?lower_case}.h

  Summary:
    ${DMT_INSTANCE_NAME} PLIB Header file

  Description:
    This file defines the interface to the RTC peripheral library. This
    library provides access to and control of the associated peripheral
    instance.

*******************************************************************************/
// DOM-IGNORE-BEGIN
/*******************************************************************************
* Copyright (C) 2019 Microchip Technology Inc. and its subsidiaries.
*
* Subject to your compliance with these terms, you may use Microchip software
* and any derivatives exclusively with Microchip products. It is your
* responsibility to comply with third party license terms applicable to your
* use of third party software (including open source software) that may
* accompany Microchip software.
*
* THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
* EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
* WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
* PARTICULAR PURPOSE.
*
* IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
* INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
* WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
* BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
* FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
* ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
* THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
*******************************************************************************/
// DOM-IGNORE-END

#ifndef PLIB_${DMT_INSTANCE_NAME}_H
#define PLIB_${DMT_INSTANCE_NAME}_H

#include <stddef.h>
#include <stdbool.h>
#include <stdint.h>
#include "device.h"



// DOM-IGNORE-BEGIN
#ifdef __cplusplus // Provide C++ Compatibility
extern "C" {
#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: type definitions
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
// *****************************************************************************
// Section: Interface Routines
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
/* Function:
   void ${DMT_INSTANCE_NAME}_Clear ( void )

  Summary:
    Clears DMT counter.

  Description:
    This function clears the DMT counter by writing specific numbers to DMT 
    registers in the proper order.

  Parameters:
    none

  Example:
    <code>
    ${DMT_INSTANCE_NAME}_Clear()
    </code>
    
  Returns:
    void
*/
void ${DMT_INSTANCE_NAME}_Clear ( void );

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
}
#endif
// DOM-IGNORE-END

#endif /* PLIB_${DMT_INSTANCE_NAME}_H */