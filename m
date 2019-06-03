Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F3132FAF
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2019 14:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfFCMcU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 08:32:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfFCMcU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Jun 2019 08:32:20 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2ACE62F8BDB;
        Mon,  3 Jun 2019 12:32:20 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C81A95B685;
        Mon,  3 Jun 2019 12:32:18 +0000 (UTC)
Date:   Mon, 3 Jun 2019 08:32:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: inode btree scrubber should calculate im_boffset
 correctly
Message-ID: <20190603123216.GA38223@bfoster>
References: <20190529002545.GB5231@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529002545.GB5231@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 03 Jun 2019 12:32:20 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 28, 2019 at 05:25:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The im_boffset field is in units of bytes, whereas XFS_INO_OFFSET
> returns a value in units of inodes.  Convert the units so that scrub on
> a 64k-block filesystem works correctly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/ialloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 693eb51f5efb..9b47117180cb 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -252,7 +252,8 @@ xchk_iallocbt_check_cluster(
>  	ir_holemask = (irec->ir_holemask & cluster_mask);
>  	imap.im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
>  	imap.im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
> -	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino);
> +	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino) <<
> +			mp->m_sb.sb_inodelog;
>  
>  	if (imap.im_boffset != 0 && cluster_base != 0) {
>  		ASSERT(imap.im_boffset == 0 || cluster_base == 0);
