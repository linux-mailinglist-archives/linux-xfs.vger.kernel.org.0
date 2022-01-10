Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E540048A2E3
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jan 2022 23:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242073AbiAJWcY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jan 2022 17:32:24 -0500
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:23361
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242151AbiAJWcR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jan 2022 17:32:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiuH+uFu6sFg7FF5d0ZRPY0cxKcLnUtEewGww/s53JRjJjWwruEo84YsgfmQmBta+XZG5Gx2yDfJAHej4mDm7IpIzpbMk5l4ie/kd8F70f3/rQsHwwPNJjrwSqLUFRHQONRQ7+W6iImzzOaxHoVFIJrsXLF6C9l+zH3k5YHxRSClhQzlTIjywD9v1/FsI5QLDgIj6dPqAL/2O3+OCkrYwoLqQjKYogAejBlgapVM88W3Od/Pu0DunNcoPaGs76OQX2qoVyqKqQhH608nTYWNcT6thRaFF3kdJreTEbEaoKntAC8zk98cNBZiSWX05LCJ0rZ2lMi63kWRPGp646iJ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5XOWr7fnVYEba5NhGZxd4trx6OZFuB1g3xD2zb3WjmU=;
 b=nczLUf4uwkATElS3kstF+9p8CB1XRVfoC72tdlG4TQyQv2NtE8LdoThdpoZl/xU020CjfKCNVfZ/amIlavktR5np+WnSRhnSlMu8o9eQIh4zVViCSX+AZiPUAAtYUMg+4uNeKP02ZIPfC/ML71mxPHzsvOHtpKTZ9FvOXoYbjBlIJqph6MxDOejxcWtwsuo58Oq1/bHKe+DUGLUr5EFCIU9ZnrFcrzPVVwo/dQ5ovUfK7bgQt0CUpuwvQktv5IaBmjxnIWj41ecXrysfYvZ8hW/Kjz6apatjfrUaXVt12lO8+PgwUKQWLBk7LEqlpBz4dnnCDio4s5s+yFjInlP17Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XOWr7fnVYEba5NhGZxd4trx6OZFuB1g3xD2zb3WjmU=;
 b=a8rwg2JykkLgWKPT7NaGfx0T8IDsrwG0g0yhCveONQqMcCmLhqiSw7Nz0EDNxhNPXdfcEmTfZ4S9pOdMKivG3VE1ot+QEuaojMOWd+vMniM4qy/tqbd7rmOnSFirSyKed3mvz/aKnPvBTehl5NzHWlK70UBm/bPzKFholHSJixM=
Received: from BN7PR02CA0006.namprd02.prod.outlook.com (2603:10b6:408:20::19)
 by DM4PR12MB5117.namprd12.prod.outlook.com (2603:10b6:5:390::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Mon, 10 Jan
 2022 22:32:15 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::22) by BN7PR02CA0006.outlook.office365.com
 (2603:10b6:408:20::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11 via Frontend
 Transport; Mon, 10 Jan 2022 22:32:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.9 via Frontend Transport; Mon, 10 Jan 2022 22:32:15 +0000
Received: from alex-MS-7B09.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 10 Jan
 2022 16:32:14 -0600
From:   Alex Sierra <alex.sierra@amd.com>
To:     <akpm@linux-foundation.org>, <Felix.Kuehling@amd.com>,
        <linux-mm@kvack.org>, <rcampbell@nvidia.com>,
        <linux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>
CC:     <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <hch@lst.de>, <jgg@nvidia.com>, <jglisse@redhat.com>,
        <apopple@nvidia.com>, <willy@infradead.org>
Subject: [PATCH v3 05/10] drm/amdkfd: coherent type as sys mem on migration to ram
Date:   Mon, 10 Jan 2022 16:31:56 -0600
Message-ID: <20220110223201.31024-6-alex.sierra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9d1e849c-c678-4f7b-8bde-08d9d4890da9
X-MS-TrafficTypeDiagnostic: DM4PR12MB5117:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5117E237E5ECB357EFDAE0DAFD509@DM4PR12MB5117.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ko7QYzFeqs3ARTKJyAzozHw4LEYeZyLh6lrm0wrQYmpDil6xFvyWkfyLEMUjN5yVT/sDNdCnpV4itNkP7pVjyGkTZFzHNOzY7WQm4bvDK4bJ5McfZU/xGYJnpqmShl7upkVKUOlYlPCI2wB6ls9XkUCa7dy8IPiHLr/yVSZIfAtzpp/oXgzydU6hOZA0xQf58HqHDiGWWQTTSioiV3Go1bx3MK2dgkxaK5k2UqijLfClM6nVkXbpkBAwYJ0th/itqbkEoU7yF14cE7u0Cy7lpFgVYsqpbgeuqCxlSd2cdlohtBPKzr1VoCcl4JAFsV6BQW1vUlv12mhKpdZoEnrhrucGZYu9ZLH61F0UAN39lcyb1CkIQjWxHlDaSOwhVtggVNRk9UxDQD4a1BF+7LmZYEUUHZprAvqr3KqdhJbzPeudqWxaOkICCQijEge7mma0wBoM41Cfz447zb4cl8wbF1P0aCWaUqoCqSwRvAcD7ZGS+9tLRi4HNPJhsg3IyyLv2KcGy/OjgBzsx3h7Xq2WyBY8GnYg3nKcgA/P4RD44iGl7DV+I0chB5qbw6vSJYzOQc9VbNlppIeHMQYUYnrUGJVRyYPDwCp9ZijFMbm5lcDJGLsD85k9SjXIsmq6o/Bfq82myitw2LYFPnyeSKZR3gZUtYqiSlcu9jgLXCk4Or1hVANnONQUZszFMdqZYRx3D/rTPMuXRQMv0QfYCJ6cO6yHoE4UCXPmKP/XpM4qnUwfHvn7tdvLb6EIzXOwlkyt/10mjVxNyVcbbuNvlPj6fz/nRIKqrLspMCceCNmb/YY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(7696005)(5660300002)(2616005)(336012)(426003)(44832011)(36860700001)(16526019)(26005)(186003)(83380400001)(1076003)(54906003)(110136005)(316002)(4326008)(40460700001)(86362001)(47076005)(82310400004)(6666004)(81166007)(70206006)(356005)(70586007)(36756003)(7416002)(8936002)(8676002)(508600001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 22:32:15.3990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d1e849c-c678-4f7b-8bde-08d9d4890da9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5117
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Coherent device type memory on VRAM to RAM migration, has similar access
as System RAM from the CPU. This flag sets the source from the sender.
Which in Coherent type case, should be set as
MIGRATE_VMA_SELECT_DEVICE_COHERENT.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 9e36fe8aea0f..3e405f078ade 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -661,9 +661,12 @@ svm_migrate_vma_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
 	migrate.vma = vma;
 	migrate.start = start;
 	migrate.end = end;
-	migrate.flags = MIGRATE_VMA_SELECT_DEVICE_PRIVATE;
 	migrate.pgmap_owner = SVM_ADEV_PGMAP_OWNER(adev);
 
+	if (adev->gmc.xgmi.connected_to_cpu)
+		migrate.flags = MIGRATE_VMA_SELECT_DEVICE_COHERENT;
+	else
+		migrate.flags = MIGRATE_VMA_SELECT_DEVICE_PRIVATE;
 	size = 2 * sizeof(*migrate.src) + sizeof(uint64_t) + sizeof(dma_addr_t);
 	size *= npages;
 	buf = kvmalloc(size, GFP_KERNEL | __GFP_ZERO);
-- 
2.32.0

