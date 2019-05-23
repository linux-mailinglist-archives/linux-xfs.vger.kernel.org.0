Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCBB428508
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 19:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731201AbfEWRh5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 13:37:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55920 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731037AbfEWRh4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:37:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=g5YpdyD9XyofeiUIQZ4/qG/uw7w3j5UshO+iKK5MVYw=; b=Ghva7ecFj/OPZ3+sLyWRpZ0rd
        RyXBPlEKjqj5v0CZjG0AVHb7nZw6HTuJI6EB9fJ2ccq9WG++8q3vm60oFYJ1IdxcYX1/n7JwDHNNi
        PlzSuYtoSiKAzyJyXqgOePTHzAalZW9zobtFFs8J8PLIm2uH6l1l2kgOluac5My993ifzhYqGr0xu
        RxS2jcixGGSNLODLeRdBgT9d8iDlVsgie8UOuW9p9tv+AO6aXMEohYbZc2EGx4dCC1TCiIMqTpd63
        8yCHk42Eu4y7EpVg3kzm4ROPGn1kqk0AlFIXRDFbDuQ+lIMmOGk5n8a29ace8CmFTmHeX87FF91nn
        S7YBcwSNw==;
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTrf9-0000Re-N8
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:37:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: use bios directly in the log code v2
Date:   Thu, 23 May 2019 19:37:22 +0200
Message-Id: <20190523173742.15551-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series switches the log writing and log recovery code to use bios
directly, and remove various special cases from the buffer cache code.
Note that I have developed it on top of the previous series of log item
related cleanups, so if you don't have that applied there is a small
conflict.  To make life easier I have pushed out a git branche here:

    git://git.infradead.org/users/hch/xfs.git xfs-log-bio

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-bio

Changes since v1:
 - rebased to not required the log item series first
 - split the bio-related code out of xfs_log_recover.c into a new file
   to ease using xfs_log_recover.c in xfsprogs
 - use kmem_alloc_large instead of vmalloc to allocate the buffer
 - additional minor cleanups
