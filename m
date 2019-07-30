Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E7C7A8B3
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2019 14:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbfG3Mhu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jul 2019 08:37:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34186 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfG3Mhu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 08:37:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so65632780wrm.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2019 05:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=quPTdbJSNqfTHVNDVTg9sWKMFlQafnU0Ap7bRA31guE=;
        b=ghJLThm7WWrj5UDUxq0US6+Z7ohcjwIgWWJ9fsa2xR+STxBaIwCUC4P5zY2cPMtfbP
         cjUd1qwPUvK5iMA76ORCnp9XmK3PtEI+p9HD6GTiJpS+LbY6CoglewxPAJejWxyQmWQl
         CeYsMdbi/rrHCw8rGBB1ZNIUnHK1yFCNtm6nYzoQU0Ut8hwZrV4qoRRtmSIqsmoqWUfx
         wKzmRdUioS9Bz/SSZkn8twdgvXo+yxUVnfq/UvjoLC+kA/xrTVZKWr+6YHVDl7gVwtg7
         6SZ6UUP9lKFg9GekOReS+j/B3mFMLmD0lAee3JZhj+H0xofhLpR6KoZ8RvVspxG7byfx
         PxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=quPTdbJSNqfTHVNDVTg9sWKMFlQafnU0Ap7bRA31guE=;
        b=X4s8Xwr0rWLg8SSgRlpzJXcnfPfIzeOcTQJQL1X7oVP7mdweTmd0EM82v0/TyqYmDb
         WL+0LvWxN3q0kjbrWC1JctD+BuV/Jc0wq++jU8fUmxaI3Mdvmr0tQhBTrQaREd4rxNTz
         5MBOfv5zrNSOeD3Bd/sBNt7L+Lmcx/ZH3s2meIExBl5yQ9hcEUTJ5ExR1fB3d5h1z7OI
         4vydgCfKA0xoJPnWFzJ665NClqyKcTiFxbQDLgwatuYR1no7OIZULShz0jbgWfGqZes4
         grhR05+OytVu4bhBKJJoO5zSo3WVyiFErjVuTRxCUHZnbpt+up8cf1pn2IXsKDDvy3bX
         WUtg==
X-Gm-Message-State: APjAAAVtqfDgT7KY0VGZgSLG8a8IUUME7BnWVinQ9Fw/ikW8PH5Nutze
        4JlmXlX1XeUeDTLbhuMVjJDtUKpF
X-Google-Smtp-Source: APXvYqzh/mWgYFKjkpAj/0Ce34CTq/O3Fys+6vCTsfZR9wBgtRYJJYPeuLDOAt1PChZd1dDNXVxgaQ==
X-Received: by 2002:adf:e708:: with SMTP id c8mr26281479wrm.25.1564490268347;
        Tue, 30 Jul 2019 05:37:48 -0700 (PDT)
Received: from localhost ([197.211.57.129])
        by smtp.gmail.com with ESMTPSA id p10sm2641774wmk.2.2019.07.30.05.37.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 05:37:47 -0700 (PDT)
Date:   Tue, 30 Jul 2019 13:36:48 +0100
From:   Sheriff Esseson <sheriffesseson@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: design: Fix typo
Message-ID: <20190730123648.GA20126@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace "possible" with "possibly" and improve the flow of the phrase.

Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
---
 design/XFS_Filesystem_Structure/overview.asciidoc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 mode change 100644 => 100755 design/XFS_Filesystem_Structure/overview.asciidoc

diff --git a/design/XFS_Filesystem_Structure/overview.asciidoc b/design/XFS_Filesystem_Structure/overview.asciidoc
old mode 100644
new mode 100755
index d15b50a..7628a7d
--- a/design/XFS_Filesystem_Structure/overview.asciidoc
+++ b/design/XFS_Filesystem_Structure/overview.asciidoc
@@ -28,7 +28,7 @@ record.  Both forks associate a logical offset with an extent of physical
 blocks, which makes sparse files and directories possible.  Directory entries
 and extended attributes are contained inside a second-level data structure
 within the blocks that are mapped by the forks.  This structure consists of
-variable-length directory or attribute records and possible a second B+tree to
+variable-length directory or attribute records and, possibly, a second B+tree to
 index these records.
 
 XFS employs a journalling log in which metadata changes are collected so that
-- 
2.22.0

