Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260D92D12B4
	for <lists+linux-xfs@lfdr.de>; Mon,  7 Dec 2020 14:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgLGN5Z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 7 Dec 2020 08:57:25 -0500
Received: from verein.lst.de ([213.95.11.211]:41950 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgLGN5Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Dec 2020 08:57:24 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6364267373; Mon,  7 Dec 2020 14:56:42 +0100 (CET)
Date:   Mon, 7 Dec 2020 14:56:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 5/6] xfs: spilt xfs_dialloc() into 2 functions
Message-ID: <20201207135642.GF29249@lst.de>
References: <20201207001533.2702719-1-hsiangkao@redhat.com> <20201207001533.2702719-6-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207001533.2702719-6-hsiangkao@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  		if (pag->pagi_freecount) {
>  			xfs_perag_put(pag);
> +			*IO_agbp = agbp;
> +			return 0;

I think assigning *IO_agbp would benefit from a little consolidation.
Set it to NULL in the normal unsuccessful return, and add a found_ag
label that assigns agbp and returns 0.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
