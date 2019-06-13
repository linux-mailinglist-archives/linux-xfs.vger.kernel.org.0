Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70B144A23
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 20:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfFMSDE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 14:03:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57400 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFMSDD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2OfNAbjPRlwP9Qk325AFTP/6CJ5y9hWTyNNZRcvIgdI=; b=E5kSMDTroG7vT0HepELiC/JT4
        VTpTYjGcLTsC5K2kivHGCD068EX3CLhyTwUcMjcpplluaEYBqgOvZUDYcM3M43165QbweHS+OvTal
        Fi25y7aU4BYvhwvPlP6giPcnYCalR8wnBhLji3mDuHb4h0dSWYHWJvLPvEz86KwpUgNmNzxeNA3ra
        yOXHkoiSe5xS1fSdwZSSBZkamI5jneMEycSb7QnajYu+Tp9AgDOwEkYx+8OHNMUJri+/V3BT8rkb9
        SUXpISm9da3FmLSs28tq9HdhVvCSzFFVmRVF0B6ggi+6qPBu8IYZZ4c5qxclkMy5Y41n693O2bbeb
        1TokPJw1w==;
Received: from [213.208.157.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbU3z-0002fE-87
        for linux-xfs@vger.kernel.org; Thu, 13 Jun 2019 18:03:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: misc log item related cleanups v2
Date:   Thu, 13 Jun 2019 20:02:40 +0200
Message-Id: <20190613180300.30447-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I've recently been trying to debug issue related to latencies related to
locked buffers and went all over our log item lifecycles for that.

It turns out a lot of code in that area is rather obsfucated and
redundant.  This series is almost entirely cleanups, but there are lots
of it.  The only exception is a fix for systematic memory leaks which
appears entirely theoretical.

Note that this series sits on top of the series titled
"use bios directly in the log code v4".  To make everyones life easier
a git tree is available here:

    git://git.infradead.org/users/hch/xfs.git xfs-log-item-cleanup

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-item-cleanup


Changes since v1:
 - improve a few commit messages
 - add various comments
 - minor code style fixes
 - drop the patch to remove iop_pushed from the quotaoff item
 - set XFS_LI_ABORTED earlier in xfs_trans_committed_bulk
