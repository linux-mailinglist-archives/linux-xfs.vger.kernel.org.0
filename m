Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434E135C7C7
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Apr 2021 15:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241888AbhDLNil (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Apr 2021 09:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbhDLNik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 09:38:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DE4C061574
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 06:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=m9M+zS+MRWWBN1MP8zJZiErTd2bqICyQrpODXrfVf7I=; b=TCuGM3G/sUTeuf+TYBESiAvHFR
        t2GX33gqde8ChCpC0koY1xwkXt9sRDaEDOC3WTmT+E2IpsqwH4SPavW2L4eCIGopeIrhLFJQvkukk
        pEulYYnY/bDpB1ARu4Y/bArc5qWLnCskbrFf3JTUCx2KBO3FACx7akcCke1S+knJJE99U3z08tyKX
        au9caXvnwBuc3seGOqhk4+82wEil9LETJ/6P4uO3Sc18YWqYE+PxrbDXaz8n1yKbmffmkfBupXA2a
        dzDWDSgwOTHaZd4zZUrplLRj3vTdmOOP0mseXd5z68P1Q4tIsubL+Yk24P1XxZTtPvyeYx9jsmC1a
        p4g+5Rog==;
Received: from [2001:4bb8:199:e2bd:3218:1918:85d1:2852] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lVwlh-006H02-WD
        for linux-xfs@vger.kernel.org; Mon, 12 Apr 2021 13:38:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: remove the if_flags field in struct xfs_ifork
Date:   Mon, 12 Apr 2021 15:38:12 +0200
Message-Id: <20210412133819.2618857-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series removes the if_flags field in struct xfs_ifork, as all the
information is available from other fields in the ifork structure anyway.

Diffstat:
 libxfs/xfs_attr.c          |   53 ++++++++++------
 libxfs/xfs_attr.h          |    1 
 libxfs/xfs_attr_leaf.c     |   13 +---
 libxfs/xfs_bmap.c          |  143 +++++++++++++--------------------------------
 libxfs/xfs_bmap.h          |    1 
 libxfs/xfs_btree_staging.c |    1 
 libxfs/xfs_dir2_block.c    |    2 
 libxfs/xfs_dir2_sf.c       |   12 +--
 libxfs/xfs_inode_fork.c    |   22 +-----
 libxfs/xfs_inode_fork.h    |   14 +---
 scrub/bmap.c               |   15 +---
 scrub/symlink.c            |    2 
 xfs_aops.c                 |    3 
 xfs_attr_list.c            |    2 
 xfs_bmap_util.c            |   20 ++----
 xfs_dir2_readdir.c         |   10 +--
 xfs_dquot.c                |    8 --
 xfs_inode.c                |   10 ---
 xfs_ioctl.c                |    2 
 xfs_iomap.c                |   20 ++----
 xfs_iops.c                 |    4 -
 xfs_qm.c                   |    8 --
 xfs_reflink.c              |    8 --
 xfs_symlink.c              |    6 -
 24 files changed, 142 insertions(+), 238 deletions(-)
