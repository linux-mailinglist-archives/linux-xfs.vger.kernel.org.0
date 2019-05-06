Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14C615535
	for <lists+linux-xfs@lfdr.de>; Mon,  6 May 2019 23:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfEFVD3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 6 May 2019 17:03:29 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34075 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfEFVD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 May 2019 17:03:29 -0400
Received: by mail-pg1-f196.google.com with SMTP id c13so7080125pgt.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 May 2019 14:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=H4P0WeV3lvxWZ4EDaddBtevKkN/jkfDkLcfdx8tEW8I=;
        b=izxZWNZMVgRzvSuIGeCNROHH4B4FLUVwcoI0t3kRVII5OScIS6H1KYKyaM9oIcjMOI
         SRACl6xLFP3ydUYlynjHZDaqJb2obLTyP2oVRwOgKuW+jvKkQ2fqwvcPZ3hC3/IR06ry
         a8TtyTA6OoaqGD9d5RTKCG+ooqHl/elsfesIm82SRoN+pLQSEtIqtYW2VrUONLHqtwEF
         2NCgqF2/QHdwehYra7rg2wQQseFUEtmUeivEzvSHs5VtMhMyXAbL2nk82wj+cFG3ZV3L
         KWBo9Lo7BJ8z9327jQAQtoejGlt24yOzRhujBNllPX4O9PL/3lVqAoWgrl1fgyn82+6R
         r84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=H4P0WeV3lvxWZ4EDaddBtevKkN/jkfDkLcfdx8tEW8I=;
        b=WL471Dig+8IBCDc0zB5rURRMWHntg2cxE8VhklMQ7r13dU2LlO8S4JgkSl2p2+IkQ3
         V7QXxnfI2FJIT5MeoUp+Wze+wZK9Bk/P+g2sDzZ8LBVOmigmL4FY4RCSZEvbz38UcwwA
         0J9yQeFq9L+NuPs83gU7KPD60/Qfv87jYzVoFJz7nQTgFCWFLOzAmrV/gB931OvFrQGi
         s2+V6JdReRGBW4u1szboh4U0knYIeTN4cVLNnDN1HZJPSgk8D6gb223SlQdLTaEYTu7G
         TFHhFrLdHNdL8k93uBsUz8mkc+UA//9RQVbmfNJfCd3ydfG5i12i39bKqmMoylJIaB0E
         3edw==
X-Gm-Message-State: APjAAAVeraoz0UiTKrPqfZgJ666VPxC4/9oUzHHxSp/U4xzWrhWzVbU8
        1/VFOrO8HgvxALGZ5kmX0fjedMJzTbM=
X-Google-Smtp-Source: APXvYqwQ9nZjG/IeeHSK1X7c0yF3qqvOmKk88CVglktPNaZTVcaI1MMBNhe8nyzcxRgID+WGYCmqxw==
X-Received: by 2002:a63:af0a:: with SMTP id w10mr34886401pge.67.1557176608674;
        Mon, 06 May 2019 14:03:28 -0700 (PDT)
Received: from mangix-pc.lan (76-14-106-140.rk.wavecable.com. [76.14.106.140])
        by smtp.gmail.com with ESMTPSA id v6sm4221685pgk.77.2019.05.06.14.03.27
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 14:03:27 -0700 (PDT)
From:   Rosen Penev <rosenp@gmail.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] db/malloc: Use posix_memalign instead of deprecated valloc
Date:   Mon,  6 May 2019 14:03:26 -0700
Message-Id: <20190506210326.29581-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

valloc is not available with uClibc-ng as well as being deprecated, which
causes compilation errors. aligned_alloc is not available before C11 so
used posix_memalign.'

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 db/malloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/db/malloc.c b/db/malloc.c
index 77b3e022..38fe0b05 100644
--- a/db/malloc.c
+++ b/db/malloc.c
@@ -44,8 +44,7 @@ xmalloc(
 {
 	void	*ptr;
 
-	ptr = valloc(size);
-	if (ptr)
+	if(!posix_memalign(&ptr, sysconf(_SC_PAGESIZE), size))
 		return ptr;
 	badmalloc();
 	/* NOTREACHED */
-- 
2.17.1

