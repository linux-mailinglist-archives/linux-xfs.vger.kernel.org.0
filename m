Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5D7B9081
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Sep 2019 15:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfITNSH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Sep 2019 09:18:07 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44842 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfITNSH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 09:18:07 -0400
Received: by mail-pl1-f193.google.com with SMTP id q15so3163100pll.11
        for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2019 06:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xwzIhYyLqjWx+r3Mktlsz0Rh2IWnEF+3TAS3n5Q4e5U=;
        b=BC3CVJuv2NBJJ36AGfuIur6hGgo2ubT+ydy0+KeOSRiWLLWU38Gqx7AaxTtQX/Mz8k
         mrN5MM90VjINwR9tEuEkankceqQgK0xo7uOY8pcv3FXpMonfa1e2ifRNGZmXKUPsewYL
         E7IY8E1xD3SpWhtUyA0R3g6BJOB7XNJ+wyRoLJa1N4ftbSLzB7qKOIjNUBmP/syUboSm
         YLOhe1DhtFJiHIDiUBddE6KfPg23TYYGzQT7gUjoGkVrey6VBqeW4rdra9Rs7eAMA3f2
         i3pYOuGD+aYk/zDpPhF6nV9KqDVDTAVb1+BfNUUn4xhEADJLFwD4I3KBAy699gUDbI/Z
         I8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xwzIhYyLqjWx+r3Mktlsz0Rh2IWnEF+3TAS3n5Q4e5U=;
        b=EWdvAAsQS5YRtb44HSiGIXp0yMtPczua7X+4hP1QxJamfwZW6liAHiNSDzDLHxf3k0
         dnr9IaTnaOP3iXo0T/kG1k4p32RdOC/T6qdvSOdfS5yWaDqKk1HM96vHWss7nQXPKY4o
         pM3Kldu4N2VMiU67+eaY8bVYlWytb5RNLohH+qGXm7Ng7OruDz7uobEmNiUU8QxYsci/
         UhKrtyhPHweiMlY96jvvD2PubIArTEmCQBQdBKzm6Jzl+fkq7meOi8UvFQlpUGPpsO03
         EgbbQg286qR8KhHdt0blG9m7x8Usu5xf0ehjH3keqPfFslhFMUD4EIaiGgvqCU6qKhqq
         4mjA==
X-Gm-Message-State: APjAAAWS0XGIvXU85nzM55zDmmvujuHbtQYPnE3UCM2UJ915FYySKo++
        cXvwRVxhMAuabOaxpRx9WJ8=
X-Google-Smtp-Source: APXvYqxG8KSj/6BHATmgQtoGva86Zc7Wxxtmtm/B860okA74zBb9XFVpfghbfiWauPzuumimeZBVfA==
X-Received: by 2002:a17:902:222:: with SMTP id 31mr17110924plc.167.1568985486364;
        Fri, 20 Sep 2019 06:18:06 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:3613:c415:d9cf:5340:7db3:50bd])
        by smtp.gmail.com with ESMTPSA id r185sm2501799pfr.68.2019.09.20.06.18.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Sep 2019 06:18:05 -0700 (PDT)
From:   Aliasgar Surti <aliasgar.surti500@gmail.com>
X-Google-Original-From: Aliasgar Surti
To:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        david@fromorbit.com, bfoster@redhat.com
Cc:     Aliasgar Surti <aliasgar.surti500@gmail.com>
Subject: [PATCH] fs:xfs:scrub: Removed unneeded variable.
Date:   Fri, 20 Sep 2019 18:47:44 +0530
Message-Id: <1568985464-31258-1-git-send-email-aliasgar.surti500@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Aliasgar Surti <aliasgar.surti500@gmail.com>

Returned value directly instead of using variable as it wasn't updated.

Signed-off-by: Aliasgar Surti <aliasgar.surti500@gmail.com>
---
 fs/xfs/scrub/alloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index a43d181..5533e48 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -97,7 +97,6 @@ xchk_allocbt_rec(
 	xfs_agnumber_t		agno = bs->cur->bc_private.a.agno;
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
-	int			error = 0;
 
 	bno = be32_to_cpu(rec->alloc.ar_startblock);
 	len = be32_to_cpu(rec->alloc.ar_blockcount);
@@ -109,7 +108,7 @@ xchk_allocbt_rec(
 
 	xchk_allocbt_xref(bs->sc, bno, len);
 
-	return error;
+	return 0;
 }
 
 /* Scrub the freespace btrees for some AG. */
-- 
2.7.4

