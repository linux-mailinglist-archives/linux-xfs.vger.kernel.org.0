Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD0155F487
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jun 2022 05:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiF2Dzt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 Jun 2022 23:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiF2DzS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 23:55:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C599A2CDC6;
        Tue, 28 Jun 2022 20:55:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFNfeaxabkJ6YptSJEI0kEEv3QUCkawE1rM5pOyRHkwqSXRE5lMtODT0SskM2lRp0TJtA3L3QjpQA6DeYG4jq28vNiK2lVG3SLydJq/heMnYFElDm1nvqFd9Niaj1G48ggk71V2qtUJWz3QTvhI8sZIYs5r+7B4E6oakG+YOAApFQ4Av/hZV1R8MHSfbKO5d62d1Om/GViEftGVMSaRUk8PmKuR6iL3zDPTMcc7+mYPspJkauOEDJgioIADyqbaQJbHE1d6ONQdFgjgzZKcjn2peCgRmrVYH05NSpPImQYc0g1LdI6n/HHQrd16BbocRJ/FCehL69TP67qMIOXjC4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8lzcu9Uc51zZ3prS+uZltVgKEco8VgkJ2E7O9HgaPo=;
 b=chtdXIxaOLDef6OvjuYInL4b6IKDgnS5DRk5rDuYp7BrmVn0z00TNKETkPaIyZteH+dRGviKBYcWVgNHixqFQza5gEpicbfoNlCXZV6kOx1DQDHaEf/iXLoYLc8GAczOfxxwAwv8AVhN8m3z8ABV32M+/1GkOQstiirChokj+uBj5zewzAYwnckJ/zCvb4AobaA5kpwAbjQonNDuLNhNWWFMmNbHhEuv1BqXDDNA77CqbWaCxkQ/DD/HD4g0xUPOC8R9ytqOEUmFk8wYwkyQySaL8zbE1VtgcXfHPk491Bzk1Udc6kP8YRNEndsBkYjSA8k07JCjlnHHklrpwkR2bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8lzcu9Uc51zZ3prS+uZltVgKEco8VgkJ2E7O9HgaPo=;
 b=UTbQirQt2ogzzktIuxnmRcHnjHHRtmVlQL5NyzbV9BpnEkjWEdRqiMlUPOuR1zFeh8xscl3zxXJriBZmJk97ZSX1SnWQr4xLeaLe9GV/9VbbqQdephblPQ8JZOOx2apwup8GOi9RtyhZ+6gyUF60bUTd61k4GtypZh2TfMSUs/Q=
Received: from BN8PR12CA0011.namprd12.prod.outlook.com (2603:10b6:408:60::24)
 by DM6PR12MB4515.namprd12.prod.outlook.com (2603:10b6:5:2a1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 03:55:13 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::71) by BN8PR12CA0011.outlook.office365.com
 (2603:10b6:408:60::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Wed, 29 Jun 2022 03:55:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Wed, 29 Jun 2022 03:55:12 +0000
Received: from alex-MS-7B09.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 28 Jun
 2022 22:55:10 -0500
From:   Alex Sierra <alex.sierra@amd.com>
To:     <jgg@nvidia.com>
CC:     <david@redhat.com>, <Felix.Kuehling@amd.com>, <linux-mm@kvack.org>,
        <rcampbell@nvidia.com>, <linux-ext4@vger.kernel.org>,
        <linux-xfs@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <hch@lst.de>,
        <jglisse@redhat.com>, <apopple@nvidia.com>, <willy@infradead.org>,
        <akpm@linux-foundation.org>
Subject: [PATCH v7 08/14] lib: test_hmm add ioctl to get zone device type
Date:   Tue, 28 Jun 2022 22:54:20 -0500
Message-ID: <20220629035426.20013-9-alex.sierra@amd.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220629035426.20013-1-alex.sierra@amd.com>
References: <20220629035426.20013-1-alex.sierra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddd1929c-bd1a-4657-ad8a-08da59832b5f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4515:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vPJp0xPGuo+8sDvCrOgSnzj6i3pAW4jRcfnafUJQu1TCoZxGAcWgDQAHnUCwPTTF7mGrcbEQ2EtzIGweBbqS+kpyXUCIj/+BrT16RlszQReTyyVwDz8xQAHOQQykHAzyF2AcsaY+5fz7v/AsDWDL81G4v2fkgdzQZyJfu703zfdO20DBkakNOAiEDPwT69AXtCrHrW7KLKQkwqDy0r4Er1KDEc6r5nW23N5cssEeg30j33xgusM34VD0c3LANLTzEmNiK5yRoiQLzMM5oWtjeNTaZZhtcwOYcIDz1IH7auuSXSZaQLm+fCGhuIUlwgAHitFgpai6i/uPYUp3VAqrECisDPhi//0IFe1PTw7MGD/RiCF6BS22uihyQRXRwEiAW6o0UnLpS3Xf7h6nRamG4HusvC56gB5nrb7NRzlY3D7bHeh8flg3SH7tuhP3hUablGN3F8GnH0fC3NTIP9zMNuBb6vipv6/+C/p4bQc8Ux3nHe9LWrQJHxG6Y9hEuOE831QPYQwT+FM/1rlbLLgnKzA/yWLI9iX9GNV6HqsI2Dtu2JYtR3fzepHuEulIIIlMJC9uy1TfTnBC4K/l4dEJCumFmonSt95GE2C7umKGppBZO53yeoQgkvqUe733xx6jlt/iEWGiArj8Q40UFxPFqitY0GroHaef/Rd2gFNCYaVoW3XaRF7R5eGd1i6M7HIVQ4dsBsVnCEpytzVZo4uuNBQfD0koyCMgrHTuuYswRVJhSzDaIMmhVrf93a2xnvR2Gt/GRxBTmnIU2bhOVJgw5KLPNoYcuokNhi1i7GtYHJVgwyDuyEOv7ynfzzHnpZod8kXsOnspjWcZ4w1/Lc67YQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(396003)(136003)(46966006)(40470700004)(36840700001)(36860700001)(1076003)(83380400001)(356005)(40480700001)(6666004)(86362001)(336012)(8936002)(2906002)(426003)(8676002)(54906003)(70206006)(16526019)(316002)(186003)(6916009)(40460700003)(36756003)(4326008)(47076005)(82740400003)(478600001)(7416002)(5660300002)(26005)(41300700001)(44832011)(2616005)(82310400005)(81166007)(7696005)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 03:55:12.9000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd1929c-bd1a-4657-ad8a-08da59832b5f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4515
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

new ioctl cmd added to query zone device type. This will be
used once the test_hmm adds zone device coherent type.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alistair Poppple <apopple@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/test_hmm.c      | 11 +++++++++--
 lib/test_hmm_uapi.h | 14 ++++++++++----
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index cfe632047839..915ef6b5b0d4 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -87,6 +87,7 @@ struct dmirror_chunk {
 struct dmirror_device {
 	struct cdev		cdevice;
 	struct hmm_devmem	*devmem;
+	unsigned int            zone_device_type;
 
 	unsigned int		devmem_capacity;
 	unsigned int		devmem_count;
@@ -1260,14 +1261,20 @@ static void dmirror_device_remove(struct dmirror_device *mdevice)
 static int __init hmm_dmirror_init(void)
 {
 	int ret;
-	int id;
+	int id = 0;
+	int ndevices = 0;
 
 	ret = alloc_chrdev_region(&dmirror_dev, 0, DMIRROR_NDEVICES,
 				  "HMM_DMIRROR");
 	if (ret)
 		goto err_unreg;
 
-	for (id = 0; id < DMIRROR_NDEVICES; id++) {
+	memset(dmirror_devices, 0, DMIRROR_NDEVICES * sizeof(dmirror_devices[0]));
+	dmirror_devices[ndevices++].zone_device_type =
+				HMM_DMIRROR_MEMORY_DEVICE_PRIVATE;
+	dmirror_devices[ndevices++].zone_device_type =
+				HMM_DMIRROR_MEMORY_DEVICE_PRIVATE;
+	for (id = 0; id < ndevices; id++) {
 		ret = dmirror_device_init(dmirror_devices + id, id);
 		if (ret)
 			goto err_chrdev;
diff --git a/lib/test_hmm_uapi.h b/lib/test_hmm_uapi.h
index f14dea5dcd06..0511af7464ee 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -31,10 +31,11 @@ struct hmm_dmirror_cmd {
 /* Expose the address space of the calling process through hmm device file */
 #define HMM_DMIRROR_READ		_IOWR('H', 0x00, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_WRITE		_IOWR('H', 0x01, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_MIGRATE		_IOWR('H', 0x02, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_SNAPSHOT		_IOWR('H', 0x03, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_EXCLUSIVE		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x05, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_DEV	_IOWR('H', 0x02, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_SYS	_IOWR('H', 0x03, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_SNAPSHOT		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_EXCLUSIVE		_IOWR('H', 0x05, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
 
 /*
  * Values returned in hmm_dmirror_cmd.ptr for HMM_DMIRROR_SNAPSHOT.
@@ -62,4 +63,9 @@ enum {
 	HMM_DMIRROR_PROT_DEV_PRIVATE_REMOTE	= 0x30,
 };
 
+enum {
+	/* 0 is reserved to catch uninitialized type fields */
+	HMM_DMIRROR_MEMORY_DEVICE_PRIVATE = 1,
+};
+
 #endif /* _LIB_TEST_HMM_UAPI_H */
-- 
2.32.0

