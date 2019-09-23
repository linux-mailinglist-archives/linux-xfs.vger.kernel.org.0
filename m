Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAE4BBDB2
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Sep 2019 23:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387688AbfIWVSp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 23 Sep 2019 17:18:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387437AbfIWVSp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Sep 2019 17:18:45 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A8EE63086211
        for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2019 21:18:45 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 67DB95C1B2
        for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2019 21:18:45 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: log proper length of superblock
Message-ID: <93a080c7-5eb8-8ffe-ae5b-5152a7713828@redhat.com>
Date:   Mon, 23 Sep 2019 16:18:44 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 23 Sep 2019 21:18:45 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_trans_log_buf takes first byte, last byte as args.  In this
case, it should be from 0 to sizeof() - 1.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I should have audited everything when I sent the last patch for
this type of error.  hch suggested changing the interface but it's
all pretty grotty and I'm hesitant for now.

I think maybe a new/separate function to take start, len might
make sense so that not every caller needs to be munged into a new
format, because some of the existing callers would then become more
complex...

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a08dd8f40346..ac6cdca63e15 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -928,7 +928,7 @@ xfs_log_sb(
 
 	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
-	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb));
+	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
 }
 
 /*

