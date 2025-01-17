/*******************************************************************************
  L2CC PLIB Implementation

  Company:
    Microchip Technology Inc.

  File Name:
    plib_l2cc.c

  Summary:
    Implemenation of the L2 cache controller PLIB.

  Description:
    This file implements the functionality necessary to initialize and
    interract with the L2 cache controller.
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
<#setting boolean_format="1,0">
#include <stdbool.h>
#include <stdint.h>

#include "device.h"
#include "plib_l2cc.h"

// *****************************************************************************
// *****************************************************************************
// Section: File Scope or Global Constants
// *****************************************************************************
// *****************************************************************************
#define L2CC_OFFSET_BIT 5
#define L2CC_INDEX_BIT  9
#define L2CC_TAG_BIT    18

static bool l2cacheIsEnabled(void)
{
    return (L2CC_REGS->L2CC_CR & L2CC_CR_L2CEN_Msk) != 0;
}

static void l2cacheEnable(void)
{
    SFR_REGS->SFR_L2CC_HRAMC = SFR_L2CC_HRAMC_SRAM_SEL(1);
    L2CC_REGS->L2CC_CR |= L2CC_CR_L2CEN_Msk;
    __DSB();
    __ISB();
}

<#if L2CC_ACR_EXCC>
static void l2cacheSetExclusive(void)
{
    L2CC_REGS->L2CC_ACR |= L2CC_ACR_EXCC_Msk;
}
<#else>

static void l2cacheSetNonExclusive(void)
{
    L2CC_REGS->L2CC_ACR &= ~L2CC_ACR_EXCC_Msk;
}
</#if>

<#if L2CC_TRCR>
static void setTagRamLatency(void)
{
    L2CC_REGS->L2CC_TRCR = L2CC_TRCR_TSETLAT(${L2CC_TRCR_TSETLAT}) |
                      L2CC_TRCR_TRDLAT(${L2CC_TRCR_TRDLAT}) |
                      L2CC_TRCR_TWRLAT(${L2CC_TRCR_TWRLAT});
};
</#if>

<#if L2CC_DRCR>
static void setDataRamLatency(void)
{
    L2CC_REGS->L2CC_DRCR = L2CC_DRCR_DSETLAT(${L2CC_DRCR_DSETLAT}) |
                      L2CC_DRCR_DRDLAT(${L2CC_DRCR_DRDLAT}) |
                      L2CC_DRCR_DWRLAT(${L2CC_DRCR_DWRLAT});
}
</#if>

static void setConfig(void)
{
    L2CC_REGS->L2CC_ACR = L2CC_ACR_HPSO(${L2CC_ACR_HPSO}) |
                     L2CC_ACR_SBDLE(${L2CC_ACR_SBDLE}) |
                     L2CC_ACR_EMBEN(${L2CC_ACR_EMBEN}) |
                     L2CC_ACR_PEN(${L2CC_ACR_PEN}) |
                     L2CC_ACR_SAOEN(${L2CC_ACR_SAOEN}) |
                     L2CC_ACR_FWA(${L2CC_ACR_FWA}) |
                     L2CC_ACR_CRPOL(${L2CC_ACR_CRPOL}) |
                     L2CC_ACR_NSLEN(${L2CC_ACR_NSLEN}) |
                     L2CC_ACR_NSIAC(${L2CC_ACR_NSIAC}) |
                     L2CC_ACR_DPEN(${L2CC_ACR_DPEN}) |
                     L2CC_ACR_IPEN(${L2CC_ACR_IPEN});

    L2CC_REGS->L2CC_DCR = L2CC_DCR_DCL(${L2CC_DCR_DCL}) |
                     L2CC_DCR_DWB(${L2CC_DCR_DWB});

    L2CC_REGS->L2CC_PCR = L2CC_PCR_OFFSET(${L2CC_PCR_OFFSET}) |
                     L2CC_PCR_NSIDEN(${L2CC_PCR_NSIDEN}) |
                     L2CC_PCR_IDLEN(${L2CC_PCR_IDLEN}) |
                     L2CC_PCR_PDEN(${L2CC_PCR_PDEN}) |
                     L2CC_PCR_DLFWRDIS(${L2CC_PCR_DLFWRDIS}) |
                     L2CC_PCR_DATPEN(${L2CC_ACR_DPEN}) |
                     L2CC_PCR_INSPEN(${L2CC_ACR_IPEN}) |
                     L2CC_PCR_DLEN(${L2CC_PCR_DLEN});

    L2CC_REGS->L2CC_POWCR = L2CC_POWCR_STBYEN(${L2CC_POWCR_STBYEN}) |
                       L2CC_POWCR_DCKGATEN(${L2CC_POWCR_DCKGATEN});
}

static void dataPrefetchEnable(void)
{
    L2CC_REGS->L2CC_PCR |= L2CC_PCR_DATPEN_Msk;
}

static void instPrefetchEnable(void)
{
    L2CC_REGS->L2CC_PCR |= L2CC_PCR_INSPEN_Msk;
}

<#if L2CC_ECR_EVCEN>
static void enableEventCounter(uint8_t event_counter)
{
    switch (event_counter) {
    case 0:
        L2CC_REGS->L2CC_ECR = L2CC_ECR_EVCEN_Msk | L2CC_ECR_EVC0RST_Msk;
        break;
    case 1:
        L2CC_REGS->L2CC_ECR = L2CC_ECR_EVCEN_Msk | L2CC_ECR_EVC1RST_Msk;
        break;
    default:
        break;
    }
}

static void eventConfig(uint8_t event_counter, uint8_t source, uint8_t it)
{
    switch (event_counter) {
    case 0:
        L2CC_REGS->L2CC_ECFGR0 = L2CC_ECFGR0_ESRC(source) |
                            L2CC_ECFGR0_EIGEN(it);
        break;
    case 1:
        L2CC_REGS->L2CC_ECFGR1 = L2CC_ECFGR1_ESRC(source) |
                            L2CC_ECFGR1_EIGEN(it);
        break;
    default:
        break;
    }

}
</#if>

static void disableInt(uint32_t sources)
{
    L2CC_REGS->L2CC_IMR &= ~sources;
}

static void clearInt(uint32_t sources)
{
    L2CC_REGS->L2CC_ICR |= sources;
}

static void cacheSync(void)
{
    while (L2CC_REGS->L2CC_CSR & L2CC_CSR_C_Msk);
    L2CC_REGS->L2CC_CSR = L2CC_CSR_C_Msk;
    while (L2CC_REGS->L2CC_CSR & L2CC_CSR_C_Msk);
}

static void invalidatePAL(uint32_t phys_addr)
{
    uint32_t tag, index;

    tag = phys_addr >> (L2CC_OFFSET_BIT + L2CC_INDEX_BIT);
    index = (phys_addr >> L2CC_OFFSET_BIT) & ((1 << L2CC_INDEX_BIT) - 1);
    L2CC_REGS->L2CC_IPALR = L2CC_IPALR_TAG(tag) | L2CC_IPALR_IDX(index) | L2CC_IPALR_C_Msk;
    while (L2CC_REGS->L2CC_IPALR & L2CC_IPALR_C_Msk);
}

static void cleanPAL(uint32_t phys_addr)
{
    uint32_t tag, index;

    tag = phys_addr >> (L2CC_OFFSET_BIT + L2CC_INDEX_BIT);
    index = (phys_addr >> L2CC_OFFSET_BIT) & ((1 << L2CC_INDEX_BIT) - 1);
    L2CC_REGS->L2CC_CPALR = L2CC_CPALR_TAG(tag) | L2CC_CPALR_IDX(index) | L2CC_CPALR_C_Msk;
    while (L2CC_REGS->L2CC_CPALR & L2CC_CPALR_C_Msk);
}

static void cleanInvalidatePAL(uint32_t phys_addr)
{
    uint32_t tag, index;

    tag = phys_addr >> (L2CC_OFFSET_BIT + L2CC_INDEX_BIT);
    index = (phys_addr >> L2CC_OFFSET_BIT) & ((1 << L2CC_INDEX_BIT) - 1);
    L2CC_REGS->L2CC_CIPALR = L2CC_CIPALR_TAG(tag) | L2CC_CIPALR_IDX(index) | L2CC_CIPALR_C_Msk;
    while (L2CC_REGS->L2CC_CIPALR & L2CC_CIPALR_C_Msk);
}

static void invalidateWay(uint8_t way)
{
    L2CC_REGS->L2CC_IWR = way;
    while (L2CC_REGS->L2CC_IWR & way);
}

static void cleanWay(uint8_t way)
{
    L2CC_REGS->L2CC_CWR = way;
    while (L2CC_REGS->L2CC_CWR & way);
}

void cleanInvalidateWay(uint8_t way)
{
    L2CC_REGS->L2CC_CIWR = way;
    while (L2CC_REGS->L2CC_CIWR & way);
}

/*
void l2cc_clean_index(uint32_t phys_addr, uint8_t way)
{
    uint32_t index;

    index = (phys_addr >> L2CC_OFFSET_BIT) & ((1 << L2CC_INDEX_BIT) - 1);
    L2CC_REGS->L2CC_CIR = L2CC_CIR_IDX(index) | L2CC_CIR_WAY(way) | L2CC_CIR_C_Msk;
    while (L2CC_REGS->L2CC_CIR & L2CC_CIR_C_Msk);
}

void l2cc_clean_invalidate_index(uint32_t phys_addr, uint8_t way)
{
    uint32_t index;

    index = (phys_addr >> L2CC_OFFSET_BIT) & ((1 << L2CC_INDEX_BIT) - 1);
    L2CC_REGS->L2CC_CIIR = L2CC_CIIR_IDX(index) | L2CC_CIIR_WAY(way) | L2CC_CIIR_C_Msk;
    while (L2CC_REGS->L2CC_CIIR & L2CC_CIIR_C_Msk);
}

void l2cc_data_lockdown(uint8_t way)
{
    L2CC_REGS->L2CC_DLKR = way;
    while (L2CC_REGS->L2CC_CSR & L2CC_CSR_C_Msk);
}

void l2cc_instruction_lockdown(uint8_t way)
{
    L2CC_REGS->L2CC_ILKR = way;
    while (L2CC_REGS->L2CC_CSR & L2CC_CSR_C_Msk);
}
*/

// *****************************************************************************
/* Function:
    void PLIB_L2CC_CleanCache(void);

  Summary:
    Cleans (flushes) the L2 cache.

  Description:
    This function flushes the L2 cache.

  Precondition:
    PLIB_L2CC_Initialize has been called.

  Parameters:
    None.

  Returns:
    None.

  Example:
    <code>
    PLIB_L2CC_CleanCache();
    </code>

*/
void PLIB_L2CC_CleanCache(void)
{
    if (l2cacheIsEnabled()) {
        // forces the address out past level 2
        cleanWay(0xFF);
        // Ensures completion of the L2 clean
        cacheSync();
    }
}

// *****************************************************************************
/* Function:
    void PLIB_L2CC_InvalidateCache(void);

  Summary:
    Invalidates L2 cache entries.

  Description:
    This function will mark all cache entries as invalid.

  Precondition:
    PLIB_L2CC_Initialize has been called.

  Parameters:
    None.

  Returns:
    None.

  Example:
    <code>
    PLIB_L2CC_InvalidateCache();
    </code>

*/
void PLIB_L2CC_InvalidateCache(void)
{
    if (l2cacheIsEnabled()) {
        // forces the address out past level 2
        invalidateWay(0xFF);
        // Ensures completion of the L2 inval
        cacheSync();
    }
}

// *****************************************************************************
/* Function:
    void PLIB_L2CC_CleanInvalidateCache(void);

  Summary:
    Cleans and Invalidates L2 cache entries.

  Description:
    This function will clean all dirty entries and then mark all cache entries
    as invalid.

  Precondition:
    PLIB_L2CC_Initialize has been called.

  Parameters:
    None.

  Returns:
    None.

  Example:
    <code>
    PLIB_L2CC_CleanInvalidateCache();
    </code>

*/
void PLIB_L2CC_CleanInvalidateCache(void)
{
    if (l2cacheIsEnabled()) {
        /* forces the address out past level 2 */
        cleanInvalidateWay(0xFF);
        /* Ensures completion of the L2 inval */
        cacheSync();
    }
}

// *****************************************************************************
/* Function:
    void PLIB_L2CC_InvalidateCacheByAddr(uint32_t *addr, uint32_t size);

  Summary:
    Invalidates L2 cache entries.

  Description:
    This function will mark cache entries within the givin address range as
    invalid.

  Precondition:
    PLIB_L2CC_Initialize has been called.

  Parameters:
    addr        - The start address of the memory range to be invalidated

    size        - The size of the memory range to be invalidated

  Returns:
    None.

  Example:
    <code>
    PLIB_L2CC_InvalidateCacheByAddr(dmaMem, dmaMemSize);
    </code>

*/
void PLIB_L2CC_InvalidateCacheByAddr(uint32_t *addr, uint32_t size)
{
    uint32_t start = (uint32_t)addr;
    uint32_t end = start + size;
    uint32_t current = start & ~0x1f;
    if (l2cacheIsEnabled()) {
        while (current <= end) {
            invalidatePAL(current);
            current += 32;
        }
        invalidatePAL(end);
    }
}

// *****************************************************************************
/* Function:
    void PLIB_L2CC_CleanCacheByAddr(uint32_t *addr, uint32_t size);

  Summary:
    Flushes L2 cache entries.

  Description:
    This function will flush all dirty cache entries within the given address
    range.

  Precondition:
    PLIB_L2CC_Initialize has been called.

  Parameters:
    addr        - The start address of the memory range to be cleaned

    size        - The size of the memory range to be cleaned

  Returns:
    None.

  Example:
    <code>
    PLIB_L2CC_CleanCacheByAddr(dmaMem, dmaMemSize);
    </code>

*/
void PLIB_L2CC_CleanCacheByAddr(uint32_t *addr, uint32_t size)
{
    uint32_t start = (uint32_t)addr;
    uint32_t end = start + size;
    uint32_t current = start & ~0x1f;
    if (l2cacheIsEnabled()) {
        while (current <= end) {
            cleanPAL(current);
            current += 32;
        }
        cleanPAL(end);
    }
}

// *****************************************************************************
/* Function:
    void PLIB_L2CC_CleanInvalidateCacheByAddr(uint32_t *addr, uint32_t size);

  Summary:
    Cleans and Invalidates L2 cache entries.

  Description:
    This function will clean all dirty entries and then mark all cache entries
    as invalid within the given range.

  Precondition:
    PLIB_L2CC_Initialize has been called.

  Parameters:
    addr        - The start address of the memory range to be cleaned

    size        - The size of the memory range to be cleaned

  Returns:
    None.

  Example:
    <code>
    PLIB_L2CC_CleanInvalidateCacheByAddr(dmaMem, dmaMemSize);
    </code>

*/
void PLIB_L2CC_CleanInvalidateCacheByAddr(uint32_t *addr, uint32_t size)
{
    uint32_t start = (uint32_t)addr;
    uint32_t end = start + size;
    uint32_t current = start & ~0x1f;
    if (l2cacheIsEnabled()) {
        while (current <= end) {
            cleanInvalidatePAL(current);
            current += 32;
        }
        cleanInvalidatePAL(end);
    }
}

// *****************************************************************************
/* Function:
    void PLIB_L2CC_Initialize(void);

  Summary:
    Initialize the L2 cache controller.

  Description:
    This function initializes the L2 cache controller.

  Precondition:
    None.

  Parameters:
    None.

  Returns:
    None.

  Example:
    <code>
    PLIB_L2CC_Initialize();
    </code>

*/
void PLIB_L2CC_Initialize(void)
{
    <#if L2CC_ECR_EVCEN>
    eventConfig(0, ${L2CC_ECFGR0_ESRC},
                      ${L2CC_ECFGR0_EIGEN});
    eventConfig(1, ${L2CC_ECFGR1_ESRC},
                      ${L2CC_ECFGR1_EIGEN});
    enableEventCounter(0);
    enableEventCounter(1);
    </#if>

    /* Set configuration */
    setConfig();

    <#if L2CC_TRCR>
    /* Set tag latency */
    setTagRamLatency();
    </#if>

    <#if L2CC_DRCR>
    /* Set data latency */
    setDataRamLatency();
    </#if>

    /* Enable Prefetch */
    instPrefetchEnable();
    dataPrefetchEnable();

    /* Invalidate whole L2CC */
    invalidateWay(0xFF);

    /* Disable all L2CC Interrupt */
    disableInt(0x1FF);

    /* Clear all L2CC Interrupt */
    clearInt(0x1FF);

    <#if L2CC_ACR_EXCC>
    /* Set exclusive mode */
    l2cacheSetExclusive();
    <#else>
    /* Set non-exclusive mode */
    l2cacheSetNonExclusive();
    </#if>

    /* Enable L2CC */
    l2cacheEnable();
}
