Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C3D48A2E0
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jan 2022 23:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345058AbiAJWcW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jan 2022 17:32:22 -0500
Received: from mail-mw2nam12on2081.outbound.protection.outlook.com ([40.107.244.81]:50145
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242073AbiAJWcR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jan 2022 17:32:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/+H0n0+6QOFTW5dAlb7UJyy26em+ouYP2xnVgewIX+ef5wXEDEab4KN7ir6mjd/r01Dz6WT0LOdU+6YKhfR70EGP96U/9GP+4spQsPz5GbKGBwzS9f4/L+vgdMtA1Nv7DMZ8v+e76LDs1ApvoVmojo4fZTJU7NiUFQuGb1t4/fnParkrEBoySzBVTjEiaLVCFdUCTDGl1PLNyY8X2fSVVt86G3TeHwNAjkt+6nFCyG4xUFxWkK5xF/l9PIxU/0+vqnJnEVnwmYGoBLtPl3QQrWGY/H6gY/PF/BP67xY/dBtoqzTwkw1yp11tJYX6KRYi8kraQVKfIFGQCHt7Ls4dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SN4TZuTqTKm3s0l6VB7Pala5pjfNrTVsDcquCXNhKko=;
 b=Mgpvl465YFEpk81c60gESfDg6SEFBigv3iEvf8z0mGCJRlQWR+adFOrDzSM2J+VQmSLOQ7CDoJ7kqWi7mh/OX3pbp0hkKIgn5DzucxuvKB0l8z30R0E9JVP7oSWB9D2orrS3xf318WOCXKrNxtHm+ER7n8kDdU+94p/i7khHSVlAWCQUyVz6BwYl4m1jLXdWqUE7CiGW5nW9fOAN6e9kX/vZbCE9D0MaxJuF0bthQw1uix0QUKh2+qSZJ222IDhybh316FkQdSXsYJ7nVimMUS49AMyTQPaMyceCeY4uBX/VBJVLKgnIFGUA4EugTeIiowETaKs4I/bSnITyblZuHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SN4TZuTqTKm3s0l6VB7Pala5pjfNrTVsDcquCXNhKko=;
 b=3vreLj1rYyUAzp7hUMh0cFOxtVxW+GN1WZhZ3xzJlUmWRzEW25m+FdKT2h5N5zjLlmDjGw0+Xnapvli617fD74/WxhIYjEzILeCMhBRWY4ISzE4hf9EHt+yWSoH6KeoynRojCD3RjxVeJyP4ZlcdojOkkLZvU1CtI6zkUJgSr1w=
Received: from BN0PR04CA0136.namprd04.prod.outlook.com (2603:10b6:408:ed::21)
 by DM6PR12MB2681.namprd12.prod.outlook.com (2603:10b6:5:41::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Mon, 10 Jan
 2022 22:32:13 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::87) by BN0PR04CA0136.outlook.office365.com
 (2603:10b6:408:ed::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9 via Frontend
 Transport; Mon, 10 Jan 2022 22:32:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.9 via Frontend Transport; Mon, 10 Jan 2022 22:32:13 +0000
Received: from alex-MS-7B09.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 10 Jan
 2022 16:32:12 -0600
From:   Alex Sierra <alex.sierra@amd.com>
To:     <akpm@linux-foundation.org>, <Felix.Kuehling@amd.com>,
        <linux-mm@kvack.org>, <rcampbell@nvidia.com>,
        <linux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>
CC:     <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <hch@lst.de>, <jgg@nvidia.com>, <jglisse@redhat.com>,
        <apopple@nvidia.com>, <willy@infradead.org>
Subject: [PATCH v3 02/10] mm: add device coherent vma selection for memory migration
Date:   Mon, 10 Jan 2022 16:31:53 -0600
Message-ID: <20220110223201.31024-3-alex.sierra@amd.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220110223201.31024-1-alex.sierra@amd.com>
References: <20220110223201.31024-1-alex.sierra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b161fbe9-979d-4980-1ed4-08d9d4890c95
X-MS-TrafficTypeDiagnostic: DM6PR12MB2681:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2681285D109C10B62C0BE4F1FD509@DM6PR12MB2681.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VHEJMRGzywtNWH/sGdFLvBNW9MVJbf1SJzRLP19GxRpJT+GMIMlREEVAkpWoULjSkK81YHpVa9WTytpUVNEwJqsSpCJZHNQeq2r2yaZbTuPlIzUUrIZboV3pzHoxspw2tQQNFrPrAOj/gkv5vZN+ECFqsExOEJF8aeqVUDe2KcZRDBbGoJF7tgkofw38ahi9gH7l3VSsNyxXTgE0XI7DhjuORcw+tsGUJkSToLR2eaRHgABZ0zChtKuUgNN5d+0/DnWTwGcfGTAQRLYNB0Uwf9Uxbwuu4LEn+QW4lJfaM0p/B8VFFIvQRz7O6Ien/FTUYysSUzPZEaJpUpnBTXh66sdfBC27Sn27v3PYfrTDnoVjkqm9YHDO0cmrUvbIC5llgE+nWb2Pm4m4OOk2WCkaiAeVtkCh1T/GBXUDRcEPZej6lKAAdc7qeVfiPXj7x3lDp5DeDI6JjNFwMoZagc+byDxn0Kkbk78A8wpQFJfbswzJ4IX/Un4dU+Ucuv9VVqWMfYg15TURrvZmkOZ9IcwSHFqmNjDDPZE8aIvHcUB3WCZRxnnCy5oXlZnSgn7EoQ51NDCZaR5UwYpaugnh6rwpb8W+tV8Wsj6XxKJa1fnqBm5BjYr9GeUpJ84tFEkyP7WRKxUFUwgBhmJ2nC2DL15osum6ZqBlfZlvPAb+duLg46N19G3xvdWzoenT6/sbbmA+NKfjGoqy4Q45KUbIItiARvRf2pQc2BCV8AmwnZTVDTn57QXrSpL1wZze/SvRcS2MVwombHCL8BVO6aPsB6RJWWgqOf7M1GYS5NPZejGVANw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(44832011)(356005)(40460700001)(316002)(82310400004)(81166007)(83380400001)(2616005)(6666004)(16526019)(7696005)(70586007)(70206006)(186003)(7416002)(426003)(508600001)(2906002)(336012)(36756003)(110136005)(5660300002)(4326008)(8936002)(1076003)(8676002)(26005)(36860700001)(47076005)(86362001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 22:32:13.2281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b161fbe9-979d-4980-1ed4-08d9d4890c95
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2681
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This case is used to migrate pages from device memory, back to system
memory. Device coherent type memory is cache coherent from device and CPU
point of view.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
---
v2:
condition added when migrations from device coherent pages.
---
 include/linux/migrate.h | 1 +
 mm/migrate.c            | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index c8077e936691..e74bb0978f6f 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -138,6 +138,7 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 enum migrate_vma_direction {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
+	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
 };
 
 struct migrate_vma {
diff --git a/mm/migrate.c b/mm/migrate.c
index 91018880dc7f..0367f471211a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2340,8 +2340,6 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			if (is_writable_device_private_entry(entry))
 				mpfn |= MIGRATE_PFN_WRITE;
 		} else {
-			if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM))
-				goto next;
 			pfn = pte_pfn(pte);
 			if (is_zero_pfn(pfn)) {
 				mpfn = MIGRATE_PFN_MIGRATE;
@@ -2349,6 +2347,13 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 				goto next;
 			}
 			page = vm_normal_page(migrate->vma, addr, pte);
+			if (page && !is_zone_device_page(page) &&
+			    !(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM))
+				goto next;
+			if (page && is_device_coherent_page(page) &&
+			    (!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
+			     page->pgmap->owner != migrate->pgmap_owner))
+				goto next;
 			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 		}
-- 
2.32.0

