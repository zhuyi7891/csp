/*******************************************************************************
  ${FLEXCOM_INSTANCE_NAME} SPI PLIB

  Company:
    Microchip Technology Inc.

  File Name:
    plib_${FLEXCOM_INSTANCE_NAME?lower_case}_spi.h

  Summary:
   ${FLEXCOM_INSTANCE_NAME} SPI PLIB Header File.

  Description
    This file defines the interface to the FLEXCOM SPI peripheral library.
    This library provides access to and control of the associated
    peripheral instance.

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

#ifndef PLIB_${FLEXCOM_INSTANCE_NAME}_SPI_H // Guards against multiple inclusion
#define PLIB_${FLEXCOM_INSTANCE_NAME}_SPI_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
/* This section lists the other files that are included in this file.
*/

#include "device.h"
#include "plib_flexcom_spi_local.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus // Provide C++ Compatibility

extern "C" {

#endif

// DOM-IGNORE-END

/****************************** ${FLEXCOM_INSTANCE_NAME} SPI Interface *********************************/

void ${FLEXCOM_INSTANCE_NAME}_SPI_Initialize( void );
bool ${FLEXCOM_INSTANCE_NAME}_SPI_WriteRead( void * pTransmitData, size_t txSize, void * pReceiveData, size_t rxSize );
bool ${FLEXCOM_INSTANCE_NAME}_SPI_Write( void * pTransmitData, size_t txSize );
bool ${FLEXCOM_INSTANCE_NAME}_SPI_Read( void * pReceiveData, size_t rxSize );
bool ${FLEXCOM_INSTANCE_NAME}_SPI_TransferSetup( FLEXCOM_SPI_TRANSFER_SETUP * setup, uint32_t spiSourceClock );
<#if SPI_INTERRUPT_MODE == true>
bool ${FLEXCOM_INSTANCE_NAME}_SPI_IsBusy( void );
void ${FLEXCOM_INSTANCE_NAME}_SPI_CallbackRegister( FLEXCOM_SPI_CALLBACK callback, uintptr_t context );
</#if>

<#if (USE_SPI_TX_DMA )>
void ${FLEXCOM_INSTANCE_NAME}_SPI_DmaTransmitCallbackRegister( FLEXCOM_SPI_DMA_CALLBACK callback, uintptr_t context );

void ${FLEXCOM_INSTANCE_NAME}_SPI_DMAWrite( void * pTransmitData, size_t txSize );
</#if>

<#if (USE_SPI_RX_DMA )>
void ${FLEXCOM_INSTANCE_NAME}_SPI_DmaReceiveCallbackRegister( FLEXCOM_SPI_DMA_CALLBACK callback, uintptr_t context );

void ${FLEXCOM_INSTANCE_NAME}_SPI_DMARead( void * pReceiveData, size_t rxSize );
</#if>
<#if (USE_SPI_TX_DMA || USE_SPI_RX_DMA)>
void ${FLEXCOM_INSTANCE_NAME}_SPI_DMAWriteRead( void * pTransmitData, size_t txSize, void * pReceiveData, size_t rxSize );
</#if>
/* Provide C++ Compatibility */
#ifdef __cplusplus

    }

#endif

#endif // PLIB_${FLEXCOM_INSTANCE_NAME}_SPI_H

/*******************************************************************************
 End of File
*/
