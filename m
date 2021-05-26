Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E96390FF4
	for <lists+linux-xfs@lfdr.de>; Wed, 26 May 2021 07:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhEZFXF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 May 2021 01:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEZFXC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 May 2021 01:23:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 991DA613B9;
        Wed, 26 May 2021 05:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622006438;
        bh=+IFtpsVHoMfnuKZ/Kbl3O9fBM9Eeb6YhX4/POJVMai4=;
        h=Date:From:To:Subject:From;
        b=E5MNts4ndsmbTwwMMAwWViQgVjeyhIwDaKXC/jSYX0mAUKJOLcij9IIoBWq0Zd6y4
         hEWoAQHHLWQcF7x+LgCRkYpzbfDFb2+POAlLbdMol+rCA8RwQDF/8zxkjwL+bTYhiK
         aD6MKDg//sKJsplCC2qgHVYccUo15hApskn7Ok0oKecUI523NEUQUP7zYV3AZKne8F
         nOAEkiFbGLry1g659s7epQ97CURr/CftA7Mc/DAjmaw9LnDYA+B3CBIa4CpVxcXP2U
         mYjSzv3WtY49EFZT6tLSyLIN2aFVZS6iTSnYJtVA1H5V7IOS4P4rap6qwuYQy/ydD2
         5LU1FyrwZbpBw==
Date:   Tue, 25 May 2021 22:20:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: add new IRC channel to MAINTAINERS
Message-ID: <20210526052038.GX202121@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add our new OFTC channel to the MAINTAINERS list so everyone will know
where to go.  Ignore the XFS wikis, we have no access to them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 008fcad7ac00..ceb146e9b506 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19998,6 +19998,7 @@ F:	arch/x86/xen/*swiotlb*
 F:	drivers/xen/*swiotlb*
 
 XFS FILESYSTEM
+C:	irc://irc.oftc.net/xfs
 M:	Darrick J. Wong <djwong@kernel.org>
 M:	linux-xfs@vger.kernel.org
 L:	linux-xfs@vger.kernel.org
