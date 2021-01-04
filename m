Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A602E9418
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Jan 2021 12:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbhADLb0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Jan 2021 06:31:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725921AbhADLb0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 06:31:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609759800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o0rYxrys7aX8Dw2VlZgK6yTn5NwLi7xdzArLwaQ5JFY=;
        b=gA24hQ2Tt83GRfTvxcGTfzUaDZMDZWjrNjvrqQ0VmZM1uH1QssOcAX5bWXICpwOCyzMZYe
        uL6u188/8VAJq+TV/dgnohC97RVNzKnT6t04YOtyRv+nn7d/8kJsG8Ow2P7yxbellDlgHe
        4WCJwpQQXP3ETXosxmZAIyoFzh+3WeM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-oFzkTcsUNnuiYOlwfYr_Tw-1; Mon, 04 Jan 2021 06:29:58 -0500
X-MC-Unique: oFzkTcsUNnuiYOlwfYr_Tw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E391B1005504
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 11:29:57 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-14-10.pek2.redhat.com [10.72.14.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F154F60CCE
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 11:29:56 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] mkfs: fix wrong inobtcount usage error output
Date:   Mon,  4 Jan 2021 19:29:52 +0800
Message-Id: <20210104112952.328169-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When mkfs fails, it shows:
  ...
  /* metadata */         [-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
                           inobtcnt=0|1,bigtime=0|1]\n\
  ...

The "inobtcnt=0|1" is wrong usage, it must be inobtcount, there's not
an alias. To avoid misadvice, fix it.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 47acc127..0581843f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -928,7 +928,7 @@ usage( void )
 /* blocksize */		[-b size=num]\n\
 /* config file */	[-c options=xxx]\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
-			    inobtcnt=0|1,bigtime=0|1]\n\
+			    inobtcount=0|1,bigtime=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num\n\
-- 
2.25.4

