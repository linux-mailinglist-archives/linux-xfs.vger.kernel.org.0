Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7DFC18103E
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Mar 2020 06:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgCKFxU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Mar 2020 01:53:20 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52517 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726160AbgCKFxT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 01:53:19 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C7FAF7E8C46;
        Wed, 11 Mar 2020 16:53:16 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jBuIt-0007Ge-LY; Wed, 11 Mar 2020 16:53:15 +1100
Date:   Wed, 11 Mar 2020 16:53:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: mark extended attr corrupt when lookup-by-hash
 fails
Message-ID: <20200311055315.GC10776@dread.disaster.area>
References: <158388768123.939608.12366470947594416375.stgit@magnolia>
 <158388769356.939608.4585090255151116523.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158388769356.939608.4585090255151116523.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=Ria4c-EfzzQC7pQNOCMA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 10, 2020 at 05:48:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xchk_xattr_listent, we attempt to validate the extended attribute
> hash structures by performing a attr lookup by (hashed) name.  If the
> lookup returns ENODATA, that means that the hash information is corrupt.
> The _process_error functions don't catch this, so we have to add that
> explicitly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/attr.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index d9f0dd444b80..941c09bafb35 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -163,6 +163,9 @@ xchk_xattr_listent(
>  	args.valuelen = valuelen;
>  
>  	error = xfs_attr_get_ilocked(context->dp, &args);
> +	/* ENODATA means the hash lookup failed and the attr is bad */
> +	if (error == -ENODATA)
> +		error = -EFSCORRUPTED;
>  	if (!xchk_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
>  			&error))
>  		goto fail_xref;

Much nicer than the previous iteration :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
