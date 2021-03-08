Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06AD331291
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Mar 2021 16:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhCHPv6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Mar 2021 10:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCHPv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:27 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CB8C06174A;
        Mon,  8 Mar 2021 07:51:27 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso3357514pjb.3;
        Mon, 08 Mar 2021 07:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EuvjnEG/FpNrBBt/9X3rBuaBuMlpS/vb3MZt/Qx6vlY=;
        b=sXeV2VSCwrS2s1AUeFsCKsPggE7DGN2K67mgW5tAjZEtIi/tett8hi7xiDJrXjKep8
         yvy+3mwnawoPXNRWXKs3veoBo9JhOKo4aFPXPyVESekHSdQJJFZmZGAO/uOQFxtQNgEE
         XAFpeoPO0TDytM0P5mU119+CufVbl5ulbQ2ExGvkx8+QZ6HaAYIBGBkAqBr8Fnth5bXG
         zWbdqEYyZjNS5yv7rWrWB8NbShwjyQKZYULUN/uFZYbI2ESFGOtZoptLNRSKfwYWz9eQ
         BhgkrCE48HGKKfrmJ9g4QoF4bCx2GMV/qDEv3S6PpQzlOPWnzvC3XNOAXJEqtUFCH76c
         hXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EuvjnEG/FpNrBBt/9X3rBuaBuMlpS/vb3MZt/Qx6vlY=;
        b=oLG1cbRFk0F69boIhD2kh0GMEuhMX0fArZzSfU92o7gkuEUFQRe1fqFh+cMaNMW/1I
         EHg052ktdTMpR8EeuM+5c/gW96I/lg/ipVkufMTh5ectDzCTaQYH45fbR0/4PTO1KJyS
         Yv0Tc4e9h7yId6WsbWpRyDMD19WzLGn5uyaZSYGZ7ZirQvs7nA7w6zPXoZqzVxGGL+Ph
         kXOw1WNakkNCJpWf+eoLCed/cFSO5WvM0DGYQ16J9N7aH2KIH0+KXpl6k2pXXnjL3Ky1
         qncklIA7yvDZ849E/XgnPcnLnQD/SAuRZ3giJhgnZwSNBuqrdPbHvZ+76P49PeuDbVKq
         XDsQ==
X-Gm-Message-State: AOAM531A4pKhs7WbAftUkZaS+341L7ZBsb07nuAMzyVKEFNc3sHsjC5v
        AtI0xg3BvzTUpSD0w4zrN1obHRJTHGQ=
X-Google-Smtp-Source: ABdhPJwiTKxIbGkgM8vgKGPG90sGyS/KWfOJd6kDVGXylqHFXIEj9d8imvQSgfJyOcI60pkgAVCOlw==
X-Received: by 2002:a17:902:7002:b029:e5:e1fc:7e88 with SMTP id y2-20020a1709027002b02900e5e1fc7e88mr18672006plk.30.1615218686837;
        Mon, 08 Mar 2021 07:51:26 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:26 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 02/13] common/xfs: Add a helper to get an inode fork's extent count
Date:   Mon,  8 Mar 2021 21:21:00 +0530
Message-Id: <20210308155111.53874-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the helper _scratch_get_iext_count() which returns an
inode fork's extent count.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 common/xfs | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/common/xfs b/common/xfs
index 7ec89492..f0ae321e 100644
--- a/common/xfs
+++ b/common/xfs
@@ -914,6 +914,29 @@ _scratch_get_bmx_prefix() {
 	return 1
 }
 
+_scratch_get_iext_count()
+{
+	local ino=$1
+	local whichfork=$2
+	local nextents=0
+	local field=""
+
+	case $whichfork in
+		"attr")
+			field=core.naextents
+			;;
+		"data")
+			field=core.nextents
+			;;
+		*)
+			return 1
+	esac
+
+	nextents=$(_scratch_xfs_get_metadata_field $field "inode $ino")
+
+	echo $nextents
+}
+
 #
 # Ensures that we don't pass any mount options incompatible with XFS v4
 #
-- 
2.29.2

