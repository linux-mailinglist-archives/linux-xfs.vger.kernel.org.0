Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290C064BB0A
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Dec 2022 18:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbiLMRa7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Dec 2022 12:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236297AbiLMRai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 12:30:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB00022BCC
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670952584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PYjmeLrT3i6/hh4pTFXkLdj6FOGAvtP6dMYWRjFj29Y=;
        b=GS/EseoW2PUQ4iCSBEhMkdaDdcBWLASeaUbgv8Ft6Cr+GU0Eb8oZoeBg147gug9R3EQwmx
        R1SELNCR7iarN27P5xNBz1esUt3qrl1D2cRUJWEBURf6OCewSc7h9OfJ12j41g55dPccTE
        wZ5YkXGNisZ7VGNEwWAHyS3UDCxBgHg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-rbz_c-vuMwSjW8AzJClvFg-1; Tue, 13 Dec 2022 12:29:42 -0500
X-MC-Unique: rbz_c-vuMwSjW8AzJClvFg-1
Received: by mail-ej1-f71.google.com with SMTP id nb4-20020a1709071c8400b007c18ba778e9so1880887ejc.16
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYjmeLrT3i6/hh4pTFXkLdj6FOGAvtP6dMYWRjFj29Y=;
        b=pe/YMqeSnatZmvqvFiwEM4Ohlt/qiHB01+KbOjoP1K1aHLU+5bmbVKW+NT9CR0jmvK
         Br2DYRcpAqampTndTI4tpzI/TQgkV1auXtjzUoJYxBkh+aWdR2+v1UUFEtRGvh1PlHRc
         bT5nwaHyulF2OnQCBIFAqdQkAzJWRi0N7uxrxsLwUCA6mLwFS1GL1qkGBOWDQr4mtIDX
         gvW3dvsOtG0+Wb7FrsnnteD3mQHOVSveel77MtCMqIF/Z3oggdIHrUcNXKGjLzADOK/u
         /KwKa9fgTIaLc8J6/vXagk+Dps1iP05pZsnELT5OmxD8D+5Yda4DMrd17dsvEZlsVIXo
         Kr8Q==
X-Gm-Message-State: ANoB5ple23+zUDiR7mfIsfR6HklHONST9CxAPeGy5RC0eHTxLZ9YXGdZ
        ROKbwXntje7ZnmGrWvc4rDDcicieNUfMbdNZtQJmsZb0+rgHub9SOtw/WP/EnFnisx5f6gOjJKF
        m7rg+7uwsQiL7Xe6VOciQqpPTBoCfFWdOkwlvlzC//dfZ/ckgieGM8Zg1MCZbCXMrASFa3j4=
X-Received: by 2002:a05:6402:5305:b0:461:c6f8:fb72 with SMTP id eo5-20020a056402530500b00461c6f8fb72mr15805615edb.10.1670952581540;
        Tue, 13 Dec 2022 09:29:41 -0800 (PST)
X-Google-Smtp-Source: AA0mqf73zYXk5C4Q9RiYEiIPI9dK+R4yDd40bqcxblgQCA8+sa8kOvFSja6W/u4rGCy7njSqJOO9Vg==
X-Received: by 2002:a05:6402:5305:b0:461:c6f8:fb72 with SMTP id eo5-20020a056402530500b00461c6f8fb72mr15805603edb.10.1670952581288;
        Tue, 13 Dec 2022 09:29:41 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ec14-20020a0564020d4e00b0047025bf942bsm1204187edb.16.2022.12.13.09.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:29:40 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RFC PATCH 03/11] xfs: add attribute type for fs-verity
Date:   Tue, 13 Dec 2022 18:29:27 +0100
Message-Id: <20221213172935.680971-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213172935.680971-1-aalbersh@redhat.com>
References: <20221213172935.680971-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The Merkle tree pages and descriptor are stored in the extended
attributes of the inode. Add new attribute type for fs-verity
metadata. Skip fs-verity attributes for getfattr as it can not parse
binary page names.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
 fs/xfs/libxfs/xfs_log_format.h | 1 +
 fs/xfs/xfs_trace.h             | 1 +
 fs/xfs/xfs_xattr.c             | 3 +++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 75b13807145d1..778bf2b476618 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -689,14 +689,17 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
 #define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
+#define	XFS_ATTR_VERITY_BIT	4	/* verity merkle tree and descriptor */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
 #define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
+#define XFS_ATTR_VERITY		(1u << XFS_ATTR_VERITY_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
 #define XFS_ATTR_NSP_ONDISK_MASK \
-			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
+			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT | \
+			 XFS_ATTR_VERITY)
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 727b5a8580285..678eacb7925c9 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -968,6 +968,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
 					 XFS_ATTR_PARENT | \
+					 XFS_ATTR_VERITY | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 372d871bccc5e..5eceb259cc5f7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -78,6 +78,7 @@ struct xfs_icwalk;
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
 	{ XFS_ATTR_SECURE,	"SECURE" }, \
+	{ XFS_ATTR_VERITY,	"VERITY" }, \
 	{ XFS_ATTR_INCOMPLETE,	"INCOMPLETE" }
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 5b57f6348d630..acbfa29d04af0 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -237,6 +237,9 @@ xfs_xattr_put_listent(
 	if (flags & XFS_ATTR_PARENT)
 		return;
 
+	if (flags & XFS_ATTR_VERITY)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&
-- 
2.31.1

