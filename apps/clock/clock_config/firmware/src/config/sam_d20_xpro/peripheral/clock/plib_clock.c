/*******************************************************************************
 CLOCK PLIB

  Company:
    Microchip Technology Inc.

  File Name:
    plib_clock.c

  Summary:
    CLOCK PLIB Implementation File.

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

#include "plib_clock.h"
#include "device.h"

static void SYSCTRL_Initialize(void)
{

    /* Configure 8MHz Oscillator */
    /* Configure 8MHz Oscillator */
    SYSCTRL_REGS->SYSCTRL_OSC8M = (SYSCTRL_REGS->SYSCTRL_OSC8M & (SYSCTRL_OSC8M_CALIB_Msk | SYSCTRL_OSC8M_FRANGE_Msk)) | SYSCTRL_OSC8M_ENABLE_Msk | SYSCTRL_OSC8M_PRESC(0x0) ;

    while((SYSCTRL_REGS->SYSCTRL_PCLKSR & SYSCTRL_PCLKSR_OSC8MRDY_Msk) != SYSCTRL_PCLKSR_OSC8MRDY_Msk)
    {
        /* Waiting for the OSC8M Ready state */
    }


    /****************** XOSC32K initialization  ******************************/

    /* Configure 32K External Oscillator */
    SYSCTRL_REGS->SYSCTRL_XOSC32K = SYSCTRL_XOSC32K_STARTUP(0) | SYSCTRL_XOSC32K_ENABLE_Msk | SYSCTRL_XOSC32K_EN32K_Msk | SYSCTRL_XOSC32K_XTALEN_Msk;

    while(!((SYSCTRL_REGS->SYSCTRL_PCLKSR & SYSCTRL_PCLKSR_XOSC32KRDY_Msk) == SYSCTRL_PCLKSR_XOSC32KRDY_Msk))
    {
        /* Waiting for the XOSC32K Ready state */
    }

    SYSCTRL_REGS->SYSCTRL_OSC32K = 0x0;
}

static void DFLL_Initialize(void)
{
    /****************** DFLL Initialization  *********************************/
    SYSCTRL_REGS->SYSCTRL_DFLLCTRL = 0 ;

    while((SYSCTRL_REGS->SYSCTRL_PCLKSR & SYSCTRL_PCLKSR_DFLLRDY_Msk) != SYSCTRL_PCLKSR_DFLLRDY_Msk)
    {
        /* Waiting for the Ready state */
    }

    GCLK_REGS->GCLK_CLKCTRL = GCLK_CLKCTRL_GEN(0x1)  | GCLK_CLKCTRL_CLKEN_Msk | GCLK_CLKCTRL_ID(0);

    SYSCTRL_REGS->SYSCTRL_DFLLMUL = SYSCTRL_DFLLMUL_MUL(1460) | SYSCTRL_DFLLMUL_FSTEP(1) | SYSCTRL_DFLLMUL_CSTEP(1);


    /* Configure DFLL    */
    SYSCTRL_REGS->SYSCTRL_DFLLCTRL = SYSCTRL_DFLLCTRL_ENABLE_Msk | SYSCTRL_DFLLCTRL_MODE_Msk ;

    while((SYSCTRL_REGS->SYSCTRL_PCLKSR & SYSCTRL_PCLKSR_DFLLRDY_Msk) != SYSCTRL_PCLKSR_DFLLRDY_Msk)
    {
        /* Waiting for the Ready state */
    }
}


static void GCLK0_Initialize(void)
{
    GCLK_REGS->GCLK_GENCTRL = GCLK_GENCTRL_SRC(7) | GCLK_GENCTRL_OE_Msk | GCLK_GENCTRL_GENEN_Msk | GCLK_GENCTRL_ID(0);

    GCLK_REGS->GCLK_GENDIV = GCLK_GENDIV_DIV(10) | GCLK_GENDIV_ID(0);
    while((GCLK_REGS->GCLK_STATUS & GCLK_STATUS_SYNCBUSY_Msk) == GCLK_STATUS_SYNCBUSY_Msk)
    {
        /* wait for the Generator 0 synchronization */
    }
}


static void GCLK1_Initialize(void)
{
    GCLK_REGS->GCLK_GENCTRL = GCLK_GENCTRL_SRC(5) | GCLK_GENCTRL_GENEN_Msk | GCLK_GENCTRL_ID(1);

    while((GCLK_REGS->GCLK_STATUS & GCLK_STATUS_SYNCBUSY_Msk) == GCLK_STATUS_SYNCBUSY_Msk)
    {
        /* wait for the Generator 1 synchronization */
    }
}

void CLOCK_Initialize (void)
{
    /* NVM Wait States */
    NVMCTRL_REGS->NVMCTRL_CTRLB |= NVMCTRL_CTRLB_RWS(NVMCTRL_CTRLB_RWS_SINGLE_Val);

    /* Function to Initialize the Oscillators */
    SYSCTRL_Initialize();

    GCLK1_Initialize();
    DFLL_Initialize();
    GCLK0_Initialize();




    /* Configure the AHB Bridge Clocks */
    PM_REGS->PM_AHBMASK = 0x1f;

    /* Configure the APBB Bridge Clocks */
    PM_REGS->PM_APBBMASK = 0x1f;

}