Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB97336A2
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2019 19:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfFCR3t (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 13:29:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53498 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfFCR3t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=G200v/4E4bBqgrRDP1JKFvF7cICTylL+G4PKy6kYz3w=; b=Nb0xWKcwlXCOAu8zgrTAPFG1P
        fzkJ5+CR4UtTO7YOummrdHaugbhGAmrTpN+jdMiUt8uLAt2qJs+6tj2ZGBpoDKJIactnFhVWpCtyA
        lVeGwIPbSZ/X2/E7wYbXSWLqYQpuE2QBZ+f/xBsjX2t572eCQGqIyxY0mrsyGgL3c0jVg0PhViPW+
        8ZR9jr3UocAjAxt1yCBxPW0gizP2zyQsys2T76VM4TgceEe0EU5Kg+YBJVUCNJ/w36Q0SfythfOUT
        OpWlIo3Y3bTMIEC1EJIK9HPGmEeu1g27UWrGILsvdVWPeEi24XTFXr9S7wpA0QJPRqkFlwLw7ogNi
        CNL6Xyk3Q==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXqmK-0002Mq-QZ
        for linux-xfs@vger.kernel.org; Mon, 03 Jun 2019 17:29:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: use bios directly in the log code v2
Date:   Mon,  3 Jun 2019 19:29:25 +0200
Message-Id: <20190603172945.13819-1-hch@lst.de>
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

Changes since v2:
 - rename the 'flush' flag to 'need_flush'
 - spelling fixes
 - minor cleanups

Changes since v1:
 - rebased to not required the log item series first
 - split the bio-related code out of xfs_log_recover.c into a new file
   to ease using xfs_log_recover.c in xfsprogs
 - use kmem_alloc_large instead of vmalloc to allocate the buffer
 - additional minor cleanups
