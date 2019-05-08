Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B20518071
	for <lists+linux-xfs@lfdr.de>; Wed,  8 May 2019 21:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfEHT2L (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 May 2019 15:28:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43672 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbfEHT2L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 May 2019 15:28:11 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0170AA836
        for <linux-xfs@vger.kernel.org>; Wed,  8 May 2019 19:28:11 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B0D80600C6;
        Wed,  8 May 2019 19:28:10 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: short circuit xfs_get_acl() if no acl is possible
Cc:     David Valin <dvalin@redhat.com>
Message-ID: <35128e32-d69b-316e-c8d6-8f109646390d@redhat.com>
Date:   Wed, 8 May 2019 14:28:09 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 08 May 2019 19:28:11 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If there are no attributes on the inode, don't go through the
cost of memory allocation and callling xfs_attr_get when we
already know we'll just get -ENOATTR.

Reported-by: David Valin <dvalin@redhat.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 8039e35147dd..b469b44e9e71 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -132,6 +132,9 @@ xfs_get_acl(struct inode *inode, int type)
 		BUG();
 	}
 
+	if (!xfs_inode_hasattr(ip))
+		return NULL;
+
 	/*
 	 * If we have a cached ACLs value just return it, not need to
 	 * go out to the disk.

