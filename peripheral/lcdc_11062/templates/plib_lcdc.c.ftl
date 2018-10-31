/*******************************************************************************
  LCDC PLIB Implementation

  Company:
    Microchip Technology Inc.

  File Name:
    plib_lcdc.c

  Summary:
    Function implementations for the LCDC (LCD Controller) PLIB.

  Description:
    This PLIB provides the interfaces to configure the LCD Controller (LCDC).
    This peripheral library implements a SUBSET of the register configurations
    for the LCDC. 

*******************************************************************************/

//DOM-IGNORE-BEGIN
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
//DOM-IGNORE-END

#include "definitions.h"

void ${LCDC_INSTANCE_NAME}_SetPixelClockPolarity(${LCDC_INSTANCE_NAME}_SIGNAL_POLARITY polarity)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 & ~${LCDC_INSTANCE_NAME}_LCDCFG0_CLKPOL_Msk) | 
                                ${LCDC_INSTANCE_NAME}_LCDCFG0_CLKPOL(polarity == ${LCDC_INSTANCE_NAME}_POLARITY_NEGATIVE);
}

void ${LCDC_INSTANCE_NAME}_SetClockSourceSelection(${LCDC_INSTANCE_NAME}_CLOCK_SOURCE source)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 & ~${LCDC_INSTANCE_NAME}_LCDCFG0_CLKSEL_Msk) | 
                                ${LCDC_INSTANCE_NAME}_LCDCFG0_CLKSEL(source == ${LCDC_INSTANCE_NAME}_CLOCK_SOURCE_SYSTEM_2X);
}

void ${LCDC_INSTANCE_NAME}_SetPWMClockSourceSelection(${LCDC_INSTANCE_NAME}_PWM_CLOCK_SOURCE source)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 & ~${LCDC_INSTANCE_NAME}_LCDCFG0_CLKPWMSEL_Msk) | 
                                ${LCDC_INSTANCE_NAME}_LCDCFG0_CLKPWMSEL(source == ${LCDC_INSTANCE_NAME}_PWM_SOURCE_SYSTEM);
}

void ${LCDC_INSTANCE_NAME}_SetLayerClockGatingDisable(${LCDC_INSTANCE_NAME}_LAYER_ID layer, bool disable)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 & ~${LCDC_INSTANCE_NAME}_LCDCFG0_CGDISBASE_Msk) | 
                                ${LCDC_INSTANCE_NAME}_LCDCFG0_CGDISBASE(disable == false);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 & ~${LCDC_INSTANCE_NAME}_LCDCFG0_CGDISOVR1_Msk) | 
                                ${LCDC_INSTANCE_NAME}_LCDCFG0_CGDISOVR1(disable == false);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 & ~${LCDC_INSTANCE_NAME}_LCDCFG0_CGDISOVR2_Msk) | 
                                ${LCDC_INSTANCE_NAME}_LCDCFG0_CGDISOVR2(disable == false);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 & ~${LCDC_INSTANCE_NAME}_LCDCFG0_CGDISHEO_Msk) | 
                                ${LCDC_INSTANCE_NAME}_LCDCFG0_CGDISHEO(disable == false);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 & ~${LCDC_INSTANCE_NAME}_LCDCFG0_CGDISPP_Msk) | 
                                ${LCDC_INSTANCE_NAME}_LCDCFG0_CGDISPP(disable == false);
            break;
        default:
            break;
    }
}

void ${LCDC_INSTANCE_NAME}_SetClockDivider(uint8_t value)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG0 & ~${LCDC_INSTANCE_NAME}_LCDCFG0_CLKDIV_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG0_CLKDIV(value - 2);
}

void ${LCDC_INSTANCE_NAME}_SetHSYNCPulseWidth(uint16_t value)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG1 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG1 & ~${LCDC_INSTANCE_NAME}_LCDCFG1_HSPW_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG1_HSPW(value);
}

void ${LCDC_INSTANCE_NAME}_SetVSYNCPulseWidth(uint16_t value)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG1 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG1 & ~${LCDC_INSTANCE_NAME}_LCDCFG1_VSPW_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG1_VSPW(value);
}

void ${LCDC_INSTANCE_NAME}_SetVerticalFrontPorchWidth(uint16_t value)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG2 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG2 & ~${LCDC_INSTANCE_NAME}_LCDCFG2_VFPW_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG2_VFPW(value - 1);
}

void ${LCDC_INSTANCE_NAME}_SetVerticalBackPorchWidth(uint16_t value)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG2 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG2 & ~${LCDC_INSTANCE_NAME}_LCDCFG2_VBPW_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG2_VBPW(value - 1);
}

void ${LCDC_INSTANCE_NAME}_SetHorizontalFrontPorchWidth(uint16_t value)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG3 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG3 & ~${LCDC_INSTANCE_NAME}_LCDCFG3_HFPW_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG3_HFPW(value - 1);
}

void ${LCDC_INSTANCE_NAME}_SetHorizontalBackPorchWidth(uint16_t value)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG4 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG4 & ~${LCDC_INSTANCE_NAME}_LCDCFG3_HBPW_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG3_HBPW(value - 1);
}

void ${LCDC_INSTANCE_NAME}_SetNumActiveRows(uint16_t value)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG4 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG4 & ~${LCDC_INSTANCE_NAME}_LCDCFG4_RPF_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG4_RPF(value - 1);
}

void ${LCDC_INSTANCE_NAME}_SetNumPixelsPerLine(uint16_t value)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG4 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG4 & ~${LCDC_INSTANCE_NAME}_LCDCFG4_PPL_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG4_PPL(value - 1);
}

void ${LCDC_INSTANCE_NAME}_SetHSYNCPolarity(${LCDC_INSTANCE_NAME}_SIGNAL_POLARITY polarity)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 & ~${LCDC_INSTANCE_NAME}_LCDCFG5_HSPOL_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG5_HSPOL(polarity == ${LCDC_INSTANCE_NAME}_POLARITY_NEGATIVE);
}

void ${LCDC_INSTANCE_NAME}_SetVSYNCPolarity(${LCDC_INSTANCE_NAME}_SIGNAL_POLARITY polarity)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 & ~${LCDC_INSTANCE_NAME}_LCDCFG5_VSPOL_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG5_VSPOL(polarity == ${LCDC_INSTANCE_NAME}_POLARITY_NEGATIVE);
}

void ${LCDC_INSTANCE_NAME}_SetVSYNCPulseStart(${LCDC_INSTANCE_NAME}_VSYNC_SYNC_EDGE edge)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 & ~${LCDC_INSTANCE_NAME}_LCDCFG5_VSPDLYS_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG5_VSPDLYS(edge == ${LCDC_INSTANCE_NAME}_SYNC_EDGE_FIRST);
}

void ${LCDC_INSTANCE_NAME}_SetVSYNCPulseEnd(${LCDC_INSTANCE_NAME}_VSYNC_SYNC_EDGE edge)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 & ~${LCDC_INSTANCE_NAME}_LCDCFG5_VSPDLYE_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG5_VSPDLYE(edge == ${LCDC_INSTANCE_NAME}_SYNC_EDGE_FIRST);
}

void ${LCDC_INSTANCE_NAME}_SetDisplaySignalPolarity(${LCDC_INSTANCE_NAME}_SIGNAL_POLARITY polarity)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 & ~${LCDC_INSTANCE_NAME}_LCDCFG5_DISPPOL_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG5_DISPPOL(polarity == ${LCDC_INSTANCE_NAME}_POLARITY_NEGATIVE);
}

void ${LCDC_INSTANCE_NAME}_SetDitheringEnable(bool enable)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 & ~${LCDC_INSTANCE_NAME}_LCDCFG5_DITHER_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG5_DITHER(enable == true);
}

void ${LCDC_INSTANCE_NAME}_SetDisplaySignalSynchronization(bool synchronous)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 & ~${LCDC_INSTANCE_NAME}_LCDCFG5_DISPDLY_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG5_DISPDLY(synchronous == false);
}

void ${LCDC_INSTANCE_NAME}_SetOutputMode(${LCDC_INSTANCE_NAME}_OUTPUT_COLOR_MODE mode)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 & ~${LCDC_INSTANCE_NAME}_LCDCFG5_MODE_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG5_MODE(mode);
}

void ${LCDC_INSTANCE_NAME}_SetPostPocessingEnable(bool enable)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 & ~${LCDC_INSTANCE_NAME}_LCDCFG5_PP_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG5_PP(enable == true);
}

void ${LCDC_INSTANCE_NAME}_SetVSYNCPulseSetupConfig(bool synchronous)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 & ~${LCDC_INSTANCE_NAME}_LCDCFG5_VSPSU_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG5_VSPSU(synchronous == false);
}

void ${LCDC_INSTANCE_NAME}_SetVSYNCPulseHoldConfig(bool synchronous)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 & ~${LCDC_INSTANCE_NAME}_LCDCFG5_VSPHO_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG5_VSPHO(synchronous == false);
}

void ${LCDC_INSTANCE_NAME}_SetDisplayGuardTime(uint16_t frames)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG5 & ~${LCDC_INSTANCE_NAME}_LCDCFG5_GUARDTIME_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG5_GUARDTIME(frames);
}

void ${LCDC_INSTANCE_NAME}_SetPWMPrescaler(uint8_t div)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG6 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG6 & ~${LCDC_INSTANCE_NAME}_LCDCFG6_PWMPS_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG6_PWMPS(div);
}

void ${LCDC_INSTANCE_NAME}_SetPWMSignalPolarity(${LCDC_INSTANCE_NAME}_SIGNAL_POLARITY polarity)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG6 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG6 & ~${LCDC_INSTANCE_NAME}_LCDCFG6_PWMPOL_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG6_PWMPOL(polarity == ${LCDC_INSTANCE_NAME}_POLARITY_POSITIVE);
}

void ${LCDC_INSTANCE_NAME}_SetPWMCompareValue(uint32_t value)
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG6 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDCFG6 & ~${LCDC_INSTANCE_NAME}_LCDCFG6_PWMCVAL_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDCFG6_PWMCVAL(value);
}

void ${LCDC_INSTANCE_NAME}_SetPixelClockEnable(bool enable)
{
    if (enable == true)
        ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDEN = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDEN & ~${LCDC_INSTANCE_NAME}_LCDEN_CLKEN_Msk) | 
                                      ${LCDC_INSTANCE_NAME}_LCDEN_CLKEN(1);
    else
        ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS & ~${LCDC_INSTANCE_NAME}_LCDDIS_CLKDIS_Msk) | 
                                      ${LCDC_INSTANCE_NAME}_LCDDIS_CLKDIS(1);
}

void ${LCDC_INSTANCE_NAME}_SetSYNCEnable(bool enable)
{
    if (enable == true)
        ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDEN = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDEN & ~${LCDC_INSTANCE_NAME}_LCDEN_SYNCEN_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDEN_SYNCEN(1);
    else
        ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS & ~${LCDC_INSTANCE_NAME}_LCDDIS_SYNCDIS_Msk) | 
                                      ${LCDC_INSTANCE_NAME}_LCDDIS_SYNCDIS(1);
}

void ${LCDC_INSTANCE_NAME}_SetDISPSignalEnable(bool enable)
{
    if (enable == true)
        ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDEN = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDEN & ~${LCDC_INSTANCE_NAME}_LCDEN_DISPEN_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDEN_DISPEN(1);
    else
        ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS & ~${LCDC_INSTANCE_NAME}_LCDDIS_DISPDIS_Msk) | 
                                      ${LCDC_INSTANCE_NAME}_LCDDIS_DISPDIS(1);  
}

void ${LCDC_INSTANCE_NAME}_SetPWMEnable(bool enable)
{
    if (enable == true)
        ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDEN = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDEN & ~${LCDC_INSTANCE_NAME}_LCDEN_PWMEN_Msk) | 
                                 ${LCDC_INSTANCE_NAME}_LCDEN_PWMEN(1);
    else
        ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS & ~${LCDC_INSTANCE_NAME}_LCDDIS_PWMDIS_Msk) | 
                                      ${LCDC_INSTANCE_NAME}_LCDDIS_PWMDIS(1);    
}

void ${LCDC_INSTANCE_NAME}_ClockReset( void )
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS & ~${LCDC_INSTANCE_NAME}_LCDDIS_CLKRST_Msk) | 
                              ${LCDC_INSTANCE_NAME}_LCDDIS_CLKRST(1);    
}

void ${LCDC_INSTANCE_NAME}_SYNCReset( void )
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS & ~${LCDC_INSTANCE_NAME}_LCDDIS_SYNCRST_Msk) | 
                              ${LCDC_INSTANCE_NAME}_LCDDIS_SYNCRST(1);    
}

void ${LCDC_INSTANCE_NAME}_DISPSignalReset( void )
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS & ~${LCDC_INSTANCE_NAME}_LCDDIS_DISPRST_Msk) | 
                              ${LCDC_INSTANCE_NAME}_LCDDIS_DISPRST(1);    
}

void ${LCDC_INSTANCE_NAME}_PWMReset( void )
{
    ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDDIS & ~${LCDC_INSTANCE_NAME}_LCDDIS_PWMRST_Msk) | 
                              ${LCDC_INSTANCE_NAME}_LCDDIS_PWMRST(1); 
}

bool ${LCDC_INSTANCE_NAME}_GetPixelClockStatusRunning( void )
{
    return ((${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDSR & ${LCDC_INSTANCE_NAME}_LCDSR_CLKSTS_Msk) == ${LCDC_INSTANCE_NAME}_LCDSR_CLKSTS_Msk);
}

bool ${LCDC_INSTANCE_NAME}_GetTimingEngineStatusRunning( void )
{
    return ((${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDSR & ${LCDC_INSTANCE_NAME}_LCDSR_LCDSTS_Msk) == ${LCDC_INSTANCE_NAME}_LCDSR_LCDSTS_Msk);
}

bool ${LCDC_INSTANCE_NAME}_GetDisplaySignalStatusActivated( void )
{
    return ((${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDSR & ${LCDC_INSTANCE_NAME}_LCDSR_DISPSTS_Msk) == ${LCDC_INSTANCE_NAME}_LCDSR_DISPSTS_Msk);
}

bool ${LCDC_INSTANCE_NAME}_GetPWMSignalStatusActivated( void )
{
    return ((${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDSR & ${LCDC_INSTANCE_NAME}_LCDSR_PWMSTS_Msk) == ${LCDC_INSTANCE_NAME}_LCDSR_PWMSTS_Msk);
}

bool ${LCDC_INSTANCE_NAME}_GetSynchronizationStatusInProgress( void )
{
    return ((${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDSR & ${LCDC_INSTANCE_NAME}_LCDSR_SIPSTS_Msk) == ${LCDC_INSTANCE_NAME}_LCDSR_SIPSTS_Msk);
}

void ${LCDC_INSTANCE_NAME}_SetSOFInterruptEnable(bool enable)
{
    if (enable == true)
        ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDIER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDIER & ~${LCDC_INSTANCE_NAME}_LCDIER_SOFIE_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDIER_SOFIE(1);
    else
        ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDIDR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDIDR & ~${LCDC_INSTANCE_NAME}_LCDIDR_SOFID_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDIDR_SOFID(1);    
}

void ${LCDC_INSTANCE_NAME}_SetLCDDisableInterruptEnable(bool enable)
{
    if (enable == true)
        ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDIER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDIER & ~${LCDC_INSTANCE_NAME}_LCDIER_DISIE_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDIER_DISIE(1);
    else
        ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDIDR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDIDR & ~${LCDC_INSTANCE_NAME}_LCDIDR_DISID_Msk) | 
                                  ${LCDC_INSTANCE_NAME}_LCDIDR_DISID(1);    
}

void ${LCDC_INSTANCE_NAME}_WaitForSyncInProgress( void )
{
    while ((${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDSR & ${LCDC_INSTANCE_NAME}_LCDSR_SIPSTS_Msk));
}

void ${LCDC_INSTANCE_NAME}_WaitForClockRunning( void )
{
    while (!(${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDSR & ${LCDC_INSTANCE_NAME}_LCDSR_CLKSTS_Msk));
}

void ${LCDC_INSTANCE_NAME}_WaitForSynchronization( void )
{
    while (!(${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDSR & ${LCDC_INSTANCE_NAME}_LCDSR_LCDSTS_Msk));
}

void ${LCDC_INSTANCE_NAME}_WaitForDISPSignal( void )
{
    while (!(${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDSR & ${LCDC_INSTANCE_NAME}_LCDSR_DISPSTS_Msk));
}


static void _wait_for_clock_domain_sync(void)
{
	while ((${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_LCDSR & ${LCDC_INSTANCE_NAME}_LCDSR_SIPSTS_Msk));
}

void ${LCDC_INSTANCE_NAME}_SetRGBModeInput(${LCDC_INSTANCE_NAME}_LAYER_ID layer, ${LCDC_INSTANCE_NAME}_INPUT_COLOR_MODE mode)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECFG1 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECFG1 & ~${LCDC_INSTANCE_NAME}_BASECFG1_RGBMODE_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_BASECFG1_RGBMODE(mode);
          break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG1 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG1 & ~${LCDC_INSTANCE_NAME}_OVR1CFG1_RGBMODE_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR1CFG1_RGBMODE(mode);
          break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG1 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG1 & ~${LCDC_INSTANCE_NAME}_OVR2CFG1_RGBMODE_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR2CFG1_RGBMODE(mode);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG1 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG1 & ~${LCDC_INSTANCE_NAME}_HEOCFG1_RGBMODE_Msk) | 
                                       ${LCDC_INSTANCE_NAME}_HEOCFG1_RGBMODE(mode);
            break;            
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
        default:
          break;
    }
}

void ${LCDC_INSTANCE_NAME}_SetDMAHeadPointer(${LCDC_INSTANCE_NAME}_LAYER_ID layer, uint32_t head)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASEHEAD = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASEHEAD & ~${LCDC_INSTANCE_NAME}_BASEHEAD_HEAD_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_BASEHEAD_HEAD(head);
          break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1HEAD = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1HEAD & ~${LCDC_INSTANCE_NAME}_OVR1HEAD_HEAD_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR1HEAD_HEAD(head);
          break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2HEAD = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2HEAD & ~${LCDC_INSTANCE_NAME}_OVR2HEAD_HEAD_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR2HEAD_HEAD(head);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOHEAD = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOHEAD & ~${LCDC_INSTANCE_NAME}_OVR2HEAD_HEAD_Msk) | 
                                       ${LCDC_INSTANCE_NAME}_OVR2HEAD_HEAD(head);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
        default:
          break;
    }
}

void ${LCDC_INSTANCE_NAME}_UpdateAddToQueue(${LCDC_INSTANCE_NAME}_LAYER_ID layer)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR & ~${LCDC_INSTANCE_NAME}_ATTR_BASEA2Q_Msk) | 
                                    ${LCDC_INSTANCE_NAME}_ATTR_BASEA2Q(1); 
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR & ~${LCDC_INSTANCE_NAME}_ATTR_OVR1A2Q_Msk) | 
                                    ${LCDC_INSTANCE_NAME}_ATTR_OVR1A2Q(1); 
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR & ~${LCDC_INSTANCE_NAME}_ATTR_OVR2A2Q_Msk) | 
                                    ${LCDC_INSTANCE_NAME}_ATTR_OVR2A2Q(1);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR & ~${LCDC_INSTANCE_NAME}_ATTR_HEOA2Q_Msk) | 
                              ${LCDC_INSTANCE_NAME}_ATTR_HEOA2Q(1);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR & ~${LCDC_INSTANCE_NAME}_ATTR_PPA2Q_Msk) | 
                              ${LCDC_INSTANCE_NAME}_ATTR_PPA2Q(1);
            break;
        default:
          break;
    }
}

void ${LCDC_INSTANCE_NAME}_SetWindowPosition(${LCDC_INSTANCE_NAME}_LAYER_ID layer, uint16_t xpos, uint16_t ypos)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG2 = ${LCDC_INSTANCE_NAME}_OVR1CFG2_YPOS(ypos) | ${LCDC_INSTANCE_NAME}_OVR1CFG2_XPOS(xpos); 
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG2 = ${LCDC_INSTANCE_NAME}_OVR1CFG2_YPOS(ypos) | ${LCDC_INSTANCE_NAME}_OVR1CFG2_XPOS(xpos); 
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG2 = ${LCDC_INSTANCE_NAME}_HEOCFG2_YPOS(ypos) | ${LCDC_INSTANCE_NAME}_HEOCFG2_XPOS(xpos); 
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            //unsupported
        default:
          break;
    }
}

void ${LCDC_INSTANCE_NAME}_SetWindowSize(${LCDC_INSTANCE_NAME}_LAYER_ID layer, uint16_t width, uint16_t height)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG3 = ${LCDC_INSTANCE_NAME}_OVR1CFG3_YSIZE(height - 1) | ${LCDC_INSTANCE_NAME}_OVR1CFG3_XSIZE(width - 1); 
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG3 = ${LCDC_INSTANCE_NAME}_OVR2CFG3_YSIZE(height - 1) | ${LCDC_INSTANCE_NAME}_OVR2CFG3_XSIZE(width - 1); 
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG3 = ${LCDC_INSTANCE_NAME}_HEOCFG3_YSIZE(height - 1) | ${LCDC_INSTANCE_NAME}_HEOCFG3_XSIZE(width - 1); 
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            //unsupported
        default:
          break;
    }
}

void ${LCDC_INSTANCE_NAME}_SetUseDMAPathEnable(${LCDC_INSTANCE_NAME}_LAYER_ID layer, bool enable)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECFG4 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECFG4 & ~${LCDC_INSTANCE_NAME}_BASECFG4_DMA_Msk) | 
                                ${LCDC_INSTANCE_NAME}_BASECFG4_DMA(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 & ~${LCDC_INSTANCE_NAME}_OVR1CFG9_DMA_Msk) | 
                                ${LCDC_INSTANCE_NAME}_OVR1CFG9_DMA(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 & ~${LCDC_INSTANCE_NAME}_OVR2CFG9_DMA_Msk) | 
                                ${LCDC_INSTANCE_NAME}_OVR2CFG9_DMA(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 & ~${LCDC_INSTANCE_NAME}_HEOCFG12_DMA_Msk) | 
                                ${LCDC_INSTANCE_NAME}_HEOCFG12_DMA(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
        default:
          break;
    }
}

void ${LCDC_INSTANCE_NAME}_SetDMAAddressRegister(${LCDC_INSTANCE_NAME}_LAYER_ID layer, uint32_t addr)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASEADDR = ${LCDC_INSTANCE_NAME}_BASEADDR_ADDR(addr);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1ADDR = ${LCDC_INSTANCE_NAME}_OVR1ADDR_ADDR(addr);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2ADDR = ${LCDC_INSTANCE_NAME}_OVR2ADDR_ADDR(addr);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOADDR = ${LCDC_INSTANCE_NAME}_HEOADDR_ADDR(addr);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_PPADDR = ${LCDC_INSTANCE_NAME}_PPADDR_ADDR(addr);
            break;
        default:
          break;
    }
}

void ${LCDC_INSTANCE_NAME}_SetDMADescriptorNextAddress(${LCDC_INSTANCE_NAME}_LAYER_ID layer, uint32_t next)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASENEXT = ${LCDC_INSTANCE_NAME}_BASENEXT_NEXT(next);  
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1NEXT = ${LCDC_INSTANCE_NAME}_OVR1NEXT_NEXT(next);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2NEXT = ${LCDC_INSTANCE_NAME}_OVR2NEXT_NEXT(next);  
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEONEXT = ${LCDC_INSTANCE_NAME}_HEONEXT_NEXT(next);  
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_PPNEXT = ${LCDC_INSTANCE_NAME}_PPNEXT_NEXT(next);  
            break;
        default:
          break;
    }  
}

void ${LCDC_INSTANCE_NAME}_SetTransferDescriptorFetchEnable(${LCDC_INSTANCE_NAME}_LAYER_ID layer, bool enable)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECTRL = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECTRL & ~${LCDC_INSTANCE_NAME}_BASECTRL_DFETCH_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_BASECTRL_DFETCH(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CTRL = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CTRL & ~${LCDC_INSTANCE_NAME}_OVR1CTRL_DFETCH_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR1CTRL_DFETCH(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CTRL = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CTRL & ~${LCDC_INSTANCE_NAME}_OVR2CTRL_DFETCH_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR2CTRL_DFETCH(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCTRL = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCTRL & ~${LCDC_INSTANCE_NAME}_HEOCTRL_DFETCH_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_HEOCTRL_DFETCH(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_PPCTRL = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_PPCTRL & ~${LCDC_INSTANCE_NAME}_PPCTRL_DFETCH_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_PPCTRL_DFETCH(enable == true);
            break;
        default:
          break;
    }
}

void ${LCDC_INSTANCE_NAME}_UpdateOverlayAttributesEnable(${LCDC_INSTANCE_NAME}_LAYER_ID layer)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECHER & ~${LCDC_INSTANCE_NAME}_BASECHER_UPDATEEN_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_BASECHER_UPDATEEN(1);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CHER & ~${LCDC_INSTANCE_NAME}_OVR1CHER_UPDATEEN_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR1CHER_UPDATEEN(1);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CHER & ~${LCDC_INSTANCE_NAME}_OVR2CHER_UPDATEEN_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR2CHER_UPDATEEN(1);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCHER & ~${LCDC_INSTANCE_NAME}_HEOCHER_UPDATEEN_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_HEOCHER_UPDATEEN(1);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_PPCHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_PPCHER & ~${LCDC_INSTANCE_NAME}_PPCHER_UPDATEEN_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_PPCHER_UPDATEEN(1);
            break;
        default:
          break;
    }  
}

void ${LCDC_INSTANCE_NAME}_SetChannelEnable(${LCDC_INSTANCE_NAME}_LAYER_ID layer, bool enable)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            if (enable == true)
                ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECHER & ~${LCDC_INSTANCE_NAME}_BASECHER_CHEN_Msk) | 
                                            ${LCDC_INSTANCE_NAME}_BASECHER_CHEN(1);
            else
                ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECHDR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECHDR & ~${LCDC_INSTANCE_NAME}_BASECHDR_CHDIS_Msk) | 
                                            ${LCDC_INSTANCE_NAME}_BASECHDR_CHDIS(1);    
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            if (enable == true)
                ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CHER & ~${LCDC_INSTANCE_NAME}_OVR1CHER_CHEN_Msk) | 
                                            ${LCDC_INSTANCE_NAME}_OVR1CHER_CHEN(1);
            else
                ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CHDR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECHDR & ~${LCDC_INSTANCE_NAME}_OVR1CHDR_CHDIS_Msk) | 
                                            ${LCDC_INSTANCE_NAME}_OVR1CHDR_CHDIS(1);    
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            if (enable == true)
                ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CHER & ~${LCDC_INSTANCE_NAME}_OVR2CHER_CHEN_Msk) | 
                                            ${LCDC_INSTANCE_NAME}_OVR2CHER_CHEN(1);
            else
                ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CHDR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CHDR & ~${LCDC_INSTANCE_NAME}_OVR2CHDR_CHDIS_Msk) | 
                                            ${LCDC_INSTANCE_NAME}_OVR2CHDR_CHDIS(1);    
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            if (enable == true)
                ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCHER & ~${LCDC_INSTANCE_NAME}_HEOCHER_CHEN_Msk) | 
                                            ${LCDC_INSTANCE_NAME}_HEOCHER_CHEN(1);
            else
                ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCHDR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCHDR & ~${LCDC_INSTANCE_NAME}_HEOCHDR_CHDIS_Msk) | 
                                            ${LCDC_INSTANCE_NAME}_HEOCHDR_CHDIS(1);    
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
            if (enable == true)
                ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_PPCHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_PPCHER & ~${LCDC_INSTANCE_NAME}_PPCHER_CHEN_Msk) | 
                                            ${LCDC_INSTANCE_NAME}_PPCHER_CHEN(1);
            else
                ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_PPCHDR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_PPCHDR & ~${LCDC_INSTANCE_NAME}_PPCHDR_CHDIS_Msk) | 
                                            ${LCDC_INSTANCE_NAME}_PPCHDR_CHDIS(1);    
            break;
        default:
          break;
    }  
}

void ${LCDC_INSTANCE_NAME}_AddToQueueEnable(${LCDC_INSTANCE_NAME}_LAYER_ID layer)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_BASECHER & ~${LCDC_INSTANCE_NAME}_BASECHSR_A2QSR_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_BASECHER_A2QEN(1);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CHER & ~${LCDC_INSTANCE_NAME}_OVR1CHSR_A2QSR_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR1CHER_A2QEN(1);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CHER & ~${LCDC_INSTANCE_NAME}_OVR2CHSR_A2QSR_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR2CHER_A2QEN(1);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCHER & ~${LCDC_INSTANCE_NAME}_HEOCHSR_A2QSR_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_HEOCHER_A2QEN(1);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_PPCHER = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_PPCHER & ~${LCDC_INSTANCE_NAME}_PPCHSR_A2QSR_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_PPCHER_A2QEN(1);
            break;
        default:
          break;
    }  
}

void ${LCDC_INSTANCE_NAME}_SetBlenderOverlayLayerEnable(${LCDC_INSTANCE_NAME}_LAYER_ID layer, bool enable)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 & ~${LCDC_INSTANCE_NAME}_OVR1CFG9_OVR_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR1CFG9_OVR(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 & ~${LCDC_INSTANCE_NAME}_OVR2CFG9_OVR_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR2CFG9_OVR(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 & ~${LCDC_INSTANCE_NAME}_HEOCFG12_OVR_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_HEOCFG12_OVR(enable == true);
            break;
        //Not supported            
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE: 
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
        default:
          break;
    }  
}

void ${LCDC_INSTANCE_NAME}_SetBlenderDMALayerEnable(${LCDC_INSTANCE_NAME}_LAYER_ID layer, bool enable)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 & ~${LCDC_INSTANCE_NAME}_OVR1CFG9_DMA_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR1CFG9_DMA(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 & ~${LCDC_INSTANCE_NAME}_OVR2CFG9_DMA_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR2CFG9_DMA(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 & ~${LCDC_INSTANCE_NAME}_HEOCFG12_DMA_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_HEOCFG12_DMA(enable == true);
            break;
        //Not supported            
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE: 
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
        default:
          break;
    }  
}

void ${LCDC_INSTANCE_NAME}_SetBlenderLocalAlphaEnable(${LCDC_INSTANCE_NAME}_LAYER_ID layer, bool enable)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 & ~${LCDC_INSTANCE_NAME}_OVR1CFG9_LAEN_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR1CFG9_LAEN(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 & ~${LCDC_INSTANCE_NAME}_OVR2CFG9_LAEN_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR2CFG9_LAEN(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 & ~${LCDC_INSTANCE_NAME}_HEOCFG12_LAEN_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_HEOCFG12_LAEN(enable == true);
            break;
        //Not supported            
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE: 
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
        default:
          break;
    }  
}

void ${LCDC_INSTANCE_NAME}_SetBlenderIteratedColorEnable(${LCDC_INSTANCE_NAME}_LAYER_ID layer, bool enable)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 & ~${LCDC_INSTANCE_NAME}_OVR1CFG9_ITER2BL_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR1CFG9_ITER2BL(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 & ~${LCDC_INSTANCE_NAME}_OVR2CFG9_ITER2BL_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR2CFG9_ITER2BL(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 & ~${LCDC_INSTANCE_NAME}_HEOCFG12_ITER2BL_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_HEOCFG12_ITER2BL(enable == true);
            break;
        //Not supported            
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE: 
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
        default:
          break;
    }  
}

void ${LCDC_INSTANCE_NAME}_SetBlenderUseIteratedColor(${LCDC_INSTANCE_NAME}_LAYER_ID layer, bool use)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 & ~${LCDC_INSTANCE_NAME}_OVR1CFG9_ITER_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR1CFG9_ITER(use == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 & ~${LCDC_INSTANCE_NAME}_OVR2CFG9_ITER_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR2CFG9_ITER(use == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 & ~${LCDC_INSTANCE_NAME}_HEOCFG12_ITER_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_HEOCFG12_ITER(use == true);
            break;
        //Not supported            
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE: 
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
        default:
          break;
    }  
}

void ${LCDC_INSTANCE_NAME}_SetBlenderGlobalAlphaEnable(${LCDC_INSTANCE_NAME}_LAYER_ID layer, bool enable)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 & ~${LCDC_INSTANCE_NAME}_OVR1CFG9_GAEN_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR1CFG9_GAEN(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 & ~${LCDC_INSTANCE_NAME}_OVR2CFG9_GAEN_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR2CFG9_GAEN(enable == true);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 & ~${LCDC_INSTANCE_NAME}_HEOCFG12_GAEN_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_HEOCFG12_GAEN(enable == true);
            break;
        //Not supported            
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE: 
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
        default:
          break;
    }  
}

void ${LCDC_INSTANCE_NAME}_SetBlenderGlobalAlpha(${LCDC_INSTANCE_NAME}_LAYER_ID layer, uint8_t alpha)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR1CFG9 & ~${LCDC_INSTANCE_NAME}_OVR1CFG9_GA_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR1CFG9_GA(alpha);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_OVR2CFG9 & ~${LCDC_INSTANCE_NAME}_OVR2CFG9_GA_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_OVR2CFG9_GA(alpha);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_HEOCFG12 & ~${LCDC_INSTANCE_NAME}_HEOCFG12_GA_Msk) | 
                                        ${LCDC_INSTANCE_NAME}_HEOCFG12_GA(alpha);
            break;
        //Not supported            
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE: 
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
        default:
          break;
    }  
}


void ${LCDC_INSTANCE_NAME}_UpdateAttribute(${LCDC_INSTANCE_NAME}_LAYER_ID layer)
{
    switch(layer)
    {
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR1:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR & ~${LCDC_INSTANCE_NAME}_ATTR_OVR1_Msk) | 
                                    ${LCDC_INSTANCE_NAME}_ATTR_OVR1(1);             
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_OVR2:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR & ~${LCDC_INSTANCE_NAME}_ATTR_OVR2_Msk) | 
                                    ${LCDC_INSTANCE_NAME}_ATTR_OVR2(1);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_HEO:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR & ~${LCDC_INSTANCE_NAME}_ATTR_HEO_Msk) | 
                                    ${LCDC_INSTANCE_NAME}_ATTR_HEO(1);
            break;
        case ${LCDC_INSTANCE_NAME}_LAYER_BASE:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR & ~${LCDC_INSTANCE_NAME}_ATTR_BASE_Msk) | 
                                    ${LCDC_INSTANCE_NAME}_ATTR_BASE(1);
            break;          
        case ${LCDC_INSTANCE_NAME}_LAYER_PP:
            ${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR = (${LCDC_INSTANCE_NAME}_REGS->${LCDC_INSTANCE_NAME}_ATTR & ~${LCDC_INSTANCE_NAME}_ATTR_PP_Msk) | 
                                    ${LCDC_INSTANCE_NAME}_ATTR_PP(1);
            break;
        default:
          break;
    }   

}