Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC722D129E
	for <lists+linux-xfs@lfdr.de>; Mon,  7 Dec 2020 14:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgLGNyT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 7 Dec 2020 08:54:19 -0500
Received: from verein.lst.de ([213.95.11.211]:41938 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgLGNyT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Dec 2020 08:54:19 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id C0D6467373; Mon,  7 Dec 2020 14:53:36 +0100 (CET)
Date:   Mon, 7 Dec 2020 14:53:36 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 4/6] xfs: move xfs_dialloc_roll() into xfs_dialloc()
Message-ID: <20201207135336.GE29249@lst.de>
References: <20201207001533.2702719-1-hsiangkao@redhat.com> <20201207001533.2702719-5-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207001533.2702719-5-hsiangkao@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  
>  		if (ialloced) {
>  			/*
> +			 * We successfully allocated some inodes, roll the
> +			 * transaction so they can allocate one of the free
> +			 * inodes we just prepared for them.

Maybe:

			/*
			 * We successfully allocated space for an inode cluster
			 * in this AG.  Roll the transaction so that we can
			 * allocate one of the new inodes.
			 */

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
