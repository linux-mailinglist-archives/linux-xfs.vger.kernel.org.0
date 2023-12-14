Return-Path: <linux-xfs+bounces-749-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5201D81283B
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 07:35:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06BAC1F21B50
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 06:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0AAD2FD;
	Thu, 14 Dec 2023 06:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UWxyReH2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91292A6
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=yEUe+pGMX+loEMQuPO1K5UczOHND9RjRtQb8CvqJeBo=; b=UWxyReH2l0eTUKnVaw+6/uuIMH
	NmthFHL9VcMOgygSIA84c0blAKC3/HpcZVvlUUWzvOfZLtNmu1Jiz/B/gd0/d11QznuSAiXbXyJlW
	cRjNyQT4RY69UKoGaC6sgEIX6nfxgXoWjqXBsNioxgDqqPrcqG4pAmkSvbeaZ+qUoKGA4L17hk+HD
	S5SxLoDwDfBFgZ3Fz5oFYQKXxyREJS4ZhxU2W6cEomEDke/IBFWq2O0m8eFyOPgkFB499Zf6TFNaT
	SrRYTqWm8adK2LnKuZLeIC6EQvmVNzB2XDgk7Uy27CKWjF4dq5lPpM0j4MLBFsk3rZcN7Vs1/V9Hc
	n/3BJTcg==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfIv-00GzIr-2J;
	Thu, 14 Dec 2023 06:34:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: RT allocator tidy ups
Date: Thu, 14 Dec 2023 07:34:19 +0100
Message-Id: <20231214063438.290538-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series has a bunch of tidy ups preparing for my research into
per-RTG RT bitmaps.

The first is a fix for a one-off bug that I could only reproduce with
my hacky patches, but which seems real.  The second- and third-last
patches change the policy for retrying allocations that didn't succeed
and could use very careful review.  The rest is fairly mechanic
cleanups.

Diffstat:
 libxfs/xfs_bmap.c     |   55 ++--
 libxfs/xfs_bmap.h     |    2 
 libxfs/xfs_format.h   |   14 -
 libxfs/xfs_rtbitmap.c |  106 +++-----
 libxfs/xfs_rtbitmap.h |    4 
 libxfs/xfs_types.h    |    1 
 scrub/rtsummary.c     |    2 
 xfs_bmap_util.c       |  141 ----------
 xfs_bmap_util.h       |    2 
 xfs_quota.h           |    5 
 xfs_rtalloc.c         |  647 +++++++++++++++++++++++++-------------------------
 xfs_rtalloc.h         |   37 --
 12 files changed, 416 insertions(+), 600 deletions(-)

