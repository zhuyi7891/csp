/*******************************************************************************
  TC Peripheral Library Interface Source File

  Company
    Microchip Technology Inc.

  File Name
    plib_tc1.c

  Summary
    TC peripheral library source file.

  Description
    This file implements the interface to the TC peripheral library.  This
    library provides access to and control of the associated peripheral
    instance.

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


// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

/*  This section lists the other files that are included in this file.
*/
#include "device.h"
#include "plib_tc1.h"
 

 

 

 

/* Callback object for channel 0 */
TC_COMPARE_CALLBACK_OBJECT TC1_CH0_CallbackObj;

/* Initialize channel in compare mode */
void TC1_CH0_CompareInitialize (void)
{
    /* clock selection and waveform selection */
    TC1_REGS->TC_CHANNEL[0].TC_CMR = TC_CMR_TCCLKS_TIMER_CLOCK2 | TC_CMR_WAVEFORM_WAVSEL_UP_RC | TC_CMR_WAVE_Msk | \
            TC_CMR_WAVEFORM_ACPA_SET | TC_CMR_WAVEFORM_ACPC_CLEAR | TC_CMR_WAVEFORM_AEEVT_CLEAR \
           | TC_CMR_WAVEFORM_BCPB_SET | TC_CMR_WAVEFORM_BCPC_CLEAR | TC_CMR_WAVEFORM_BEEVT_CLEAR ;

    /* external reset event configurations */
    TC1_REGS->TC_CHANNEL[0].TC_CMR |= TC_CMR_WAVEFORM_ENETRG_Msk | TC_CMR_WAVEFORM_EEVT_XC0 | \
                TC_CMR_WAVEFORM_EEVTEDG_NONE;

    /* write period */
    TC1_REGS->TC_CHANNEL[0].TC_RC = 4150U;

    /* write compare values */
    TC1_REGS->TC_CHANNEL[0].TC_RA = 415U;
    TC1_REGS->TC_CHANNEL[0].TC_RB = 345U;

    /* enable interrupt */
    TC1_REGS->TC_CHANNEL[0].TC_IER = TC_IER_CPCS_Msk;
    TC1_CH0_CallbackObj.callback_fn = NULL;
}

/* Start the compare mode */
void TC1_CH0_CompareStart (void)
{
    TC1_REGS->TC_CHANNEL[0].TC_CCR = (TC_CCR_CLKEN_Msk | TC_CCR_SWTRG_Msk);
}

/* Stop the compare mode */
void TC1_CH0_CompareStop (void)
{
    TC1_REGS->TC_CHANNEL[0].TC_CCR = (TC_CCR_CLKDIS_Msk);
}

uint32_t TC1_CH0_CompareFrequencyGet( void )
{
    return (uint32_t)(10375000UL);
}

/* Configure the period value */
void TC1_CH0_ComparePeriodSet (uint32_t period)
{
    TC1_REGS->TC_CHANNEL[0].TC_RC = period;
}

/* Read the period value */
uint32_t TC1_CH0_ComparePeriodGet (void)
{
    return TC1_REGS->TC_CHANNEL[0].TC_RC;
}

/* Set the compare A value */
void TC1_CH0_CompareASet (uint32_t value)
{
    TC1_REGS->TC_CHANNEL[0].TC_RA = value;
}

/* Set the compare B value */
void TC1_CH0_CompareBSet (uint32_t value)
{
    TC1_REGS->TC_CHANNEL[0].TC_RB = value;
}

/* Register callback function */
void TC1_CH0_CompareCallbackRegister(TC_COMPARE_CALLBACK callback, uintptr_t context)
{
    TC1_CH0_CallbackObj.callback_fn = callback;
    TC1_CH0_CallbackObj.context = context;
}

/* Interrupt Handler */
void TC1_CH0_InterruptHandler(void)
{
    TC_COMPARE_STATUS compare_status = (TC_COMPARE_STATUS)(TC1_REGS->TC_CHANNEL[0].TC_SR & TC_COMPARE_STATUS_MSK);
    /* Call registered callback function */
    if ((TC_COMPARE_NONE != compare_status) && TC1_CH0_CallbackObj.callback_fn != NULL)
    {
        TC1_CH0_CallbackObj.callback_fn(compare_status, TC1_CH0_CallbackObj.context);
    }
}
 

 
 


/* Callback object for channel 1 */
TC_TIMER_CALLBACK_OBJECT TC1_CH1_CallbackObj;

/* Initialize channel in timer mode */
void TC1_CH1_TimerInitialize (void)
{
    /* clock selection and waveform selection */
    TC1_REGS->TC_CHANNEL[1].TC_CMR = TC_CMR_TCCLKS_TIMER_CLOCK5 | TC_CMR_WAVEFORM_WAVSEL_UP_RC | \
                                                        TC_CMR_WAVE_Msk ;

    /* write period */
    TC1_REGS->TC_CHANNEL[1].TC_RC = 32U;


    /* enable interrupt */
    TC1_REGS->TC_CHANNEL[1].TC_IER = TC_IER_CPCS_Msk;
    TC1_CH1_CallbackObj.callback_fn = NULL;
}

/* Start the timer */
void TC1_CH1_TimerStart (void)
{
    TC1_REGS->TC_CHANNEL[1].TC_CCR = (TC_CCR_CLKEN_Msk | TC_CCR_SWTRG_Msk);
}

/* Stop the timer */
void TC1_CH1_TimerStop (void)
{
    TC1_REGS->TC_CHANNEL[1].TC_CCR = (TC_CCR_CLKDIS_Msk);
}

uint32_t TC1_CH1_TimerFrequencyGet( void )
{
    return (uint32_t)(32768UL);
}

/* Configure timer period */
void TC1_CH1_TimerPeriodSet (uint32_t period)
{
    TC1_REGS->TC_CHANNEL[1].TC_RC = period;
}


/* Read timer period */
uint32_t TC1_CH1_TimerPeriodGet (void)
{
    return TC1_REGS->TC_CHANNEL[1].TC_RC;
}

/* Read timer counter value */
uint32_t TC1_CH1_TimerCounterGet (void)
{
    return TC1_REGS->TC_CHANNEL[1].TC_CV;
}

/* Register callback for period interrupt */
void TC1_CH1_TimerCallbackRegister(TC_TIMER_CALLBACK callback, uintptr_t context)
{
    TC1_CH1_CallbackObj.callback_fn = callback;
    TC1_CH1_CallbackObj.context = context;
}

void TC1_CH1_InterruptHandler(void)
{
    TC_TIMER_STATUS timer_status = (TC_TIMER_STATUS)(TC1_REGS->TC_CHANNEL[1].TC_SR & TC_TIMER_STATUS_MSK);
    /* Call registered callback function */
    if ((TC_TIMER_NONE != timer_status) && TC1_CH1_CallbackObj.callback_fn != NULL)
    {
        TC1_CH1_CallbackObj.callback_fn(timer_status, TC1_CH1_CallbackObj.context);
    }
}

 

 

 

 
 

 

/* Interrupt handler for TC1 */
void TC1_InterruptHandler(void)
{
	TC1_CH0_InterruptHandler();

	TC1_CH1_InterruptHandler();
}
 
 
/**
 End of File
*/
