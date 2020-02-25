Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D33716ED78
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 19:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgBYSH1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 13:07:27 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgBYSH1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 13:07:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aCaDXtbBQPVEc9XwUeRXZXycGtd4URd8os8NhYVB/ZI=; b=kjY4KEu9G68waT7PVGTNrC5OTD
        alIjGbCn1cTJsnpr7OKaq8fT6XfrJox2JDRDqiEwD0GbL+GW8RZHNIrTyijbZv2RTE6IFbZw0GycS
        px2U5yzIkx4yBHBZNEsQZUIR8AhuJULSbGSX8aD+vTlOllUVyTuBdlnVNybDzC3rjDYLJ+T4/h/NX
        ughbMwxKWUz3R2frUfteJaPIOkvA/s8M8gUKk0Tf0V2gn//LWFcCOpj0kuikDHj2jwVJnm2DqU/5K
        qYcrvlBIicxkjoSW0dGlrrSpvqZ6WpURqmoG7qyqr6CeCM5tR4vENw6dl0ArDHKogeKPwm6/xuZrL
        6G18/UDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6ec9-0007zW-2t; Tue, 25 Feb 2020 18:07:25 +0000
Date:   Tue, 25 Feb 2020 10:07:25 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Qian Cai <cai@lca.pw>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix an undefined behaviour in _da3_path_shift
Message-ID: <20200225180725.GA29862@infradead.org>
References: <1582641477-4011-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582641477-4011-1-git-send-email-cai@lca.pw>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I think we code do this a tad more cleaner, something like:

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 875e04f82541..542a4edfcf54 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1986,7 +1986,8 @@ xfs_da3_path_shift(
 	ASSERT(path != NULL);
 	ASSERT((path->active > 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	level = (path->active-1) - 1;	/* skip bottom layer in path */
-	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
+	for ( ; level >= 0; level--) {
+		blk = &path->blk[level];
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
 					   blk->bp->b_addr);
 
