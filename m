Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC88BB346
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Sep 2019 14:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbfIWMEQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 23 Sep 2019 08:04:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43688 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729725AbfIWMEQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Sep 2019 08:04:16 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 69E08315C001;
        Mon, 23 Sep 2019 12:04:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 104891001B00;
        Mon, 23 Sep 2019 12:04:15 +0000 (UTC)
Date:   Mon, 23 Sep 2019 08:04:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 08/19] xfs: Factor up commit from
 xfs_attr_try_sf_addname
Message-ID: <20190923120414.GA6924@bfoster>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-9-allison.henderson@oracle.com>
 <20190920135037.GF40150@bfoster>
 <1336049c-33fb-ee2d-53e6-28f27a576e82@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336049c-33fb-ee2d-53e6-28f27a576e82@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 23 Sep 2019 12:04:16 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 20, 2019 at 06:25:04PM -0700, Allison Collins wrote:
> 
> 
> On 9/20/19 6:50 AM, Brian Foster wrote:
> > On Thu, Sep 05, 2019 at 03:18:26PM -0700, Allison Collins wrote:
> > > New delayed attribute routines cannot handle transactions,
> > > so factor this up to the calling function.
> > > 
> > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_attr.c | 15 ++++++++-------
> > >   1 file changed, 8 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index f27e2c6..318c543 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -227,7 +227,7 @@ xfs_attr_try_sf_addname(
> > >   {
> > >   	struct xfs_mount	*mp = dp->i_mount;
> > > -	int			error, error2;
> > > +	int			error;
> > >   	error = xfs_attr_shortform_addname(args);
> > >   	if (error == -ENOSPC)
> > > @@ -243,9 +243,7 @@ xfs_attr_try_sf_addname(
> > >   	if (mp->m_flags & XFS_MOUNT_WSYNC)
> > >   		xfs_trans_set_sync(args->trans);
> > 
> > Perhaps the above check should stay along with the tx commit code..?
> That makes sense, I will move it upwards
> > 
> > > -	error2 = xfs_trans_commit(args->trans);
> > > -	args->trans = NULL;
> > > -	return error ? error : error2;
> > > +	return error;
> > >   }
> > >   /*
> > > @@ -257,7 +255,7 @@ xfs_attr_set_args(
> > >   {
> > >   	struct xfs_inode	*dp = args->dp;
> > >   	struct xfs_buf          *leaf_bp = NULL;
> > > -	int			error;
> > > +	int			error, error2 = 0;;
> > >   	/*
> > >   	 * If the attribute list is non-existent or a shortform list,
> > > @@ -277,8 +275,11 @@ xfs_attr_set_args(
> > >   		 * Try to add the attr to the attribute list in the inode.
> > >   		 */
> > >   		error = xfs_attr_try_sf_addname(dp, args);
> > > -		if (error != -ENOSPC)
> > > -			return error;
> > > +		if (!error) {
> > > +			error2 = xfs_trans_commit(args->trans);
> > > +			args->trans = NULL;
> > > +			return error ? error : error2;
> > 
> > We've already checked that error == 0 here, so this can be simplified.
> > Hmm.. that said, the original code looks like it commits the transaction
> > on error != -ENOSPC, which means this slightly changes behavior when
> > (error && error != -ENOSPC) is true. So perhaps it is the error check
> > that should be fixed up and not the error2 logic..
> 
> Yes, I believe this got some attention in the last review.  While it is
> different logic now, I think we reasoned that committing on say -EIO or some
> other such unexpected error didn't make much sense either, so we cleaned it
> up a bit.  Though you're probably right about the simplification now with
> the change.  Is there a reason we would want to commit in the case of
> unexpected errors?
> 

I'm not 100% sure tbh. There is a comment that acknowledges unrelated
errors so it might be intentional, at least for some errors. I'd at
least suggest to preserve the existing logic in the refactoring patch
and if you think there's a bug, perhaps tack on a separate patch later
for independent review. That way if we find we broke something down the
line, it's easier to identify and test the logic change separately from
the broader rework.

Brian

> Allison
> 
> > 
> > Brian
> > 
> > > +		}
> > >   		/*
> > >   		 * It won't fit in the shortform, transform to a leaf block.
> > > -- 
> > > 2.7.4
> > > 
