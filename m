Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4AE49F27B
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Jan 2022 05:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiA1EZN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jan 2022 23:25:13 -0500
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:44608
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346033AbiA1EZN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jan 2022 23:25:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DB8vA0a0FI0ovPIDuz6I8rOZwXLtjBdO8at4k6hEOzMz7UTvxQeTv1B4eeBT8OIE4dtq6wwz5sOSJXa4tURAhZpm9t/UtvL28e2gz+srIo7hLuW9OXqj+8l6eE4Jb652Tfwhm2Mp9frjDfFOcXmPAh6RE6l3X+NfxQ4ydPC48E0tn+7cZelNEo/TWnt8uv1Pp6jLBJZ8Av8pufVjlaAmtLOg9OXzamNnVMPSaddxxRSsqb8Z4ETBTZ/NolsVzFrc+oNUrmmlFM8cRA9v0ylGGLWhG5mrFooGAslnANEmn0vnIidQ8GjuYuBLgAKKn7SP3xj0ffhwfUFcv3m3nb5tQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zw25dBe122RsY1Dd02aURAPDw/ptl3nm25r0MvpnKDc=;
 b=nD2jfXoSnpsItDmZY1fQ5RbSLA+8iNFwaeLJGVrNRdhYgVMeg6Cdgv2qw8j9gSjiNNkIiVXSgrE4IdSvpmOZortrZsiN7SF1I2ch7O4O5V/iTqJckab+EgCiAftm70JxmqQ9hWN/u8AdhQT8L2EFE2fVtBF5a4RwUiqPshPePadkn5EVLb8CLyUff2R5l6v2lWyLXBQWrPhIN/SEFRr/GHBxjBZhVTUcbxN64OVILrOrdjojXP6jf3yCfWgg5Nc6QLKa4kZeXeMYuBqTKoKWtVCyxS5IlYrXEBMyM134ZI4T4XXQcv1NiRoAkvya3sjAezIplzCKnmY/CH+2V4/l4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=lists.freedesktop.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zw25dBe122RsY1Dd02aURAPDw/ptl3nm25r0MvpnKDc=;
 b=oEY5n8jH6PMThd48/IwrRQEGoBmSC2eV0MsJQRxtBQcyFjQyanTb7dcAyE8DyKDD6mjJvCFmLkfLpEEmUrAwzrLMEr+e1Cx0HJFjJYDRNLbPtkAFaxMU0+y9XO2eSE9t43rvkOHivnSYaFEdpe/DDeDqnzCobFB+DSbyJg8d+dYOOAfqZXaHaJuX5YUvbjmfZ4h6eHq7mzgaRgqk01G+8cbdnoipmJ2ZbqL2zk/XlwT2ZUcMnYP72XfiqpJsPzeqhtki6hHjnMDFmExfw8hXvx7UKT5iKlL4DrDHrRW4uD4Ic96WFg2BexMUP25Y18uZwJ019B5vJJRyCjy6WBFsWg==
Received: from CO2PR06CA0069.namprd06.prod.outlook.com (2603:10b6:104:3::27)
 by MWHPR12MB1487.namprd12.prod.outlook.com (2603:10b6:301:3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Fri, 28 Jan
 2022 04:25:10 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:3:cafe::b6) by CO2PR06CA0069.outlook.office365.com
 (2603:10b6:104:3::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Fri, 28 Jan 2022 04:25:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Fri, 28 Jan 2022 04:25:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 28 Jan
 2022 04:25:07 +0000
Received: from nvdebian.localnet (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 27 Jan 2022
 20:25:04 -0800
From:   Alistair Popple <apopple@nvidia.com>
To:     <akpm@linux-foundation.org>, <Felix.Kuehling@amd.com>,
        <linux-mm@kvack.org>, <rcampbell@nvidia.com>,
        <linux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        Alex Sierra <alex.sierra@amd.com>
CC:     <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <hch@lst.de>, <jgg@nvidia.com>, <jglisse@redhat.com>,
        <willy@infradead.org>
Subject: Re: [PATCH v4 08/10] lib: add support for device coherent type in test_hmm
Date:   Fri, 28 Jan 2022 15:25:02 +1100
Message-ID: <82227662.YJXyKnsqfq@nvdebian>
In-Reply-To: <20220127030949.19396-9-alex.sierra@amd.com>
References: <20220127030949.19396-1-alex.sierra@amd.com> <20220127030949.19396-9-alex.sierra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail201.nvidia.com (10.126.190.180) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd0e7d8e-5cde-4ed2-882f-08d9e2162b99
X-MS-TrafficTypeDiagnostic: MWHPR12MB1487:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB14870A62D5DF402CBA418878DF229@MWHPR12MB1487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pX9vJtMCMB0uj2DKFW41UtW/rvckgBZFqyHzO9Xw3JaOPNzI1ZHGdb7WEzYoCBZIFq+UNeKJqe9R+GWPg2WXgeRa1r2AEnsbUazyjEBLgG1Bp8VkZzpoqLVpiYtFWeyG5MqdGnBCRw1cIeCqR/zfGJx8FhAOAd854mfVdia+vCepM94Dzg6AdVPF5Gu1ngXSQtbIEeW00sHElObN3HsojxhUj1FBdh7BDswWLiGkKMsDiAJlu++ieNBXgHFPyJ1RTSwu0T79yIDLVTpWOC4TY5sz4SVgpev2c3O0LCIJcWmWfsHEGPMLgRJZcTfD04jcYXK4KVZoeKIz2bTYwSHPiVw6DxcXj+eDtj/ShhxWoamxeYWpQVo5txSW4ieevyn8VM6AIbXPfrQr1pMU5FZgSknVjv2K6Ruog8BeWq4nkGPss0uUi+Kh3LVFtj+z3Ai1ogFCKEsHPd+D1j+/KdFTR0LXql5fxvKhAeSWSFulNUTWSe/Sj+SE5Qnh9FFIwES1n7Sa/mHalNg8KbWCKdNly4pBl071tcdS4pYJ2vBftgWp9goQbAKqdTJQK+nbX1oV4JwoEfQjpd2wTuOww7IiORUSJgJcV41JkEpOV+40dd4yPw52S0SVuvS+Q6095ZOhD6XYh07fcHJtcYTL43tMZ6UvI02OciQEupfAv+jszPkYVS8Pqw7hdfEnaSC0OM0uA6JE4oc6xN1eH+JO0SDNyqAzom9vWUEYSRblJoZVaBGce98FfwSmVs9lRVuCIlfJ7OHgPrtYZU9gj7ze57eaRnW6VWnEpLr83vrH/683YBE=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700004)(86362001)(508600001)(82310400004)(8676002)(356005)(16526019)(83380400001)(54906003)(110136005)(40460700003)(316002)(7416002)(186003)(47076005)(70586007)(426003)(70206006)(30864003)(9576002)(9686003)(336012)(81166007)(33716001)(26005)(8936002)(4326008)(5660300002)(2906002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 04:25:09.7182
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0e7d8e-5cde-4ed2-882f-08d9e2162b99
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1487
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I haven't tested the change which checks that pages migrated back to sysmem,
but it looks ok so:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

On Thursday, 27 January 2022 2:09:47 PM AEDT Alex Sierra wrote:
> Device Coherent type uses device memory that is coherently accesible by
> the CPU. This could be shown as SP (special purpose) memory range
> at the BIOS-e820 memory enumeration. If no SP memory is supported in
> system, this could be faked by setting CONFIG_EFI_FAKE_MEMMAP.
> 
> Currently, test_hmm only supports two different SP ranges of at least
> 256MB size. This could be specified in the kernel parameter variable
> efi_fake_mem. Ex. Two SP ranges of 1GB starting at 0x100000000 &
> 0x140000000 physical address. Ex.
> efi_fake_mem=1G@0x100000000:0x40000,1G@0x140000000:0x40000
> 
> Private and coherent device mirror instances can be created in the same
> probed. This is done by passing the module parameters spm_addr_dev0 &
> spm_addr_dev1. In this case, it will create four instances of
> device_mirror. The first two correspond to private device type, the
> last two to coherent type. Then, they can be easily accessed from user
> space through /dev/hmm_mirror<num_device>. Usually num_device 0 and 1
> are for private, and 2 and 3 for coherent types. If no module
> parameters are passed, two instances of private type device_mirror will
> be created only.
> 
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> ---
> v4:
> Return number of coherent device pages successfully migrated to system.
> This is returned at cmd->cpages.
> ---
>  lib/test_hmm.c      | 260 +++++++++++++++++++++++++++++++++-----------
>  lib/test_hmm_uapi.h |  15 ++-
>  2 files changed, 205 insertions(+), 70 deletions(-)
> 
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 6f068f7c4ee3..850d5331e370 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -29,11 +29,22 @@
>  
>  #include "test_hmm_uapi.h"
>  
> -#define DMIRROR_NDEVICES		2
> +#define DMIRROR_NDEVICES		4
>  #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
>  #define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
>  #define DEVMEM_CHUNKS_RESERVE		16
>  
> +/*
> + * For device_private pages, dpage is just a dummy struct page
> + * representing a piece of device memory. dmirror_devmem_alloc_page
> + * allocates a real system memory page as backing storage to fake a
> + * real device. zone_device_data points to that backing page. But
> + * for device_coherent memory, the struct page represents real
> + * physical CPU-accessible memory that we can use directly.
> + */
> +#define BACKING_PAGE(page) (is_device_private_page((page)) ? \
> +			   (page)->zone_device_data : (page))
> +
>  static unsigned long spm_addr_dev0;
>  module_param(spm_addr_dev0, long, 0644);
>  MODULE_PARM_DESC(spm_addr_dev0,
> @@ -122,6 +133,21 @@ static int dmirror_bounce_init(struct dmirror_bounce *bounce,
>  	return 0;
>  }
>  
> +static bool dmirror_is_private_zone(struct dmirror_device *mdevice)
> +{
> +	return (mdevice->zone_device_type ==
> +		HMM_DMIRROR_MEMORY_DEVICE_PRIVATE) ? true : false;
> +}
> +
> +static enum migrate_vma_direction
> +	dmirror_select_device(struct dmirror *dmirror)
> +{
> +	return (dmirror->mdevice->zone_device_type ==
> +		HMM_DMIRROR_MEMORY_DEVICE_PRIVATE) ?
> +		MIGRATE_VMA_SELECT_DEVICE_PRIVATE :
> +		MIGRATE_VMA_SELECT_DEVICE_COHERENT;
> +}
> +
>  static void dmirror_bounce_fini(struct dmirror_bounce *bounce)
>  {
>  	vfree(bounce->ptr);
> @@ -572,16 +598,19 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
>  static struct page *dmirror_devmem_alloc_page(struct dmirror_device *mdevice)
>  {
>  	struct page *dpage = NULL;
> -	struct page *rpage;
> +	struct page *rpage = NULL;
>  
>  	/*
> -	 * This is a fake device so we alloc real system memory to store
> -	 * our device memory.
> +	 * For ZONE_DEVICE private type, this is a fake device so we alloc real
> +	 * system memory to store our device memory.
> +	 * For ZONE_DEVICE coherent type we use the actual dpage to store the data
> +	 * and ignore rpage.
>  	 */
> -	rpage = alloc_page(GFP_HIGHUSER);
> -	if (!rpage)
> -		return NULL;
> -
> +	if (dmirror_is_private_zone(mdevice)) {
> +		rpage = alloc_page(GFP_HIGHUSER);
> +		if (!rpage)
> +			return NULL;
> +	}
>  	spin_lock(&mdevice->lock);
>  
>  	if (mdevice->free_pages) {
> @@ -601,7 +630,8 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror_device *mdevice)
>  	return dpage;
>  
>  error:
> -	__free_page(rpage);
> +	if (rpage)
> +		__free_page(rpage);
>  	return NULL;
>  }
>  
> @@ -627,12 +657,16 @@ static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
>  		 * unallocated pte_none() or read-only zero page.
>  		 */
>  		spage = migrate_pfn_to_page(*src);
> +		if (WARN(spage && is_zone_device_page(spage),
> +		     "page already in device spage pfn: 0x%lx\n",
> +		     page_to_pfn(spage)))
> +			continue;
>  
>  		dpage = dmirror_devmem_alloc_page(mdevice);
>  		if (!dpage)
>  			continue;
>  
> -		rpage = dpage->zone_device_data;
> +		rpage = BACKING_PAGE(dpage);
>  		if (spage)
>  			copy_highpage(rpage, spage);
>  		else
> @@ -646,6 +680,8 @@ static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
>  		 */
>  		rpage->zone_device_data = dmirror;
>  
> +		pr_debug("migrating from sys to dev pfn src: 0x%lx pfn dst: 0x%lx\n",
> +			 page_to_pfn(spage), page_to_pfn(dpage));
>  		*dst = migrate_pfn(page_to_pfn(dpage)) |
>  			    MIGRATE_PFN_LOCKED;
>  		if ((*src & MIGRATE_PFN_WRITE) ||
> @@ -724,11 +760,7 @@ static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
>  		if (!dpage)
>  			continue;
>  
> -		/*
> -		 * Store the page that holds the data so the page table
> -		 * doesn't have to deal with ZONE_DEVICE private pages.
> -		 */
> -		entry = dpage->zone_device_data;
> +		entry = BACKING_PAGE(dpage);
>  		if (*dst & MIGRATE_PFN_WRITE)
>  			entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
>  		entry = xa_store(&dmirror->pt, pfn, entry, GFP_ATOMIC);
> @@ -808,15 +840,124 @@ static int dmirror_exclusive(struct dmirror *dmirror,
>  	return ret;
>  }
>  
> -static int dmirror_migrate(struct dmirror *dmirror,
> -			   struct hmm_dmirror_cmd *cmd)
> +static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
> +						      struct dmirror *dmirror)
> +{
> +	const unsigned long *src = args->src;
> +	unsigned long *dst = args->dst;
> +	unsigned long start = args->start;
> +	unsigned long end = args->end;
> +	unsigned long addr;
> +
> +	for (addr = start; addr < end; addr += PAGE_SIZE,
> +				       src++, dst++) {
> +		struct page *dpage, *spage;
> +
> +		spage = migrate_pfn_to_page(*src);
> +		if (!spage || !(*src & MIGRATE_PFN_MIGRATE))
> +			continue;
> +
> +		if (WARN_ON(!is_dev_private_or_coherent_page(spage)))
> +			continue;
> +		spage = BACKING_PAGE(spage);
> +		dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
> +		if (!dpage)
> +			continue;
> +		pr_debug("migrating from dev to sys pfn src: 0x%lx pfn dst: 0x%lx\n",
> +			 page_to_pfn(spage), page_to_pfn(dpage));
> +
> +		lock_page(dpage);
> +		xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
> +		copy_highpage(dpage, spage);
> +		*dst = migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
> +		if (*src & MIGRATE_PFN_WRITE)
> +			*dst |= MIGRATE_PFN_WRITE;
> +	}
> +	return 0;
> +}
> +
> +static unsigned long dmirror_successful_migrated_pages(struct migrate_vma *migrate)
> +{
> +	unsigned long cpages = 0;
> +	unsigned long i;
> +
> +	for (i = 0; i < migrate->npages; i++) {
> +		if (migrate->src[i] & MIGRATE_PFN_VALID &&
> +		    migrate->src[i] & MIGRATE_PFN_MIGRATE)
> +			cpages++;
> +	}
> +	return cpages;
> +}
> +
> +static int dmirror_migrate_to_system(struct dmirror *dmirror,
> +				     struct hmm_dmirror_cmd *cmd)
> +{
> +	unsigned long start, end, addr;
> +	unsigned long size = cmd->npages << PAGE_SHIFT;
> +	struct mm_struct *mm = dmirror->notifier.mm;
> +	struct vm_area_struct *vma;
> +	unsigned long src_pfns[64] = { 0 };
> +	unsigned long dst_pfns[64] = { 0 };
> +	struct migrate_vma args;
> +	unsigned long next;
> +	int ret;
> +
> +	start = cmd->addr;
> +	end = start + size;
> +	if (end < start)
> +		return -EINVAL;
> +
> +	/* Since the mm is for the mirrored process, get a reference first. */
> +	if (!mmget_not_zero(mm))
> +		return -EINVAL;
> +
> +	cmd->cpages = 0;
> +	mmap_read_lock(mm);
> +	for (addr = start; addr < end; addr = next) {
> +		vma = vma_lookup(mm, addr);
> +		if (!vma || !(vma->vm_flags & VM_READ)) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +		next = min(end, addr + (ARRAY_SIZE(src_pfns) << PAGE_SHIFT));
> +		if (next > vma->vm_end)
> +			next = vma->vm_end;
> +
> +		args.vma = vma;
> +		args.src = src_pfns;
> +		args.dst = dst_pfns;
> +		args.start = addr;
> +		args.end = next;
> +		args.pgmap_owner = dmirror->mdevice;
> +		args.flags = dmirror_select_device(dmirror);
> +
> +		ret = migrate_vma_setup(&args);
> +		if (ret)
> +			goto out;
> +
> +		pr_debug("Migrating from device mem to sys mem\n");
> +		dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
> +
> +		migrate_vma_pages(&args);
> +		cmd->cpages += dmirror_successful_migrated_pages(&args);
> +		migrate_vma_finalize(&args);
> +	}
> +out:
> +	mmap_read_unlock(mm);
> +	mmput(mm);
> +
> +	return ret;
> +}
> +
> +static int dmirror_migrate_to_device(struct dmirror *dmirror,
> +				struct hmm_dmirror_cmd *cmd)
>  {
>  	unsigned long start, end, addr;
>  	unsigned long size = cmd->npages << PAGE_SHIFT;
>  	struct mm_struct *mm = dmirror->notifier.mm;
>  	struct vm_area_struct *vma;
> -	unsigned long src_pfns[64];
> -	unsigned long dst_pfns[64];
> +	unsigned long src_pfns[64] = { 0 };
> +	unsigned long dst_pfns[64] = { 0 };
>  	struct dmirror_bounce bounce;
>  	struct migrate_vma args;
>  	unsigned long next;
> @@ -853,6 +994,7 @@ static int dmirror_migrate(struct dmirror *dmirror,
>  		if (ret)
>  			goto out;
>  
> +		pr_debug("Migrating from sys mem to device mem\n");
>  		dmirror_migrate_alloc_and_copy(&args, dmirror);
>  		migrate_vma_pages(&args);
>  		dmirror_migrate_finalize_and_map(&args, dmirror);
> @@ -861,7 +1003,7 @@ static int dmirror_migrate(struct dmirror *dmirror,
>  	mmap_read_unlock(mm);
>  	mmput(mm);
>  
> -	/* Return the migrated data for verification. */
> +	/* Return the migrated data for verification. only for pages in device zone */
>  	ret = dmirror_bounce_init(&bounce, start, size);
>  	if (ret)
>  		return ret;
> @@ -898,12 +1040,22 @@ static void dmirror_mkentry(struct dmirror *dmirror, struct hmm_range *range,
>  	}
>  
>  	page = hmm_pfn_to_page(entry);
> -	if (is_device_private_page(page)) {
> -		/* Is the page migrated to this device or some other? */
> -		if (dmirror->mdevice == dmirror_page_to_device(page))
> +	if (is_dev_private_or_coherent_page(page)) {
> +		/* Is page ZONE_DEVICE coherent? */
> +		if (is_device_coherent_page(page)) {
> +			if (dmirror->mdevice == dmirror_page_to_device(page))
> +				*perm = HMM_DMIRROR_PROT_DEV_COHERENT_LOCAL;
> +			else
> +				*perm = HMM_DMIRROR_PROT_DEV_COHERENT_REMOTE;
> +		/*
> +		 * Is page ZONE_DEVICE private migrated to
> +		 * this device or some other?
> +		 */
> +		} else if (dmirror->mdevice == dmirror_page_to_device(page)) {
>  			*perm = HMM_DMIRROR_PROT_DEV_PRIVATE_LOCAL;
> -		else
> +		} else {
>  			*perm = HMM_DMIRROR_PROT_DEV_PRIVATE_REMOTE;
> +		}
>  	} else if (is_zero_pfn(page_to_pfn(page)))
>  		*perm = HMM_DMIRROR_PROT_ZERO;
>  	else
> @@ -1100,8 +1252,12 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
>  		ret = dmirror_write(dmirror, &cmd);
>  		break;
>  
> -	case HMM_DMIRROR_MIGRATE:
> -		ret = dmirror_migrate(dmirror, &cmd);
> +	case HMM_DMIRROR_MIGRATE_TO_DEV:
> +		ret = dmirror_migrate_to_device(dmirror, &cmd);
> +		break;
> +
> +	case HMM_DMIRROR_MIGRATE_TO_SYS:
> +		ret = dmirror_migrate_to_system(dmirror, &cmd);
>  		break;
>  
>  	case HMM_DMIRROR_EXCLUSIVE:
> @@ -1142,14 +1298,13 @@ static const struct file_operations dmirror_fops = {
>  
>  static void dmirror_devmem_free(struct page *page)
>  {
> -	struct page *rpage = page->zone_device_data;
> +	struct page *rpage = BACKING_PAGE(page);
>  	struct dmirror_device *mdevice;
>  
> -	if (rpage)
> +	if (rpage != page)
>  		__free_page(rpage);
>  
>  	mdevice = dmirror_page_to_device(page);
> -
>  	spin_lock(&mdevice->lock);
>  	mdevice->cfree++;
>  	page->zone_device_data = mdevice->free_pages;
> @@ -1157,43 +1312,11 @@ static void dmirror_devmem_free(struct page *page)
>  	spin_unlock(&mdevice->lock);
>  }
>  
> -static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
> -						      struct dmirror *dmirror)
> -{
> -	const unsigned long *src = args->src;
> -	unsigned long *dst = args->dst;
> -	unsigned long start = args->start;
> -	unsigned long end = args->end;
> -	unsigned long addr;
> -
> -	for (addr = start; addr < end; addr += PAGE_SIZE,
> -				       src++, dst++) {
> -		struct page *dpage, *spage;
> -
> -		spage = migrate_pfn_to_page(*src);
> -		if (!spage || !(*src & MIGRATE_PFN_MIGRATE))
> -			continue;
> -		spage = spage->zone_device_data;
> -
> -		dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
> -		if (!dpage)
> -			continue;
> -
> -		lock_page(dpage);
> -		xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
> -		copy_highpage(dpage, spage);
> -		*dst = migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
> -		if (*src & MIGRATE_PFN_WRITE)
> -			*dst |= MIGRATE_PFN_WRITE;
> -	}
> -	return 0;
> -}
> -
>  static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>  {
>  	struct migrate_vma args;
> -	unsigned long src_pfns;
> -	unsigned long dst_pfns;
> +	unsigned long src_pfns = 0;
> +	unsigned long dst_pfns = 0;
>  	struct page *rpage;
>  	struct dmirror *dmirror;
>  	vm_fault_t ret;
> @@ -1213,7 +1336,7 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>  	args.src = &src_pfns;
>  	args.dst = &dst_pfns;
>  	args.pgmap_owner = dmirror->mdevice;
> -	args.flags = MIGRATE_VMA_SELECT_DEVICE_PRIVATE;
> +	args.flags = dmirror_select_device(dmirror);
>  
>  	if (migrate_vma_setup(&args))
>  		return VM_FAULT_SIGBUS;
> @@ -1292,6 +1415,12 @@ static int __init hmm_dmirror_init(void)
>  				HMM_DMIRROR_MEMORY_DEVICE_PRIVATE;
>  	dmirror_devices[ndevices++].zone_device_type =
>  				HMM_DMIRROR_MEMORY_DEVICE_PRIVATE;
> +	if (spm_addr_dev0 && spm_addr_dev1) {
> +		dmirror_devices[ndevices++].zone_device_type =
> +					HMM_DMIRROR_MEMORY_DEVICE_COHERENT;
> +		dmirror_devices[ndevices++].zone_device_type =
> +					HMM_DMIRROR_MEMORY_DEVICE_COHERENT;
> +	}
>  	for (id = 0; id < ndevices; id++) {
>  		ret = dmirror_device_init(dmirror_devices + id, id);
>  		if (ret)
> @@ -1314,7 +1443,8 @@ static void __exit hmm_dmirror_exit(void)
>  	int id;
>  
>  	for (id = 0; id < DMIRROR_NDEVICES; id++)
> -		dmirror_device_remove(dmirror_devices + id);
> +		if (dmirror_devices[id].zone_device_type)
> +			dmirror_device_remove(dmirror_devices + id);
>  	unregister_chrdev_region(dmirror_dev, DMIRROR_NDEVICES);
>  }
>  
> diff --git a/lib/test_hmm_uapi.h b/lib/test_hmm_uapi.h
> index 625f3690d086..e190b2ab6f19 100644
> --- a/lib/test_hmm_uapi.h
> +++ b/lib/test_hmm_uapi.h
> @@ -33,11 +33,12 @@ struct hmm_dmirror_cmd {
>  /* Expose the address space of the calling process through hmm device file */
>  #define HMM_DMIRROR_READ		_IOWR('H', 0x00, struct hmm_dmirror_cmd)
>  #define HMM_DMIRROR_WRITE		_IOWR('H', 0x01, struct hmm_dmirror_cmd)
> -#define HMM_DMIRROR_MIGRATE		_IOWR('H', 0x02, struct hmm_dmirror_cmd)
> -#define HMM_DMIRROR_SNAPSHOT		_IOWR('H', 0x03, struct hmm_dmirror_cmd)
> -#define HMM_DMIRROR_EXCLUSIVE		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
> -#define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x05, struct hmm_dmirror_cmd)
> -#define HMM_DMIRROR_GET_MEM_DEV_TYPE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
> +#define HMM_DMIRROR_MIGRATE_TO_DEV	_IOWR('H', 0x02, struct hmm_dmirror_cmd)
> +#define HMM_DMIRROR_MIGRATE_TO_SYS	_IOWR('H', 0x03, struct hmm_dmirror_cmd)
> +#define HMM_DMIRROR_SNAPSHOT		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
> +#define HMM_DMIRROR_EXCLUSIVE		_IOWR('H', 0x05, struct hmm_dmirror_cmd)
> +#define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
> +#define HMM_DMIRROR_GET_MEM_DEV_TYPE	_IOWR('H', 0x07, struct hmm_dmirror_cmd)
>  
>  /*
>   * Values returned in hmm_dmirror_cmd.ptr for HMM_DMIRROR_SNAPSHOT.
> @@ -52,6 +53,8 @@ struct hmm_dmirror_cmd {
>   *					device the ioctl() is made
>   * HMM_DMIRROR_PROT_DEV_PRIVATE_REMOTE: Migrated device private page on some
>   *					other device
> + * HMM_DMIRROR_PROT_DEV_COHERENT: Migrate device coherent page on the device
> + *				  the ioctl() is made
>   */
>  enum {
>  	HMM_DMIRROR_PROT_ERROR			= 0xFF,
> @@ -63,6 +66,8 @@ enum {
>  	HMM_DMIRROR_PROT_ZERO			= 0x10,
>  	HMM_DMIRROR_PROT_DEV_PRIVATE_LOCAL	= 0x20,
>  	HMM_DMIRROR_PROT_DEV_PRIVATE_REMOTE	= 0x30,
> +	HMM_DMIRROR_PROT_DEV_COHERENT_LOCAL	= 0x40,
> +	HMM_DMIRROR_PROT_DEV_COHERENT_REMOTE	= 0x50,
>  };
>  
>  enum {
> 




