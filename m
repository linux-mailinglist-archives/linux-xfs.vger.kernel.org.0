Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C57F60ACC
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 19:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfGERNJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 13:13:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfGERNJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jul 2019 13:13:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65H9NgN065337;
        Fri, 5 Jul 2019 17:13:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=BphgNbWtWBDkKwhNSRbcQZJ2/8aCyPBrVe4v3URU+WM=;
 b=GjknqXNg/Tcq6WTOU1r2xaZLvqjM8m05nLlh2d+NjdwXu59og+Rf4H3hrRBCg5mG952w
 oFcIL6MeaP8CsFQJUqbre6155Dk+AYCuU2KpIeiI6FkvAv0I2cchtJBioF+GAKgfM9kt
 /e6Cm73ePJ5/UhW0I9wBPQtFhIzenDMTSVsHAlQvX3XHI2WfDyYGcvVHBgIEJmKOySuk
 BwLHsGiCl4kCxV4MMSIGwGOOddYoDN3lgYhCwIMOYDrKi+zSeonRltBauvIypyQ76ktu
 MW1R+ctOSTRxEzxzXpRIkesFCwprMn8qvyHBqRtXkeWZpwztT9G4dkH/qJcY268DnFFk Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2te5tc3y81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 17:13:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65HCfWt112317;
        Fri, 5 Jul 2019 17:13:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2thxrvhvvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 17:13:05 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x65HD5OW007521;
        Fri, 5 Jul 2019 17:13:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jul 2019 10:13:04 -0700
Date:   Fri, 5 Jul 2019 10:13:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] man: create a separate xfs shutdown ioctl manpage
Message-ID: <20190705171303.GJ1404256@magnolia>
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
 <156104950912.1174403.4990641877651635072.stgit@magnolia>
 <d00e8961-c6f0-4adb-9b83-4750a15e97b1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d00e8961-c6f0-4adb-9b83-4750a15e97b1@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050212
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050212
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 05, 2019 at 11:08:54AM -0500, Eric Sandeen wrote:
> On 6/20/19 11:51 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a separate manual page for the xfs shutdown ioctl so we can
> > document how it works.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man2/ioctl_xfs_goingdown.2 |   63 ++++++++++++++++++++++++++++++++++++++++
> >  man/man3/xfsctl.3              |    7 ++++
> >  2 files changed, 70 insertions(+)
> >  create mode 100644 man/man2/ioctl_xfs_goingdown.2
> > 
> > 
> > diff --git a/man/man2/ioctl_xfs_goingdown.2 b/man/man2/ioctl_xfs_goingdown.2
> > new file mode 100644
> > index 00000000..bedc85c8
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_goingdown.2
> > @@ -0,0 +1,63 @@
> > +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> > +.\"
> > +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> > +.\" SPDX-License-Identifier: GPL-2.0+
> > +.\" %%%LICENSE_END
> > +.TH IOCTL-XFS-GOINGDOWN 2 2019-06-17 "XFS"
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
> 
> That almost sounds permanently destructive.  Perhaps:
> 
> "... will be totally unusable until the filesystem has been unmounted and remounted."
> 
> ?

Sounds good to me.

> > +
> > +.PP
> > +.I flags
> > +can be one of the following:
> > +.RS 0.4i
> > +.TP
> > +.B XFS_FSOP_GOING_FLAGS_DEFAULT
> > +Flush all dirty data and in-core state to disk, flush pending transactions to
> > +the log, and shut down.
> 
> What exactly do we mean by "in-core state" here?  I'm not sure the average
> reader will know (I'm not sure I know)

Hm... really it's any dirty cached state, like ... unflushed inodes and
dquots, dirty file data, etc.  I didn't want to commit to that level of
specificity though.

> > +.TP
> > +.B XFS_FSOP_GOING_FLAGS_LOGFLUSH
> > +Flush all pending transactions to the log and shut down, leaving all dirty
> > +data unwritten.
> > +.TP
> > +.B XFS_FSOP_GOING_FLAGS_NOLOGFLUSH
> > +Shut down immediately, without writing pending transactions or dirty data
> > +to disk.
> > +
> > +.SH RETURN VALUE
> > +On error, \-1 is returned, and
> > +.I errno
> > +is set to indicate the error.
> > +.PP
> > +.SH ERRORS
> > +Error codes can be one of, but are not limited to, the following:
> 
> Hm crud, now I wonder about auditing all your stated error codes.
> EPERM, EFAULT, and EINVAL seem to be the only options for this
> particular call.  Maybe that can be a 2nd cleanup, documenting
> an error code that won't happen is harmless...

<urk> Ok, I'll go do that. :)

> > +.TP
> > +.B EFSBADCRC
> > +Metadata checksum validation failed while performing the query.
> > +.TP
> > +.B EFSCORRUPTED
> > +Metadata corruption was encountered while performing the query.
> > +.TP
> > +.B EINVAL
> > +The specified allocation group number is not valid for this filesystem.

This one definitely was copypasta error. :(

--D

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
> > index 077dd411..7e6588b8 100644
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
> > @@ -388,6 +394,7 @@ as they are not of general use to applications.
> >  .BR ioctl_xfs_fscounts (2),
> >  .BR ioctl_xfs_getresblks (2),
> >  .BR ioctl_xfs_getbmap (2),
> > +.BR ioctl_xfs_goingdown (2),
> >  .BR fstatfs (2),
> >  .BR statfs (2),
> >  .BR xfs (5),
> > 
