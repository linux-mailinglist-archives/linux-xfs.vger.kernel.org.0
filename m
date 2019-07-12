Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B729667491
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jul 2019 19:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfGLRqU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 Jul 2019 13:46:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfGLRqU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jul 2019 13:46:20 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A546E3091DC4
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 17:46:20 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DA6560BFB;
        Fri, 12 Jul 2019 17:46:18 +0000 (UTC)
Subject: [PATCH 2/2] xfs: sync up xfs_trans_inode with userspace
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <112d2e52-c96c-af83-7e53-5fca12448c76@redhat.com>
Date:   Fri, 12 Jul 2019 12:46:17 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 12 Jul 2019 17:46:20 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an XFS_ICHGTIME_CREATE case to xfs_trans_ichgtime() to keep in
sync with userspace.  (Currently no kernel caller sends this flag.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 93d14e47269d..a9ad90926b87 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -66,6 +66,10 @@ xfs_trans_ichgtime(
 		inode->i_mtime = tv;
 	if (flags & XFS_ICHGTIME_CHG)
 		inode->i_ctime = tv;
+	if (flags & XFS_ICHGTIME_CREATE) {
+		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
+		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
+	}
 }
 
 /*


