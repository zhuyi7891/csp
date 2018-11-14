/*******************************************************************************
  Controller Area Network (MCAN) Peripheral Library Source File

  Company:
    Microchip Technology Inc.

  File Name:
    plib_mcan0.c

  Summary:
    MCAN peripheral library interface.

  Description:
    This file defines the interface to the MCAN peripheral library. This
    library provides access to and control of the associated peripheral
    instance.

  Remarks:
    None.
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
// *****************************************************************************
// *****************************************************************************
// Header Includes
// *****************************************************************************
// *****************************************************************************

#include "device.h"
#include "plib_mcan0.h"

// *****************************************************************************
// *****************************************************************************
// Global Data
// *****************************************************************************
// *****************************************************************************

static MCAN_OBJ mcan0Obj;

/* Configuration for the bytes in each element of RX FIFOs */
static uint8_t mcan0_rx0_fifo[1 * 16]__attribute__((aligned (4)));

static uint8_t mcan0_rx1_fifo[1 * 16]__attribute__((aligned (4)));

/* Configuration for the bytes in each element of TX FIFOs */
static uint8_t mcan0_tx_fifo[1 * 16]__attribute__((aligned (4)));
static MCAN_TX_EVENT_FIFO_ENTRY mcan0_tx_event_fifo[1]__attribute__((aligned (4)));


/******************************************************************************
Local Functions
******************************************************************************/

static uint8_t MCANDlcToLengthGet(uint8_t dlc)
{
    uint8_t msgLength[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 12, 16, 20, 24, 32, 48, 64};
    return msgLength[dlc];
}

// *****************************************************************************
// *****************************************************************************
// MCAN0 PLib Interface Routines
// *****************************************************************************
// *****************************************************************************
// *****************************************************************************
/* Function:
    void MCAN0_Initialize(void)

   Summary:
    Initializes given instance of the MCAN peripheral.

   Precondition:
    None.

   Parameters:
    None.

   Returns:
    None
*/
void MCAN0_Initialize(void)
{
    /* Start MCAN initialization */
    MCAN0_REGS->MCAN_CCCR = MCAN_CCCR_INIT_ENABLED;
    while ((MCAN0_REGS->MCAN_CCCR & MCAN_CCCR_INIT_Msk) != MCAN_CCCR_INIT_Msk);

    /* Set CCE to unlock the configuration registers */
    MCAN0_REGS->MCAN_CCCR |= MCAN_CCCR_CCE_Msk;

    /* Set Nominal Bit timing and Prescaler Register */
    MCAN0_REGS->MCAN_NBTP  = MCAN_NBTP_NTSEG2(3) | MCAN_NBTP_NTSEG1(10) | MCAN_NBTP_NBRP(0) | MCAN_NBTP_NSJW(3);

    /* Receive FIFO 0 Configuration Register */
    MCAN0_REGS->MCAN_RXF0C = MCAN_RXF0C_F0S(1) | MCAN_RXF0C_F0WM(0) | MCAN_RXF0C_F0OM_Msk |
            MCAN_RXF0C_F0SA(((uint32_t)mcan0_rx0_fifo >> 2));

    /* Receive FIFO 1 Configuration Register */
    MCAN0_REGS->MCAN_RXF1C = MCAN_RXF1C_F1S(1) | MCAN_RXF1C_F1WM(0) | MCAN_RXF1C_F1OM_Msk |
            MCAN_RXF1C_F1SA(((uint32_t)mcan0_rx1_fifo >> 2));

    /* Receive Buffer / FIFO Element Size Configuration Register */
    MCAN0_REGS->MCAN_RXESC = 0  | MCAN_RXESC_F0DS(0) | MCAN_RXESC_F1DS(0);

    /* Transmit Buffer/FIFO Configuration Register */
    MCAN0_REGS->MCAN_TXBC = MCAN_TXBC_TFQS(1) | MCAN_TXBC_NDTB(0) |
            MCAN_TXBC_TBSA(((uint32_t)mcan0_tx_fifo >> 2));

    /* Transmit Buffer/FIFO Element Size Configuration Register */
    MCAN0_REGS->MCAN_TXESC = MCAN_TXESC_TBDS(0);

    /* Transmit Event FIFO Configuration Register */
    MCAN0_REGS->MCAN_TXEFC = MCAN_TXEFC_EFWM(0) | MCAN_TXEFC_EFS(1) |
            MCAN_TXEFC_EFSA(((uint32_t)mcan0_tx_event_fifo >> 2));

    /* Global Filter Configuration Register */
    MCAN0_REGS->MCAN_GFC = MCAN_GFC_ANFS_RX_FIFO_0 | MCAN_GFC_ANFE_RX_FIFO_0;

    /* Timestamp Counter Configuration Register */
    MCAN0_REGS->MCAN_TSCC = MCAN_TSCC_TSS_TCP_INC | MCAN_TSCC_TCP(1);

    /* Set 16-bit MSB of mcan0 base address */
    SFR_REGS->SFR_CAN = (SFR_REGS->SFR_CAN & ~SFR_CAN_EXT_MEM_CAN0_ADDR_Msk)
                       | SFR_CAN_EXT_MEM_CAN0_ADDR((uint32_t)mcan0_rx0_fifo >> 16);

    /* Clear Tx/Rx FIFO */
    memset((void*)mcan0_rx0_fifo, 0x00, (1 * 16));
    memset((void*)mcan0_rx1_fifo, 0x00, (1 * 16));
    memset((void*)mcan0_tx_fifo, 0x00, (1 * 16));
    memset((void*)mcan0_tx_event_fifo, 0x00, (sizeof(MCAN_TX_EVENT_FIFO_ENTRY) * 1));

    /* Set the operation mode */
    MCAN0_REGS->MCAN_CCCR = MCAN_CCCR_INIT_DISABLED;
    while ((MCAN0_REGS->MCAN_CCCR & MCAN_CCCR_INIT_Msk) == MCAN_CCCR_INIT_Msk);
}

// *****************************************************************************
/* Function:
    bool MCAN0_MessageTransmit(uint32_t address, uint8_t length, uint8_t* data, MCAN_MODE mode, MCAN_MSG_TX_ATTRIBUTE msgAttr)

   Summary:
    Transmits a message into CAN bus.

   Precondition:
    MCAN0_Initialize must have been called for the associated MCAN instance.

   Parameters:
    address - 11-bit / 29-bit identifier (ID).
    length  - length of data buffer in number of bytes.
    data    - pointer to source data buffer
    mode    - MCAN mode Classic CAN or CAN FD without BRS or CAN FD with BRS
    msgAttr - Data Frame or Remote frame using Tx FIFO or Tx Buffer

   Returns:
    Request status.
    true  - Request was successful.
    false - Request has failed.
*/
bool MCAN0_MessageTransmit(uint32_t address, uint8_t length, uint8_t* data, MCAN_MODE mode, MCAN_MSG_TX_ATTRIBUTE msgAttr)
{
    uint8_t tfqpi = 0;
    MCAN_TX_BUFFER_FIFO_ENTRY *fifo = NULL;

    switch (msgAttr)
    {
        case MCAN_MSG_ATTR_TX_FIFO_DATA_FRAME:
        case MCAN_MSG_ATTR_TX_FIFO_RTR_FRAME:
            if (MCAN0_REGS->MCAN_TXFQS & MCAN_TXFQS_TFQF_Msk)
            {
                /* The FIFO is full */
                return false;
            }
            tfqpi = (uint8_t)((MCAN0_REGS->MCAN_TXFQS & MCAN_TXFQS_TFQPI_Msk) >> MCAN_TXFQS_TFQPI_Pos);
            mcan0Obj.txBufferIndex |= (1 << ((tfqpi - 0) & 0x1F));
            fifo = (MCAN_TX_BUFFER_FIFO_ENTRY *) (mcan0_tx_fifo + tfqpi * 16);
            break;
        default:
            /* Invalid Message Attribute */
            return false;
    }

    /* If the address is longer than 11 bits, it is considered as extended identifier */
    if (address > MCAN_STD_ID_Msk)
    {
        /* An extended identifier is stored into ID */
        fifo->T0.val = (address & MCAN_EXT_ID_Msk) | MCAN_TX_XTD_Msk;
    }
    else
    {
        /* A standard identifier is stored into ID[28:18] */
        fifo->T0.val = address << 18;
    }

    /* Limit length */
    if (length > 8)
        length = 8;
    fifo->T1.val = MCAN_TXFE_DLC(length);

    if (msgAttr == MCAN_MSG_ATTR_TX_BUFFER_DATA_FRAME || msgAttr == MCAN_MSG_ATTR_TX_FIFO_DATA_FRAME)
    {
        /* copy the data into the payload */
        memcpy((uint8_t *)&fifo->data, data, length);
    }
    else if (msgAttr == MCAN_MSG_ATTR_TX_BUFFER_RTR_FRAME || msgAttr == MCAN_MSG_ATTR_TX_FIFO_RTR_FRAME)
    {
        fifo->T0.val |= MCAN_TX_RTR_Msk;
    }


    /* request the transmit */
    MCAN0_REGS->MCAN_TXBAR = 1U << tfqpi;

    return true;
}

// *****************************************************************************
/* Function:
    bool MCAN0_MessageReceive(uint32_t *address, uint8_t *length, uint8_t *data, MCAN_MSG_RX_ATTRIBUTE msgAttr)

   Summary:
    Receives a message from CAN bus.

   Precondition:
    MCAN0_Initialize must have been called for the associated MCAN instance.

   Parameters:
    address - Pointer to 11-bit / 29-bit identifier (ID) to be received.
    length  - Pointer to data length in number of bytes to be received.
    data    - pointer to destination data buffer
    msgAttr - Message to be read from Rx FIFO0 or Rx FIFO1 or Rx Buffer

   Returns:
    Request status.
    true  - Request was successful.
    false - Request has failed.
*/
bool MCAN0_MessageReceive(uint32_t *address, uint8_t *length, uint8_t *data, MCAN_MSG_RX_ATTRIBUTE msgAttr)
{
    uint8_t msgLength = 0;
    uint8_t rxgi = 0;
    MCAN_RX_BUFFER_FIFO_ENTRY *fifo = NULL;
    bool status = false;

    switch (msgAttr)
    {
        case MCAN_MSG_ATTR_RX_FIFO0:
            /* Check and return false if nothing to be read */
            if ((MCAN0_REGS->MCAN_RXF0S & MCAN_RXF0S_F0FL_Msk) == 0)
            {
                return status;
            }
            /* Read data from the Rx FIFO0 */
            rxgi = (uint8_t)((MCAN0_REGS->MCAN_RXF0S & MCAN_RXF0S_F0GI_Msk) >> MCAN_RXF0S_F0GI_Pos);
            fifo = (MCAN_RX_BUFFER_FIFO_ENTRY *) (mcan0_rx0_fifo + rxgi * 16);

            /* Get received identifier */
            if (MCAN_RX_XTD(fifo->R0.val))
            {
                *address = fifo->R0.val & MCAN_EXT_ID_Msk;
            }
            else
            {
                *address = (fifo->R0.val >> 18) & MCAN_STD_ID_Msk;
            }

            /* Get received data length */
            msgLength = MCANDlcToLengthGet((MCAN_RX_DLC(fifo->R1.val)));

            /* Copy data to user buffer */
            memcpy(data, (uint8_t *)&fifo->data, msgLength);
            *length = msgLength;

            /* Ack the fifo position */
            MCAN0_REGS->MCAN_RXF0A = MCAN_RXF0A_F0AI(rxgi);
            status = true;
            break;
        case MCAN_MSG_ATTR_RX_FIFO1:
            /* Check and return false if nothing to be read */
            if ((MCAN0_REGS->MCAN_RXF1S & MCAN_RXF1S_F1FL_Msk) == 0)
            {
                return status;
            }
            /* Read data from the Rx FIFO1 */
            rxgi = (uint8_t)((MCAN0_REGS->MCAN_RXF1S & MCAN_RXF1S_F1GI_Msk) >> MCAN_RXF1S_F1GI_Pos);
            fifo = (MCAN_RX_BUFFER_FIFO_ENTRY *) (mcan0_rx1_fifo + rxgi * 16);

            /* Get received identifier */
            if (MCAN_RX_XTD(fifo->R0.val))
            {
                *address = fifo->R0.val & MCAN_EXT_ID_Msk;
            }
            else
            {
                *address = (fifo->R0.val >> 18) & MCAN_STD_ID_Msk;
            }

            /* Get received data length */
            msgLength = MCANDlcToLengthGet((MCAN_RX_DLC(fifo->R1.val)));

            /* Copy data to user buffer */
            memcpy(data, (uint8_t *)&fifo->data, msgLength);
            *length = msgLength;

            /* Ack the fifo position */
            MCAN0_REGS->MCAN_RXF1A = MCAN_RXF1A_F1AI(rxgi);
            status = true;
            break;
        default:
            return status;
    }
    return status;
}

// *****************************************************************************
/* Function:
    MCAN_ERROR MCAN0_ErrorGet(void)

   Summary:
    Returns the error during transfer.

   Precondition:
    MCAN0_Initialize must have been called for the associated MCAN instance.

   Parameters:
    None.

   Returns:
    Error during transfer.
*/
MCAN_ERROR MCAN0_ErrorGet(void)
{
    MCAN_ERROR error;
    uint32_t   errorStatus = MCAN0_REGS->MCAN_PSR;

    error = (MCAN_ERROR) ((errorStatus & MCAN_PSR_LEC_Msk) | (errorStatus & MCAN_PSR_EP_Msk) | (errorStatus & MCAN_PSR_EW_Msk)
            | (errorStatus & MCAN_PSR_BO_Msk) | (errorStatus & MCAN_PSR_DLEC_Msk) | (errorStatus & MCAN_PSR_PXE_Msk));

    if ((MCAN0_REGS->MCAN_CCCR & MCAN_CCCR_INIT_Msk) == MCAN_CCCR_INIT_Msk)
    {
        MCAN0_REGS->MCAN_CCCR |= MCAN_CCCR_CCE_Msk;
        MCAN0_REGS->MCAN_CCCR = MCAN_CCCR_INIT_DISABLED;
        while ((MCAN0_REGS->MCAN_CCCR & MCAN_CCCR_INIT_Msk) == MCAN_CCCR_INIT_Msk);
    }

    return error;
}

// *****************************************************************************
/* Function:
    bool MCAN0_InterruptGet(MCAN_INTERRUPT_MASK interruptMask)

   Summary:
    Returns the Interrupt status.

   Precondition:
    MCAN0_Initialize must have been called for the associated MCAN instance.

   Parameters:
    interruptMask - Interrupt source number

   Returns:
    true - Requested interrupt is occurred.
    false - Requested interrupt is not occurred.
*/
bool MCAN0_InterruptGet(MCAN_INTERRUPT_MASK interruptMask)
{
    return ((MCAN0_REGS->MCAN_IR & interruptMask) != 0x0);
}

// *****************************************************************************
/* Function:
    void MCAN0_InterruptClear(MCAN_INTERRUPT_MASK interruptMask)

   Summary:
    Clears Interrupt status.

   Precondition:
    MCAN0_Initialize must have been called for the associated MCAN instance.

   Parameters:
    interruptMask - Interrupt to be cleared

   Returns:
    None
*/
void MCAN0_InterruptClear(MCAN_INTERRUPT_MASK interruptMask)
{
    MCAN0_REGS->MCAN_IR = interruptMask;
}

// *****************************************************************************
/* Function:
    void MCAN0_MessageRAMConfigGet(MCAN_MSG_RAM_CONFIG *msgRAMConfig)

   Summary:
    Get the Message RAM Configuration.

   Precondition:
    MCAN0_Initialize must have been called for the associated MCAN instance.

   Parameters:
    msgRAMConfig - Pointer to the Message RAM Configuration object

   Returns:
    None
*/
void MCAN0_MessageRAMConfigGet(MCAN_MSG_RAM_CONFIG *msgRAMConfig)
{
    memset((void*)msgRAMConfig, 0x00, sizeof(MCAN_MSG_RAM_CONFIG));

    msgRAMConfig->rxFIFO0Address = (MCAN_RX_BUFFER_FIFO_ENTRY *)mcan0_rx0_fifo;
    msgRAMConfig->rxFIFO0Size = (1 * 16);
    msgRAMConfig->rxFIFO1Address = (MCAN_RX_BUFFER_FIFO_ENTRY *)mcan0_rx1_fifo;
    msgRAMConfig->rxFIFO1Size = (1 * 16);
    msgRAMConfig->txBuffersAddress = (MCAN_TX_BUFFER_FIFO_ENTRY *)mcan0_tx_fifo;
    msgRAMConfig->txBuffersSize = (1 * 16);
    msgRAMConfig->txEventFIFOAddress =  (MCAN_TX_EVENT_FIFO_ENTRY *)mcan0_tx_event_fifo;
    msgRAMConfig->txEventFIFOSize = (1 * sizeof(MCAN_TX_EVENT_FIFO_ENTRY));
}



/*******************************************************************************
 End of File
*/