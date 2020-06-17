Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6FD1FCD11
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Jun 2020 14:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgFQMJ2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 17 Jun 2020 08:09:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57577 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725894AbgFQMJ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jun 2020 08:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592395766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wMDOVEHrXH8NHVBdCYfKSilh2GMbuCHQM6qU1vPDNmw=;
        b=QiRJXgs9g6e77IlilEyXEx9CSfNKIOoctORpxrH+lNcxGcqvgqqOafs6ZW4/xr4rKIDDwT
        6LR7iyntpAaLzG49OB2KbSvo6UJNhsz5I9nzYmURpr4qnDpJDXtmMJsWP8wH/M3HDxHl36
        0aDgwIxqarHrTSNyfAj2n19YNwoLOAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-X_eQFixiNhWn4ea_Dzus-g-1; Wed, 17 Jun 2020 08:09:24 -0400
X-MC-Unique: X_eQFixiNhWn4ea_Dzus-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21D6B107AD92;
        Wed, 17 Jun 2020 12:09:23 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94436100238D;
        Wed, 17 Jun 2020 12:09:22 +0000 (UTC)
Date:   Wed, 17 Jun 2020 08:09:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs_repair: drop lostblocks from build_agf_agfl
Message-ID: <20200617120920.GA27169@bfoster>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107201957.315004.49440739053731951.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159107201957.315004.49440739053731951.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 09:26:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We don't do anything with this parameter, so get rid of it.
> 
> Fixes: ef4332b8 ("xfs_repair: add freesp btree block overflow to the free space")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/phase5.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 677297fe..c9b278bd 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -2049,7 +2049,6 @@ build_agf_agfl(
>  	struct bt_status	*bno_bt,
>  	struct bt_status	*bcnt_bt,
>  	xfs_extlen_t		freeblks,	/* # free blocks in tree */
> -	int			lostblocks,	/* # blocks that will be lost */
>  	struct bt_status	*rmap_bt,
>  	struct bt_status	*refcnt_bt,
>  	struct xfs_slab		*lost_fsb)
> @@ -2465,9 +2464,9 @@ phase5_func(
>  		/*
>  		 * set up agf and agfl
>  		 */
> -		build_agf_agfl(mp, agno, &bno_btree_curs,
> -				&bcnt_btree_curs, freeblks1, extra_blocks,
> -				&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
> +		build_agf_agfl(mp, agno, &bno_btree_curs, &bcnt_btree_curs,
> +				freeblks1, &rmap_btree_curs,
> +				&refcnt_btree_curs, lost_fsb);
>  		/*
>  		 * build inode allocation tree.
>  		 */
> 

