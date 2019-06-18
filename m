Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6BDD4AB22
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 21:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbfFRToq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 15:44:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37204 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730494AbfFRToq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 15:44:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IJcPP4177702;
        Tue, 18 Jun 2019 19:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=VCdVhyhC5jKU2zHcv64JeKeWR6NSPURrUaJahMUnnc0=;
 b=u8KFcBf0gdMWqDGuvrSJfT24WWUjcbYsOQcidqP/C+2oheOxtJNyffMDhDOP9vIUxrrs
 gaO3K3qGU26hNJ0880/xnVyS7kvgjmhqusfOKXSjJ4jIbXDK9iyTrePmHwLmjrUDw9p3
 0rXl6aNrBjp5QTdeSwdaovrsTp+I5QvkdYyv8LvapApXcZGUBtuyt0W2swFMVA2Z5z6n
 6YngagEjTcQFb34qjbBGw+yNsZW8Kw/spkfhGBYvW9Tlju8BUIN4t5d/iV0fxnBfV9UJ
 lxJUKx5kG8aJjeVt81S4q1qQ80TWCbeeoRuIPgfQmSgUcVn46AMAtX3zbycldTplW6cO KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t4saqeeyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 19:44:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IJhC0Q014253;
        Tue, 18 Jun 2019 19:44:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2t5cpe8pb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 19:44:43 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IJifY6025495;
        Tue, 18 Jun 2019 19:44:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 12:44:41 -0700
Date:   Tue, 18 Jun 2019 12:44:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] libxfs: break out the RESBLKS manpage
Message-ID: <20190618194440.GN5387@magnolia>
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993578504.2343530.9106560408928916864.stgit@magnolia>
 <8e9a0911-94b0-e18f-c7c3-1c2728443875@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e9a0911-94b0-e18f-c7c3-1c2728443875@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180155
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

On Mon, Jun 17, 2019 at 12:15:40PM -0500, Eric Sandeen wrote:
> On 6/7/19 2:29 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a separate manual page for the RESBLKS ioctls so we can document
> > how they work.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man2/ioctl_xfs_getresblks.2 |   65 +++++++++++++++++++++++++++++++++++++++
> >  man/man3/xfsctl.3               |   14 +++++++-
> >  2 files changed, 77 insertions(+), 2 deletions(-)
> >  create mode 100644 man/man2/ioctl_xfs_getresblks.2
> > 
> > 
> > diff --git a/man/man2/ioctl_xfs_getresblks.2 b/man/man2/ioctl_xfs_getresblks.2
> > new file mode 100644
> > index 00000000..57533927
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_getresblks.2
> > @@ -0,0 +1,65 @@
> > +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> > +.\"
> > +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> > +.\" SPDX-License-Identifier: GPL-2.0+
> > +.\" %%%LICENSE_END
> > +.TH IOCTL-XFS-GETRESBLKS 2 2019-04-16 "XFS"
> > +.SH NAME
> > +ioctl_xfs_getresblks \- query XFS summary counter information
> > +.SH SYNOPSIS
> > +.br
> > +.B #include <xfs/xfs_fs.h>
> > +.PP
> > +.BI "int ioctl(int " fd ", XFS_IOC_GET_RESBLKS, struct xfs_fsop_resblks *" arg );
> > +.PP
> > +.BI "int ioctl(int " fd ", XFS_IOC_SET_RESBLKS, struct xfs_fsop_resblks *" arg );
> > +.SH DESCRIPTION
> > +Query or set the free space reservation information.
> > +These blocks are reserved by the filesystem as a last-ditch attempt to prevent
> 
> last-ditch is a bit colloquial and possibly not fun for translators?
> 
> s/a last-ditch/an/

"...as a final attempt to prevent metadata update failures..." ?

--D

> > +metadata update failures due to insufficient space.
> > +Only the system administrator can call these ioctls, because overriding the
> > +defaults is extremely dangerous and should never be tried by anyone.
> > +.PP
> > +The reservation information is conveyed in a structure of the following form:
> > +.PP
> > +.in +4n
> > +.nf
> > +struct xfs_fsop_resblks {
> > +	__u64  resblks;
> > +	__u64  resblks_avail;
> > +};
> > +.fi
> > +.in
> > +.PP
> > +.I resblks
> > +is the number of blocks that the filesystem will try to maintain to prevent
> > +critical out of space situations.
> > +.PP
> > +.I resblks_avail
> > +is the number of reserved blocks remaining.
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
> > +.TP
> > +.B EPERM
> > +Caller does not have permission to call this ioctl.
> > +.SH CONFORMING TO
> > +This API is specific to XFS filesystem on the Linux kernel.
> > +.SH SEE ALSO
> > +.BR ioctl (2)
> > diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> > index 007f7d58..25e51417 100644
> > --- a/man/man3/xfsctl.3
> > +++ b/man/man3/xfsctl.3
> > @@ -396,12 +396,21 @@ See
> >  .BR ioctl_xfs_fscounts (2)
> >  for more information.
> >  
> > +.TP
> > +.nf
> > +.B XFS_IOC_GET_RESBLKS
> > +.fi
> > +.TP
> > +.B XFS_IOC_SET_RESBLKS
> > +See
> > +.BR ioctl_xfs_getresblks (2)
> > +for more information.
> > +Save yourself a lot of frustration and avoid these ioctls.
> > +
> >  .PP
> >  .nf
> >  .B XFS_IOC_THAW
> >  .B XFS_IOC_FREEZE
> > -.B XFS_IOC_GET_RESBLKS
> > -.B XFS_IOC_SET_RESBLKS
> >  .B XFS_IOC_FSGROWFSDATA
> >  .B XFS_IOC_FSGROWFSLOG
> >  .fi
> > @@ -418,6 +427,7 @@ as they are not of general use to applications.
> >  .BR ioctl_xfs_fsbulkstat (2),
> >  .BR ioctl_xfs_fsinumbers (2),
> >  .BR ioctl_xfs_fscounts (2),
> > +.BR ioctl_xfs_getresblks (2),
> >  .BR fstatfs (2),
> >  .BR statfs (2),
> >  .BR xfs (5),
> > 
