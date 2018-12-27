/*******************************************************************************
  Comparator (CMP) Peripheral Library Interface Header File

  Company:
    Microchip Technology Inc.

  File Name:
    plib_${CMP_INSTANCE_NAME?lower_case}.h

  Summary:
    CMP PLIB Header File

  Description:
    None

*******************************************************************************/

/*******************************************************************************
* Copyright (C) 2018 Microchip Technology Inc. and its subsidiaries.
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

#ifndef _PLIB_${CMP_INSTANCE_NAME}_H
#define _PLIB_${CMP_INSTANCE_NAME}_H

#include <stddef.h>
#include <stdbool.h>
#include <stdint.h>
#include "device.h"
#include "plib_cmp_common.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    extern "C" {
#endif
// DOM-IGNORE-END


// *****************************************************************************
// Section: Interface
// *****************************************************************************
// *****************************************************************************

/*************************** ${CMP_INSTANCE_NAME} API ******************************************/
// *****************************************************************************
/* Function:
   void ${CMP_INSTANCE_NAME}_Initialize (void)

  Summary:
    Initialization function for both CMP1 & CMP2 channels of the CMP peripheral

  Description:
    This function initializes the CMP peripheral with user input from the 
	configurator.

  Parameters:
    none

  Returns:
    void
*/

void ${CMP_INSTANCE_NAME}_Initialize (void);

// *****************************************************************************
/* Function:
   void ${CMP_INSTANCE_NAME}_1_CompareEnable (void)

  Summary:
    Enable function of the CMP1 Channel

  Description:
    This function enables the CMP1 Channel 

  Parameters:
    none

  Returns:
    void
*/

void ${CMP_INSTANCE_NAME}_1_CompareEnable (void);

// *****************************************************************************
/* Function:
   void ${CMP_INSTANCE_NAME}_1_CompareDisable (void)

  Summary:
    Disable function of the CMP1 Channel

  Description:
    This function disables the CMP1 Channel

  Parameters:
    none

  Returns:
    void
*/

void ${CMP_INSTANCE_NAME}_1_CompareDisable (void);

// *****************************************************************************
/* Function:
   void ${CMP_INSTANCE_NAME}_2_CompareEnable (void)

  Summary:
    Enable function of the CMP2 Channel

  Description:
    This function enables the CMP2 Channel

  Parameters:
    none

  Returns:
    void
*/

void ${CMP_INSTANCE_NAME}_2_CompareEnable (void);

// *****************************************************************************
/* Function:
   void ${CMP_INSTANCE_NAME}_2_CompareDisable (void)

  Summary:
    Disable function of the CMP2 Channel

  Description:
    This function disables the CMP2 Channel

  Parameters:
    none

  Returns:
    void
*/

void ${CMP_INSTANCE_NAME}_2_CompareDisable (void);

// *****************************************************************************
/* Function:
   void ${CMP_INSTANCE_NAME}_StatusGet (CMP_STATUS_SOURCE source)

  Summary:
    CMP Channel status

  Description:
    Returns the current state of requested CMP Channel

  Parameters:
    source	cmp channel

  Returns:
    bool	current value of cmp channel output
*/

bool ${CMP_INSTANCE_NAME}_StatusGet (CMP_STATUS_SOURCE source);

// *****************************************************************************
/* Function:
  void COMPARATOR_1_Tasks( void )

  Summary:
    Is run when interrupt occurs, or during polling.  Calls the callback function if present.

  Description:
    This function is called when the comparator 1 interrupt occurs.

  Precondition:
    None.

  Parameters:
    None.

  Returns:
    void
*/
void COMPARATOR_1_Tasks(void);

// *****************************************************************************
/* Function:
  void COMPARATOR_2_Tasks( void )

  Summary:
    Is run when interrupt occurs, or during polling.  Calls the callback function if present.

  Description:
    This function is called when the comparator 2 interrupt occurs.

  Precondition:
    None.

  Parameters:
    None.

  Returns:
    void
*/
void COMPARATOR_2_Tasks(void);
<#if CMP1_INTERRUPT_ENABLE?c == "true">

// *****************************************************************************
/* Function:
  void ${CMP_INSTANCE_NAME}_1_CallbackRegister( CMP_CALLBACK callback, uintptr_t context )

  Summary:
    Sets the callback function for a cmp interrupt.

  Description:
    This function sets the callback function that will be called when the CMP
    value is reached.

  Precondition:
    None.

  Parameters:
    *callback   - a pointer to the function to be called when value is reached.
                  Use NULL to Un Register the compare callback

    context     - a pointer to user defined data to be used when the callback
                  function is called. NULL can be passed in if no data needed.

  Returns:
    void
*/

void ${CMP_INSTANCE_NAME}_1_CallbackRegister(CMP_CALLBACK callback, uintptr_t context);
</#if>
<#if CMP2_INTERRUPT_ENABLE?c == "true">

// *****************************************************************************
/* Function:
  void ${CMP_INSTANCE_NAME}_2_CallbackRegister( CMP_CALLBACK callback, uintptr_t context )

  Summary:
    Sets the callback function for a cmp interrupt.

  Description:
    This function sets the callback function that will be called when the CMP
    value is reached.

  Precondition:
    None.

  Parameters:
    *callback   - a pointer to the function to be called when value is reached.
                  Use NULL to Un Register the compare callback

    context     - a pointer to user defined data to be used when the callback
                  function is called. NULL can be passed in if no data needed.

  Returns:
    void
*/

void ${CMP_INSTANCE_NAME}_2_CallbackRegister(CMP_CALLBACK callback, uintptr_t context);
</#if>

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    }
#endif

// DOM-IGNORE-END
#endif // _PLIB_${CMP_INSTANCE_NAME}_H