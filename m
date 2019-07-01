Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEE44AB13
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbfFRTk5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 15:40:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42332 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfFRTk5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 15:40:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IJcwP3080269;
        Tue, 18 Jun 2019 19:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=aw8idkCu+AD9+Zr/qdoehvZdbsG0R32qvA+Lewkss4U=;
 b=xGhH684cvLmCaAVR4UkekyQ5kflijHt+wfNX1UoecUKjWzQonA9uO5UrGZ3HERdUxEv3
 /IKqViSGkiyIvS3cv62QDUtbFvYw0VHhosk2VurXFe/bEw2Tu2YTmv/+C1Tesn60qW8U
 iY4jDxNdA6iHtZVT+GJh0zyAfuLh3U07Kfg3tv90lP0lDNyVod4RjzHWUwUKy9Zuvyx4
 l6VDkM1ZrbEiCoTTWos6A3ITqB3Ht9dfABUr/m3WAFzWzEQePAFYSf6ls0jIXc6UGRl/
 96MzwZoPFVF2S/ESV0ve/zqjOLTYiBlAnN0ReXSxetVGxOZRFsKYvBhBiqLorkbC6DI5 ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t4rmp6ffx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 19:40:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IJbZBx071629;
        Tue, 18 Jun 2019 19:38:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t59ge1hjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 19:38:53 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IJcqSO009147;
        Tue, 18 Jun 2019 19:38:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 12:38:51 -0700
Date:   Tue, 18 Jun 2019 12:38:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] libxfs: break out the INUMBERS manpage
Message-ID: <20190618193850.GL5387@magnolia>
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993577237.2343530.1326868231083603392.stgit@magnolia>
 <a77f0dd8-0087-5e47-a298-e9c6221e281f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a77f0dd8-0087-5e47-a298-e9c6221e281f@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180155
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 17, 2019 at 11:34:00AM -0500, Eric Sandeen wrote:
> 
> 
> On 6/7/19 2:29 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a separate manual page for the INUMBERS ioctl so we can document
> > how it works.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man2/ioctl_xfs_fsinumbers.2 |  115 +++++++++++++++++++++++++++++++++++++++
> >  man/man3/xfsctl.3               |   34 +-----------
> >  2 files changed, 119 insertions(+), 30 deletions(-)
> >  create mode 100644 man/man2/ioctl_xfs_fsinumbers.2
> > 
> > 
> > diff --git a/man/man2/ioctl_xfs_fsinumbers.2 b/man/man2/ioctl_xfs_fsinumbers.2
> > new file mode 100644
> > index 00000000..86cdf4d9
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_fsinumbers.2
> > @@ -0,0 +1,115 @@
> > +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> > +.\"
> > +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> > +.\" SPDX-License-Identifier: GPL-2.0+
> > +.\" %%%LICENSE_END
> > +.TH IOCTL-XFS-FSINUMBERS 2 2019-04-16 "XFS"
> > +.SH NAME
> > +ioctl_xfs_fsinumbers \- extract a list of valid inode numbers from an XFS filesystem
> > +.SH SYNOPSIS
> > +.br
> > +.B #include <xfs/xfs_fs.h>
> > +.PP
> > +.BI "int ioctl(int " fd ", XFS_IOC_FSINUMBERS, struct xfs_fsop_bulkreq *" arg );
> > +.SH DESCRIPTION
> > +Query a list of valid inode numbers from an XFS filesystem.
> > +It is intended to be called iteratively to obtain the entire set of inodes.
> > +These ioctls use
> > +.B struct xfs_fsop_bulkreq
> > +to set up a bulk transfer with the kernel:
> > +.PP
> > +.in +4n
> > +.nf
> > +struct xfs_fsop_bulkreq {
> > +	__u64   *lastip;
> > +	__s32   count;
> > +	void    *ubuffer;
> > +	__s32   *ocount;
> > +};
> > +.fi
> > +.in
> > +.PP
> > +.I lastip
> > +points to a value that will receive the number of the "last inode".
> > +This should be set to one less than the number of the first inode for which the
> > +caller wants information, or zero to start with the first inode in the
> > +filesystem.
> > +After the call, this value will be set to the number of the last inode for
> > +which information is supplied.
> > +This field will not be updated if
> > +.I ocount
> > +is NULL.
> > +.PP
> > +.I count
> > +is the number of inodes to examine.
> 
> again should it have something like "corresponding to the number
> of array elements passed in in the ubuffer array?"

Fixed.

> > +.PP
> > +.I ocount
> > +points to a value that will receive the number of records returned.
> > +An output value of zero means that there are no more inodes left to enumerate.
> > +If this value is NULL, then neither
> > +.I ocount
> > +nor
> > +.I lastip
> > +will be updated.
> > +.PP
> > +.I ubuffer
> > +points to a memory buffer where information will be copied.
> > +This buffer must be an array of
> > +.B struct xfs_inogrp
> > +which is described below.
> > +The array must have at least
> > +.I count
> > +elements.
> > +.PP
> > +.in +4n
> > +.nf
> > +struct xfs_inogrp {
> > +	__u64   xi_startino;
> > +	__s32   xi_alloccount;
> > +	__u64   xi_allocmask;
> > +}
> > +.fi
> > +.in
> > +.PP
> > +.I xi_startino
> > +is the number of this inode numbers record.
> 
> this phrasing confuses me.
> 
> xi_startino is the first inode number in this inode... group?

Yes, will chnage it to that.

> > +Each inode numbers record will correspond roughly to a record in the inode
> > +btree, though this is not guaranteed.
> 
> I don't think that is useful information.

Ok.

> > +.PP
> > +.I xi_alloccount
> > +is the number of bits that are set in
> > +.IR xi_allocmask .
> 
> i.e. the number of inodes in use in this group?

Yes.  I'll add a second sentence stating this.

> > +.PP
> > +.I xi_allocmask
> > +is the mask of inodes that are in use for this inode.
> 
> inodes that are in use for this inode?  wut.

Yeah, is dumb.

"is a bitmask of inodes that are allocated in this inode group."

> > +The bitmask is 64 bits long, and the least significant bit corresponds to inode
> > +.BR xi_startino .
> 
> ok so finally we get to what I consider to be the useful thing that ties it
> all together ;)
> 
> so maybe best to just say that it returns inode usage information for a group of
> 64 consecutive inode numbers, starting with inode xi_startino, with a bitmask of
> in-use inodes in xi_allocmask, with total in-use inodes for this batch/group/set
> shown in xi_alloccount?

Yep.  I'll try to clarify this more in the manpage.

--D

> 
> > +.SH RETURN VALUE
> > +On error, \-1 is returned, and
> > +.I errno
> > +is set to indicate the error.
> > +.PP
> > +.SH ERRORS
> > +Error codes can be one of, but are not limited to, the following:
> > +.TP
> > +.B EFAULT
> > +The kernel was not able to copy into the userspace buffer.
> > +.TP
> > +.B EFSBADCRC
> > +Metadata checksum validation failed while performing the query.
> > +.TP
> > +.B EFSCORRUPTED
> > +Metadata corruption was encountered while performing the query.
> > +.TP
> > +.B EINVAL
> > +One of the arguments was not valid.
> > +.TP
> > +.B EIO
> > +An I/O error was encountered while performing the query.
> > +.TP
> > +.B ENOMEM
> > +There was insufficient memory to perform the query.
> > +.SH CONFORMING TO
> > +This API is specific to XFS filesystem on the Linux kernel.
> > +.SH SEE ALSO
> > +.BR ioctl (2)
> > diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> > index cdf0fcfc..148119a9 100644
> > --- a/man/man3/xfsctl.3
> > +++ b/man/man3/xfsctl.3
> > @@ -368,36 +368,9 @@ can be any open file in the XFS filesystem in question.
> >  .PP
> >  .TP
> >  .B XFS_IOC_FSINUMBERS
> > -This interface is used to extract a list of valid inode numbers from an
> > -XFS filesystem.
> > -It is intended to be called iteratively, to obtain the entire set of inodes.
> > -The information is passed in and out via a structure of type
> > -.B xfs_fsop_bulkreq_t
> > -pointed to by the final argument.
> > -.B lastip
> > -is a pointer to a variable containing the last inode number returned,
> > -initially it should be zero.
> > -.B icount
> > -is the size of the array of structures specified by
> > -.BR ubuffer .
> > -.B ubuffer
> > -is the address of an array of structures, of type
> > -.BR xfs_inogrp_t .
> > -This structure has the following elements:
> > -.B xi_startino
> > -(starting inode number),
> > -.B xi_alloccount
> > -(count of bits set in xi_allocmask), and
> > -.B xi_allocmask
> > -(mask of allocated inodes in this group).
> > -The bitmask is 64 bits long, and the least significant bit corresponds to inode
> > -.B xi_startino.
> > -Each bit is set if the corresponding inode is in use.
> > -.B ocount
> > -is a pointer to a count of returned values, filled in by the call.
> > -An output
> > -.B ocount
> > -value of zero means that the inode table has been exhausted.
> > +See
> > +.BR ioctl_xfs_fsinumbers (2)
> > +for more information.
> >  
> >  .TP
> >  .B XFS_IOC_FSGEOMETRY
> > @@ -442,6 +415,7 @@ as they are not of general use to applications.
> >  .BR ioctl_xfs_fsgetxattr (2),
> >  .BR ioctl_xfs_fsop_geometry (2),
> >  .BR ioctl_xfs_fsbulkstat (2),
> > +.BR ioctl_xfs_fsinumbers (2),
> >  .BR fstatfs (2),
> >  .BR statfs (2),
> >  .BR xfs (5),
> > 
