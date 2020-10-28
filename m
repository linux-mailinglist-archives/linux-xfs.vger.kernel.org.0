Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7F629D331
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Oct 2020 22:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgJ1Vlm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Oct 2020 17:41:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725931AbgJ1Vll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603921300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=LhENSx2EttwM9DyL2rsq8rtceZSh7KlVqPrWwMltGEg=;
        b=SfI8YlA30Fe88yNl3BtrOrmb1fYdQg+nDoYnk9LxN0DVY286yhn2A6pzPMJP/XJ/q0kzK/
        /KmQFy1f2WakYaejSnqiPRo5DE/73Aey7oO/Y31LR0Kr0FwA8B9CV+5b8qT6ptaU8shUFW
        sq7XZraPI0OcVFjKHruulRHl+72beNM=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-EVNOubmpMJGBiKmE0DXebg-1; Wed, 28 Oct 2020 07:40:42 -0400
X-MC-Unique: EVNOubmpMJGBiKmE0DXebg-1
Received: by mail-pj1-f71.google.com with SMTP id t15so2563254pja.7
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 04:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LhENSx2EttwM9DyL2rsq8rtceZSh7KlVqPrWwMltGEg=;
        b=qBWlDW4DDxIbtwV4uf56xW1ICei+ocU4jB5Z/mJJSA0qLA7wJqPfXb8b+pvFMcWFba
         +FqdqbCJFM6ZVnGIb8phaZ0dHB8xwcU5UThZALLnYzzMwRMlLsQzZLNIIyjx7bHLfbP+
         kX2Dfklkw0X5zF3CoGEMArcmSWKFxxRBor3c1IONXgUHGYEpBU9RdqKPK/ncibQVyZVG
         svFMgz0fDaruldrexF8OHQTHSBcTrOnfmx6yKrlSKI7yqmVxZMtF1Fjs69+nGbLvrL4N
         MJkqwrLYaiOVEXBdDU/dgrsnGsBo/0pqVJigV51cLdRUmktBYhyjbcVvXwrO8ruLN5DV
         Vktg==
X-Gm-Message-State: AOAM530RazaUfV+82w1aP16X5E/9PjJ5LOUIdl9ctn2k8WZI3DNWYYLN
        kVcE7x57szRf6xb9glUlMVr/uzBtxzB7Swws5YvrP880cA9Avo5qHsOYM288M0h6ffscKMOyCik
        2qoq2VxJ14cIJEAtCjqvA
X-Received: by 2002:a17:90a:2e87:: with SMTP id r7mr6346174pjd.193.1603885241443;
        Wed, 28 Oct 2020 04:40:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvDUWxRZgB7zB8dKqo5wNw1VmqtBlYQQ+224O57KKZz63hV7OENzdhTlpm+zOWO5+/qk5W9Q==
X-Received: by 2002:a17:90a:2e87:: with SMTP id r7mr6346160pjd.193.1603885241234;
        Wed, 28 Oct 2020 04:40:41 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z26sm6405656pfq.131.2020.10.28.04.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 04:40:40 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [WIP] [RFC PATCH] xfs_growfs: allow shrinking unused space in the last AG
Date:   Wed, 28 Oct 2020 19:40:10 +0800
Message-Id: <20201028114010.545331-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This allows shrinking operation can pass into kernel.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
preliminary version.

 growfs/xfs_growfs.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index a68b515d..d45ba703 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -246,12 +246,11 @@ main(int argc, char **argv)
 			error = 1;
 		}
 
-		if (!error && dsize < geo.datablocks) {
-			fprintf(stderr, _("data size %lld too small,"
-				" old size is %lld\n"),
+		if (!error && dsize < geo.datablocks)
+			fprintf(stderr,
+_("[EXPERIMENTAL] try to shrink unused space %lld, old size is %lld\n"),
 				(long long)dsize, (long long)geo.datablocks);
-			error = 1;
-		} else if (!error &&
+		if (!error &&
 			   dsize == geo.datablocks && maxpct == geo.imaxpct) {
 			if (dflag)
 				fprintf(stderr, _(
-- 
2.18.1

