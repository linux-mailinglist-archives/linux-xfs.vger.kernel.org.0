Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B8E4F5ACB
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Apr 2022 12:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244858AbiDFJkJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 Apr 2022 05:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584956AbiDFJgJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB8224A763
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:11 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235NhHTI006418;
        Wed, 6 Apr 2022 06:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=lWn72lAVrgH7ISPU1asBQF21rTBmWzHT5qbRE1uofw0=;
 b=0HatitPASCRgeLrPY28hi/zN2gYjrChGmDpPb7pm1TpPfOX+oJVN5eXj0MIHL1adoNQH
 XK8pb4XzXpSZhyaKLpLcDYZTsbxRvfsZxh9KDe5p0qf0Rj1SjblkpBXkS+CAL+DM2Vhh
 91ffaSUbgwCpgjWS94RSfumYX9vyUsrn38ExVI7ReDMez1l4jn6yVTRz+RISLQgJ0ulT
 EXFYKuDgQC0bAPntwONa7aHscOJ2gCyoWPg8Y7R9OJ5HuGgDfr4ntzGLUtrbfbQJZrqI
 KsCI58W4P/xCBkHxPUC4FsblDCs2iwYdNBz5YuZZJu23vQ4ynq5EcQleTysRJjmvPi9m uA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31fydw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:06 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366ApBV024421;
        Wed, 6 Apr 2022 06:20:05 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx48p8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHbA2JwnJvqfiUrq6OwvHs4/bE8JV89Q3rMP4RA3MaQHdN77HH8NutoELgyMId8WVhkcKALlvxk+jatDYiGn5F2+8U/Iwq7gzPpsHr/UJw9Y62HODHfUANeE1hU518LMwtA0D7RB8mQpgQgT0eqTzgkfIhSHouxdp0J+ECpb7ViYp/1BlMAEx/RJHbPsOD78mZABPbzmXyx75xOzRg+LSRucC4V8xMt7cPNlLA3haqCvFCX09CQhyzcBCuX8/dWtmALRvz63pmU5Zhl+kyduUoXHObIhypdu5GkXomIiB7+HnSX3np/pVtJwLLwjTa+jkbqRNZeoI/9A8jeec7gpyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lWn72lAVrgH7ISPU1asBQF21rTBmWzHT5qbRE1uofw0=;
 b=lTrzzHv2Xnxvf8JwF5hmD5C3LkQT+n9IHU0HNjfjhfYNKnQhbeRSYqsmsGz3x5/cd0lsKW2HEM//nSKPjsBgyPmNCsagOuhsdkTRcFdt1jnXXNb0ZwOry2eUKI5Jtqyayr1reFj9L70w+TnZ82HWAARqH940kINa8GHYNeBC4N3hllCxW6U7EJm8n8krfqkXutZ5bcILWOu7mC+Adn2BCDzpvlIw3bjoJqQyIX5Dy3ZN3/C+l0gFFCsNDyr9YQsZmmRQ3rygXnugp3+LMgH2ZodzEHYqh4XYawuxmSSwQkhyKzGpEyduShvusFwU+wNJI80vMvZ0yXNI8o42qIT1aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWn72lAVrgH7ISPU1asBQF21rTBmWzHT5qbRE1uofw0=;
 b=kVsSE1hKQP22PKZq5YIxcLFTATh00b/M/A3E4L3hnVTUXwQVsft4JvekvoRQ7S8yT6ppqWHKTX5relOuhGkuafhg/lIwTBKtaX+aMM6r/a8Ihbu4ZaJY/RZxyLAsD4T7G5rOLraubRsH5jhfa02sPMSwDuwJPWtS+otnoa228F0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:03 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V9 00/19] xfs: Extend per-inode extent counters
Date:   Wed,  6 Apr 2022 11:48:44 +0530
Message-Id: <20220406061904.595597-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 159cd746-f6f8-4968-80e8-08da17957c29
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB556477F986EE774F8318445BF6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YuIgwWChgghdgIsO81DRqjWIUjbOimBnG1QnJHszpAYG1fxGdw0psrnfp5OrwNouptCs7QRpgGRm+Au2u/z15dJQeHffphJ0YH6Y2b2dZaUGCaD1uazooIKjA0aM6b1SzMXn1UABy8Vz2bdolD4sCa2nXLfrPPCoumbdFm5BGkPxSQxEHQnEmWDcMMZeKx5K2uIJOnXKtU5AWT48Ed3kHjRZ5MeVINTrqDfUkMqtJET/aqi9FgYkBssPEpE2UjKLsfiB7J1vVs72UxTYQQJGof2b1w427Rptc64s2ZnNjUILOzvqI2OZPOg6KpAv496pB7zTRL18WP53mtZeyAinkUbPZRGoWwRytOGptEd6CCfmStKMe9meGbZtP1INuMp9QgPN+pqW9bRftKui/EY8pqh+Q1sulhYvzqoB9wZx98gDwrYcl7QwbpLdfhj+lkaor5bqtC5HAvipGj/fKBNHrRjxWmvUDwn1Uo/6wE3FPNG/VlKQwx26KGuOKKCsnzEPuj1tm29LTsUSssLNwl2iHZCCkIurc1UAv1i4aMZS5sygUVKffaYImAF+LduWBZLZezqFKv/9qADeD9R7XiAWDGE5LwqtyuXT99G4WkW/lJ8ZzLAZTG+2kO4/vRNggriOSIXsFb+i3uhNiO6Mf+qd0plPXBDpuFSHGo/sr7muHswP0YgPAYlfxhF2WmNrzmHRaWIX8+4uArDrqpRG8j8qAMjpY/3A9SfBrcqgxTsmrtFYScrtaU7vNLPVd2PE+23kDI9Pkx/0dJkNSyAv4oiWuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(6916009)(4326008)(8676002)(966005)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uq7CJeFudtxkCpHCW/FxNenuWg8+I+eYaYYFJqwqHh9mrIEfkRwXAc+yVhJT?=
 =?us-ascii?Q?PUQgD7XxdwfCZlwjBbJ5gc3H2UPo5q1ir4bA2lzEUnqnsf42nR2obJ8B/xiN?=
 =?us-ascii?Q?+mDn4LiMnrSzLymH4lpW5QmH03bxf8965x1HJ2Tq4kQ76uhXY3SR4ahdt3rR?=
 =?us-ascii?Q?/sUDT2rp35zSrl1ctymPlEBPSXp/H3Sor8ps9ilZ9CCtIl6CegbPL8b51qnt?=
 =?us-ascii?Q?QuLfg01BcBgmkLOryln58Ye48jLw5YOyd6xiBzEfj5GiixiYf99wu6lDyrF0?=
 =?us-ascii?Q?wO/MrG6P93QJFj1JQVRamTrHmqgRxj0iixS5VSVFiLg0aBCAcDC8WZherGFh?=
 =?us-ascii?Q?8heHvx/xMt5EbynI91FAy4BdFSNleirWPB1hMYSf4SlZV7wjGHFoRffRW6B6?=
 =?us-ascii?Q?xmYYq5xhK1LAPjMC0mcmwjeY3H6Pu22KTa3kTj2jpJfv5Pejb1SgwHX/uIKf?=
 =?us-ascii?Q?Cm2cixfFTAKQ5+/HO6oyhZUdYxvDCzki37XIVKbKwiuDejt2QoE4plSHh5T2?=
 =?us-ascii?Q?Puztfpiwa8j8Ycx3gUVURfaEuT+Ji0blmyZXr1lIcIYXhwmauKYl42NH3EJU?=
 =?us-ascii?Q?cwdqIXlECJgse6I+5N6KNwQdiqDqLToNeYUulSxQHfmdTPw9bAIqu4f1dSHD?=
 =?us-ascii?Q?PnXae3xmYeNpnocWrZ9jNprKzR74h6maCPKeMxhJlIhhscIRR1REzrpAwqUw?=
 =?us-ascii?Q?zjB2W6kLzEy+t+5AwMpMo6BHnhpbmfGgXoxhZHc1MMM2JDZSoftyEuJX9F+s?=
 =?us-ascii?Q?sPxRxybiTcK37gH6L7+Lgw/8XvfL7Iael5J6gIek9imL/FkJyyaqM6VfdT+4?=
 =?us-ascii?Q?ftN8YXK3rfDi2fby2LO0yeGc6ACyOJnEu6d055IFvaTb2R3Su1IveKmmsvDN?=
 =?us-ascii?Q?Q8vOpeKuVqatYMsbwZz/LdIbGBQgS58Eg8iaYouMD0LNIJzEptCbdocvXKbz?=
 =?us-ascii?Q?//8oiYBRFKnnzk9kYqTtHQydiIGKR2Dkcr1PcBeC0UEVHHarmzmWs2OKetDO?=
 =?us-ascii?Q?hekZ/H9pEZlZWyMXL8Qwojoihf9XxvJTazX2CKKt2DwasYGucShtIKIh5jYH?=
 =?us-ascii?Q?IWGJfQmXU6NwnwMMGa4L8E4mmzVEuD8qp0t6N+Fx3eF5/sDJlcxC4+nBS6u7?=
 =?us-ascii?Q?yeS0/EryqMQBiDJ3aOq4oh0s1xvu4adD87HB7Bje/lxCwlGGMwhpIZ1P4KY0?=
 =?us-ascii?Q?OE4CDdwL/qLaUD2fdWQd+cX65t3/xyjHKVyQxu9Hath29T5WXBTB3FkrbJpW?=
 =?us-ascii?Q?TICDqSsCCoMIgn47HT0cKejWu5QkmNNp15qnlArDFmAGrHBtC35gW8qtPnPs?=
 =?us-ascii?Q?UnLiRON6FEWWCgBnhtxuj6E7to2Bs04BFunb4ZOlw+qVAfdaJU4EP/XmW03C?=
 =?us-ascii?Q?X0KIgpBCdSCfImjEs8CwEVd4eM74MiJ0ZfNA1Y4xiknQdvvxME4fFgYSZFPY?=
 =?us-ascii?Q?DaIQplZc155MX+I/5DvqTLitndyS9SVjDyGfl0n33H9K1KIia3pSZPFWCGBZ?=
 =?us-ascii?Q?hrlIHXlM2fPPYebqOLfnDssjVm2cXyzB2SLRSbZ9V1wtNwPgeSwNEAC77IoO?=
 =?us-ascii?Q?ckMieoYHTpghs/591bVL+ZfkJzkAO2NbJO12RbIhiXJsMX4zBUmOAef6bXYH?=
 =?us-ascii?Q?c0NVAP50xFq8n+8W9972YAEnOEoNgJueRdgGOTnOkX6hsYW8eNTeySjOKfw4?=
 =?us-ascii?Q?JNC2+BRxpx5LqQ2kvrJq5bBuocUazV/kFwu2Tmo8pxIM9SJ2lhz4PuGQHGvw?=
 =?us-ascii?Q?kUuYYfh8eKW52MLz8aiVUoko2FJGIjk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 159cd746-f6f8-4968-80e8-08da17957c29
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:03.2670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4loTFm/bD1Ffx9bTZ8CZbs7nKC7EyGE16baYFjI2+CQIVHK8pQrDEZT66nSCnCU2TP7vrgcsKecbTjWoH2v1mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060027
X-Proofpoint-GUID: nn_Q8Ar9Yr4grwcL9zQnlBYeyXKUX5w6
X-Proofpoint-ORIG-GUID: nn_Q8Ar9Yr4grwcL9zQnlBYeyXKUX5w6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The commit xfs: fix inode fork extent count overflow
(3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
data fork extents should be possible to create. However the
corresponding on-disk field has a signed 32-bit type. Hence this
patchset extends the per-inode data fork extent counter to 64 bits
(out of which 48 bits are used to store the extent count).

Also, XFS has an attribute fork extent counter which is 16 bits
wide. A workload that,
1. Creates 1 million 255-byte sized xattrs,
2. Deletes 50% of these xattrs in an alternating manner,
3. Tries to insert 400,000 new 255-byte sized xattrs
   causes the xattr extent counter to overflow.

Dave tells me that there are instances where a single file has more
than 100 million hardlinks. With parent pointers being stored in
xattrs, we will overflow the signed 16-bits wide attribute extent
counter when large number of hardlinks are created. Hence this
patchset extends the on-disk field to 32-bits.

The following changes are made to accomplish this,
1. A 64-bit inode field is carved out of existing di_pad and
   di_flushiter fields to hold the 64-bit data fork extent counter.
2. The existing 32-bit inode data fork extent counter will be used to
   hold the attribute fork extent counter.
3. A new incompat superblock flag to prevent older kernels from mounting
   the filesystem.

The patchset has been tested by executing xfstests with the following
mkfs.xfs options,
1. -m crc=0 -b size=1k
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

Each of the above test scenarios were executed on the following
combinations (For V4 FS test scenario, the last combination was
omitted).
|---------------------------+-----------|
| Xfsprogs                  | Kernel    |
|---------------------------+-----------|
| Unpatched                 | Patched   |
| Patched (disable nrext64) | Patched   |
| Patched (enable nrext64)  | Patched   |
|---------------------------+-----------|

I have also written tests to check if the correct extent counter
fields are updated with/without the new incompat flag and to verify
upgrading older fs instances to support large extent counters. I have
also fixed xfs/270 test to work with the new code base.

These patches can also be obtained from
https://github.com/chandanr/linux.git at branch
xfs-incompat-extend-extcnt-v9.

Changelog:
V8 -> V9:
1. Rebase patchset on Linux v5.18-rc1.
2. Replace directory extent count overflow checks with a simple check
   added to xfs_dinode_verify(). 
3. Warn users about "Large extent counters" being an experimental feature.
4. Address other trivial review comments provided for v9 of the patchset.

V7 -> V8:
1. Do not roll a transaction after upgrading an inode to "Large extent
   counter" feature. Any transaction which can cause an inode's extent counter
   to change, will have included the space required to log the inode in its
   transaction reservation calculation.  
   This means that the patch "xfs: xfs_growfs_rt_alloc: Unlock inode
   explicitly rather than through iop_committing()" is no longer required.
2. Use XFS_MAX_EXTCNT_DATA_FORK_LARGE & XFS_MAX_EXTCNT_ATTR_FORK_LARGE to
   represent large extent counter limits. Similarly, use
   XFS_MAX_EXTCNT_DATA_FORK_SMALL & XFS_MAX_EXTCNT_ATTR_FORK_SMALL to
   represent previously defined extent counter limits.
3. Decouple XFS_IBULK flags from XFS_IWALK flags in a separate patch.
4. Bulkstat operation now returns XFS_MAX_EXTCNT_DATA_FORK_SMALL as the extent
   count if data fork extent count exceeds XFS_MAX_EXTCNT_DATA_FORK_SMALL and
   userspace program isn't aware of large extent counters.

V6 -> V7:
1. Address the following review comments from V6,
   - Revert xfs_ibulk->flags to "unsigned int" type.
   - Fix definition of XFS_IBULK_NREXT64 to be independent of IWALK flags.
   - Fix possible double free of transaction handle in xfs_growfs_rt_alloc().

V5 -> V6:
1. Rebase on Linux-v5.17-rc4.
2. Upgrade inodes to use large extent counters from within a
   transaction context.

V4 -> V5:
1. Rebase on xfs-linux/for-next.
2. Use howmany_64() to compute height of maximum bmbt tree.
3. Rename disk and log inode's di_big_dextcnt to di_big_nextents.
4. Rename disk and log inode's di_big_aextcnt to di_big_anextents.
5. Since XFS_IBULK_NREXT64 is not associated with inode walking
   functionality, define it as the 32nd bit and mask it when passing
   xfs_ibulk->flags to xfs_iwalk() function. 

V3 -> V4:
1. Rebase patchset on xfs-linux/for-next branch.
2. Carve out a 64-bit inode field out of the existing di_pad and
   di_flushiter fields to hold the 64-bit data fork extent counter.
3. Use the existing 32-bit inode data fork extent counter to hold the
   attr fork extent counter.
4. Verify the contents of newly introduced inode fields immediately
   after the inode has been read from the disk.
5. Upgrade inodes to be able to hold large extent counters when
   reading them from disk.
6. Use XFS_BULK_IREQ_NREXT64 as the flag that userspace can use to
   indicate that it can read 64-bit data fork extent counter.
7. Bulkstat ioctl returns -EOVERFLOW when userspace is not capable of
   working with large extent counters and inode's data fork extent
   count is larger than INT32_MAX.

V2 -> V3:
1. Define maximum extent length as a function of
   BMBT_BLOCKCOUNT_BITLEN.
2. Introduce xfs_iext_max_nextents() function in the patch series
   before renaming MAXEXTNUM/MAXAEXTNUM. This is done to reduce
   proliferation of macros indicating maximum extent count for data
   and attribute forks.
3. Define xfs_dfork_nextents() as an inline function.
4. Use xfs_rfsblock_t as the data type for variables that hold block
   count.
5. xfs_dfork_nextents() now returns -EFSCORRUPTED when an invalid fork
   is passed as an argument.
6. The following changes are done to enable bulkstat ioctl to report
   64-bit extent counters,
   - Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
     xfs_bulkstat->bs_pad[].
   - Carve out a new 64-bit field xfs_bulk_ireq->bulkstat_flags from
     xfs_bulk_ireq->reserved[] to hold bulkstat specific operational
     flags. Introduce XFS_IBULK_NREXT64 flag to indicate that
     userspace has the necessary infrastructure to receive 64-bit
     extent counters.
   - Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to
     indicate that xfs_bulk_ireq->bulkstat_flags has valid flags set.
7. Rename the incompat flag from XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT
   to XFS_SB_FEAT_INCOMPAT_NREXT64.
8. Add a new helper function xfs_inode_to_disk_iext_counters() to
   convert from incore inode extent counters to ondisk inode extent
   counters.
9. Reuse XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag to skip reporting
   inodes with more than 10 extents when bulkstat ioctl is invoked by
   userspace.
10. Introduce the new per-inode XFS_DIFLAG2_NREXT64 flag to indicate
    that the inode uses 64-bit extent counter. This is used to allow
    administrators to upgrade existing filesystems.
11. Export presence of XFS_SB_FEAT_INCOMPAT_NREXT64 feature to
    userspace via XFS_IOC_FSGEOMETRY ioctl.

V1 -> V2:
1. Rebase patches on top of Darrick's btree-dynamic-depth branch.
2. Add new bulkstat ioctl version to support 64-bit data fork extent
   counter field.
3. Introduce new error tag to verify if the old bulkstat ioctls skip
   reporting inodes with large data fork extent counters.

Chandan Babu R (19):
  xfs: Move extent count limits to xfs_format.h
  xfs: Define max extent length based on on-disk format definition
  xfs: Introduce xfs_iext_max_nextents() helper
  xfs: Use xfs_extnum_t instead of basic data types
  xfs: Introduce xfs_dfork_nextents() helper
  xfs: Use basic types to define xfs_log_dinode's di_nextents and
    di_anextents
  xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
    respectively
  xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs
    feature bit
  xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
  xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
  xfs: Use uint64_t to count maximum blocks that can be used by BMBT
  xfs: Introduce macros to represent new maximum extent counts for
    data/attr forks
  xfs: Replace numbered inode recovery error messages with descriptive
    ones
  xfs: Introduce per-inode 64-bit extent counters
  xfs: Directory's data fork extent counter can never overflow
  xfs: Conditionally upgrade existing inodes to use large extent
    counters
  xfs: Decouple XFS_IBULK flags from XFS_IWALK flags
  xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
  xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags

 fs/xfs/libxfs/xfs_alloc.c       |   2 +-
 fs/xfs/libxfs/xfs_attr.c        |  10 +++
 fs/xfs/libxfs/xfs_bmap.c        | 109 +++++++++++--------------
 fs/xfs/libxfs/xfs_bmap_btree.c  |   3 +-
 fs/xfs/libxfs/xfs_da_format.h   |   1 +
 fs/xfs/libxfs/xfs_format.h      | 101 ++++++++++++++++++++---
 fs/xfs/libxfs/xfs_fs.h          |  21 ++++-
 fs/xfs/libxfs/xfs_ialloc.c      |   2 +
 fs/xfs/libxfs/xfs_inode_buf.c   |  89 ++++++++++++++++----
 fs/xfs/libxfs/xfs_inode_fork.c  |  34 ++++++--
 fs/xfs/libxfs/xfs_inode_fork.h  |  76 +++++++++++++----
 fs/xfs/libxfs/xfs_log_format.h  |  33 +++++++-
 fs/xfs/libxfs/xfs_sb.c          |   5 ++
 fs/xfs/libxfs/xfs_trans_resv.c  |  11 +--
 fs/xfs/libxfs/xfs_types.h       |  11 +--
 fs/xfs/scrub/bmap.c             |   2 +-
 fs/xfs/scrub/inode.c            |  20 ++---
 fs/xfs/xfs_bmap_item.c          |   2 +
 fs/xfs/xfs_bmap_util.c          |  27 +++++--
 fs/xfs/xfs_dquot.c              |   3 +
 fs/xfs/xfs_inode.c              |  59 +-------------
 fs/xfs/xfs_inode.h              |   5 ++
 fs/xfs/xfs_inode_item.c         |  23 +++++-
 fs/xfs/xfs_inode_item_recover.c | 139 +++++++++++++++++++++++---------
 fs/xfs/xfs_ioctl.c              |   3 +
 fs/xfs/xfs_iomap.c              |  33 ++++----
 fs/xfs/xfs_itable.c             |  19 ++++-
 fs/xfs/xfs_itable.h             |   4 +-
 fs/xfs/xfs_iwalk.h              |   2 +-
 fs/xfs/xfs_mount.h              |   2 +
 fs/xfs/xfs_reflink.c            |   5 ++
 fs/xfs/xfs_rtalloc.c            |   3 +
 fs/xfs/xfs_super.c              |   5 ++
 fs/xfs/xfs_symlink.c            |   5 --
 fs/xfs/xfs_trace.h              |   4 +-
 35 files changed, 599 insertions(+), 274 deletions(-)

-- 
2.30.2

