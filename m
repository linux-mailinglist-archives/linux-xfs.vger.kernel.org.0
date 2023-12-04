Return-Path: <linux-xfs+bounces-397-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E6531803BD4
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 18:41:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19C631C20A63
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 17:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6BA2E854;
	Mon,  4 Dec 2023 17:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pKzcV6ai"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE915DF
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 09:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=lpT5OcQBhcO9sNINVU3ix7uAWm2lg8i7VBXUh3/isw0=; b=pKzcV6ais+AwmMt4VeFrnIvN/g
	1x3uoJL0Q+NGeZjR2CKbfbPUDAAIx1oi6dX+YiTMMXMk3gAErrbXwi7hWbpgHj6l3OzEs6NZOZjcj
	SlFLo8gTWQAe//KiWWTjzNaEy7PPNHhw+rA7Gjm6oywwxD0/wF0Ff2V78jvI/0alc/zM52R/cWvwx
	g9xjE3gQZ/2ZzcDSiEZErPP/YGcpukAxcL6NKYhP9QqK6ErBhH3WVJtLro6EZFMUD1G4yb66sIB9+
	jzlbk72hhtFh7LjERYImizMa45455XulTSpKFi/ovk8xM8DU/+hNrCACk1eC59s1lkrf7IDosxffq
	Ri+3Plow==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rACwG-005DhO-0s;
	Mon, 04 Dec 2023 17:41:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: misc cleanups to the resblks interfaces v2
Date: Mon,  4 Dec 2023 18:40:53 +0100
Message-Id: <20231204174057.786932-1-hch@lst.de>
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

this series has small cosmetics to the get/set reslks and fscounts
interface.

Changes since v1:
 - add a missing __user annotation
 - align the lines of a struct initialization

Diffstat:
 xfs_fsops.c |   50 +-------------------------
 xfs_fsops.h |   14 +++----
 xfs_ioctl.c |  115 ++++++++++++++++++++++++++++++++----------------------------
 xfs_mount.c |    8 +---
 xfs_super.c |    6 +--
 5 files changed, 75 insertions(+), 118 deletions(-)

