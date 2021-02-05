Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0BF311295
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Feb 2021 21:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhBESwx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Feb 2021 13:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhBESwd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Feb 2021 13:52:33 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47ECC061756
        for <linux-xfs@vger.kernel.org>; Fri,  5 Feb 2021 12:34:17 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id a16so8543425wmm.0
        for <linux-xfs@vger.kernel.org>; Fri, 05 Feb 2021 12:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OcmqGlL8Q1hkrktRoFCdNeODFYg2FXVGz/AXTvHlrzY=;
        b=fHI/D+waf6/vbDLut4cbNjGp07a0BO1pcl5VGFTAUloTyHKm1Y07zEl7zlIt348/KL
         vm5r3R0ov3P/67zRQN4a5SjO4sO9IfzrKx2ehg3zHfh0HFVP2Pfm0nWywNvlEt1CcSIa
         4mE6EfSAre6vzpTgE82ydkHdXRJKhAVpuyE89JAWp4offqlsRsEfixweW2p/6tyBjFhN
         Oaxz1rXUUcFiT/ADb8rsWEZsXKaJCjGAPxiaUGnur1URR+uLyB5liRhsNGwkhGSKNEQV
         HJoKvk4KjbMI7qR4J6GCAd64TOjqFl0NZyZ7WkKHOrYFB9nvwYim6wi0DNJDkCvnuIWd
         guLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OcmqGlL8Q1hkrktRoFCdNeODFYg2FXVGz/AXTvHlrzY=;
        b=ahjq5rfRXKnSjCyBvUO2Tz2c07TAwHpoYtIPTh2k7cksdIdtHoponYHIWMPQEcO44A
         /DUCjgWJN6lHvkwHz2IGg4Xd7QUR7OqpFO93me/6RLgJZql2tsCZ0Zfkbh5hjXdLPIts
         f+EXw/m3u4h9nUJ0VAvyzelQzKgfy+MMa1/Kk2jhha2V0jNV22EvCwh0L9PKTWLxnLYt
         VoCM22wM/5VPjRxYzijkCu3x6sK49+9eIzLJx0T9uWAyPyv1OdBYGOBFFIPd6nm3HMFl
         tzGA1pQRUSxqD15o94u0E6Uaf1wpNlinArOR/JcZ/EIGflsRu1MDKs8MOXo3mQWmCkGt
         yzVA==
X-Gm-Message-State: AOAM530KhE7fHf40AXS7e+nEu139drQ0we3loda6zDDPHBjyR1ORWEZ1
        CbZFjMaHgoM1S/xSItOfnSu4sb3JH0rSk1t2oog=
X-Google-Smtp-Source: ABdhPJxiAZr3UiiP2b3rOUPphbkRiUpRf1MWMzNwvaugbqJquHlvxewQky3mr7q8tyL9J7YiZC/sWw==
X-Received: by 2002:a1c:5412:: with SMTP id i18mr4918329wmb.152.1612557256643;
        Fri, 05 Feb 2021 12:34:16 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id j14sm15664985wrd.36.2021.02.05.12.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 12:34:16 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        Helmut Grohne <helmut@subdivi.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 1/3] debian: Drop unused dh-python from Build-Depends
Date:   Fri,  5 Feb 2021 21:34:03 +0100
Message-Id: <20210205203405.1955-2-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205203405.1955-1-bastiangermann@fishpost.de>
References: <20210205203405.1955-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs participates in dependency loops relevant to architecture
bootstrap. Identifying easily droppable dependencies, it was found
that xfsprogs does not use dh-python in any way.

Reported-by: Helmut Grohne <helmut@subdivi.de>
Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/changelog | 6 ++++++
 debian/control   | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/debian/changelog b/debian/changelog
index ce4a224d..7b0120c2 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,9 @@
+xfsprogs (5.10.0-3) unstable; urgency=medium
+
+  * Drop unused dh-python from Build-Depends (Closes: #981361)
+
+ -- Bastian Germann <bastiangermann@fishpost.de>  Fri, 05 Feb 2021 00:18:31 +0100
+
 xfsprogs (5.10.0-2) unstable; urgency=low
 
   * Team upload
diff --git a/debian/control b/debian/control
index b0eb1566..8975bd13 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
-Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python, pkg-config
+Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
-- 
2.30.0

