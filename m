Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12EF248ABA
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Aug 2020 17:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHRPz5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Aug 2020 11:55:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39270 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbgHRPzw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 11:55:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFlQYW138242;
        Tue, 18 Aug 2020 15:55:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=vAk29E/TyHSwTIx8GNcJFZjiYN7M6zKVEywyCzG+8vY=;
 b=Mhjt/AKZuOTIvlmnTCPvq02nQqBN+zdpN4OeYiggiSUOwhGorw21kLvxoT0zu2qMAuws
 LRfy05YfVLYFVRXMzfnmQc9Uz1gaZYU9kgekoPigYuE64u8SHnV0TRdv7q5hl8jkX1sj
 CdIgagN+9T4TNSNWw29Jh5KM9bFTNu6UgF4T5tABxNan2tCpAFwIkI3w5fzUl3KpavMo
 Ut1z/ojJPCKVBt9DNAZODF13gUfjOiCVTRawsYTiqjTNrtUiF0CDOkVBwO3sxaWG4WDT
 B7TkTwJhPWtSX/KzuV9CNY2cEgqL6iwd/piOLBRLCvnwEiJIeBXPlVvHPhN/j0ypnmaK qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32x7nmdqs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 15:55:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFmvRm179845;
        Tue, 18 Aug 2020 15:53:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32xsmxd8p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 15:53:48 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IFrkmd015481;
        Tue, 18 Aug 2020 15:53:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 08:53:46 -0700
Date:   Tue, 18 Aug 2020 08:53:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200818155345.GV6096@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770505894.3956827.5973810026298120596.stgit@magnolia>
 <CAOQ4uxj=K5TCTZoKxd9G4F0cTRYeE73-6iQgmp+3pR3QJKYdvg@mail.gmail.com>
 <CAOQ4uxgiVdzVNo00-mzDjRn4x3+40dXWGx78n-KucrOBxMcREA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgiVdzVNo00-mzDjRn4x3+40dXWGx78n-KucrOBxMcREA@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 03:53:57PM +0300, Amir Goldstein wrote:
> On Tue, Aug 18, 2020 at 3:00 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Aug 18, 2020 at 1:57 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
> > > nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
> > > time epoch).  This enables us to handle dates up to 2486, which solves
> > > the y2038 problem.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > ...
> >
> > > diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> > > index 9f036053fdb7..b354825f4e51 100644
> > > --- a/fs/xfs/scrub/inode.c
> > > +++ b/fs/xfs/scrub/inode.c
> > > @@ -190,6 +190,11 @@ xchk_inode_flags2(
> > >         if ((flags2 & XFS_DIFLAG2_DAX) && (flags2 & XFS_DIFLAG2_REFLINK))
> > >                 goto bad;
> > >
> > > +       /* the incore bigtime iflag always follows the feature flag */
> > > +       if (!!xfs_sb_version_hasbigtime(&mp->m_sb) ^
> > > +           !!(flags2 & XFS_DIFLAG2_BIGTIME))
> > > +               goto bad;
> > > +
> >
> > Seems like flags2 are not the incore iflags and that the dinode iflags
> > can very well
> > have no bigtime on fs with bigtime support:
> >
> > xchk_dinode(...
> > ...
> >                 flags2 = be64_to_cpu(dip->di_flags2);
> >
> > What am I missing?
> >
> 
> Another question. Do we need to worry about xfs_reinit_inode()?
> It seems not because incore inode should already have the correct bigtime
> flag. Right?

I sure hope so.  Any inode being fed to xfs_reinit_inode was fully read
into memory, then we tore down the VFS inode, but before we tore down
the XFS inode, someone wanted it back, so all we have to do is reset
the VFS part of the incore state.

Therefore, we don't have to do anything about the XFS part of the incore
state. :)

> But by same logic, xfs_ifree() should already have the correct
> bigtime flag as well, so we don't need to set the flag, maybe assert the flag?

Right.  I think that piece can go since we set the incore flag
opportunistically now.

--D

> 
> Thanks,
> Amir.
