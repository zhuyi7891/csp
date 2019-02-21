"""*****************************************************************************
* Copyright (C) 2019 Microchip Technology Inc. and its subsidiaries.
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

###################################################################################################
#################################### Global Variables #############################################
###################################################################################################

global interruptsChildren

interruptsChildren = ATDF.getNode('/avr-tools-device-file/devices/device/interrupts').getChildren()

###################################################################################################
######################################### Functions ###############################################
###################################################################################################

def getIRQnumber(string):

    for param in interruptsChildren:
        name = param.getAttribute("name")
        if string == name:
            irq_index = param.getAttribute("index")
            break

    return irq_index

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

def setI2CInterruptData(status):

    for id in InterruptVector:
        Database.setSymbolValue("core", id, status, 1)

    for id in InterruptHandlerLock:
        Database.setSymbolValue("core", id, status, 1)

    for id in InterruptHandler:
        interruptName = id.split("_INTERRUPT_HANDLER")[0]
        if status == True:
            Database.setSymbolValue("core", id, interruptName + "_InterruptHandler", 1)
        else:
            Database.setSymbolValue("core", id, interruptName + "_Handler", 1)

###################################################################################################
########################################## Callbacks  #############################################
###################################################################################################

def updateI2CInterruptData(symbol, event):

    status = False

    for id in InterruptVectorUpdate:
        id = id.replace("core.", "")
        if Database.getSymbolValue("core", id) == True:
            status = True
            break

    if status == True:
        symbol.setVisible(True)
    else:
        symbol.setVisible(False)

# Calculates BRG value
def baudRateCalc(clk, baud):
    # Equation from FRM
    #I2CxBRG = [PBCLK/(2*FSCK) - (PBCLK*TPGOB)/2]  - 1
    #where TPGD = 130ns

    I2CxBRG = (clk / (2 * baud) - (clk * 0.000000104) / 2)  - 1

    if I2CxBRG < 3:
        I2CxBRG = 3

    return int(I2CxBRG)

def baudRateTrigger(symbol, event):

    clk = int(Database.getSymbolValue("core", "CONFIG_SYS_CLK_PBCLK2_FREQ"))
    baud = int(i2cSym_BAUD.getValue())

    brgVal = baudRateCalc(clk, baud)
    symbol.setValue(brgVal, 2)

def i2cSourceFreq(symbol, event):

    symbol.setValue(int(Database.getSymbolValue("core", "CONFIG_SYS_CLK_PBCLK2_FREQ")), 2)

###################################################################################################
########################################## Component  #############################################
###################################################################################################

def instantiateComponent(i2cComponent):

    global i2cInstanceName
    global InterruptVector
    global InterruptHandlerLock
    global InterruptHandler
    global InterruptVectorUpdate
    global i2cSym_BAUD

    InterruptVector = []
    InterruptHandler = []
    InterruptHandlerLock = []
    InterruptVectorUpdate = []

    i2cInstanceName = i2cComponent.createStringSymbol("I2C_INSTANCE_NAME", None)
    i2cInstanceName.setVisible(False)
    i2cInstanceName.setDefaultValue(i2cComponent.getID().upper())

    ## I2C Clock Frequency
    i2cSym_ClkValue = i2cComponent.createIntegerSymbol("I2C_CLOCK_FREQ", None)
    i2cSym_ClkValue.setLabel("I2C Clock Frequency")
    i2cSym_ClkValue.setReadOnly(True)
    i2cSym_ClkValue.setDefaultValue(int(Database.getSymbolValue("core", "CONFIG_SYS_CLK_PBCLK2_FREQ")))
    i2cSym_ClkValue.setDependencies(i2cSourceFreq, ["core." + "CONFIG_SYS_CLK_PBCLK2_FREQ"])

    #DISSLW: Slew Rate Control Disable bit
    i2cSym_SlewRateControl = i2cComponent.createBooleanSymbol("I2C_DISSLW", None)
    i2cSym_SlewRateControl.setLabel("Disable Slew Rate Control")

    #SMEN: SMBus Input Levels bit
    i2cSym_SMBusInputLevels = i2cComponent.createBooleanSymbol("I2C_SMEN", None)
    i2cSym_SMBusInputLevels.setLabel("SMBus Input Levels")

    #SIDL: Stop in Idle Mode bit
    i2cSym_StopInIdleMode = i2cComponent.createBooleanSymbol("I2C_SIDL", None)
    i2cSym_StopInIdleMode.setLabel("Stop in Idle Mode bit")

    #Baud Rate
    i2cSym_BAUD = i2cComponent.createLongSymbol("I2C_CLOCK_SPEED", None)
    i2cSym_BAUD.setLabel("I2C Baud Rate")
    i2cSym_BAUD.setDefaultValue(50000)
    i2cSym_BAUD.setMin(1)

    ## Baud Rate Frequency dependency
    i2cSym_BRGValue = i2cComponent.createIntegerSymbol("BRG_VALUE", None)
    i2cSym_BRGValue.setDefaultValue(baudRateCalc(i2cSym_ClkValue.getValue(), i2cSym_BAUD.getValue()))
    i2cSym_BRGValue.setVisible(False)
    i2cSym_BRGValue.setDependencies(baudRateTrigger, ["I2C_CLOCK_SPEED", "core." + "CONFIG_SYS_CLK_PBCLK2_FREQ"])

    ## Master Interrupt Setup
    i2cMasterInt = i2cInstanceName.getValue() + "_MASTER"
    InterruptVector.append(i2cMasterInt + "_INTERRUPT_ENABLE")
    InterruptHandler.append(i2cMasterInt + "_INTERRUPT_HANDLER")
    InterruptHandlerLock.append(i2cMasterInt + "_INTERRUPT_HANDLER_LOCK")
    InterruptVectorUpdate.append("core." + i2cMasterInt + "_INTERRUPT_ENABLE_UPDATE")

    MasterVectorNum = int(getIRQnumber(i2cMasterInt))
    enblRegName = _get_enblReg_parms(MasterVectorNum)
    statRegName = _get_statReg_parms(MasterVectorNum)

    #IEC REG
    i2cMasterIntIEC = i2cComponent.createStringSymbol("I2C_MASTER_IEC_REG", None)
    i2cMasterIntIEC.setDefaultValue(enblRegName)
    i2cMasterIntIEC.setVisible(False)

    #IFS REG
    i2cMasterIntIFS = i2cComponent.createStringSymbol("I2C_MASTER_IFS_REG", None)
    i2cMasterIntIFS.setDefaultValue(statRegName)
    i2cMasterIntIFS.setVisible(False)

    ## Slave Interrupt Setup
    i2cSlaveInt = i2cInstanceName.getValue() + "_SLAVE"
    SlaveVectorNum = int(getIRQnumber(i2cSlaveInt))
    enblRegName = _get_enblReg_parms(SlaveVectorNum)
    statRegName = _get_statReg_parms(SlaveVectorNum)

    #IEC REG
    i2cSlaveIntIEC = i2cComponent.createStringSymbol("I2C_SLAVE_IEC_REG", None)
    i2cSlaveIntIEC.setDefaultValue(enblRegName)
    i2cSlaveIntIEC.setVisible(False)

    #IFS REG
    i2cSlaveIntIFS = i2cComponent.createStringSymbol("I2C_SLAVE_IFS_REG", None)
    i2cSlaveIntIFS.setDefaultValue(statRegName)
    i2cSlaveIntIFS.setVisible(False)

    ## Bus Error Interrupt Setup
    i2cBusInt = i2cInstanceName.getValue() + "_BUS"
    InterruptVector.append(i2cBusInt + "_INTERRUPT_ENABLE")
    InterruptHandler.append(i2cBusInt + "_INTERRUPT_HANDLER")
    InterruptHandlerLock.append(i2cBusInt + "_INTERRUPT_HANDLER_LOCK")
    InterruptVectorUpdate.append("core." + i2cBusInt + "_INTERRUPT_ENABLE_UPDATE")

    BusVectorNum = int(getIRQnumber(i2cBusInt))
    enblRegName = _get_enblReg_parms(BusVectorNum)
    statRegName = _get_statReg_parms(BusVectorNum)

    #IEC REG
    i2cBusIntIEC = i2cComponent.createStringSymbol("I2C_BUS_IEC_REG", None)
    i2cBusIntIEC.setDefaultValue(enblRegName)
    i2cBusIntIEC.setVisible(False)

    #IFS REG
    i2cBusIntIFS = i2cComponent.createStringSymbol("I2C_BUS_IFS_REG", None)
    i2cBusIntIFS.setDefaultValue(statRegName)
    i2cBusIntIFS.setVisible(False)

    ############################################################################
    #### Dependency ####
    ############################################################################

    ## EVIC Interrupt Dynamic settings
    setI2CInterruptData(True)

    i2cSymIntEnComment = i2cComponent.createCommentSymbol("I2C_INTRRUPT_ENABLE_COMMENT", None)
    i2cSymIntEnComment.setLabel("Warning!!! " + i2cInstanceName.getValue() + " Interrupt is Disabled in Interrupt Manager")
    i2cSymIntEnComment.setVisible(False)
    i2cSymIntEnComment.setDependencies(updateI2CInterruptData, InterruptVectorUpdate)

    ###################################################################################################
    ####################################### Driver Symbols ############################################
    ###################################################################################################

    #I2C API Prefix
    i2cSym_API_Prefix = i2cComponent.createStringSymbol("I2C_PLIB_API_PREFIX", None)
    i2cSym_API_Prefix.setDefaultValue(i2cInstanceName.getValue())
    i2cSym_API_Prefix.setVisible(False)

    ###################################################################################################
    ####################################### Code Generation  ##########################################
    ###################################################################################################

    configName = Variables.get("__CONFIGURATION_NAME")

    i2cHeaderFile = i2cComponent.createFileSymbol("I2C_HEADER", None)
    i2cHeaderFile.setSourcePath("../peripheral/i2c_01441/templates/plib_i2c.h.ftl")
    i2cHeaderFile.setOutputName("plib_" + i2cInstanceName.getValue().lower() + ".h")
    i2cHeaderFile.setDestPath("peripheral/i2c/")
    i2cHeaderFile.setProjectPath("config/" + configName +"/peripheral/i2c/")
    i2cHeaderFile.setType("HEADER")
    i2cHeaderFile.setMarkup(True)

    i2cGlobalHeaderFile = i2cComponent.createFileSymbol("I2C_GLOBALHEADER", None)
    i2cGlobalHeaderFile.setSourcePath("../peripheral/i2c_01441/plib_i2c_master.h")
    i2cGlobalHeaderFile.setOutputName("plib_i2c_master.h")
    i2cGlobalHeaderFile.setDestPath("peripheral/i2c/")
    i2cGlobalHeaderFile.setProjectPath("config/" + configName +"/peripheral/i2c/")
    i2cGlobalHeaderFile.setType("HEADER")

    i2cSource1File = i2cComponent.createFileSymbol("I2C_SOURCE", None)
    i2cSource1File.setSourcePath("../peripheral/i2c_01441/templates/plib_i2c.c.ftl")
    i2cSource1File.setOutputName("plib_" + i2cInstanceName.getValue().lower() + ".c")
    i2cSource1File.setDestPath("peripheral/i2c/")
    i2cSource1File.setProjectPath("config/" + configName +"/peripheral/i2c/")
    i2cSource1File.setType("SOURCE")
    i2cSource1File.setMarkup(True)

    i2cSystemInitFile = i2cComponent.createFileSymbol("I2C_INIT", None)
    i2cSystemInitFile.setType("STRING")
    i2cSystemInitFile.setOutputName("core.LIST_SYSTEM_INIT_C_SYS_INITIALIZE_PERIPHERALS")
    i2cSystemInitFile.setSourcePath("../peripheral/i2c_01441/templates/system/initialization.c.ftl")
    i2cSystemInitFile.setMarkup(True)

    i2cSystemDefFile = i2cComponent.createFileSymbol("I2C_DEF", None)
    i2cSystemDefFile.setType("STRING")
    i2cSystemDefFile.setOutputName("core.LIST_SYSTEM_DEFINITIONS_H_INCLUDES")
    i2cSystemDefFile.setSourcePath("../peripheral/i2c_01441/templates/system/definitions.h.ftl")
    i2cSystemDefFile.setMarkup(True)