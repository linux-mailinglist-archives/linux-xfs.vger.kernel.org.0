Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FECBA611F
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Sep 2019 08:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfICGPC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 Sep 2019 02:15:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52244 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfICGPC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Sep 2019 02:15:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NVibb4QhR/IS/0LLvBWYWaLt+UDUTXbRwVdItDc8cK8=; b=CI2pEn4OjG+2zojvAO46bnfU9
        HXD4PsJsTsVtpdOY2hqdK2OIZMawLjC2yaKm8v+4fe+H73iA7J50SBftEF27i/8Pmw9/oKBA7golW
        iLgHcjIOvHA98isTvDR28x+7W6TOurC7RtrbG9sjFJofnAQuIE/h4I9Fc5MKELejstcFweiy/HyEG
        2o6Sh50/jV3w7hMxUjlwwbQ8XyHZOxnEr9cPsBbz4kG0HBy0/iRtQyYt5UdhQnG3M2PXt1yGdv/Og
        vvnCc/IEpIpX8JriqiqW+8BUGpknO+vqXNhaSuqqt7UYp7n1mmJLKrG849gWBHvOmkjbWDMtBTgsw
        TTBykVE5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i525j-0007CH-6B; Tue, 03 Sep 2019 06:14:59 +0000
Date:   Mon, 2 Sep 2019 23:14:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] libxfs: revert FSGEOMETRY v5 -> v4 hack
Message-ID: <20190903061459.GA26583@infradead.org>
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
 <156713882716.386621.4791011879331220967.stgit@magnolia>
 <20190902224952.GU1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902224952.GU1119@dread.disaster.area>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 08:49:52AM +1000, Dave Chinner wrote:
> On Thu, Aug 29, 2019 at 09:20:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Revert the #define redirection of XFS_IOC_FSGEOMETRY to the old V4
> > ioctl.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libxfs/xfs_fs.h |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > 
> > diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> > index 67fceffc..31ac6323 100644
> > --- a/libxfs/xfs_fs.h
> > +++ b/libxfs/xfs_fs.h
> > @@ -822,9 +822,7 @@ struct xfs_scrub_metadata {
> >  #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
> >  #define XFS_IOC_FSGEOMETRY_V4	     _IOR ('X', 124, struct xfs_fsop_geom_v4)
> >  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
> > -/* For compatibility, for now */
> > -/* #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom_v5) */
> > -#define XFS_IOC_FSGEOMETRY XFS_IOC_FSGEOMETRY_V4
> > +#define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
> >  #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
> >  #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
> 
> Looks fine, but can we change the order of this patch in the series
> until after all the geometry callers have been converted to use the
> common function with fallback from v5 to v4 calls?
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

I don't really remember this history here, but can we please avoid
using XFS_IOC_FSGEOMETRY for what I assume is the v4 structure, and just
version all of them instead?
