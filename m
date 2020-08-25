Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE99F2521F7
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Aug 2020 22:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgHYUZf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Aug 2020 16:25:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46651 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgHYUZe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 16:25:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598387132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=U4Gwhq3hgd91w2FVjfAPq7z72lC8CvtYAA8BS2O4r1M=;
        b=PbZ+NNa2o3Eoobn1Y+IB4xPd2Ba6nvzd/fL0BfqmopxiqrU5HP+gVxzLZxbkx2oAAa6E0U
        lTaq/dhSx2votqz8+CgamCjvbiSIMjH5Gyzf8w5co5BSIqLnJvolwjYHTyvknFZgsYZnmo
        FM3BB7u7rjHtw7IRs+9OjwwSpK+65Rg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-o2F1obj2P-q9i55jwj19tw-1; Tue, 25 Aug 2020 16:25:30 -0400
X-MC-Unique: o2F1obj2P-q9i55jwj19tw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C7FC10ABDBA
        for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2020 20:25:29 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65E3C1944D
        for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2020 20:25:29 +0000 (UTC)
To:     linux-xfs@vger.kernel.org
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: fix boundary test in xfs_attr_shortform_verify
Message-ID: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
Date:   Tue, 25 Aug 2020 15:25:29 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The boundary test for the fixed-offset parts of xfs_attr_sf_entry
in xfs_attr_shortform_verify is off by one.  endp is the address
just past the end of the valid data; to check the last byte of
a structure at offset of size "size" we must subtract one.
(i.e. for an object at offset 10, size 4, last byte is 13 not 14).

This can be shown by:

# touch file
# setfattr -n root.a file

and subsequent verifications will fail when it's reread from disk.

This only matters for a last attribute which has a single-byte name
and no value, otherwise the combination of namelen & valuelen will
push endp out and this test won't fail.

Fixes: 1e1bbd8e7ee06 ("xfs: create structure verifier function for shortform xattrs")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 8623c815164a..a0cf22f0c904 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1037,7 +1037,7 @@ xfs_attr_shortform_verify(
 		 * Check the fixed-offset parts of the structure are
 		 * within the data buffer.
 		 */
-		if (((char *)sfep + sizeof(*sfep)) >= endp)
+		if (((char *)sfep + sizeof(*sfep)-1) >= endp)
 			return __this_address;
 
 		/* Don't allow names with known bad length. */

