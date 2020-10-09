Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A98B2881AA
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Oct 2020 07:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbgJIFZO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Oct 2020 01:25:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730449AbgJIFZO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 01:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602221112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=e5YmFQloaORwYRu04FIstli5H1tapvDa7XT4/gY7lrs=;
        b=OWas2h+XgC6hem4qJyF8L0sLQvudGQze3JwvA5DnHsCnq6WJX6481EzBfo+D/WmCD0wi/d
        GVc8gYTIvQC4GsqPJ0iudB9egLNovlHQ5h/q+nwSEvSbZY6itgobI+hGjhNYkOD1MDJinY
        6UZNG3M0chX9Pl4LUAlZsAd5GDkWJf8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-jvOofVXJMaOXjf2AZilV8w-1; Fri, 09 Oct 2020 01:25:11 -0400
X-MC-Unique: jvOofVXJMaOXjf2AZilV8w-1
Received: by mail-pl1-f197.google.com with SMTP id b5so5374533plk.2
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 22:25:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e5YmFQloaORwYRu04FIstli5H1tapvDa7XT4/gY7lrs=;
        b=TowH3vMnVauiHaD40MBm6n9ynIE9EnYyAj9NJ6sVQ0WjN7cr9HjTRyYFezNzC9oR+m
         D+Kwa/LJLbchgEGgd+RugaudX7h3aD82bzY+LbKuHJv+4Mkfd8R8Z4f3OmpJWbiRJgUf
         fS/SG2MLzokDCYMVHQ0qnNNUtTJ/bqFjJ3UWXAWOgIMYx4I5SL4QjGDYTiSgpPZipp45
         Yp3W+oSO67dL+45aiejOWbMXLZJoGEZCnzqPaWpS+PtEsGL40CpnTrg+pKknmCmp2vO1
         lOYUpxP8P9CqMy7cF2+nEaZcgoq+KzauJpd0JXlTRwSblVipSlpVZZ4OtN64/bHiCZqx
         haOw==
X-Gm-Message-State: AOAM533jNh+dRmVPi8Pm6pwuUiHv/2x5mQ1KhLxziGnIk/jjQ1mDnjzp
        9ilyR3JJbalnJ6e7UGcbjjL0HmIBQvm7cwytfkFV7EBsYvWgkIxj1qWZm+cFBUTj5xwXiuVClK2
        A3Zapl/rmVl89eDJjngvb
X-Received: by 2002:a17:902:7589:b029:d2:686a:4ede with SMTP id j9-20020a1709027589b02900d2686a4edemr10853847pll.45.1602221109908;
        Thu, 08 Oct 2020 22:25:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTtNWv2kuBiYG2mEAgvf1nyJmObhBFCbHLNVgVclqX4EgleYYkFeuRAMPJhW7fRwWf3HRCHA==
X-Received: by 2002:a17:902:7589:b029:d2:686a:4ede with SMTP id j9-20020a1709027589b02900d2686a4edemr10853828pll.45.1602221109708;
        Thu, 08 Oct 2020 22:25:09 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p12sm9254042pgm.29.2020.10.08.22.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 22:25:09 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 1/3] libxfs: allow i18n to xfs printk
Date:   Fri,  9 Oct 2020 13:24:19 +0800
Message-Id: <20201009052421.3328-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201009052421.3328-1-hsiangkao@redhat.com>
References: <20201009052421.3328-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation to a common stripe validation helper, allow i18n to
xfs_{notice,warn,err,alert} so xfsprogs can share code with kernel.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 libxfs/libxfs_priv.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 4356fa43..bd724c32 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -121,10 +121,10 @@ extern char    *progname;
 extern void cmn_err(int, char *, ...);
 enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 
-#define xfs_notice(mp,fmt,args...)		cmn_err(CE_NOTE,fmt, ## args)
-#define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
-#define xfs_err(mp,fmt,args...)			cmn_err(CE_ALERT,fmt, ## args)
-#define xfs_alert(mp,fmt,args...)		cmn_err(CE_ALERT,fmt, ## args)
+#define xfs_notice(mp,fmt,args...)	cmn_err(CE_NOTE, _(fmt), ## args)
+#define xfs_warn(mp,fmt,args...)	cmn_err(CE_WARN, _(fmt), ## args)
+#define xfs_err(mp,fmt,args...)		cmn_err(CE_ALERT, _(fmt), ## args)
+#define xfs_alert(mp,fmt,args...)	cmn_err(CE_ALERT, _(fmt), ## args)
 
 #define xfs_buf_ioerror_alert(bp,f)	((void) 0);
 
-- 
2.18.1

