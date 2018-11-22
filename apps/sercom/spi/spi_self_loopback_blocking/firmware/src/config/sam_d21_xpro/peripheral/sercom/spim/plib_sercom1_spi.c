/*******************************************************************************
  SERIAL COMMUNICATION SERIAL PERIPHERAL INTERFACE(SERCOM1_SPI) PLIB

  Company
    Microchip Technology Inc.

  File Name
    plib_sercom1_spi.c

  Summary
    SERCOM1_SPI PLIB Implementation File.

  Description
    This file defines the interface to the SERCOM SPI peripheral library.
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

#include "plib_sercom1_spi.h"
#include "device.h"

// *****************************************************************************
// *****************************************************************************
// Section: MACROS Definitions
// *****************************************************************************
// *****************************************************************************
/* Sercom clk freq value for the baud calculation */
#define SERCOM1_Frequency      (uint32_t) (8000000UL)


// *****************************************************************************
// *****************************************************************************
// Section: SERCOM1_SPI Implementation
// *****************************************************************************
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
/* Function:
    void SERCOM1_SPI_Initialize(void);

  Summary:
    Initializes instance SERCOM1 of the SERCOM module operating in SPI mode.

  Description:
    This function initializes instance SERCOM1 of SERCOM module operating in SPI mode.
    This function should be called before any other library function. The SERCOM
    module will be configured as per the MHC settings.

  Remarks:
    Refer plib_sercom1_spi.h file for more information.
*/

void SERCOM1_SPI_Initialize(void)
{

    /* Selection of the Character Size and Receiver Enable */
    SERCOM1_REGS->SPIM.SERCOM_CTRLB = SERCOM_SPIM_CTRLB_CHSIZE_8_BIT | SERCOM_SPIM_CTRLB_RXEN_Msk ;

    /* Wait for synchronization */
    while(SERCOM1_REGS->SPIM.SERCOM_SYNCBUSY);

    /* Selection of the Baud Value */
    SERCOM1_REGS->SPIM.SERCOM_BAUD = 3;

    /* Configure Data Out Pin Out , Master Mode,
     * Data In and Pin Out,Data Order and Standby mode if configured
     * and Selection of the Clock Phase and Polarity and Enable the SPI Module
     */
    SERCOM1_REGS->SPIM.SERCOM_CTRLA = SERCOM_SPIM_CTRLA_MODE_SPI_MASTER | SERCOM_SPIM_CTRLA_DOPO_PAD1 | SERCOM_SPIM_CTRLA_DIPO_PAD0 | SERCOM_SPIM_CTRLA_CPOL_IDLE_LOW | SERCOM_SPIM_CTRLA_CPHA_LEADING_EDGE | SERCOM_SPIM_CTRLA_DORD_MSB | SERCOM_SPIM_CTRLA_ENABLE_Msk ;

    /* Wait for synchronization */
    while(SERCOM1_REGS->SPIM.SERCOM_SYNCBUSY);
}

// *****************************************************************************
/* Function:
    bool SERCOM1_SPI_TransferSetup(SPI_TRANSFER_SETUP *setup,
                                                uint32_t spiSourceClock);

 Summary:
    Configure SERCOM SPI operational parameters at run time.

  Description:
    This function allows the application to change the SERCOM SPI operational
    parameter at run time. The application can thus override the MHC defined
    configuration for these parameters. The parameter are specified via the
    SPI_TRANSFER_SETUP type setup parameter. Each member of this parameter
    should be initialized to the desired value.

    The application may feel need to call this function in situation where
    multiple SPI slaves, each with different operation parameters, are connected
    to one SPI master. This function can thus be used to setup the SPI Master to
    meet the communication needs of the slave.

    Calling this function will affect any ongoing communication. The application
    must thus ensure that there is no on-going communication on the SPI before
    calling this function.

  Remarks:
    Refer plib_sercom1_spi.h file for more information.
*/

bool SERCOM1_SPI_TransferSetup(SPI_TRANSFER_SETUP *setup, uint32_t spiSourceClock)
{
    uint32_t baudValue = 0;

    bool statusValue = false;

    if(spiSourceClock == 0)
    {
        /* Fetch Master Clock Frequency directly */
        spiSourceClock = SERCOM1_Frequency;
    }

    /* Disable the SPI Module */
    SERCOM1_REGS->SPIM.SERCOM_CTRLA &= ~(SERCOM_SPIM_CTRLA_ENABLE_Msk);

    /* Wait for synchronization */
    while(SERCOM1_REGS->SPIM.SERCOM_SYNCBUSY);

    if(setup != NULL)
    {
        baudValue = (spiSourceClock/(2*(setup->clockFrequency))) - 1;

        if((baudValue > 0) & (baudValue <= 255))
        {
            /* Selection of the Clock Polarity and Clock Phase */
            SERCOM1_REGS->SPIM.SERCOM_CTRLA |= setup->clockPolarity | setup->clockPhase;

            /* Selection of the Baud Value */
            SERCOM1_REGS->SPIM.SERCOM_BAUD = baudValue;

            /* Selection of the Character Size */
            SERCOM1_REGS->SPIM.SERCOM_CTRLB |= setup->dataBits;

            /* Wait for synchronization */
            while(SERCOM1_REGS->SPIM.SERCOM_SYNCBUSY);

            statusValue = true;
        }
    }

    /* Enabling the SPI Module */
    SERCOM1_REGS->SPIM.SERCOM_CTRLA |= SERCOM_SPIM_CTRLA_ENABLE_Msk;

    /* Wait for synchronization */
    while(SERCOM1_REGS->SPIM.SERCOM_SYNCBUSY);

    return statusValue;
}



// *****************************************************************************
/* Function:
    bool SERCOM1_SPI_WriteRead (void* pTransmitData, size_t txSize
                                        void* pReceiveData, size_t rxSize);

  Summary:
    Write and Read data on SERCOM SERCOM1 SPI peripheral.

  Description:
    This function transmits "txSize" number of bytes and receives "rxSize"
    number of bytes on SERCOM SERCOM1 SPI module. Data pointed by pTransmitData is
    transmitted and received data is saved in the location pointed by
    pReceiveData. The function will transfer the maximum of "txSize" or "rxSize"
    data units towards completion.

    When "Interrupt Mode" option is unchecked in MHC, this function will be
    blocking in nature.  In this mode, the function will not return until all
    the requested data is transferred.  The function returns true after
    transferring all the data.  This indicates that the operation has been
    completed.

    When "Interrupt Mode" option is selected in MHC, the function will be
    non-blocking in nature.  The function returns immediately. The data transfer
    process continues in the peripheral interrupt.  The application specified
    transmit and receive buffer  are ownerd by the library until the data
    transfer is complete and should not be modified by the application till the
    transfer is complete.  Only one transfer is allowed at any time. The
    Application can use a callback function or a polling function to check for
    completion of the transfer. If a callback is required, this should be
    registered prior to calling the SERCOM1_SPI_WriteRead() function. The
    application can use the SERCOM1_SPI_IsBusy() to poll for completion.

  Remarks:
    Refer plib_sercom1_spi.h file for more information.
*/

bool SERCOM1_SPI_WriteRead (void* pTransmitData, size_t txSize, void* pReceiveData, size_t rxSize)
{
    size_t txCount = 0;
    size_t rxCount = 0;
    size_t dummySize = 0;
    size_t receivedData;
    uint32_t dataBits;
    bool isSuccess = false;

    /* Verify the request */
    if(((txSize > 0) && (pTransmitData != NULL)) || ((rxSize > 0) && (pReceiveData != NULL)))
    {
        dataBits = SERCOM1_REGS->SPIM.SERCOM_CTRLB & SERCOM_SPIM_CTRLB_CHSIZE_Msk;

        if(dataBits != SPI_DATA_BITS_8)
        {
            /* For 9-bit transmission, the txSize and rxSize must be an even number. */
            if(((txSize > 0) && (txSize & 0x01)) || ((rxSize > 0) && (rxSize & 0x01)))
            {
                return isSuccess;
            }
        }

        if(pTransmitData == NULL)
        {
            txSize = 0;
        }

        if(pReceiveData == NULL)
        {
            rxSize = 0;
        }

        /* Flush out any unread data in SPI DATA Register from the previous transfer */
        receivedData = SERCOM1_REGS->SPIM.SERCOM_DATA;

        if(rxSize > txSize)
        {
            dummySize = rxSize - txSize;
        }

        if(dataBits != SPI_DATA_BITS_8)
        {
            rxSize >>= 1;
            txSize >>= 1;
            dummySize >>= 1;
        }

        /* Make sure DRE is empty */
        while((SERCOM1_REGS->SPIM.SERCOM_INTFLAG & SERCOM_SPIM_INTFLAG_DRE_Msk) != SERCOM_SPIM_INTFLAG_DRE_Msk);

        while((txCount != txSize) || (dummySize != 0))
        {
            if(txCount != txSize)
            {
                if(dataBits == SPI_DATA_BITS_8)
                {
                    SERCOM1_REGS->SPIM.SERCOM_DATA = ((uint8_t*)pTransmitData)[txCount++];
                }
                else
                {
                    SERCOM1_REGS->SPIM.SERCOM_DATA = ((uint16_t*)pTransmitData)[txCount++] & SERCOM_SPIM_DATA_Msk;
                }
            }
            else if(dummySize > 0)
            {
                if(dataBits == SPI_DATA_BITS_8)
                {
                    SERCOM1_REGS->SPIM.SERCOM_DATA = 0xFF;
                }
                else
                {
                    SERCOM1_REGS->SPIM.SERCOM_DATA = 0xFFFF & SERCOM_SPIM_DATA_Msk;
                }

                dummySize--;
            }

            if(rxSize == 0)
            {
                /* For transmit only request, wait for DRE to become empty */
                while((SERCOM1_REGS->SPIM.SERCOM_INTFLAG & SERCOM_SPIM_INTFLAG_DRE_Msk) != SERCOM_SPIM_INTFLAG_DRE_Msk);

            }
            else
            {
                while((SERCOM1_REGS->SPIM.SERCOM_INTFLAG & SERCOM_SPIM_INTFLAG_RXC_Msk) != SERCOM_SPIM_INTFLAG_RXC_Msk)
                {
                    /* If data is read, wait for the Receiver Data Register to become full */
                }

                receivedData = SERCOM1_REGS->SPIM.SERCOM_DATA;

                if(rxCount < rxSize)
                {
                    if(dataBits == SPI_DATA_BITS_8)
                    {
                        ((uint8_t*)pReceiveData)[rxCount++] = receivedData;
                    }
                    else
                    {
                        ((uint16_t*)pReceiveData)[rxCount++] = receivedData & SERCOM_SPIM_DATA_Msk;
                    }
                }
            }
        }

        while((SERCOM1_REGS->SPIM.SERCOM_INTFLAG & SERCOM_SPIM_INTFLAG_TXC_Msk) != SERCOM_SPIM_INTFLAG_TXC_Msk)
        {
            /* Make sure no data is pending in the shift register */
        }

        isSuccess = true;
    }

    return isSuccess;
}
