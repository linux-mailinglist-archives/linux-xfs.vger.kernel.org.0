Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E58C52F318
	for <lists+linux-xfs@lfdr.de>; Fri, 20 May 2022 20:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352814AbiETSh0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 May 2022 14:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352901AbiETShY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 14:37:24 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B12D166880
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 11:37:22 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHSIGr010689
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 11:37:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=JmNWcJ9S5BuVrDagcKBT8mAi6jQ8Go8fzpG+AeBXTsU=;
 b=qUZzpfK27enxbJD8TbCXOSUkdo1jEz02hR2C3TBvdksrMSz99UxRgez26GTav6E7cqw3
 hX9IIvDPxZwqHQMdsEwgYhTQd9x5MiVa3Q98fZQHM/1cLrEqFBEU0tv/JHtBkrHu8XK3
 hmnN4ljOPLE18Rah/iBdaPiKJVNZzyJI3Rs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g6341cjc5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 11:37:22 -0700
Received: from twshared24024.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 11:37:21 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 64B10F5E5B23; Fri, 20 May 2022 11:37:16 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [RFC PATCH v4 02/17] mm: Move updates of dirty_exceeded into one place
Date:   Fri, 20 May 2022 11:36:31 -0700
Message-ID: <20220520183646.2002023-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220520183646.2002023-1-shr@fb.com>
References: <20220520183646.2002023-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: rB6bYbI1VSO0Ysas5r1790Bb_hIUJG5z
X-Proofpoint-ORIG-GUID: rB6bYbI1VSO0Ysas5r1790Bb_hIUJG5z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_06,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Transition of wb->dirty_exceeded from 0 to 1 happens before we go to
sleep in balance_dirty_pages() while transition from 1 to 0 happens when
exiting from balance_dirty_pages(), possibly based on old values. This
does not make a lot of sense since wb->dirty_exceeded should simply
reflect whether wb is over dirty limit and so we should ratelimit
entering to balance_dirty_pages() less. Move the two updates together.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Stefan Roesch <shr@fb.com>
---
 mm/page-writeback.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 8e5e003f0093..89dcc7d8395a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1720,8 +1720,8 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 				sdtc =3D mdtc;
 		}
=20
-		if (dirty_exceeded && !wb->dirty_exceeded)
-			wb->dirty_exceeded =3D 1;
+		if (dirty_exceeded !=3D wb->dirty_exceeded)
+			wb->dirty_exceeded =3D dirty_exceeded;
=20
 		if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
 					   BANDWIDTH_INTERVAL))
@@ -1825,9 +1825,6 @@ static void balance_dirty_pages(struct bdi_writebac=
k *wb,
 		if (fatal_signal_pending(current))
 			break;
 	}
-
-	if (!dirty_exceeded && wb->dirty_exceeded)
-		wb->dirty_exceeded =3D 0;
 }
=20
 static DEFINE_PER_CPU(int, bdp_ratelimits);
--=20
2.30.2

