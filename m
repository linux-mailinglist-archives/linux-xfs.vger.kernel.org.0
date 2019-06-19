Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444D74B808
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Jun 2019 14:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731681AbfFSMTh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 Jun 2019 08:19:37 -0400
Received: from verein.lst.de ([213.95.11.211]:53106 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731680AbfFSMTh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Jun 2019 08:19:37 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 9087C227A81; Wed, 19 Jun 2019 14:19:08 +0200 (CEST)
Date:   Wed, 19 Jun 2019 14:19:08 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/20] xfs: move the log ioend workqueue to struct xlog
Message-ID: <20190619121908.GA11894@lst.de>
References: <20190603172945.13819-1-hch@lst.de> <20190603172945.13819-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-15-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The build/test bot found an issue with this one leading to crashes
at unmount, and I think this incremental patch should fix it:

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 66b87cce69b9..c66757251809 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1954,7 +1954,6 @@ xlog_dealloc_log(
 	int		i;
 
 	xlog_cil_destroy(log);
-	destroy_workqueue(log->l_ioend_workqueue);
 
 	/*
 	 * Cycle all the iclogbuf locks to make sure all log IO completion
@@ -1976,6 +1975,7 @@ xlog_dealloc_log(
 	}
 
 	log->l_mp->m_log = NULL;
+	destroy_workqueue(log->l_ioend_workqueue);
 	kmem_free(log);
 }	/* xlog_dealloc_log */
 
