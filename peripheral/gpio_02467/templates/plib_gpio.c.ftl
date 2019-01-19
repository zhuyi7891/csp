/*******************************************************************************
  SYS PORTS Static Functions for PORTS System Service

  Company:
    Microchip Technology Inc.

  File Name:
    plib_gpio.c

  Summary:
    GPIO function implementations for the GPIO PLIB.

  Description:
    The GPIO PLIB provides a simple interface to manage peripheral
    input-output controller.

*******************************************************************************/

//DOM-IGNORE-BEGIN
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
//DOM-IGNORE-END

#include "plib_gpio.h"
<#compress> <#-- To remove unwanted new lines -->

<#-- Find out number of active interrupt pins for each channel -->

<#-- Initialize variables to 0 -->
<#assign GPIO_ATLEAST_ONE_INTERRUPT_USED = false>

<#list 0..GPIO_CHANNEL_TOTAL-1 as i>
    <#assign channel = "GPIO_CHANNEL_" + i + "_NAME">
    <#if .vars[channel]?has_content>
        <@"<#assign GPIO_${.vars[channel]}_NUM_INT_PINS = 0>"?interpret />
        <@"<#assign port${.vars[channel]}IndexStart = 0>"?interpret />
        <#assign GPIO_ATLEAST_ONE_INTERRUPT_USED = GPIO_ATLEAST_ONE_INTERRUPT_USED || .vars["SYS_PORT_${.vars[channel]}_CN_USED"]>
    </#if>
</#list>

<#-- count number of active interrupts for each channel and save it in variable -->
<#list 1..GPIO_PIN_TOTAL as i>
    <#assign pinChannel = "BSP_PIN_" + i + "_PORT_CHANNEL">
    <#assign intConfig = "BSP_PIN_" + i + "_CN">

    <#if .vars[intConfig]?has_content>
        <#if (.vars[intConfig] != "Disabled")>
            <@"<#assign GPIO_${.vars[pinChannel]}_NUM_INT_PINS = GPIO_${.vars[pinChannel]}_NUM_INT_PINS + 1>"?interpret />
        </#if>
    </#if>
</#list>

</#compress>
<#if GPIO_ATLEAST_ONE_INTERRUPT_USED == true >
    <@"<#assign port${.vars['GPIO_CHANNEL_0_NAME']}IndexStart = 0>"?interpret />
    <#assign TOTAL_NUM_OF_INT_USED = 0>

    <#list 1..GPIO_CHANNEL_TOTAL as i>
        <#assign channel = "GPIO_CHANNEL_" + i + "_NAME">
        <#assign prevChannel = "GPIO_CHANNEL_" + (i - 1) + "_NAME">
        <#if .vars[channel]?has_content>
            <@"<#assign port${.vars[channel]}IndexStart = port${.vars[prevChannel]}IndexStart + GPIO_${.vars[prevChannel]}_NUM_INT_PINS>"?interpret />
            <@"<#assign TOTAL_NUM_OF_INT_USED = TOTAL_NUM_OF_INT_USED + GPIO_${.vars[prevChannel]}_NUM_INT_PINS>"?interpret />
        </#if>
    </#list>

    <#lt>/* Array to store callback objects of each configured interrupt */
    <#lt>GPIO_PIN_CALLBACK_OBJ portPinCbObj[${TOTAL_NUM_OF_INT_USED}];

    <#lt>/* Array to store number of interrupts in each PORT Channel + previous interrupt count */
    <@compress single_line=true>
        <#lt>uint8_t portNumCb[${GPIO_CHANNEL_TOTAL} + 1] = {
                            <#list 0..GPIO_CHANNEL_TOTAL-1 as i>
                                <#assign channel = "GPIO_CHANNEL_" + i + "_NAME">
                                <#if .vars[channel]?has_content>
                                    ${.vars["port${.vars[channel]}IndexStart"]},
                                </#if>
                            </#list>
                                    ${TOTAL_NUM_OF_INT_USED}};
    </@compress>
</#if>


/******************************************************************************
  Function:
    GPIO_Initialize ( void )

  Summary:
    Initialize the GPIO library.

  Remarks:
    See plib_gpio.h for more details.
*/
void GPIO_Initialize ( void )
{
<#list 0..GPIO_CHANNEL_TOTAL-1 as i>
    <#assign channel = "GPIO_CHANNEL_" + i + "_NAME">
    <#if .vars[channel]?has_content>
        <#lt>    /* PORT${.vars[channel]} Initialization */
        <#if .vars["SYS_PORT_${.vars[channel]}_ODC"] != "0">
             <#lt>    ODC${.vars[channel]}SET = 0x${.vars["SYS_PORT_${.vars[channel]}_ODC"]}; /* Open Drain Enable */
        </#if>
        <#if .vars["SYS_PORT_${.vars[channel]}_LAT"] != "0">
             <#lt>    LAT${.vars[channel]} = 0x${.vars["SYS_PORT_${.vars[channel]}_LAT"]}; /* Initial Latch Value */
        </#if>
        <#if .vars["SYS_PORT_${.vars[channel]}_TRIS"] != "0">
             <#lt>    TRIS${.vars[channel]}CLR = 0x${.vars["SYS_PORT_${.vars[channel]}_TRIS"]}; /* Direction Control */
        </#if>
        <#if .vars["SYS_PORT_${.vars[channel]}_ANSEL"] != "0">
             <#lt>    ANSEL${.vars[channel]}CLR = 0x${.vars["SYS_PORT_${.vars[channel]}_ANSEL"]}; /* Digital Mode Enable */
        </#if>
        <#if .vars["SYS_PORT_${.vars[channel]}_CNPU"] != "0">
             <#lt>    CNPU${.vars[channel]}SET = 0x${.vars["SYS_PORT_${.vars[channel]}_CNPU"]}; /* Pull-Up Enable */
        </#if>
        <#if .vars["SYS_PORT_${.vars[channel]}_CNPD"] != "0">
             <#lt>    CNPD${.vars[channel]}SET = 0x${.vars["SYS_PORT_${.vars[channel]}_CNPD"]}; /* Pull-Down Enable */
        </#if>
        <#if .vars["SYS_PORT_${.vars[channel]}_CN_USED"] == true>
             <#lt>    /* Change Notice Enable */
             <#lt>    CNCON${.vars[channel]}SET = _CNCONB_ON_MASK;
             <#lt>    PORT${.vars[channel]};
        </#if>
   <#--     <#if .vars["SYS_PORT_${.vars[channel]}_CNEN"] != "0">
             <#lt>    CNEN${.vars[channel]}SET = 0x${.vars["SYS_PORT_${.vars[channel]}_CNEN"]};
        </#if> -->

    </#if>
</#list>

<#if USE_PPS_INPUT_0 == true || USE_PPS_OUTPUT_0 == true>
    /* unlock system for PPS configuration */
    SYSKEY = 0x00000000;
    SYSKEY = 0xAA996655;
    SYSKEY = 0x556699AA;
    CFGCONbits.IOLOCK = 0;
</#if>

<#lt>    /* PPS Input Remapping */
<#list 0..PPS_PIN_COUNT-1 as i>
    <#assign usePPSInputPin = "USE_PPS_INPUT_" + i>
    <#assign inputFunction = "SYS_PORT_PPS_INPUT_FUNCTION_" + i>
    <#assign remapInputPin = "SYS_PORT_PPS_INPUT_PIN_" + i>
    <#if .vars[usePPSInputPin]?has_content>
        <#if .vars[usePPSInputPin] == true>
            <#lt>    ${.vars[inputFunction]}R = ${.vars[remapInputPin]};
        <#else>
            <#break>
        </#if>
    </#if>
</#list>

<#lt>    /* PPS Output Remapping */
<#list 0..PPS_PIN_COUNT-1 as i>
    <#assign usePPSOutputPin = "USE_PPS_OUTPUT_" + i>
    <#assign outputFunction = "SYS_PORT_PPS_OUTPUT_FUNCTION_" + i>
    <#assign remapOutputPin = "SYS_PORT_PPS_OUTPUT_PIN_" + i>
    <#if .vars[usePPSOutputPin]?has_content>
        <#if .vars[usePPSOutputPin] == true>
            <#lt>    ${.vars[remapOutputPin]}R = ${.vars[outputFunction]};
        <#else>
            <#break>
        </#if>
    </#if>
</#list>

<#if USE_PPS_INPUT_0 == true || USE_PPS_OUTPUT_0 == true>
    /* Lock back the system after PPS configuration */
    SYSKEY = 0x00000000;
    SYSKEY = 0xAA996655;
    SYSKEY = 0x556699AA;
    CFGCONbits.IOLOCK = 1;
</#if>

<#if GPIO_ATLEAST_ONE_INTERRUPT_USED == true >
    uint32_t i;
    /* Initialize Interrupt Pin data structures */
    <#list 0..GPIO_CHANNEL_TOTAL-1 as i>
        <#assign channel = "GPIO_CHANNEL_" + i + "_NAME">
        <#if .vars[channel]?has_content>
            <@"<#assign portCurNumCb_${.vars[channel]} = 0>"?interpret />
        </#if>
    </#list>
    <#list 1..GPIO_PIN_TOTAL as i>
        <#assign intConfig = "BSP_PIN_" + i + "_CN">
        <#assign portChannel = "BSP_PIN_" + i + "_PORT_CHANNEL">
        <#assign portPosition = "BSP_PIN_" + i + "_PORT_PIN">
        <#if .vars[intConfig]?has_content>
            <#if (.vars[intConfig] != "Disabled")>
                <#lt>    portPinCbObj[${.vars["port${.vars[portChannel]}IndexStart"]} + ${.vars["portCurNumCb_${.vars[portChannel]}"]}].pin = GPIO_PIN_R${.vars[portChannel]}${.vars[portPosition]};
                <#lt>    <@"<#assign portCurNumCb_${.vars[portChannel]} = portCurNumCb_${.vars[portChannel]} + 1>"?interpret />
            </#if>
        </#if>
    </#list>
    <#lt>    for(i=0; i<${TOTAL_NUM_OF_INT_USED}; i++)
    <#lt>    {
    <#lt>        portPinCbObj[i].callback = NULL;
    <#lt>    }
</#if>
}

// *****************************************************************************
// *****************************************************************************
// Section: GPIO APIs which operates on multiple pins of a port
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
/* Function:
    uint32_t GPIO_PortRead ( GPIO_PORT port )

  Summary:
    Read all the I/O lines of the selected port.

  Description:
    This function reads the live data values on all the I/O lines of the
    selected port.  Bit values returned in each position indicate corresponding
    pin levels.
    1 = Pin is high.
    0 = Pin is low.

    This function reads the value regardless of pin configuration, whether it is
    set as as an input, driven by the GPIO Controller, or driven by a peripheral.

  Remarks:
    If the port has less than 32-bits, unimplemented pins will read as
    low (0).
    Implemented pins are Right aligned in the 32-bit return value.
*/
uint32_t GPIO_PortRead(GPIO_PORT port)
{
    return (*(volatile uint32_t *)(&PORT${GPIO_CHANNEL_0_NAME} + (port * 0x40)));
}

// *****************************************************************************
/* Function:
    void GPIO_PortWrite (GPIO_PORT port, uint32_t mask, uint32_t value);

  Summary:
    Write the value on the masked I/O lines of the selected port.

  Remarks:
    See plib_gpio.h for more details.
*/
void GPIO_PortWrite(GPIO_PORT port, uint32_t mask, uint32_t value)
{
    *(volatile uint32_t *)(&LAT${GPIO_CHANNEL_0_NAME} + (port * 0x40)) = (*(volatile uint32_t *)(&LAT${GPIO_CHANNEL_0_NAME} + (port * 0x40)) & (~mask)) | (mask & value);
}

// *****************************************************************************
/* Function:
    uint32_t GPIO_PortLatchRead ( GPIO_PORT port )

  Summary:
    Read the latched value on all the I/O lines of the selected port.

  Remarks:
    See plib_gpio.h for more details.
*/
uint32_t GPIO_PortLatchRead(GPIO_PORT port)
{
    return (*(volatile uint32_t *)(&LAT${GPIO_CHANNEL_0_NAME} + (port * 0x40)));
}

// *****************************************************************************
/* Function:
    void GPIO_PortSet ( GPIO_PORT port, uint32_t mask )

  Summary:
    Set the selected IO pins of a port.

  Remarks:
    See plib_gpio.h for more details.
*/
void GPIO_PortSet(GPIO_PORT port, uint32_t mask)
{
    *(volatile uint32_t *)(&LAT${GPIO_CHANNEL_0_NAME}SET + (port * 0x40)) = mask;
}

// *****************************************************************************
/* Function:
    void GPIO_PortClear ( GPIO_PORT port, uint32_t mask )

  Summary:
    Clear the selected IO pins of a port.

  Remarks:
    See plib_gpio.h for more details.
*/
void GPIO_PortClear(GPIO_PORT port, uint32_t mask)
{
    *(volatile uint32_t *)(&LAT${GPIO_CHANNEL_0_NAME}CLR + (port * 0x40)) = mask;
}

// *****************************************************************************
/* Function:
    void GPIO_PortToggle ( GPIO_PORT port, uint32_t mask )

  Summary:
    Toggles the selected IO pins of a port.

  Remarks:
    See plib_gpio.h for more details.
*/
void GPIO_PortToggle(GPIO_PORT port, uint32_t mask)
{
    *(volatile uint32_t *)(&LAT${GPIO_CHANNEL_0_NAME}INV + (port * 0x40))= mask;
}

// *****************************************************************************
/* Function:
    void GPIO_PortInputEnable ( GPIO_PORT port, uint32_t mask )

  Summary:
    Enables selected IO pins of a port as input.

  Remarks:
    See plib_gpio.h for more details.
*/
void GPIO_PortInputEnable(GPIO_PORT port, uint32_t mask)
{
    *(volatile uint32_t *)(&TRIS${GPIO_CHANNEL_0_NAME}SET + (port * 0x40)) = mask;
}

// *****************************************************************************
/* Function:
    void GPIO_PortOutputEnable ( GPIO_PORT port, uint32_t mask )

  Summary:
    Enables selected IO pins of a port as output(s).

  Remarks:
    See plib_gpio.h for more details.
*/
void GPIO_PortOutputEnable(GPIO_PORT port, uint32_t mask)
{
    *(volatile uint32_t *)(&TRIS${GPIO_CHANNEL_0_NAME}CLR + (port * 0x40)) = mask;
}

<#if GPIO_ATLEAST_ONE_INTERRUPT_USED == true >
// *****************************************************************************
/* Function:
    void GPIO_PortInterruptEnable(GPIO_PORT port, uint32_t mask)

  Summary:
    Enables IO interrupt on selected IO pins of a port.

  Remarks:
    See plib_gpio.h for more details.
*/
void GPIO_PortInterruptEnable(GPIO_PORT port, uint32_t mask)
{
    *(volatile uint32_t *)(&CNEN${GPIO_CHANNEL_0_NAME}SET + (port * 0x40)) = mask;
}

// *****************************************************************************
/* Function:
    void GPIO_PortInterruptDisable(GPIO_PORT port, uint32_t mask)

  Summary:
    Disables IO interrupt on selected IO pins of a port.

  Remarks:
    See plib_gpio.h for more details.
*/
void GPIO_PortInterruptDisable(GPIO_PORT port, uint32_t mask)
{
    *(volatile uint32_t *)(&CNEN${GPIO_CHANNEL_0_NAME}CLR + (port * 0x40)) = mask;
}

// *****************************************************************************
// *****************************************************************************
// Section: GPIO APIs which operates on one pin at a time
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
/* Function:
    bool GPIO_PinInterruptCallbackRegister(
        GPIO_PIN pin,
        const GPIO_PIN_CALLBACK callback,
        uintptr_t context
    );

  Summary:
    Allows application to register callback for configured pin.

  Remarks:
    See plib_gpio.h for more details.
*/
bool GPIO_PinInterruptCallbackRegister(
    GPIO_PIN pin,
    const GPIO_PIN_CALLBACK callback,
    uintptr_t context
)
{
    uint8_t i;
    uint8_t portIndex;

    portIndex = pin >> 5;

    for(i = portNumCb[portIndex]; i < portNumCb[portIndex +1]; i++)
    {
        if (portPinCbObj[i].pin == pin)
        {
            portPinCbObj[i].callback = callback;
            portPinCbObj[i].context  = context;
            return true;
        }
    }
    return false;
}
<#if GPIO_ATLEAST_ONE_INTERRUPT_USED == true >
// *****************************************************************************
// *****************************************************************************
// Section: Local Function Implementation
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
/* Function:
    void _CHANGE_NOTICE_Interrupt_Handler ( GPIO_PORT port )

  Summary:
    Interrupt handler for a selected port.

  Description:
    This function defines the Interrupt handler for a selected port.

  Remarks:
	It is an internal function used by the library, user should not call it.
*/
void _CHANGE_NOTICE_Interrupt_Handler ( GPIO_PORT port )
{
    uint8_t i;
    uint32_t status;

    status  = (*(volatile uint32_t *)(&CNSTAT${GPIO_CHANNEL_0_NAME} + (port * 0x40)));
    status &= (*(volatile uint32_t *)(&CNEN${GPIO_CHANNEL_0_NAME} + (port * 0x40)));

    /* Check pending events and call callback if registered */
    for(i = portNumCb[port]; i < portNumCb[port+1]; i++)
    {
        if((status & (1 << (portPinCbObj[i].pin & 0x1F))) && (portPinCbObj[i].callback != NULL))
        {
            portPinCbObj[i].callback (portPinCbObj[i].pin, portPinCbObj[i].context);
        }
    }

}
</#if>
// *****************************************************************************
// *****************************************************************************
// Section: Interrupt Service Routine (ISR) Implementation(s)
// *****************************************************************************
// *****************************************************************************
</#if>

<#list 0..GPIO_CHANNEL_TOTAL-1 as i>
    <#assign channel = "GPIO_CHANNEL_" + i + "_NAME">
    <#if .vars[channel]?has_content>
        <#if .vars["SYS_PORT_${.vars[channel]}_CN_USED"] == true>
// *****************************************************************************
/* Function:
    void CHANGE_NOTICE_${.vars[channel]}_InterruptHandler (void)

  Summary:
    Interrupt handler for PORT${.vars[channel]}.

  Description:
    This function defines the Interrupt service routine for PORT${.vars[channel]}.
    This is the function which by default gets into Interrupt Vector Table.

  Remarks:
    User should not call this function.
*/
void CHANGE_NOTICE_${.vars[channel]}_InterruptHandler(void)
{
    /* Local Change Notice Interrupt Handler */
    _CHANGE_NOTICE_Interrupt_Handler(GPIO_PORT_${.vars[channel]});
}
        </#if>
    </#if>
</#list>

/*******************************************************************************
 End of File
*/