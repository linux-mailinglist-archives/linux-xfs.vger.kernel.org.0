Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B81365331
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Apr 2021 09:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhDTHXb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Apr 2021 03:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhDTHXb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 03:23:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7A7C06174A
        for <linux-xfs@vger.kernel.org>; Tue, 20 Apr 2021 00:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=fjTJwmsLCbMTVv7+Ttxf2zj+ByB0HR705yUAAOyvOFg=; b=4buPlUTYlSMVCKhD2jRz4NUxDA
        81b3mYFtDFhQsShDu4QdlmqLPYW4l4k0axD1DUYNw3qBzNM/UXsdbkXoUOeSk3vBg34TcPL1Omspi
        2pCw9ACcxzRrokkFEeWvZUm4I+N9EU9mVpHM3Zk9KO0Y23Divtq2MM3Eu1eKJFGDQLZ0cZRqEwvY2
        ASNjYNerJ02leAtcxcaWEE09dzYqa4M9M7UBPZzqzftQnXK9kLvJT33VHWfP2VVj1JuuDu8CSDaQ6
        p6F813ytRelLOJawLDRBmQw2FhKrYCxOuf1tufaPbXjd7Ie7sdKyhAEcdFRtzqc2zKezI1tj0iwm0
        wk3gC77w==;
Received: from [2001:4bb8:19b:f845:7e4b:8a2:58e2:9b7b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYkip-00BsOz-Sv
        for linux-xfs@vger.kernel.org; Tue, 20 Apr 2021 07:23:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: RFC: don't allow disabling quota accounting on a mounted file system
Date:   Tue, 20 Apr 2021 09:22:54 +0200
Message-Id: <20210420072256.2326268-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

disabling quota accounting (vs just enforcement) on a running file system
is a fundamentally race and hard to get right operation.  It also has
very little practical use.

This causes xfs/007 xfs/106 xfs/220 xfs/304 xfs/305 to fail, as they
specifically test this functionality.

Note that the quotaitem log recovery code is left for to make sure we
don't increase inconsistent recovery states.

Diffstat:
 libxfs/xfs_quota_defs.h |   30 ----
 libxfs/xfs_trans_resv.c |   30 ----
 libxfs/xfs_trans_resv.h |    2 
 scrub/quota.c           |    2 
 xfs_dquot.c             |    3 
 xfs_dquot_item.c        |  134 ---------------------
 xfs_dquot_item.h        |   17 --
 xfs_ioctl.c             |    2 
 xfs_iops.c              |    4 
 xfs_mount.c             |    4 
 xfs_qm.c                |   28 ++--
 xfs_qm.h                |    4 
 xfs_qm_syscalls.c       |  300 ------------------------------------------------
 xfs_quotaops.c          |   57 +++++----
 xfs_super.c             |   51 +++-----
 xfs_trans_dquot.c       |   49 -------
 16 files changed, 84 insertions(+), 633 deletions(-)
