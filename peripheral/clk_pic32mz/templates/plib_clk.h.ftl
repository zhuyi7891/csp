<#--
/*******************************************************************************
Copyright (c) 2018 released Microchip Technology Inc.  All rights reserved.

Microchip licenses to you the right to use, modify, copy and distribute
Software only when embedded on a Microchip microcontroller or digital signal
controller that is integrated into your product or third party product
(pursuant to the sublicense terms in the accompanying license agreement).

You should refer to the license agreement accompanying this Software for
additional information regarding your rights and obligations.

SOFTWARE AND DOCUMENTATION ARE PROVIDED AS IS WITHOUT WARRANTY OF ANY KIND,
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
 -->

#ifndef PLIB_CLK_H
#define PLIB_CLK_H

#include <stddef.h>
#include <stdbool.h>  

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
 
// *****************************************************************************
// *****************************************************************************
// Section: CLK Module System Interface Routines
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
/* Function:
    void CLK_Initialize ( void )

  Summary:
    Initializes hardware of the System Clock and Peripheral Clock.
    
  Description:
    This function initializes the hardware of System Clock and Peripheral Clocks.

  Precondition:
    None.

  Parameters:
    None.

  Returns:
    None.

  Example:
    <code>
    //Example 1: Do not alter the configuration bit settings
    CLK_Initialize ( );

    </code>

  Remarks:
    None.
*/

void CLK_Initialize ( void );

#ifdef __cplusplus
}
#endif

#endif //PLIB_CLK_H

<#--
/*******************************************************************************
 End of File
*/
-->