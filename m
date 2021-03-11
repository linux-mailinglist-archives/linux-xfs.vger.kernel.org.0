Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCABB336A45
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Mar 2021 03:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhCKCy6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Mar 2021 21:54:58 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:55250 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhCKCy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 21:54:28 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 5DCED1AE924;
        Thu, 11 Mar 2021 13:54:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKBSz-0017mZ-Iy; Thu, 11 Mar 2021 13:54:25 +1100
Date:   Thu, 11 Mar 2021 13:54:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/45] xfs: embed the xlog_op_header in the unmount record
Message-ID: <20210311025425.GJ74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-22-david@fromorbit.com>
 <20210309001523.GH3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309001523.GH3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=dUU8WNNNTr0vn8zOWOcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 04:15:23PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:19PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Remove another case where xlog_write() has to prepend an opheader to
> > a log transaction. The unmount record + ophdr is smaller than the
> > minimum amount of space guaranteed to be free in an iclog (2 *
> > sizeof(ophdr)) and so we don't have to care about an unmount record
> > being split across 2 iclogs.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_log.c | 35 ++++++++++++++++++++++++-----------
> >  1 file changed, 24 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index b2f9fb1b4fed..94711b9ff007 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -798,12 +798,22 @@ xlog_write_unmount_record(
> >  	struct xlog		*log,
> >  	struct xlog_ticket	*ticket)
> >  {
> > -	struct xfs_unmount_log_format ulf = {
> > -		.magic = XLOG_UNMOUNT_TYPE,
> > +	struct  {
> > +		struct xlog_op_header ophdr;
> > +		struct xfs_unmount_log_format ulf;
> > +	} unmount_rec = {
> 
> I wonder, should we have a BUILD_BUG_ON to confirm sizeof(umount_rec)
> just in case some weird architecture injects padding between these two?
> Prior to this code we formatted the op header and unmount record in
> separate incore buffers and wrote them to disk with no gap, right?

Yup. Easy enough to add.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
