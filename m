Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C403D36461
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFETPO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:15:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59398 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfFETPO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SldthcHSRPh8gHxs0xG2B6qIiNWD0Mf6/ak5RWVo2mc=; b=HUup7HFVLZUPuLPX1uF68jOLf
        niqQKg1uF0xAfIu+DyfGzfZnSjL/9vTFgvQPB9FXyLbJ6zXKltJ4zaxsDJjUDTDiKFSD1PhkcDW87
        dOYaIS9PvyNrtjQep6GqaHFCNxWed7vBEpYw9n6RO9wygdPEDZ0xsXfjnIybeoAmj4venjdjo6RwU
        mF9qgYtSrZXYmgK2meqKBbvGmheFwAN4nDjbQdAaLLsz/T+ckRDaYMMLwSBJ5nCEFA66GWhZIqvx0
        E3EeoqdliZl6qsObM6TYJwta743NmIrso17elv0BlpUJvbaoShtVaAMvlDELfcMiI1/b6SINbEAlW
        z78Twa37w==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbNR-0001sl-ES
        for linux-xfs@vger.kernel.org; Wed, 05 Jun 2019 19:15:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: use bios directly in the log code v4
Date:   Wed,  5 Jun 2019 21:14:47 +0200
Message-Id: <20190605191511.32695-1-hch@lst.de>
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

A git tree is available here:

    git://git.infradead.org/users/hch/xfs.git xfs-log-bio

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-bio

Chances since v3:
 - add a few additional cleanup patches
 - clean up iclog allocation
 - drop a not required vmap invalidation
 - better document the iclog size fields
 - fix vmap invalidation

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
