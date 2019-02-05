"""*****************************************************************************
* Copyright (C) 2018-2019 Microchip Technology Inc. and its subsidiaries.
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
*****************************************************************************"""

################################################################################
#### Register Information ####
################################################################################

tmrBitField_T2CON_SIDL = ATDF.getNode('/avr-tools-device-file/modules/module@[name="TMR"]/register-group@[name="TMR"]/register@[name="T2CON"]/bitfield@[name="SIDL"]')
tmrValGrp_T2CON_SIDL = ATDF.getNode("/avr-tools-device-file/modules/module@[name=\"TMR\"]/value-group@[name=\"T2CON__SIDL\"]")

tmrBitField_T2CON_ON = ATDF.getNode('/avr-tools-device-file/modules/module@[name="TMR"]/register-group@[name="TMR"]/register@[name="T2CON"]/bitfield@[name="ON"]')
tmrValGrp_T2CON_ON = ATDF.getNode("/avr-tools-device-file/modules/module@[name=\"TMR\"]/value-group@[name=\"T2CON__ON\"]")

tmrBitField_T2CON_PRESCALER = ATDF.getNode('/avr-tools-device-file/modules/module@[name="TMR"]/register-group@[name="TMR"]/register@[name="T2CON"]/bitfield@[name="TCKPS"]')
tmrValGrp_T2CON_PRESCALER = ATDF.getNode("/avr-tools-device-file/modules/module@[name=\"TMR\"]/value-group@[name=\"T2CON__TCKPS\"]")

tmrBitField_T2CON_TCS = ATDF.getNode('/avr-tools-device-file/modules/module@[name="TMR"]/register-group@[name="TMR"]/register@[name="T2CON"]/bitfield@[name="TCS"]')
tmrValGrp_T2CON_TCS = ATDF.getNode("/avr-tools-device-file/modules/module@[name=\"TMR\"]/value-group@[name=\"T2CON__TCS\"]")

tmrBitField_T2CON_T32 = ATDF.getNode('/avr-tools-device-file/modules/module@[name="TMR"]/register-group@[name="TMR"]/register@[name="T2CON"]/bitfield@[name="T32"]')
tmrValGrp_T2CON_T32 = ATDF.getNode("/avr-tools-device-file/modules/module@[name=\"TMR\"]/value-group@[name=\"T2CON__T32\"]")

tmrBitField_PR2_BITS = ATDF.getNode('/avr-tools-device-file/modules/module@[name="TMR"]/register-group@[name="TMR"]/register@[name="PR2"]')

################################################################################
#### Global Variables ####
################################################################################

global PrescalerDict
PrescalerDict = {
                    "1:256 prescale value": 256,
                    "1:64 prescale value" : 64,
                    "1:32 prescale value" : 32,
                    "1:16 prescale value" : 16,
                    "1:8 prescale value"  : 8,
                    "1:4 prescale value"  : 4,
                    "1:2 prescale value"  : 2,
                    "1:1 prescale value"  : 1,
                }

################################################################################
#### Business Logic ####
################################################################################

def _get_enblReg_parms(vectorNumber):

    # This takes in vector index for interrupt, and returns the IECx register name as well as
    # mask and bit location within it for given interrupt
    index = int(vectorNumber / 32)
    regName = "IEC" + str(index)
    return regName

def _get_statReg_parms(vectorNumber):

    # This takes in vector index for interrupt, and returns the IFSx register name as well as
    # mask and bit location within it for given interrupt
    index = int(vectorNumber / 32)
    regName = "IFS" + str(index)
    return regName

def _get_bitfield_names(node, outputList):

    valueNodes = node.getChildren()

    for bitfield in valueNodes:   ##  do this for all <value > entries for this bitfield
        dict = {}
        if bitfield.getAttribute("caption").lower() != "reserved":  ##  skip (unused) reserved fields
            dict["desc"] = bitfield.getAttribute("caption")
            dict["key"] = bitfield.getAttribute("caption")

            ##  Get rid of leading '0x', and convert to int if was hex
            value = bitfield.getAttribute("value")

            if(value[:2] == "0x"):
                temp = value[2:]
                tempint = int(temp, 16)
            else:
                tempint = int(value)

            dict["value"] = str(tempint)
            outputList.append(dict)

def getIRQnumber(string):

    interruptsChildren = ATDF.getNode('/avr-tools-device-file/devices/device/interrupts').getChildren()

    for param in interruptsChildren:
        name = param.getAttribute("name")
        if string == name:
            irq_index = param.getAttribute("index")
            break

    return irq_index

###################################################################################################
########################################## Callbacks  #############################################
###################################################################################################

def setTMRInterruptData(status):

    Database.setSymbolValue("core", tmrInterruptVector, status, 1)
    Database.setSymbolValue("core", tmrInterruptHandlerLock, status, 1)

    interruptName = tmrInterruptHandler.split("_INTERRUPT_HANDLER")[0]

    if status == True:
        Database.setSymbolValue("core", tmrInterruptHandler, interruptName + "_InterruptHandler", 1)
    else:
        Database.setSymbolValue("core", tmrInterruptHandler, interruptName + "_Handler", 1)

def updateTMRInterruptData(symbol, event):

    if event["id"] == "TMR_INTERRUPT_MODE":
        setTMRInterruptData(event["value"])

    if tmrSymInterruptMode.getValue() == True and Database.getSymbolValue("core", tmrInterruptVectorUpdate) == True:
        symbol.setVisible(True)
    else:
        symbol.setVisible(False)

def timerModeMax(symbol, event):

    if int(event["symbol"].getKeyValue(event["value"])) == 1:
        symbol.setMax(4294967295)
    else:
        symbol.setMax(65535)

def T2CONcombineValues(symbol, event):

    t2conValue = symbol.getValue()

    if event["id"] == "TIMER_SIDL":
        sidlValue = int(event["symbol"].getKeyValue(event["value"]))
        maskvalue = tmrBitField_T2CON_SIDL.getAttribute("mask")
        t2conValue = t2conValue & (~int(maskvalue, 0))
        t2conValue = t2conValue | (sidlValue << 13)

    if event["id"] == "TIMER_PRE_SCALER":
        prescalerValue = int(event["symbol"].getKeyValue(event["value"]))
        maskvalue = tmrBitField_T2CON_PRESCALER.getAttribute("mask")
        t2conValue = t2conValue & (~int(maskvalue, 0))
        t2conValue = t2conValue | (prescalerValue << 4)

    if event["id"] == "TIMER_32BIT_MODE_SEL":
        T32Value = int(event["symbol"].getKeyValue(event["value"]))
        maskvalue = tmrBitField_T2CON_T32.getAttribute("mask")
        t2conValue = t2conValue & (~int(maskvalue, 0))
        t2conValue = t2conValue | (T32Value << 3)

    if event["id"] == "TIMER_SRC_SEL":
        tmrSrcSelValue = int(event["symbol"].getKeyValue(event["value"]))
        maskvalue = tmrBitField_T2CON_TCS.getAttribute("mask")
        t2conValue = t2conValue & (~int(maskvalue, 0))
        t2conValue = t2conValue | (tmrSrcSelValue << 1)

    symbol.setValue(t2conValue, 2)

def PreScaler_ValueUpdate(symbol, event):

    symbol.setValue(PrescalerDict[event["symbol"].getKey(event["value"])], 1)

###################################################################################################
########################################## Component  #############################################
###################################################################################################

def instantiateComponent(tmrComponent):

    global tmrInstanceName
    global tmrInterruptVector
    global tmrInterruptHandlerLock
    global tmrInterruptHandler
    global tmrInterruptVectorUpdate
    global tmrSymInterruptMode

    tmrInstanceName = tmrComponent.createStringSymbol("TMR_INSTANCE_NAME", None)
    tmrInstanceName.setVisible(False)
    tmrInstanceName.setDefaultValue(tmrComponent.getID().upper())
    Log.writeInfoMessage("Running " + tmrInstanceName.getValue())

    tmrInstanceNum = tmrComponent.createStringSymbol("TMR_INSTANCE_NUM", None)
    tmrInstanceNum.setVisible(False)
    instanceNum = filter(str.isdigit,str(tmrComponent.getID()))
    tmrInstanceNum.setDefaultValue(instanceNum)

    tmrSymInterruptMode = tmrComponent.createBooleanSymbol("TMR_INTERRUPT_MODE", None)
    tmrSymInterruptMode.setLabel("Enable Interrrupts ?")
    tmrSymInterruptMode.setDefaultValue(True)

    #Calculate the proper interrupt registers using IRQ#
    tmrIrq = "TIMER_" + str(instanceNum)
    tmrInterruptVector = tmrIrq + "_INTERRUPT_ENABLE"
    tmrInterruptHandler = tmrIrq + "_INTERRUPT_HANDLER"
    tmrInterruptHandlerLock = tmrIrq + "_INTERRUPT_HANDLER_LOCK"
    tmrInterruptVectorUpdate = tmrIrq + "_INTERRUPT_ENABLE_UPDATE"
    tmrIrq_index = int(getIRQnumber(tmrIrq))

    enblRegName = _get_enblReg_parms(tmrIrq_index)
    statRegName = _get_statReg_parms(tmrIrq_index)

    #IEC REG
    tmrIEC = tmrComponent.createStringSymbol("TMR_IEC_REG", None)
    tmrIEC.setDefaultValue(enblRegName)
    tmrIEC.setVisible(False)

    #IFS REG
    tmrIFS = tmrComponent.createStringSymbol("TMR_IFS_REG", None)
    tmrIFS.setDefaultValue(statRegName)
    tmrIFS.setVisible(False)

    #timer SIDL configuration
    sidl_names = []
    _get_bitfield_names(tmrValGrp_T2CON_SIDL, sidl_names)
    tmrSymField_T2CON_SIDL = tmrComponent.createKeyValueSetSymbol("TIMER_SIDL", None)
    tmrSymField_T2CON_SIDL.setLabel(tmrBitField_T2CON_SIDL.getAttribute("caption"))
    tmrSymField_T2CON_SIDL.setOutputMode( "Value" )
    tmrSymField_T2CON_SIDL.setDisplayMode( "Description" )
    for ii in sidl_names:
        tmrSymField_T2CON_SIDL.addKey( ii['key'],ii['value'], ii['desc'] )
    tmrSymField_T2CON_SIDL.setDefaultValue(1)

    #timer on off configuration
    on_names = []
    _get_bitfield_names(tmrValGrp_T2CON_ON, on_names)
    tmrSym_T2CON_ON = tmrComponent.createKeyValueSetSymbol("TIMER_START", None)
    tmrSym_T2CON_ON.setLabel(tmrBitField_T2CON_ON.getAttribute("caption"))
    tmrSym_T2CON_ON.setOutputMode( "Value" )
    tmrSym_T2CON_ON.setDisplayMode( "Description" )
    for ii in on_names:
        tmrSym_T2CON_ON.addKey( ii['key'],ii['value'], ii['desc'] )
    tmrSym_T2CON_ON.setDefaultValue(1)
    tmrSym_T2CON_ON.setVisible(False)

    #prescaler configuration
    prescale_names = []
    _get_bitfield_names(tmrValGrp_T2CON_PRESCALER, prescale_names)
    tmrSym_T2CON_PRESCALER = tmrComponent.createKeyValueSetSymbol("TIMER_PRE_SCALER", None)
    tmrSym_T2CON_PRESCALER.setLabel(tmrBitField_T2CON_PRESCALER.getAttribute("caption"))
    tmrSym_T2CON_PRESCALER.setOutputMode("Value")
    tmrSym_T2CON_PRESCALER.setDisplayMode("Description")
    for ii in prescale_names:
        tmrSym_T2CON_PRESCALER.addKey( ii['desc'], ii['value'], ii['key'] )
    tmrSym_T2CON_PRESCALER.setDefaultValue(0)
    tmrSym_T2CON_PRESCALER.setVisible(False)

    #Prescaler Value
    tmrPrescalerValue = tmrComponent.createIntegerSymbol("TMR_PRESCALER_VALUE", None)
    tmrPrescalerValue.setVisible(False)
    tmrPrescalerValue.setLabel("Prescaler Value")
    tmrPrescalerValue.setDescription("Timer Prescaler value")
    tmrPrescalerValue.setDefaultValue(256)
    tmrPrescalerValue.setMin(1)
    tmrPrescalerValue.setDependencies(PreScaler_ValueUpdate, ["TIMER_PRE_SCALER"])

     #32 bit timer mode selection bits
    t32_names = []
    _get_bitfield_names(tmrValGrp_T2CON_T32, t32_names)
    tmrSym_T2CON_32BIT_MODE_SEL = tmrComponent.createKeyValueSetSymbol("TIMER_32BIT_MODE_SEL", None)
    tmrSym_T2CON_32BIT_MODE_SEL.setLabel(tmrBitField_T2CON_T32.getAttribute("caption"))
    tmrSym_T2CON_32BIT_MODE_SEL.setOutputMode("Value")
    tmrSym_T2CON_32BIT_MODE_SEL.setDisplayMode("Description")
    for ii in t32_names:
        tmrSym_T2CON_32BIT_MODE_SEL.addKey( ii['desc'], ii['value'], ii['key'] )
    tmrSym_T2CON_32BIT_MODE_SEL.setDefaultValue(1)
    tmrSym_T2CON_32BIT_MODE_SEL.setReadOnly(True)

    #Timer clock Source Slection configuration
    tcs_names = []
    _get_bitfield_names(tmrValGrp_T2CON_TCS, tcs_names)
    tmrSym_T2CON_SOURCE_SEL = tmrComponent.createKeyValueSetSymbol("TIMER_SRC_SEL", None)
    tmrSym_T2CON_SOURCE_SEL.setLabel(tmrBitField_T2CON_TCS.getAttribute("caption"))
    tmrSym_T2CON_SOURCE_SEL.setOutputMode("Value")
    tmrSym_T2CON_SOURCE_SEL.setDisplayMode("Description")
    for ii in tcs_names:
        tmrSym_T2CON_SOURCE_SEL.addKey( ii['desc'], ii['value'], ii['key'] )
    tmrSym_T2CON_SOURCE_SEL.setDefaultValue(1)

    #Timer TxCON Reg Value
    tmrSym_T2CON_Value = tmrComponent.createHexSymbol("TCON_REG_VALUE",None)
    tmrSym_T2CON_Value.setDefaultValue((int(tmrSymField_T2CON_SIDL.getSelectedValue()) << 13) | (int (tmrSym_T2CON_PRESCALER.getSelectedValue()) << 4) \
    | (int(tmrSym_T2CON_32BIT_MODE_SEL.getSelectedValue()) << 3) | (int(tmrSym_T2CON_SOURCE_SEL.getSelectedValue()) << 1))
    tmrSym_T2CON_Value.setVisible(False)
    tmrSym_T2CON_Value.setDependencies(T2CONcombineValues,["TIMER_SIDL", "TIMER_PRE_SCALER", "TIMER_32BIT_MODE_SEL", "TIMER_SRC_SEL"])

    #Timer Period Register
    tmrSym_PR2 = tmrComponent.createLongSymbol("TIMER_PERIOD", None)
    tmrSym_PR2.setLabel(tmrBitField_PR2_BITS.getAttribute("caption"))
    tmrSym_PR2.setDefaultValue(64000)
    tmrSym_PR2.setMin(0)

    # 16 bit mode
    if((tmrSym_T2CON_32BIT_MODE_SEL.getSelectedValue) == 0):
        tmrSym_PR2.setMax(65535)
    #32 bit mode
    else:
        tmrSym_PR2.setMax(4294967295)

    tmrSym_PR2.setDependencies(timerModeMax, ["TIMER_32BIT_MODE_SEL"])

    ############################################################################
    #### Dependency ####
    ############################################################################

    ## EVIC Interrupt Dynamic settings
    setTMRInterruptData(tmrSymInterruptMode.getValue())

    tmrSymIntEnComment = tmrComponent.createCommentSymbol("TMR_INTRRUPT_ENABLE_COMMENT", None)
    tmrSymIntEnComment.setLabel("Warning!!! " + tmrInstanceName.getValue() + " Interrupt is Disabled in Interrupt Manager")
    tmrSymIntEnComment.setVisible(False)
    tmrSymIntEnComment.setDependencies(updateTMRInterruptData, ["TMR_INTERRUPT_MODE", "core." + tmrInterruptVectorUpdate])

    ###################################################################################################
    ####################################### Code Generation  ##########################################
    ###################################################################################################

    configName = Variables.get("__CONFIGURATION_NAME")

    tmrHeaderFile = tmrComponent.createFileSymbol("TMR_COMMON_HEADER", None)
    tmrHeaderFile.setSourcePath("../peripheral/tmr_00745/templates/plib_tmr_common.h")
    tmrHeaderFile.setOutputName("plib_tmr_common.h")
    tmrHeaderFile.setDestPath("peripheral/tmr/")
    tmrHeaderFile.setProjectPath("config/" + configName + "/peripheral/tmr/")
    tmrHeaderFile.setType("HEADER")
    tmrHeaderFile.setMarkup(False)
    tmrHeaderFile.setOverwrite(True)

    # Instance Header File
    tmrHeaderFile = tmrComponent.createFileSymbol("TMR_HEADER1", None)
    tmrHeaderFile.setSourcePath("../peripheral/tmr_00745/templates/plib_tmr.h.ftl")
    tmrHeaderFile.setOutputName("plib_" + tmrInstanceName.getValue().lower() + ".h")
    tmrHeaderFile.setDestPath("/peripheral/tmr/")
    tmrHeaderFile.setProjectPath("config/" + configName + "/peripheral/tmr/")
    tmrHeaderFile.setType("HEADER")
    tmrHeaderFile.setMarkup(True)
    tmrHeaderFile.setOverwrite(True)

    # Instance Source File
    tmrSourceFile = tmrComponent.createFileSymbol("TMR_SOURCE", None)
    tmrSourceFile.setSourcePath("../peripheral/tmr_00745/templates/plib_tmr.c.ftl")
    tmrSourceFile.setOutputName("plib_" + tmrInstanceName.getValue().lower() + ".c")
    tmrSourceFile.setDestPath("/peripheral/tmr/")
    tmrSourceFile.setProjectPath("config/" + configName + "/peripheral/tmr/")
    tmrSourceFile.setType("SOURCE")
    tmrSourceFile.setMarkup(True)
    tmrSourceFile.setOverwrite(True)

    tmrSym_SystemInitFile = tmrComponent.createFileSymbol("TMR_SYS_INT", None)
    tmrSym_SystemInitFile.setType("STRING")
    tmrSym_SystemInitFile.setOutputName("core.LIST_SYSTEM_INIT_C_SYS_INITIALIZE_PERIPHERALS")
    tmrSym_SystemInitFile.setSourcePath("../peripheral/tmr_00745/templates/system/system_initialize.c.ftl")
    tmrSym_SystemInitFile.setMarkup(True)

    tmrSym_SystemDefFile = tmrComponent.createFileSymbol("TMR_SYS_DEF", None)
    tmrSym_SystemDefFile.setType("STRING")
    tmrSym_SystemDefFile.setOutputName("core.LIST_SYSTEM_DEFINITIONS_H_INCLUDES")
    tmrSym_SystemDefFile.setSourcePath("../peripheral/tmr_00745/templates/system/system_definitions.h.ftl")
    tmrSym_SystemDefFile.setMarkup(True)
