Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC44178598
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2020 23:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCCW0O (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 Mar 2020 17:26:14 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45883 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726747AbgCCW0O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 17:26:14 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 26A5F7E9764;
        Wed,  4 Mar 2020 09:26:11 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9FzO-0004Qv-DR; Wed, 04 Mar 2020 09:26:10 +1100
Date:   Wed, 4 Mar 2020 09:26:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: mark dir corrupt when lookup-by-hash fails
Message-ID: <20200303222610.GV10776@dread.disaster.area>
References: <158294094367.1730101.10848559171120744339.stgit@magnolia>
 <158294094977.1730101.1658645036964056566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158294094977.1730101.1658645036964056566.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=bHL_zCj-We9uzkdPxowA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 28, 2020 at 05:49:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xchk_dir_actor, we attempt to validate the directory hash structures
> by performing a directory entry lookup by (hashed) name.  If the lookup
> returns ENOENT, that means that the hash information is corrupt.  The
> _process_error functions don't catch this, so we have to add that
> explicitly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/dir.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 266da4e4bde6..54afa75c95d1 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -155,6 +155,11 @@ xchk_dir_actor(
>  	xname.type = XFS_DIR3_FT_UNKNOWN;
>  
>  	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
> +	if (error == -ENOENT) {
> +		/* ENOENT means the hash lookup failed and the dir is corrupt */
> +		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> +		return -EFSCORRUPTED;
> +	}
>  	if (!xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
>  			&error))
>  		goto out;

So why is this error handling open coded rather than doing something
like this to use the generic, pre-existing corruption handling:

	if (error == -ENOENT) {
		/* ENOENT means the hash lookup failed and the dir is corrupt */
		error = -EFSCORRUPTED;
	}
	if (!xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
			&error))
		goto out;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
