Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5655721A2FC
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Jul 2020 17:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgGIPHH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 Jul 2020 11:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgGIPHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 11:07:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2869BC08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 08:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=8qeLJOaebl52NE+RJhzct509SnnP6P6gRns3NnGZ5G0=; b=WWIAD8ysjYJFIA8074Aq9IAaxc
        0ni9HeUv0JIRFIqBOxyZ/u3atTB17E1R3hvyJrx0zodLK21bQDML3GfC8Nf47K+FfgYoPyvvUTavc
        sKm3AckgjslQ/1dG1JM1FbeMCEQIDZW/4SqQIEm8jDu0N/kcD+f76Dqwhfk8YYQi71LM7/NXlKeE5
        OKceSjuw7vvWp+kh1zXOmvUzDi37TBi3fHm6N1O28E1ZIAVmB6RuvGbdX56nx6ZpldOXszVxRjEe5
        HCpj6fICIDDc4mNESve87r1jezx33YJn+u/bHr1gHTcLIDEj58TEQ643YxRxHRXmnPeZVfDw95Jv6
        578BYBpQ==;
Received: from 089144201169.atnat0010.highway.a1.net ([89.144.201.169] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtY8e-0004s8-AN
        for linux-xfs@vger.kernel.org; Thu, 09 Jul 2020 15:07:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: tidy up the buffer cache implementation
Date:   Thu,  9 Jul 2020 17:04:40 +0200
Message-Id: <20200709150453.109230-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series ties up some old and new bits in the XFS buffer
cache, and consolidates a fair amount of code.

Diffstat:
 libxfs/xfs_log_recover.h |    1 
 libxfs/xfs_trans_inode.c |    6 -
 xfs_buf.c                |  217 +++++++++++++++++++++++++++++++-------
 xfs_buf.h                |   18 ---
 xfs_buf_item.c           |  264 +----------------------------------------------
 xfs_buf_item.h           |    3 
 xfs_buf_item_recover.c   |    2 
 xfs_dquot.c              |   14 ++
 xfs_inode.c              |    6 -
 xfs_inode_item.c         |   12 +-
 xfs_inode_item.h         |    1 
 xfs_log_recover.c        |   37 ------
 xfs_trace.h              |    2 
 13 files changed, 227 insertions(+), 356 deletions(-)
