Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139154AB15
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 21:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbfFRTlx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 15:41:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58642 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfFRTlx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 15:41:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IJcU64166816;
        Tue, 18 Jun 2019 19:41:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=8XBzPuXRjaVHnCB7+UCAOPA/ZJd+DK2fslXkugF9qRo=;
 b=saicZfyaG83e5FUOh+CxXGu2ESZM/Q3SWYp/niaPwDEwiMHCuxjbHVVyutB3PlCvj7zM
 nr5dEZPu8I5wiPRs7+anM9CEJMI5wQ4sMsueO976XKjqEq5evvN0rGhmMAD+ogCIkKNL
 asOFgYhc6q6I4ox7CqFJoEh8w7YXsulYg1SuX5IYm91GN3nHlOSmiWZLafWLAYTIx5XX
 3+7oKonWWGhfWWWHlUaLzFjDLAs9XRti/Afwg9u2em9tuch4SFy1OBwtnZbRgpoMX3Z9
 lWatCuCN3cye97XUhK/WmjucwWgh68MZRZIcyi8dt9ZaPkSMFGrBbdxYbiKB5l0Ktx39 ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t4r3tphgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 19:41:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IJfaBe079551;
        Tue, 18 Jun 2019 19:41:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t59ge1jnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 19:41:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IJfnLr023944;
        Tue, 18 Jun 2019 19:41:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 12:41:49 -0700
Date:   Tue, 18 Jun 2019 12:41:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] libxfs: break out FSCOUNTS manpage
Message-ID: <20190618194148.GM5387@magnolia>
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993577871.2343530.12457677945958502175.stgit@magnolia>
 <ed87e06d-b762-b6f8-d566-a49faee63b47@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed87e06d-b762-b6f8-d566-a49faee63b47@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180155
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 17, 2019 at 12:12:42PM -0500, Eric Sandeen wrote:
> On 6/7/19 2:29 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a separate manual page for the FSCOUNTS ioctl so we can document
> > how it works.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man2/ioctl_xfs_fscounts.2 |   67 +++++++++++++++++++++++++++++++++++++++++
> >  man/man3/xfsctl.3             |   14 +++++----
> >  2 files changed, 75 insertions(+), 6 deletions(-)
> >  create mode 100644 man/man2/ioctl_xfs_fscounts.2
> > 
> > 
> > diff --git a/man/man2/ioctl_xfs_fscounts.2 b/man/man2/ioctl_xfs_fscounts.2
> > new file mode 100644
> > index 00000000..44b214a1
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_fscounts.2
> > @@ -0,0 +1,67 @@
> > +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> > +.\"
> > +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> > +.\" SPDX-License-Identifier: GPL-2.0+
> > +.\" %%%LICENSE_END
> > +.TH IOCTL-XFS-FSCOUNTS 2 2019-04-16 "XFS"
> > +.SH NAME
> > +ioctl_xfs_fscounts \- query XFS summary counter information
> > +.SH SYNOPSIS
> > +.br
> > +.B #include <xfs/xfs_fs.h>
> > +.PP
> > +.BI "int ioctl(int " fd ", XFS_IOC_FSCOUNTS, struct xfs_fsop_counts *" arg );
> > +.SH DESCRIPTION
> > +Query the raw filesystem summary counters.
> > +Unlike
> > +.BR statvfs (3),
> > +the values returned here are the raw values, which do not reflect any
> > +alterations or limits set by quotas.
> 
> it's altered by /project/ quotas specifically, right?  Should that be
> made clear?  Or is it more than just project?

It's only project quotas; will clarify.

> 
> > +The counter information is conveyed in a structure of the following form:
> > +.PP
> > +.in +4n
> > +.nf
> > +struct xfs_fscounts {
> 
> xfs_fsop_counts?
> 
> (this is the second time there's a misnamed structure (I think?)
> so I feel like double checking them all is in order unless i'm
> missing something?)

Massive thinko on my part, I guess?

> > +	__u64   freedata;
> > +	__u64   freertx;
> > +	__u64   freeino;
> > +	__u64   allocino;
> > +};
> > +.fi
> > +.in
> > +.PP
> > +.I freedata
> > +is the number of free filesystem blocks on the data device.
> > +.PP
> > +.I freertx
> > +is the number of free xtents on the realtime device.
> 
> extents

Fixed.

--D

> > +.PP
> > +.I freeino
> > +is the number of inode records that are not in use within the space that has
> > +been allocated for them.
> > +.PP
> > +.I allocino
> > +is the number of inode records for which space has been allocated.
> > +.SH RETURN VALUE
> > +On error, \-1 is returned, and
> > +.I errno
> > +is set to indicate the error.
> > +.PP
> > +.SH ERRORS
> > +Error codes can be one of, but are not limited to, the following:
> > +.TP
> > +.B EFSBADCRC
> > +Metadata checksum validation failed while performing the query.
> > +.TP
> > +.B EFSCORRUPTED
> > +Metadata corruption was encountered while performing the query.
> > +.TP
> > +.B EINVAL
> > +The specified allocation group number is not valid for this filesystem.
> > +.TP
> > +.B EIO
> > +An I/O error was encountered while performing the query.
> > +.SH CONFORMING TO
> > +This API is specific to XFS filesystem on the Linux kernel.
> > +.SH SEE ALSO
> > +.BR ioctl (2)
> > diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> > index 148119a9..007f7d58 100644
> > --- a/man/man3/xfsctl.3
> > +++ b/man/man3/xfsctl.3
> > @@ -390,6 +390,12 @@ See
> >  .BR ioctl_xfs_scrub_metadata (2)
> >  for more information.
> >  
> > +.TP
> > +.B XFS_IOC_FSCOUNTS
> > +See
> > +.BR ioctl_xfs_fscounts (2)
> > +for more information.
> > +
> >  .PP
> >  .nf
> >  .B XFS_IOC_THAW
> > @@ -398,16 +404,11 @@ for more information.
> >  .B XFS_IOC_SET_RESBLKS
> >  .B XFS_IOC_FSGROWFSDATA
> >  .B XFS_IOC_FSGROWFSLOG
> > -.B XFS_IOC_FSGROWFSRT
> >  .fi
> >  .TP
> > -.B XFS_IOC_FSCOUNTS
> > +.B XFS_IOC_FSGROWFSRT
> >  These interfaces are used to implement various filesystem internal
> >  operations on XFS filesystems.
> > -For
> > -.B XFS_FS_COUNTS
> > -(get filesystem dynamic global information), the output structure is of type
> > -.BR xfs_fsop_counts_t .
> >  The remainder of these operations will not be described further
> >  as they are not of general use to applications.
> >  
> > @@ -416,6 +417,7 @@ as they are not of general use to applications.
> >  .BR ioctl_xfs_fsop_geometry (2),
> >  .BR ioctl_xfs_fsbulkstat (2),
> >  .BR ioctl_xfs_fsinumbers (2),
> > +.BR ioctl_xfs_fscounts (2),
> >  .BR fstatfs (2),
> >  .BR statfs (2),
> >  .BR xfs (5),
> > 
