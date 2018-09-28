/*******************************************************************************
  AFEC Peripheral Library Interface Source File

  Company
    Microchip Technology Inc.

  File Name
    plib_afec1.c

  Summary
    AFEC1 peripheral library source.

  Description
    This file implements the AFEC peripheral library.

*******************************************************************************/

// DOM-IGNORE-BEGIN
/*******************************************************************************
Copyright (c) 2017 released Microchip Technology Inc.  All rights reserved.

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
// DOM-IGNORE-END
#include "device.h"
#include "plib_afec1.h"

#define AFEC_SEQ1_CHANNEL_NUM (8U)

#define AFEC_CGR_GAIN_X1   (0x00U)
#define AFEC_CGR_GAIN_X2   (0x01U)
#define AFEC_CGR_GAIN_x4   (0x03U)


// *****************************************************************************
// *****************************************************************************
// Section: AFEC1 Implementation
// *****************************************************************************
// *****************************************************************************

/* Initialize AFEC peripheral */
void AFEC1_Initialize()
{
    /* Software reset */
    AFEC1_REGS->AFEC_CR = AFEC_CR_SWRST_Msk;

    /* Prescaler and different time settings as per CLOCK section  */
    AFEC1_REGS->AFEC_MR = AFEC_MR_PRESCAL(7U) | AFEC_MR_TRACKTIM(15U) | AFEC_MR_STARTUP_SUT64 |
        AFEC_MR_TRANSFER(2U) | AFEC_MR_ONE_Msk   | (AFEC_MR_TRGEN_Msk) | (AFEC_MR_TRGSEL_AFEC_TRIG1);

    /* resolution and sign mode of result */
    AFEC1_REGS->AFEC_EMR = AFEC_EMR_RES_NO_AVERAGE 
         | AFEC_EMR_SIGNMODE_SE_UNSG_DF_SIGN | AFEC_EMR_TAG_Msk;

    /* Enable gain amplifiers */
    AFEC1_REGS->AFEC_ACR = AFEC_ACR_PGA0EN_Msk | AFEC_ACR_PGA1EN_Msk | AFEC_ACR_IBCTL(0x3U);

    /* Gain */
    AFEC1_REGS->AFEC_CGR = AFEC_CGR_GAIN0(AFEC_CGR_GAIN_X1) | 
		AFEC_CGR_GAIN5(AFEC_CGR_GAIN_X1) | 
		AFEC_CGR_GAIN6(AFEC_CGR_GAIN_X1);

    /* Offset */
    AFEC1_REGS->AFEC_CSELR = AFEC_CH0;
    AFEC1_REGS->AFEC_COCR = 512U;
    /* Offset */
    AFEC1_REGS->AFEC_CSELR = AFEC_CH5;
    AFEC1_REGS->AFEC_COCR = 512U;
    /* Offset */
    AFEC1_REGS->AFEC_CSELR = AFEC_CH6;
    AFEC1_REGS->AFEC_COCR = 512U;



    /* Enable channel */
    AFEC1_REGS->AFEC_CHER = AFEC_CHER_CH0_Msk | AFEC_CHER_CH5_Msk | AFEC_CHER_CH6_Msk;
}

/* Enable AFEC channels */
void AFEC1_ChannelsEnable (AFEC_CHANNEL_MASK channelsMask)
{
    AFEC1_REGS->AFEC_CHER |= channelsMask;
}

/* Disable AFEC channels */
void AFEC1_ChannelsDisable (AFEC_CHANNEL_MASK channelsMask)
{
    AFEC1_REGS->AFEC_CHDR |= channelsMask;
}

/* Enable channel end of conversion interrupt */
void AFEC1_ChannelsInterruptEnable (AFEC_INTERRUPT_MASK channelsInterruptMask)
{
    AFEC1_REGS->AFEC_IER |= channelsInterruptMask;
}

/* Disable channel end of conversion interrupt */
void AFEC1_ChannelsInterruptDisable (AFEC_INTERRUPT_MASK channelsInterruptMask)
{
    AFEC1_REGS->AFEC_IDR |= channelsInterruptMask;
}

/* Start the conversion with software trigger */
void AFEC1_ConversionStart(void)
{
    AFEC1_REGS->AFEC_CR = 0x1U << AFEC_CR_START_Pos;
}

/*Check if conversion result is available */
bool AFEC1_ChannelResultIsReady(AFEC_CHANNEL_NUM channel)
{
    return (AFEC1_REGS->AFEC_ISR>> channel) & 0x1U;
}

/* Read the conversion result */
uint16_t AFEC1_ChannelResultGet(AFEC_CHANNEL_NUM channel)
{
    AFEC1_REGS->AFEC_CSELR = channel;
    return (AFEC1_REGS->AFEC_CDR);
}

/* Configure the user defined conversion sequence */
void AFEC1_ConversionSequenceSet(AFEC_CHANNEL_NUM *channelList, uint8_t numChannel)
{
    uint8_t channelIndex;
    AFEC1_REGS->AFEC_SEQ1R = 0U;
    AFEC1_REGS->AFEC_SEQ2R = 0U;

    for (channelIndex = 0U; channelIndex < AFEC_SEQ1_CHANNEL_NUM; channelIndex++)
    {
        if (channelIndex >= numChannel)
            break;
        AFEC1_REGS->AFEC_SEQ1R |= channelList[channelIndex] << (channelIndex * 4U);
    }
    if (numChannel > AFEC_SEQ1_CHANNEL_NUM)
    {
        for (channelIndex = 0U; channelIndex < (numChannel - AFEC_SEQ1_CHANNEL_NUM); channelIndex++)
        {
            AFEC1_REGS->AFEC_SEQ2R |= channelList[channelIndex + AFEC_SEQ1_CHANNEL_NUM] << (channelIndex * 4U);
        }
    }
}

/* Set the channel gain */
void AFEC1_ChannelGainSet(AFEC_CHANNEL_NUM channel, AFEC_CHANNEL_GAIN gain)
{
    AFEC1_REGS->AFEC_CGR &= ~(0x03U << (2U * channel));
    AFEC1_REGS->AFEC_CGR |= (gain << ( 2U * channel));
}

/* Set the channel offset */
void AFEC1_ChannelOffsetSet(AFEC_CHANNEL_NUM channel, uint16_t offset)
{
    AFEC1_REGS->AFEC_CSELR = channel;
    AFEC1_REGS->AFEC_COCR = offset;
}


