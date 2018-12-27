/*******************************************************************************
  DMAC Peripheral Library Interface Header File

  Company:
    Microchip Technology Inc.

  File Name:
    plib_${DMA_INSTANCE_NAME?lower_case}.h

  Summary:
    DMAC peripheral library interface.

  Description:
    This file defines the interface to the DMAC peripheral library. This
    library provides access to and control of the DMAC controller.

  Remarks:
    None.

*******************************************************************************/

// DOM-IGNORE-BEGIN
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
// DOM-IGNORE-END

#ifndef PLIB_${DMA_INSTANCE_NAME}_H    // Guards against multiple inclusion
#define PLIB_${DMA_INSTANCE_NAME}_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

/*  This section lists the other files that are included in this file.
*/
#include <device.h>
#include <string.h>
#include <stdbool.h>
#include <sys/kmem.h>

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************
// *****************************************************************************
typedef uint32_t DMA_CHANNEL_CONFIG;

typedef uintptr_t DMA_CHANNEL_HANDLE;

// *****************************************************************************
// *****************************************************************************
// Section: type definitions
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
/* DMA error type

  Summary:
    Identifies the available DMA operating modes.

  Description:
    This data type Identifies if a transfer had an address error or not.


  Remarks:
    The identification of an error transaction takes place in the DMA ISR.
*/
typedef enum
{
    /* Data was transferred successfully. */
    DMA_ERROR_NONE /*DOM-IGNORE-BEGIN*/ = 1, /* DOM-IGNORE-END*/

    /* DMA address error. */
    DMA_ERROR_ADDRESS_ERROR /*DOM-IGNORE-BEGIN*/ = 2 /* DOM-IGNORE-END*/

} DMA_ERROR;

// *****************************************************************************
/* DMA transfer event

  Summary:
    Identifies the status of the transfer event.

  Description:
    Used to report back, via registered callback, the status of a transaction.

  Remarks:
    None
*/
typedef enum
{
    /* Data was transferred successfully. */
    DMA_TRANSFER_EVENT_COMPLETE,

    /* Error while processing the request */
    DMA_TRANSFER_EVENT_ERROR,

    /* Data transfer was aborted. */
    DMA_TRANSFER_EVENT_ABORT,
            
    /* No events yet. */
    DMA_TRANSFER_EVENT_NONE

} DMA_TRANSFER_EVENT;

typedef void (*DMA_CHANNEL_CALLBACK) (DMA_TRANSFER_EVENT status,
        uintptr_t contextHandle);

// *****************************************************************************
/* DMA channel object

  Summary:
    Fundamental data object for a DMA channel.

  Description:
    Used by DMA logic to register/use a DMA callback, report back error information
    from the ISR handling a transfer event.

  Remarks:
    None
*/
typedef struct
{
    bool inUse;

    /* Inidcates the error information for
       the last DMA operation on this channel */
    DMA_ERROR errorInfo;
    
    /* Call back function for this DMA channel */
    DMA_CHANNEL_CALLBACK  pEventCallBack;

    /* Client data(Event Context) that will be returned at callback */
    uintptr_t hClientArg;

} DMA_CHANNEL_OBJECT;

// *****************************************************************************
/* DMA channel

  Summary:
    Fundamental data object that represents DMA channel number.

  Description:
    None

  Remarks:
    None
*/
typedef enum {
<#list 0..NUM_DMA_CHANS-1 as i>
<#assign CHAN = "DMA_"+i+"_CHANNEL_NUMBER">
    DMA_CHANNEL_${i} = 0x${.vars[CHAN]},
</#list>
    DMA_NUMBER_OF_CHANNELS = 0x${NUM_DMA_CHANS}
} DMA_CHANNEL;



// *****************************************************************************
// *****************************************************************************
// Section: DMAC API
// *****************************************************************************
// *****************************************************************************
// *****************************************************************************
/* Function:
   void ${DMA_INSTANCE_NAME}_ChannelCallbackRegister

  Summary:
    Callback function registration function

  Description:
    Registers the callback function (and context pointer, if used) for a given DMA interrupt.

  Parameters:
    DMA_CHANNEL channel - DMA channel this callback pertains to
    const DMA_CHANNEL_TRANSFER_EVENT_HANDLER eventHandler - pointer to callback function
    const uintptr_t contextHandle - pointer of context information callback is to use (set to NULL if not used)

  Returns:
    void
    
  Example:
    <code>
    ${DMA_INSTANCE_NAME}_ChannelCallbackRegister(DMA_CHANNEL_0, DMA_Callback, 0);
    </code>
*/
void ${DMA_INSTANCE_NAME}_ChannelCallbackRegister(DMA_CHANNEL channel, const DMA_CHANNEL_CALLBACK eventHandler, const uintptr_t contextHandle );

// *****************************************************************************
/* Function:
   bool ${DMA_INSTANCE_NAME}_ChannelTransfer

  Summary:
    DMA channel transfer function

  Description:
    Sets up a DMA transfer, and starts the transfer if user specified a 
    software-initiated transfer in Harmony.

  Parameters:
    DMA_CHANNEL channel - DMA channel to use for this transfer
    const void *srcAddr - pointer to source data
    const void *destAddr - pointer to where data is to be moved to
    size_t blockSize - the transfer size to use

  Returns:
    false, if DMA already is busy / true, if DMA is not busy before calling function
    
  Example:
    <code>
    ${DMA_INSTANCE_NAME}_ChannelCallbackRegister(DMA_CHANNEL_0, DMA_Callback, 0);
    ${DMA_INSTANCE_NAME}_ChannelTransfer(DMA_CHANNEL_0,source, destination, TRANSFER_SIZE );
    </code>
*/
bool ${DMA_INSTANCE_NAME}_ChannelTransfer( DMA_CHANNEL channel, const void *srcAddr, const void *destAddr, size_t blockSize);

// *****************************************************************************
/* Function:
   void ${DMA_INSTANCE_NAME}_ChannelDisable (DMA_CHANNEL channel)

  Summary:
    This function disables the DMA channel.

  Description:
    Disables the DMA channel specified.

  Parameters:
    DMA_CHANNEL channel - the particular channel to be disabled

  Returns:
    void
    
  Example:
    <code>
    ${DMA_INSTANCE_NAME}_ChannelDisable (DMA_CHANNEL_0);
    </code>
*/
void ${DMA_INSTANCE_NAME}_ChannelDisable (DMA_CHANNEL channel);

// *****************************************************************************
/* Function:
   bool ${DMA_INSTANCE_NAME}_ChannelIsBusy (DMA_CHANNEL channel)

  Summary:
    Reads the busy status of a channel.

  Description:
    Reads the busy status of a channel and returns status to caller.

  Parameters:
    DMA_CHANNEL channel - the particular channel to be interrogated

  Returns:
    true - channel is busy
    false - channel is not busy
    
  Example:
    <code>
    bool returnVal;
    returnVal = ${DMA_INSTANCE_NAME}_ChannelIsBusy(DMA_CHANNEL_0);
    while( returnVal )
        ;
    </code>
*/
bool ${DMA_INSTANCE_NAME}_ChannelIsBusy (DMA_CHANNEL channel);

// *****************************************************************************
/* Function:
   void ${DMA_INSTANCE_NAME}_ChannelBlockLengthSet (DMA_CHANNEL channel, uint16_t length)

  Summary:
    Sets the size of data to send.

  Description:
    Sets the chunk size for the indicated DMA channel.

  Parameters:
    DMA_CHANNEL channel - the particular channel to be set
    uint16_t length - new size of data to send out

  Returns:
    void
    
  Example:
    <code>
    ${DMA_INSTANCE_NAME}_ChannelBlockLengthSet(DMA_CHANNEL_0, 100);
    </code>
*/
void ${DMA_INSTANCE_NAME}_ChannelBlockLengthSet (DMA_CHANNEL channel, uint16_t length);

// *****************************************************************************
/* Function:
   bool ${DMA_INSTANCE_NAME}_ChannelSettingsSet (DMA_CHANNEL channel, uint32_t setting)

  Summary:
    DMA channel settings set function.

  Description:
    Sets the indicated DMA channel with user-specified settings.  Overwrites 
    DCHxCON register with new settings.

  Parameters:
    DMA_CHANNEL channel - the particular channel to be set
    uint16_t setting - new settins for channel

  Returns:
    true
    
  Example:
    <code>
    DMA_CHANNEL_CONFIG chanSettings;
    chanSettings = ${DMA_INSTANCE_NAME}_ChannelSettingsGet(DMA_CHANNEL_3);
    chanSettings &= ~0x20;
    (void)${DMA_INSTANCE_NAME}_ChannelSettingsGet(DMA_CHANNEL_3, chanSettings);
    </code>
*/
bool ${DMA_INSTANCE_NAME}_ChannelSettingsSet (DMA_CHANNEL channel, uint32_t setting);

// *****************************************************************************
/* Function:
   DMA_CHANNEL_CONFIG ${DMA_INSTANCE_NAME}_ChannelSettingsGet (DMA_CHANNEL channel)

  Summary:
    DMA channel settings get function.

  Description:
    Gets the indicated DMA channel settings in DCHxCON register and returns value
    to user.

  Parameters:
    DMA_CHANNEL channel - the particular channel to be set

  Returns:
    DMA_CHANNEL_CONFIG - DCHxCON value
    0 - user error condition where channel was specified out-of-bounds
    
  Example:
    <code>
    DMA_CHANNEL_CONFIG chanSettings;
    chanSettings = ${DMA_INSTANCE_NAME}_ChannelSettingsGet(DMA_CHANNEL_3);
    chanSettings &= ~0x20;
    (void)${DMA_INSTANCE_NAME}_ChannelSettingsGet(DMA_CHANNEL_3, chanSettings);
    </code>
*/
DMA_CHANNEL_CONFIG ${DMA_INSTANCE_NAME}_ChannelSettingsGet (DMA_CHANNEL channel);

// *****************************************************************************
/* Function:
   void ${DMA_INSTANCE_NAME}_Initialize( void )

  Summary:
    This function initializes the DMAC controller of the device.

  Description:
    Sets up a DMA controller for subsequent transfer activity.

  Parameters:
    none

  Returns:
    void
    
  Example:
    <code>
    ${DMA_INSTANCE_NAME}_Initialize();
    </code>
*/
void ${DMA_INSTANCE_NAME}_Initialize( void );

<#list 0..NUM_DMA_CHANS-1 as i>
<#assign ENABLE = "DMA_"+i+"_INTERRUPT_ENABLE">
<#assign CHANENABLE = "DMAC_CHAN"+i+"_ENBL">
<#if .vars[ENABLE]?c == "true">
<#if .vars[CHANENABLE]?c == "true">
<#assign DMATASKNAME = "DMA"+i+"_Tasks">
// *****************************************************************************
/* Function:
   void ${DMATASKNAME} (void)

  Summary:
    Interrupt handler for interrupts from DMA${i}.

  Description:
    None

  Parameters:
    none

  Returns:
    void
*/
void ${DMATASKNAME} (void);
</#if>  <#-- .vars[CHANENABLE]?c == "true" -->
</#if>  <#-- .vars[ENABLE]?c == "true" -->
</#list>

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END

#endif //PLIB_${DMA_INSTANCE_NAME}_H