Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2388B34C363
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Mar 2021 07:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhC2F4F (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 29 Mar 2021 01:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhC2Fz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 01:55:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906A0C061574
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 22:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=TMKS6lwHar8HNfbHqBaNPcc7gk0AlMc5wbhY2ErHTII=; b=rcvmLvWwtcIB9PGpDZimINfg8B
        J8gwfETr6JVN87n3Q46/7AQF2DD43B/IT2KfiL59z2A90wiu2g2qwHmuwWEEWFwJ/ZqnKE2bRopgs
        bJV0eDxmZinl8gMhrMFpbgznL8CUmMfzRYvCOY0uR4O5lK2oPVW0tBhUgcjkQGmxRA/ca/jtm2CiS
        7T52NLfDQB8++/nH2JguMpOA6piAU+J8Rwh6zGAxAN2ZdX7v1sqn5CgO9R+IbkXJmHvsCTO4mWfmT
        cKHR9UOmzxgW+TqbuN/+qCz4s9dngxUy4Yi0dbjpev83BYanWUqZdKBNJ+h3eEsaSRfllpTiTFJOc
        2h2MjIog==;
Received: from 173.40.253.84.static.wline.lns.sme.cust.swisscom.ch ([84.253.40.173] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lQkbg-006oOh-Hu
        for linux-xfs@vger.kernel.org; Mon, 29 Mar 2021 05:38:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: xfs inode structure cleanups v4
Date:   Mon, 29 Mar 2021 07:38:09 +0200
Message-Id: <20210329053829.1851318-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series cleans up how we define struct xfs_inode.  Most importantly
it removes the pointles xfs_icdinode sub-structure.

Changes since v3:
 - rebased to the latest for-next tree
 - fix v4 file system handling in xfs_ioctl_setattr
 - rename XFS_IDMAPI to XFS_IPRESERVE_DM_FIELDS
 - two additional cleanup patches
 - minor typo fixes

Changes since v2:
 - rebased to 5.12-rc
 - remove the legacy DMAPI fields entirely
 - ensure freshly allocated inodes have diflags2 cleared

Changes since v1:
 - rebased to 5.8-rc
 - use xfs_extlen_t fo i_cowextsize
 - cleanup xfs_fill_fsxattr
