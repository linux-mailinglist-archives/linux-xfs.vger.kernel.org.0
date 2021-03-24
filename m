Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759BF3471FB
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Mar 2021 08:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhCXHDO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Mar 2021 03:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhCXHDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 03:03:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CABAC061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 00:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=3Yk5KIvIx4XihWrVSxkT9rPd5G2tV/WIjFRMNW1jv5g=; b=KW66uh2p6EzUNwXgRWWM2k6S2Z
        vzhm4bte9RTZWPqhN/5EDJbOkkH7JyPrCpCwjubtL7Xr9iBNAAa2A/j7E9af5P8FtUsCW35gkgQK0
        onOKEYjA3EbSmlLvg6mcY2LM558bje89qZSM8cbhTHCDXvA5bxtAgrnYP4+4kyUluOXva7VkiMvVw
        CUdjtXROgoKtP8aQEFAJcOGeuXtccWTbeQl15K7vhm8LNbuhHElxBH9wdaTx41ukYTb2GKecjYOYg
        zp1AdfQeYPOND34mmIKETMbFpF4jk6Mz7XvJdDcgLdNEc15Ki3TYLL2F6mBeKEm9R8rRWdWLzxETv
        HAizjzEw==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOxXp-003uih-FM
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 07:03:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: simplify the blockgc iwalk infrastructure
Date:   Wed, 24 Mar 2021 08:03:04 +0100
Message-Id: <20210324070307.908462-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series switches quotaoff to use the VFS s_inodes list and then
simplifies the iwalk infrastructure for its only remaining user.
