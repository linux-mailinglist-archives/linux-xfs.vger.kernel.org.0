Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C9E38DE92
	for <lists+linux-xfs@lfdr.de>; Mon, 24 May 2021 03:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhEXBCz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 May 2021 21:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232114AbhEXBCz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 May 2021 21:02:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8034611CC;
        Mon, 24 May 2021 01:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621818088;
        bh=JYRU7v25IksAjHCguhZi7wgXONii67/Tnl2v0fS6kDY=;
        h=Subject:From:To:Cc:Date:From;
        b=Fc2MrvJ0yKtS4XtyvDPhcW/HnzhxZyvmuiEC5q5eQ7XNKXnJM7/xJQkzSbtT9MGCt
         vscBpqyTyJXfTDAsRdr5thoFw7KjU/oD2d1rc+p6He1+gZO3nnBExPs9QqNo93j9CW
         QaDH1H7s+8M9z/6jVKnFHz+W4yVy6XPUIJzFqmABRGBAeouRDByACrJDYZ0RyoOXwE
         zduZjKHtf03cTlAYvh5cG03NzzE8y0uQ5jZz+bnhYfQ0x+65JUJ88ACM25o7CFsNb6
         yb8AR3MebGq6jABRq7gby3HUb+G10j04d3zoNZXH0Ihc4ayPKHj/Q0iT+yww+Ioi9q
         ciGEeiYu2Mk/A==
Subject: [PATCHSET 0/1] xfs: fixes for online shrink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hsiangkao@aol.com, david@fromorbit.com
Date:   Sun, 23 May 2021 18:01:27 -0700
Message-ID: <162181808760.203030.18032062235913134439.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a single fix to the per-AG reservation code to make it so that
shrink can abort successfully if shrinking would leave too little space
in the AG to handle metadata btree expansion.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=shrink-fixes-5.13
---
 fs/xfs/libxfs/xfs_ag_resv.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

