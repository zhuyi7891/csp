#********************** Static Memory Controller Module ***********************

#------------------------------------------------------------------------------
#								Dependency Functions
#------------------------------------------------------------------------------

# Function to convert Bitfield mask string to Integer
def smcConvertMaskToInt(smcRegMask):
	smcHexStr 	= smcRegMask.rstrip("0")
	print("smcHexStr: " + str(smcHexStr))
	smcIntValue = int(smcHexStr, 0)

	return smcIntValue

# Dependency function definition to enable visibility based on the selection of Off-Chip Memory Scrambling and Chip Select enable
def smcMemScrambChipSelVisible(symbol, event):
	id = symbol.getID()[-1]
	smcChipSelNum = int(id)

	smcComp 		= symbol.getComponent()
	smcGetScramble 	= smcComp.getSymbolValue("SMC_MEM_SCRAMBLING")
	smcGetChipSelEn = smcComp.getSymbolValue("SMC_CHIP_SELECT" + str(smcChipSelNum))

	if (0 == smcChipSelNum):
		smcSym_OCMS_CSSE[smcChipSelNum].setDefaultValue(smcRegBitField_OCMS_CS0SE_MASK)
	elif (1 == smcChipSelNum) :
		smcSym_OCMS_CSSE[smcChipSelNum].setDefaultValue(smcRegBitField_OCMS_CS1SE_MASK)
	elif (2 == smcChipSelNum) :
		smcSym_OCMS_CSSE[smcChipSelNum].setDefaultValue(smcRegBitField_OCMS_CS2SE_MASK)
	elif (3 == smcChipSelNum) :
		smcSym_OCMS_CSSE[smcChipSelNum].setDefaultValue(smcRegBitField_OCMS_CS3SE_MASK)		


	if (smcGetScramble == True and smcGetChipSelEn == True):
		print("Enabled Memory Scrambling on Chip Select number : " + str(smcChipSelNum))
		smcSym_OCMS_CS_SE[smcChipSelNum].setVisible(True)
	else :
		print("Disabled Memory Scrambling on Chip Select number : " + str(smcChipSelNum))
		smcSym_OCMS_CS_SE[smcChipSelNum].setVisible(False)

	if (smcGetChipSelEn == True):
		smcSym_CS_Setting[smcChipSelNum].setVisible(True)
	else :
		smcSym_CS_Setting[smcChipSelNum].setVisible(False)

# Dependency function definition to enable visibility based on selection of Page Mode Enable	
def smcMemoryPageSizeModeVisible(symbol, event):
	id = symbol.getID()[-1]
	smcChipSelNum = int(id)

	smcMemPageSizeEnableMode = symbol.getComponent().getSymbolByID(event["id"])

	if(smcMemPageSizeEnableMode.getValue() == True):
		print("Enabled External Memory Page Size on Chip Select number : " + str(smcChipSelNum))
		smcSym_MODE_PS[smcChipSelNum].setVisible(True)
	else :
		print("Disabled External Memory Page Size on Chip Select number : " + str(smcChipSelNum))
		smcSym_MODE_PS[smcChipSelNum].setVisible(False)

# Dependency functions definitions to enable visibility based on selection of TDF Optimization
def smcTdfCyclesModeVisible(symbol, event):
	id = symbol.getID()[-1]
	smcChipSelNum = int(id)

	smcTdfCyclesEnableMode = symbol.getComponent().getSymbolByID(event["id"])

	if(smcTdfCyclesEnableMode.getValue() == True):
		print("Enabled TDF Cycle on Chip Select number : " + str(smcChipSelNum))
		smcSym_MODE_TDF_CYCLES[smcChipSelNum].setVisible(True)
	else :
		print("Disabled TDF Cycle on Chip Select number : " + str(smcChipSelNum))
		smcSym_MODE_TDF_CYCLES[smcChipSelNum].setVisible(False)

# Dependency function definition to enable visibility based on selection of Byte Access Type
def smcByteAccessSelModeVisible(symbol, event):
	id = symbol.getID()[-1]
	smcChipSelNum = int(id)

	smcByetAccessSelEnableMode = symbol.getComponent().getSymbolByID(event["id"])

	if(smcByetAccessSelEnableMode.getValue() == "_16_BIT"):
		print("Enabled Byte Select Type on Chip Select number : " + str(smcChipSelNum))
		smcSym_MODE_BAT[smcChipSelNum].setVisible(True)
	else :
		print("Dosabled Byte Select Type on Chip Select number : " + str(smcChipSelNum))
		smcSym_MODE_BAT[smcChipSelNum].setVisible(False)

# Get SMC Register
smcRegModule = Register.getRegisterModule("SMC")

#------------------------------------------------------------------------------
# 				SMC Register | Bitfield | Mask | Value Group
#------------------------------------------------------------------------------

# SMC Chip Select Register Group
smcRegGroup = smcRegModule.getRegisterGroup("SMC_CS_NUMBER")

# SMC_SETUP Register Bitfield Names and Mask
smcReg_SETUP = smcRegGroup.getRegister("SMC_SETUP")
smcRegBitField_SETUP_NWE_SETUP 			= smcReg_SETUP.getBitfield("NWE_SETUP")
smcRegBitField_SETUP_NWE_SETUP_MASK		= smcConvertMaskToInt("0x0000003F")
smcRegBitField_SETUP_NCS_WR_SETUP 		= smcReg_SETUP.getBitfield("NCS_WR_SETUP")
smcRegBitField_SETUP_NCS_WR_SETUP_MASK	= smcConvertMaskToInt("0x00003F00")
smcRegBitField_SETUP_NRD_SETUP 			= smcReg_SETUP.getBitfield("NRD_SETUP")
smcRegBitField_SETUP_NRD_SETUP_MASK		= smcConvertMaskToInt("0x003F0000")
smcRegBitField_SETUP_NCS_RD_SETUP 		= smcReg_SETUP.getBitfield("NCS_RD_SETUP")
smcRegBitField_SETUP_NCS_RD_SETUP_MASK	= smcConvertMaskToInt("0x3F000000")

# SMC_PULSE Register Bitfield Names and Mask
smcReg_PULSE = smcRegGroup.getRegister("SMC_PULSE")
smcRegBitField_PULSE_NWE_PULSE 			= smcReg_PULSE.getBitfield("NWE_PULSE")
smcRegBitField_PULSE_NWE_PULSE_MASK		= smcConvertMaskToInt("0x0000003F")
smcRegBitField_PULSE_NCS_WR_PULSE		= smcReg_PULSE.getBitfield("NCS_WR_PULSE")
smcRegBitField_PULSE_NCS_WR_PULSE_MASK	= smcConvertMaskToInt("0x00003F00")
smcRegBitField_PULSE_NRD_PULSE			= smcReg_PULSE.getBitfield("NRD_PULSE")
smcRegBitField_PULSE_NRD_PULSE_MASK		= smcConvertMaskToInt("0x003F0000")
smcRegBitField_PULSE_NCS_RD_PULSE		= smcReg_PULSE.getBitfield("NCS_RD_PULSE")
smcRegBitField_PULSE_NCS_RD_PULSE_MASK	= smcConvertMaskToInt("0x3F000000")

# SMC_CYCLE Register Bitfield Names and Mask
smcReg_CYCLE = smcRegGroup.getRegister("SMC_CYCLE")
smcRegBitField_CYCLE_NWE_CYCLE 		= smcReg_CYCLE.getBitfield("NWE_CYCLE")
smcRegBitField_CYCLE_NWE_CYCLE_MASK	= smcConvertMaskToInt("0x000001FF")
smcRegBitField_CYCLE_NRD_CYCLE 		= smcReg_CYCLE.getBitfield("NRD_CYCLE")
smcRegBitField_CYCLE_NRD_CYCLE_MASK	= smcConvertMaskToInt("0x01FF0000")

# SMC_Mode Register Bitfield Names and Mask
smcReg_MODE = smcRegGroup.getRegister("SMC_MODE")
smcRegBitField_MODE_EXNW_MODE 		= smcReg_MODE.getBitfield("EXNW_MODE")
smcRegBitField_MODE_BAT 			= smcReg_MODE.getBitfield("BAT")
smcRegBitField_MODE_DBW 			= smcReg_MODE.getBitfield("DBW")
smcRegBitField_MODE_PS 				= smcReg_MODE.getBitfield("PS")
smcRegBitField_MODE_TDF_CYCLES		= smcReg_MODE.getBitfield("TDF_CYCLES")
smcRegBitField_MODE_TDF_CYCLES_MASK	= smcConvertMaskToInt("0x000F0000")

# SMC_MODE Register Bitfield Value Groups
smcValGrp_MODE_EXNW_MODE 	= smcRegModule.getValueGroup(smcRegBitField_MODE_EXNW_MODE.getValueGroupName())
smcValGrp_MODE_BAT 			= smcRegModule.getValueGroup(smcRegBitField_MODE_BAT.getValueGroupName())
smcValGrp_MODE_DBW 			= smcRegModule.getValueGroup(smcRegBitField_MODE_DBW.getValueGroupName())
smcValGrp_MODE_PS 			= smcRegModule.getValueGroup(smcRegBitField_MODE_PS.getValueGroupName())

# SMC Register Group
smcRegGroupSMC = smcRegModule.getRegisterGroup("SMC")

# SMC_OCMS : Off Chip Memory Scrambling Register Bitfield Names and Mask
smcReg_OCMS 					= smcRegGroupSMC.getRegister("SMC_OCMS")
smcRegBitField_OCMS_SMSE		= smcReg_OCMS.getBitfield("SMSE")
smcRegBitField_OCMS_CS0SE		= smcReg_OCMS.getBitfield("CS0SE")
smcRegBitField_OCMS_CS0SE_MASK	= smcConvertMaskToInt("0x00000100")
smcRegBitField_OCMS_CS1SE		= smcReg_OCMS.getBitfield("CS1SE")
smcRegBitField_OCMS_CS1SE_MASK	= smcConvertMaskToInt("0x00000200")
smcRegBitField_OCMS_CS2SE		= smcReg_OCMS.getBitfield("CS2SE")
smcRegBitField_OCMS_CS2SE_MASK	= smcConvertMaskToInt("0x00000400")
smcRegBitField_OCMS_CS3SE		= smcReg_OCMS.getBitfield("CS3SE")
smcRegBitField_OCMS_CS3SE_MASK	= smcConvertMaskToInt("0x00000800")

# SMC Write Protection Mode Register Bitefield Names and Value Group
smcReg_WPMR 				= smcRegGroupSMC.getRegister("SMC_WPMR")
smcRegBitField_WPMR_WPEN	= smcReg_WPMR.getBitfield("WPEN")
smcRegBitField_WPMR_WPKEY	= smcReg_WPMR.getBitfield("WPKEY")
smcValGrp_MODE_WPKEY 		= smcRegModule.getValueGroup(smcRegBitField_WPMR_WPKEY.getValueGroupName())

#------------------------------------------------------------------------------
# 					  Global SMC Array sysmbol declaration
#------------------------------------------------------------------------------

smcSym_CS = []
smcSym_OCMS_CSSE = []
smcSym_OCMS_CS_SE = []
smcSym_CS_Setting = []
smcSym_SETUP_TIMING_CS = []
smcSym_SETUP_NWE_CS = []
smcSym_SETUP_NCS_WR_CS = []
smcSym_SETUP_NRD_CS = []
smcSym_SETUP_NCS_RD_CS = []
smcSym_PULSE_TIMING_CS = []
smcSym_PULSE_NWE_CS = []
smcSym_PULSE_NCS_WR_CS = []
smcSym_PULSE_NRD_CS = []
smcSym_PULSE_NCS_RD_CS = []
smcSym_CYCLE_TIMING_CS = []
smcSym_CYCLE_TIMING_NWE_CS = []
smcSym_SMC_CYCLE_TIMING_NRD_CS = []
smcSym_MODE_CS_REGISTER = []
smcSym_MODE_DBW = []
smcSym_MODE_BAT = []
smcSym_MODE_PMEN = []
smcSym_MODE_PS = []
smcSym_MODE_TDF = []
smcSym_MODE_TDF_CYCLES = []
smcSym_MODE_EXNW = []
smcSym_MODE_READ = []
smcSym_MODE_WRITE = []

#------------------------------------------------------------------------------
#	 							Global Variables
#------------------------------------------------------------------------------

# Get the Chip Select Count from ATDF config file
global smcChipSelCount
global smcSym_CS_COUNT

#------------------------------------------------------------------------------
#									Constatns
#------------------------------------------------------------------------------

# Min Zero Value
SMC_DEFAULT_MIN_VALUE 				= 0

# Deafult value for SMC Setup Register
SMC_SETUP_DEFAULT_VALUE 			= 16

# Deafult value for SMC Pulse Register
SMC_PULSE_DEFAULT_VALUE 			= 16

# Deafult value for SMC Cycle Register
SMC_CYCLE_DEFAULT_VALUE 			= 3

# Deafult value for SMC MODE TDF CYCLE Register
SMC_MODE_TDF_CYCLES_DEFAULT_VALUE 	= 0

#------------------------------------------------------------------------------
# 						   Instantiate SMC Component
#------------------------------------------------------------------------------
def instantiateComponent(smcComponent):

	num = smcComponent.getID()[-1:]
	print"--------------------------------------------------------------------"
	print("************************** Running SMC"+ str(num) +" ****************************")
	print"--------------------------------------------------------------------"

	smcChipSelCount = smcRegGroup.getRegisterCount()
	print("Total available SMC Chip Select Count is : " + str(smcChipSelCount))

	smcMenu = smcComponent.createMenuSymbol(None, None)
	smcMenu.setLabel("SMC Configurations")

	# SMC Global features
	smcSym_GlobalFeat = smcComponent.createMenuSymbol("SMC_GLOBAL_FEAT", smcMenu)
	smcSym_GlobalFeat.setLabel("SMC Global Features")

	smcSym_WPMR_WPEN = smcComponent.createBooleanSymbol("SMC_WRITE_PROTECTION", smcSym_GlobalFeat)
	smcSym_WPMR_WPEN.setLabel("Enable write protection mode on SMC Timing registers?")
	smcSym_WPMR_WPEN.setDefaultValue(False)

	smcSymMenu_OCMS_SMSE = smcComponent.createMenuSymbol("SMC_MEM_SCRAMBLING_MENU", smcSym_GlobalFeat)
	smcSymMenu_OCMS_SMSE.setLabel("Memory Scrambling Configurations")

	smcSym_OCMS_SMSE = smcComponent.createBooleanSymbol("SMC_MEM_SCRAMBLING", smcSymMenu_OCMS_SMSE)
	smcSym_OCMS_SMSE.setLabel("Enable Memory Scrambling?")
	smcSym_OCMS_SMSE.setDefaultValue(False)

	#--------------------------------------------------------------------------
	# SMC Chip Select Selection and Settings
	#--------------------------------------------------------------------------
	smcSym_Chip_Select = smcComponent.createMenuSymbol("SMC_CHIP_SELECT", smcMenu)
	smcSym_Chip_Select.setLabel("SMC Chip Select Selection and Settings")

	smcSym_CS_COUNT = smcComponent.createIntegerSymbol("SMC_CHIP_SELECT_COUNT", smcSym_Chip_Select)
	smcSym_CS_COUNT.setDefaultValue(smcChipSelCount)
	smcSym_CS_COUNT.setVisible(False)

	for smcChipSelNum in range(0, smcChipSelCount):
		smcSym_CS.append(smcChipSelNum)
		smcSym_CS[smcChipSelNum] = smcComponent.createBooleanSymbol("SMC_CHIP_SELECT" + str(smcChipSelNum), smcSym_Chip_Select)
		smcSym_CS[smcChipSelNum].setLabel("Enable Chip Select "+ str(smcChipSelNum))

		if (smcChipSelNum == 0):
			smcSym_CS[smcChipSelNum].setDefaultValue(True)	
		else :
			smcSym_CS[smcChipSelNum].setDefaultValue(False)

		smcSym_OCMS_CSSE.append(smcChipSelNum)
		smcSym_OCMS_CSSE[smcChipSelNum] = smcComponent.createHexSymbol("SMC_OCMS_CS" + str(smcChipSelNum) + "SE_MASK", smcSym_CS[smcChipSelNum])
		smcSym_OCMS_CSSE[smcChipSelNum].setVisible(False)

		smcSym_OCMS_CS_SE.append(smcChipSelNum)
		smcSym_OCMS_CS_SE[smcChipSelNum] = smcComponent.createBooleanSymbol("SMC_MEM_SCRAMBLING_CS" + str(smcChipSelNum), smcSym_CS[smcChipSelNum])
		smcSym_OCMS_CS_SE[smcChipSelNum].setLabel("Enable Memory Scrambling on Chip Select - " + str(smcChipSelNum)+ "?")
		smcSym_OCMS_CS_SE[smcChipSelNum].setDefaultValue(False)
		smcSym_OCMS_CS_SE[smcChipSelNum].setVisible(False)
		smcSym_OCMS_CS_SE[smcChipSelNum].setDependencies(smcMemScrambChipSelVisible, ["SMC_MEM_SCRAMBLING" , "SMC_CHIP_SELECT" + str(smcChipSelNum)])

		smcSym_CS_Setting.append(smcChipSelNum)
		smcSym_CS_Setting[smcChipSelNum] = smcComponent.createMenuSymbol("SMC_SETUP_CS" + str(smcChipSelNum), smcSym_CS[smcChipSelNum])
		smcSym_CS_Setting[smcChipSelNum].setLabel("Chip Select " + str(smcChipSelNum) + " Setup")

		if (smcChipSelNum == 0):
			smcSym_CS_Setting[smcChipSelNum].setVisible(True)	
		else :
			smcSym_CS_Setting[smcChipSelNum].setVisible(False)


		smcSym_SETUP_TIMING_CS.append(smcChipSelNum)
		smcSym_SETUP_TIMING_CS[smcChipSelNum] = smcComponent.createMenuSymbol("SMC_SETUP_TIMING_CS" + str(smcChipSelNum), smcSym_CS_Setting[smcChipSelNum])
		smcSym_SETUP_TIMING_CS[smcChipSelNum].setLabel("SMC Setup Timings")

		# SMC Setup Timings
		smcSym_SETUP_NWE_CS.append(smcChipSelNum)
		smcSym_SETUP_NWE_CS[smcChipSelNum] = smcComponent.createIntegerSymbol("SMC_NWE_SETUP_CS" + str(smcChipSelNum), smcSym_SETUP_TIMING_CS[smcChipSelNum])
		smcSym_SETUP_NWE_CS[smcChipSelNum].setLabel(smcRegBitField_SETUP_NWE_SETUP.getDescription())
		smcSym_SETUP_NWE_CS[smcChipSelNum].setMin(SMC_DEFAULT_MIN_VALUE)
		smcSym_SETUP_NWE_CS[smcChipSelNum].setMax(smcRegBitField_SETUP_NWE_SETUP_MASK)
		smcSym_SETUP_NWE_CS[smcChipSelNum].setDefaultValue(SMC_SETUP_DEFAULT_VALUE)

		smcSym_SETUP_NCS_WR_CS.append(smcChipSelNum)
		smcSym_SETUP_NCS_WR_CS[smcChipSelNum] = smcComponent.createIntegerSymbol("SMC_NCS_WR_SETUP_CS" + str(smcChipSelNum), smcSym_SETUP_TIMING_CS[smcChipSelNum])
		smcSym_SETUP_NCS_WR_CS[smcChipSelNum].setLabel(smcRegBitField_SETUP_NCS_WR_SETUP.getDescription())
		smcSym_SETUP_NCS_WR_CS[smcChipSelNum].setMin(SMC_DEFAULT_MIN_VALUE)
		smcSym_SETUP_NCS_WR_CS[smcChipSelNum].setMax(smcRegBitField_SETUP_NCS_WR_SETUP_MASK)
		smcSym_SETUP_NCS_WR_CS[smcChipSelNum].setDefaultValue(SMC_SETUP_DEFAULT_VALUE)

		smcSym_SETUP_NRD_CS.append(smcChipSelNum)
		smcSym_SETUP_NRD_CS[smcChipSelNum] = smcComponent.createIntegerSymbol("SMC_NRD_SETUP_CS" + str(smcChipSelNum), smcSym_SETUP_TIMING_CS[smcChipSelNum])
		smcSym_SETUP_NRD_CS[smcChipSelNum].setLabel(smcRegBitField_SETUP_NRD_SETUP.getDescription())
		smcSym_SETUP_NRD_CS[smcChipSelNum].setMin(SMC_DEFAULT_MIN_VALUE)
		smcSym_SETUP_NRD_CS[smcChipSelNum].setMax(smcRegBitField_SETUP_NRD_SETUP_MASK)
		smcSym_SETUP_NRD_CS[smcChipSelNum].setDefaultValue(SMC_SETUP_DEFAULT_VALUE)

		smcSym_SETUP_NCS_RD_CS.append(smcChipSelNum)
		smcSym_SETUP_NCS_RD_CS[smcChipSelNum] = smcComponent.createIntegerSymbol("SMC_NCS_RD_SETUP_CS" + str(smcChipSelNum), smcSym_SETUP_TIMING_CS[smcChipSelNum])
		smcSym_SETUP_NCS_RD_CS[smcChipSelNum].setLabel(smcRegBitField_SETUP_NCS_RD_SETUP.getDescription())
		smcSym_SETUP_NCS_RD_CS[smcChipSelNum].setMin(SMC_DEFAULT_MIN_VALUE)
		smcSym_SETUP_NCS_RD_CS[smcChipSelNum].setMax(smcRegBitField_SETUP_NCS_RD_SETUP_MASK)
		smcSym_SETUP_NCS_RD_CS[smcChipSelNum].setDefaultValue(SMC_SETUP_DEFAULT_VALUE)

		# SMC Pulse Timings
		smcSym_PULSE_TIMING_CS.append(smcChipSelNum)
		smcSym_PULSE_TIMING_CS[smcChipSelNum] = smcComponent.createMenuSymbol("SMC_PULSE_TIMING_CS" + str(smcChipSelNum), smcSym_CS_Setting[smcChipSelNum])
		smcSym_PULSE_TIMING_CS[smcChipSelNum].setLabel("SMC Pulse Timings")

		smcSym_PULSE_NWE_CS.append(smcChipSelNum)
		smcSym_PULSE_NWE_CS[smcChipSelNum] = smcComponent.createIntegerSymbol("SMC_NWE_PULSE_CS" + str(smcChipSelNum), smcSym_PULSE_TIMING_CS[smcChipSelNum])
		smcSym_PULSE_NWE_CS[smcChipSelNum].setLabel(smcRegBitField_PULSE_NWE_PULSE.getDescription())
		smcSym_PULSE_NWE_CS[smcChipSelNum].setMin(SMC_DEFAULT_MIN_VALUE)
		smcSym_PULSE_NWE_CS[smcChipSelNum].setMax(smcRegBitField_PULSE_NWE_PULSE_MASK)
		smcSym_PULSE_NWE_CS[smcChipSelNum].setDefaultValue(SMC_PULSE_DEFAULT_VALUE)

		smcSym_PULSE_NCS_WR_CS.append(smcChipSelNum)
		smcSym_PULSE_NCS_WR_CS[smcChipSelNum] = smcComponent.createIntegerSymbol("SMC_NCS_WR_PULSE_CS" + str(smcChipSelNum), smcSym_PULSE_TIMING_CS[smcChipSelNum])
		smcSym_PULSE_NCS_WR_CS[smcChipSelNum].setLabel(smcRegBitField_PULSE_NCS_WR_PULSE.getDescription())
		smcSym_PULSE_NCS_WR_CS[smcChipSelNum].setMin(SMC_DEFAULT_MIN_VALUE)
		smcSym_PULSE_NCS_WR_CS[smcChipSelNum].setMax(smcRegBitField_PULSE_NCS_WR_PULSE_MASK)
		smcSym_PULSE_NCS_WR_CS[smcChipSelNum].setDefaultValue(SMC_PULSE_DEFAULT_VALUE)

		smcSym_PULSE_NRD_CS.append(smcChipSelNum)
		smcSym_PULSE_NRD_CS[smcChipSelNum] = smcComponent.createIntegerSymbol("SMC_NRD_PULSE_CS" + str(smcChipSelNum), smcSym_PULSE_TIMING_CS[smcChipSelNum])
		smcSym_PULSE_NRD_CS[smcChipSelNum].setLabel(smcRegBitField_PULSE_NRD_PULSE.getDescription())
		smcSym_PULSE_NRD_CS[smcChipSelNum].setMin(SMC_DEFAULT_MIN_VALUE)
		smcSym_PULSE_NRD_CS[smcChipSelNum].setMax(smcRegBitField_PULSE_NRD_PULSE_MASK)
		smcSym_PULSE_NRD_CS[smcChipSelNum].setDefaultValue(SMC_PULSE_DEFAULT_VALUE)

		smcSym_PULSE_NCS_RD_CS.append(smcChipSelNum)
		smcSym_PULSE_NCS_RD_CS[smcChipSelNum] = smcComponent.createIntegerSymbol("SMC_NCS_RD_PULSE_CS" + str(smcChipSelNum),smcSym_PULSE_TIMING_CS[smcChipSelNum])
		smcSym_PULSE_NCS_RD_CS[smcChipSelNum].setLabel(smcRegBitField_PULSE_NCS_RD_PULSE.getDescription())
		smcSym_PULSE_NCS_RD_CS[smcChipSelNum].setMin(SMC_DEFAULT_MIN_VALUE)
		smcSym_PULSE_NCS_RD_CS[smcChipSelNum].setMax(smcRegBitField_PULSE_NCS_RD_PULSE_MASK)
		smcSym_PULSE_NCS_RD_CS[smcChipSelNum].setDefaultValue(SMC_PULSE_DEFAULT_VALUE)

		# SMC Cycle Timings
		smcSym_CYCLE_TIMING_CS.append(smcChipSelNum)
		smcSym_CYCLE_TIMING_CS[smcChipSelNum] = smcComponent.createMenuSymbol("SMC_CYCLE_TIMING_CS" + str(smcChipSelNum), smcSym_CS_Setting[smcChipSelNum])
		smcSym_CYCLE_TIMING_CS[smcChipSelNum].setLabel("SMC Cycle Timings")

		smcSym_CYCLE_TIMING_NWE_CS.append(smcChipSelNum)
		smcSym_CYCLE_TIMING_NWE_CS[smcChipSelNum] = smcComponent.createIntegerSymbol("SMC_NWE_CYCLE_CS" + str(smcChipSelNum), smcSym_CYCLE_TIMING_CS[smcChipSelNum])
		smcSym_CYCLE_TIMING_NWE_CS[smcChipSelNum].setLabel(smcRegBitField_CYCLE_NWE_CYCLE.getDescription())
		smcSym_CYCLE_TIMING_NWE_CS[smcChipSelNum].setMin(SMC_CYCLE_DEFAULT_VALUE)
		smcSym_CYCLE_TIMING_NWE_CS[smcChipSelNum].setMax(smcRegBitField_CYCLE_NWE_CYCLE_MASK)
		smcSym_CYCLE_TIMING_NWE_CS[smcChipSelNum].setDefaultValue(SMC_CYCLE_DEFAULT_VALUE)

		smcSym_SMC_CYCLE_TIMING_NRD_CS.append(smcChipSelNum)
		smcSym_SMC_CYCLE_TIMING_NRD_CS[smcChipSelNum] = smcComponent.createIntegerSymbol("SMC_NRD_CYCLE_CS" + str(smcChipSelNum), smcSym_CYCLE_TIMING_CS[smcChipSelNum])
		smcSym_SMC_CYCLE_TIMING_NRD_CS[smcChipSelNum].setLabel(smcRegBitField_CYCLE_NRD_CYCLE.getDescription())
		smcSym_SMC_CYCLE_TIMING_NRD_CS[smcChipSelNum].setMin(SMC_CYCLE_DEFAULT_VALUE)
		smcSym_SMC_CYCLE_TIMING_NRD_CS[smcChipSelNum].setMax(smcRegBitField_CYCLE_NRD_CYCLE_MASK)
		smcSym_SMC_CYCLE_TIMING_NRD_CS[smcChipSelNum].setDefaultValue(SMC_CYCLE_DEFAULT_VALUE)

		# SMC Mode Settings
		smcSym_MODE_CS_REGISTER.append(smcChipSelNum)
		smcSym_MODE_CS_REGISTER[smcChipSelNum] = smcComponent.createMenuSymbol("SMC_MODE_REGISTER_CS" + str(smcChipSelNum), smcSym_CS_Setting[smcChipSelNum])
		smcSym_MODE_CS_REGISTER[smcChipSelNum].setLabel("SMC Mode Settings")

		smcSym_MODE_DBW.append(smcChipSelNum)
		smcSym_MODE_DBW[smcChipSelNum] = smcComponent.createComboSymbol("SMC_DATA_BUS_CS" + str(smcChipSelNum), smcSym_MODE_CS_REGISTER[smcChipSelNum], smcValGrp_MODE_DBW.getValueNames())
		smcSym_MODE_DBW[smcChipSelNum].setLabel("External Memory Data Bus Width")
		smcSym_MODE_DBW[smcChipSelNum].setDefaultValue("_16_BIT")

		smcSym_MODE_BAT.append(smcChipSelNum)
		smcSym_MODE_BAT[smcChipSelNum] = smcComponent.createComboSymbol("SMC_BAT_CS" + str(smcChipSelNum), smcSym_MODE_CS_REGISTER[smcChipSelNum], smcValGrp_MODE_BAT.getValueNames())
		smcSym_MODE_BAT[smcChipSelNum].setLabel("Byte Select access type (16-bit data bus only)")
		smcSym_MODE_BAT[smcChipSelNum].setDefaultValue("BYTE_SELECT")
		smcSym_MODE_BAT[smcChipSelNum].setDependencies(smcByteAccessSelModeVisible, ["SMC_DATA_BUS_CS" + str(smcChipSelNum)])

		smcSym_MODE_PMEN.append(smcChipSelNum)
		smcSym_MODE_PMEN[smcChipSelNum] = smcComponent.createBooleanSymbol("SMC_PMEN_CS" + str(smcChipSelNum), smcSym_MODE_CS_REGISTER[smcChipSelNum])
		smcSym_MODE_PMEN[smcChipSelNum].setLabel("Enable External Memory Page mode?")
		smcSym_MODE_PMEN[smcChipSelNum].setDefaultValue(False)

		smcSym_MODE_PS.append(smcChipSelNum)
		smcSym_MODE_PS[smcChipSelNum] = smcComponent.createComboSymbol("SMC_PS_CS" + str(smcChipSelNum), smcSym_MODE_CS_REGISTER[smcChipSelNum], smcValGrp_MODE_PS.getValueNames())
		smcSym_MODE_PS[smcChipSelNum].setLabel("External Memory Page Size")
		smcSym_MODE_PS[smcChipSelNum].setVisible(False)
		smcSym_MODE_PS[smcChipSelNum].setDefaultValue("_4_BYTE")
		smcSym_MODE_PS[smcChipSelNum].setDependencies(smcMemoryPageSizeModeVisible, ["SMC_PMEN_CS" + str(smcChipSelNum)])

		smcSym_MODE_TDF.append(smcChipSelNum)
		smcSym_MODE_TDF[smcChipSelNum] = smcComponent.createBooleanSymbol("SMC_TDF_MODE_CS" + str(smcChipSelNum), smcSym_MODE_CS_REGISTER[smcChipSelNum])
		smcSym_MODE_TDF[smcChipSelNum].setLabel("Enable Optimization of the TDF Wait States?")
		smcSym_MODE_TDF[smcChipSelNum].setDefaultValue(False)

		smcSym_MODE_TDF_CYCLES.append(smcChipSelNum)
		smcSym_MODE_TDF_CYCLES[smcChipSelNum] = smcComponent.createIntegerSymbol("SMC_TDF_CYCLES_CS" + str(smcChipSelNum), smcSym_MODE_CS_REGISTER[smcChipSelNum])
		smcSym_MODE_TDF_CYCLES[smcChipSelNum].setLabel("Data Float Time (no of cycles)")
		smcSym_MODE_TDF_CYCLES[smcChipSelNum].setVisible(False)
		smcSym_MODE_TDF_CYCLES[smcChipSelNum].setMin(SMC_DEFAULT_MIN_VALUE)
		smcSym_MODE_TDF_CYCLES[smcChipSelNum].setMax(smcRegBitField_MODE_TDF_CYCLES_MASK)
		smcSym_MODE_TDF_CYCLES[smcChipSelNum].setDefaultValue(SMC_MODE_TDF_CYCLES_DEFAULT_VALUE)
		smcSym_MODE_TDF_CYCLES[smcChipSelNum].setDependencies(smcTdfCyclesModeVisible, ["SMC_TDF_MODE_CS" + str(smcChipSelNum)])

		smcSym_MODE_EXNW.append(smcChipSelNum)
		smcSym_MODE_EXNW[smcChipSelNum] = smcComponent.createComboSymbol("SMC_NWAIT_MODE_CS" + str(smcChipSelNum), smcSym_MODE_CS_REGISTER[smcChipSelNum], smcValGrp_MODE_EXNW_MODE.getValueNames())
		smcSym_MODE_EXNW[smcChipSelNum].setLabel(smcRegBitField_MODE_EXNW_MODE.getDescription())
		smcSym_MODE_EXNW[smcChipSelNum].setDefaultValue("DISABLED")

		smcSym_MODE_READ.append(smcChipSelNum)
		smcSym_MODE_READ[smcChipSelNum] = smcComponent.createBooleanSymbol("SMC_READ_MODE_CS" + str(smcChipSelNum), smcSym_MODE_CS_REGISTER[smcChipSelNum])
		smcSym_MODE_READ[smcChipSelNum].setLabel("Enable Read Mode Configuration")
		smcSym_MODE_READ[smcChipSelNum].setDefaultValue(False)

		smcSym_MODE_WRITE.append(smcChipSelNum)
		smcSym_MODE_WRITE[smcChipSelNum] = smcComponent.createBooleanSymbol("SMC_WRITE_MODE_CS" + str(smcChipSelNum), smcSym_MODE_CS_REGISTER[smcChipSelNum])
		smcSym_MODE_WRITE[smcChipSelNum].setLabel("Enable Write Mode Configuration")
		smcSym_MODE_WRITE[smcChipSelNum].setDefaultValue(False)	

	smcIndex = smcComponent.createIntegerSymbol("INDEX", smcMenu)
	smcIndex.setVisible(False)
	smcIndex.setDefaultValue(int(num))	

	configName = Variables.get("__CONFIGURATION_NAME")

	smcHeader1File = smcComponent.createFileSymbol(None, None)
	smcHeader1File.setSourcePath("../peripheral/smc_" + smcRegModule.getID() + "/templates/plib_smc.h.ftl")
	smcHeader1File.setOutputName("plib_smc" + str(num) + ".h")
	smcHeader1File.setDestPath("/peripheral/smc/")
	smcHeader1File.setProjectPath("/peripheral/smc/")
	smcHeader1File.setType("HEADER")
	smcHeader1File.setMarkup(True)

	smcSource1File = smcComponent.createFileSymbol(None, None)
	smcSource1File.setSourcePath("../peripheral/smc_" + smcRegModule.getID() + "/templates/plib_smc.c.ftl")
	smcSource1File.setOutputName("plib_smc" + str(num) + ".c")
	smcSource1File.setDestPath("/peripheral/smc/")
	smcSource1File.setProjectPath("/peripheral/smc/")
	smcSource1File.setType("SOURCE")
	smcSource1File.setMarkup(True)

	#Add SMC related code to common files
	smcHeader1FileEntry = smcComponent.createFileSymbol("smcHeader1FileEntry", None)
	smcHeader1FileEntry.setType("STRING")
	smcHeader1FileEntry.setOutputName("core.LIST_SYSTEM_DEFINITIONS_H_INCLUDES")
	smcHeader1FileEntry.setSourcePath("../peripheral/smc_" + smcRegModule.getID() + "/templates/system/system_definitions.h.ftl")
	smcHeader1FileEntry.setMarkup(True)

	smcSystemInitFile = smcComponent.createFileSymbol("smcSystemInitFile", None)
	smcSystemInitFile.setType("STRING")
	smcSystemInitFile.setOutputName("core.LIST_SYSTEM_INIT_C_SYS_INITIALIZE_CORE")
	smcSystemInitFile.setSourcePath("../peripheral/smc_" + smcRegModule.getID() + "/templates/system/system_initialize.c.ftl")
	smcSystemInitFile.setMarkup(True)
