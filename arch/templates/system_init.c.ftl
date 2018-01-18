/*******************************************************************************
  System Initialization File

  File Name:
    system_init.c

  Summary:
    This file contains source code necessary to initialize the system.

  Description:
    This file contains source code necessary to initialize the system.  It
    implements the "SYS_Initialize" function, defines the configuration bits,
    and allocates any necessary global system resources,
 *******************************************************************************/

// DOM-IGNORE-BEGIN
/*******************************************************************************
Copyright (c) 2013-2015 released Microchip Technology Inc.  All rights reserved.

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
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include "system_config.h"
#include "system_definitions.h"


// ****************************************************************************
// ****************************************************************************
// Section: Configuration Bits
// ****************************************************************************
// ****************************************************************************
${LIST_SYSTEM_INIT_C_CONFIG_BITS_INITIALIZATION}

// *****************************************************************************
// *****************************************************************************
// Section: Driver Initialization Data
// *****************************************************************************
// *****************************************************************************
${LIST_SYSTEM_INIT_C_DRIVER_INITIALIZATION_DATA}

// *****************************************************************************
// *****************************************************************************
// Section: System Data
// *****************************************************************************
// *****************************************************************************
<#if CoreGenAppFiles == true >
/* Structure to hold the object handles for the modules in the system. */
SYSTEM_OBJECTS sysObj;
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: Module Initialization Data
// *****************************************************************************
// *****************************************************************************
${LIST_SYSTEM_INIT_C_MODULE_INITIALIZATION_DATA}

// *****************************************************************************
// *****************************************************************************
// Section: Library/Stack Initialization Data
// *****************************************************************************
// *****************************************************************************
${LIST_SYSTEM_INIT_C_LIBRARY_INITIALIZATION_DATA}

// *****************************************************************************
// *****************************************************************************
// Section: System Initialization
// *****************************************************************************
// *****************************************************************************
${LIST_SYSTEM_INIT_C_SYSTEM_INITIALIZATION}

/*******************************************************************************
  Function:
    void SYS_Initialize ( void *data )

  Summary:
    Initializes the board, services, drivers, application and other modules.

  Remarks:
 */

void SYS_Initialize ( void* data )
{
	<#if wdtDISABLE == true>
		<#lt>	/*Disable Watchdog Timer*/
		<#lt>	WDT->WDT_MR |= WDT_MR_WDDIS_Msk;
	</#if>
	
	<#if rswdtDISABLE == true>
		<#lt>	/*Disable Reinforced Safety Watchdog Timer*/
		<#lt>	RSWDT->RSWDT_MR |= RSWDT_MR_WDDIS_Msk;
	</#if>
	<#lt>${LIST_SYSTEM_INIT_C_SYS_INITIALIZE_DATA}
	<#lt>${LIST_SYSTEM_INIT_C_SYS_INITIALIZE_CORE}
	<#lt>${LIST_SYSTEM_INIT_C_SYS_INITIALIZE_DEPENDENT_DRIVERS}
	<#lt>${LIST_SYSTEM_INIT_C_SYS_INITIALIZE_DRIVERS}
	<#lt>${LIST_SYSTEM_INIT_C_INITIALIZE_SYSTEM_SERVICES}
	<#lt>${LIST_SYSTEM_INIT_C_INITIALIZE_MIDDLEWARE}

	<#lt><#if CoreGenAppFiles == true >
			<#lt>	APP_Initialize();
	<#lt></#if>
}


/*******************************************************************************
 End of File
*/

