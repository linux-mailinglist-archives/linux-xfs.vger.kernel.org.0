Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14624AB3E
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 21:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbfFRT4Q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 15:56:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45314 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730189AbfFRT4Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 15:56:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IJs0Xh189077;
        Tue, 18 Jun 2019 19:56:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=HMMC8upvm53FSSG0H8/mLl1kaJa/oYtc7/yFJ+kOupo=;
 b=HnIGKpg6DuliGJ1fb4kOKLW8STansmynp/JwdlhWtjxxXxHSJTg5uqn0aA1+5rnzOx8+
 ZC5RNgLQNDd9p2c97JoKV/HoSwnl5vKMAo27HIaCIYc4tpaHuGmAbbikXpT97SmCJYge
 6JeLFnqse3oM8UYHFzQrYKZu23BLcLn8zip/dH9RLLWiQ0kCv2/byk34jwb8DTIjsFVK
 YmJzEi57kVj7SOJdCxvkoggnOrMT3Re3aG5pjv7gYOCfsv/wzzog0Z/3jrHXwhzRzX4b
 sYow0IGAg9Q1pgpLENIzrDf/ZjADtAC/0dn0XDZg9gYvKFlQ9PaeH8D1Z/IQFgMescuX aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t4saqegaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 19:56:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IJt8P5166879;
        Tue, 18 Jun 2019 19:56:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2t5h5txu35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 19:56:12 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IJuCOv031189;
        Tue, 18 Jun 2019 19:56:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 12:56:11 -0700
Date:   Tue, 18 Jun 2019 12:56:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] libxfs: break out fs shutdown manpage
Message-ID: <20190618195611.GP5387@magnolia>
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993579746.2343530.1053923086240021800.stgit@magnolia>
 <d041c695-f438-c202-4c78-9273d3bdfa2a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d041c695-f438-c202-4c78-9273d3bdfa2a@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 17, 2019 at 12:27:26PM -0500, Eric Sandeen wrote:
> On 6/7/19 2:29 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a separate manual page for the fs shutdown ioctl so we can
> > document how it works.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man2/ioctl_xfs_goingdown.2 |   61 ++++++++++++++++++++++++++++++++++++++++
> >  man/man3/xfsctl.3              |    7 +++++
> >  2 files changed, 68 insertions(+)
> >  create mode 100644 man/man2/ioctl_xfs_goingdown.2
> > 
> > 
> > diff --git a/man/man2/ioctl_xfs_goingdown.2 b/man/man2/ioctl_xfs_goingdown.2
> > new file mode 100644
> > index 00000000..e9a56f28
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_goingdown.2
> > @@ -0,0 +1,61 @@
> > +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> > +.\"
> > +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> > +.\" SPDX-License-Identifier: GPL-2.0+
> > +.\" %%%LICENSE_END
> > +.TH IOCTL-XFS-GOINGDOWN 2 2019-04-16 "XFS"
> > +.SH NAME
> > +ioctl_xfs_goingdown \- shut down an XFS filesystem
> > +.SH SYNOPSIS
> > +.br
> > +.B #include <xfs/xfs_fs.h>
> > +.PP
> > +.BI "int ioctl(int " fd ", XFS_IOC_GOINGDOWN, uint32_t " flags );
> > +.SH DESCRIPTION
> > +Shuts down a live XFS filesystem.
> > +This is a software initiated hard shutdown and should be avoided whenever
> > +possible.
> > +After this call completes, the filesystem will be totally unusable and must be
> > +unmounted.
> > +
> > +.PP
> > +.I flags
> > +can be one of the following:
> > +.RS 0.4i
> > +.TP
> > +.B XFS_FSOP_GOING_FLAGS_DEFAULT
> > +Flush all dirty data and in-core state to disk, flush the log, then shut down.
> > +.TP
> > +.B XFS_FSOP_GOING_FLAGS_LOGFLUSH
> > +Flush all pending transactions to the log, then shut down, leaving all dirty
> > +data unwritten.
> > +.TP
> > +.B XFS_FSOP_GOING_FLAGS_NOLOGFLUSH
> > +Shut down, leaving all dirty transactions and dirty data.
> 
> leaving it ... what?
> 
> Maybe "Shut down, without flushing any dirty transactions or data to disk."

"Shut down immediately, without writing pending transactions or dirty data
to disk." ?

--D

> 
> > +
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
> > +Caller did not have permission to shut down the filesystem.
> > +.SH CONFORMING TO
> > +This API is specific to XFS filesystem on the Linux kernel.
> > +.SH SEE ALSO
> > +.BR ioctl (2)
> > diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> > index e0986afb..ca96a007 100644
> > --- a/man/man3/xfsctl.3
> > +++ b/man/man3/xfsctl.3
> > @@ -365,6 +365,12 @@ See
> >  for more information.
> >  Save yourself a lot of frustration and avoid these ioctls.
> >  
> > +.TP
> > +.B XFS_IOC_GOINGDOWN
> > +See
> > +.BR ioctl_xfs_goingdown (2)
> > +for more information.
> > +
> >  .PP
> >  .nf
> >  .B XFS_IOC_THAW
> > @@ -387,6 +393,7 @@ as they are not of general use to applications.
> >  .BR ioctl_xfs_fscounts (2),
> >  .BR ioctl_xfs_getresblks (2),
> >  .BR ioctl_xfs_getbmap (2),
> > +.BR ioctl_xfs_goingdown (2),
> >  .BR fstatfs (2),
> >  .BR statfs (2),
> >  .BR xfs (5),
> > 
