Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08FF60AEF
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 19:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbfGERTf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 13:19:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49546 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbfGERTf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jul 2019 13:19:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65HIWsJ176695;
        Fri, 5 Jul 2019 17:19:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=uhEmSLBzHIP2btsQ/raKOaKbLY+ybFqVQ+SnDyuM15w=;
 b=rKzcL8UYP2gHgVzAwCOC3UhwwbzZkJcuLiiY89L9jw4sgAHCRHVxIm2ZKt5okBCdbFaH
 Oh/td27exOWbjkmF8vk1Ib33ZdcuxVm+ZQwIoE4g+x5tHEfqg0aITXUog9u//EImN2m/
 qQ1oNy6TqedsindezvNQN1OMHUzSTfEEXnQ3p4P+bKKeYjv/8Q4Jq6OqUuIqo6kG7ew5
 VFg/tE/pn0vWYxbbnXCbGXCZ3e022hbUp3D9qMHbIWp8irqUQ+Vrj7Enl79IsV4VcWW/
 ypetgsFIsBbAK+0J91Chkpy1Gqwa1xTVD5vQ5HPt+GZr5BBms6kIuVPLcIsWKMiWcYa/ zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2te61qbxs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 17:19:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65HIVF0062222;
        Fri, 5 Jul 2019 17:19:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2th5qmm220-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 17:19:32 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x65HJVBk002832;
        Fri, 5 Jul 2019 17:19:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jul 2019 10:19:30 -0700
Date:   Fri, 5 Jul 2019 10:19:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] man: create a separate GETBMAPX/GETBMAPA/GETBMAP
 ioctl manpage
Message-ID: <20190705171929.GK1404256@magnolia>
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
 <156104950296.1174403.15218317280608955242.stgit@magnolia>
 <06724ca8-8a13-7e2b-eb68-295ed316e95e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06724ca8-8a13-7e2b-eb68-295ed316e95e@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050214
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 05, 2019 at 10:53:05AM -0500, Eric Sandeen wrote:
> On 6/20/19 11:51 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a separate manual page for the xfs BMAP ioctls so we can document
> > how they work.
> 
> Same drill ... ;)
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man2/ioctl_xfs_getbmap.2  |    1 
> >  man/man2/ioctl_xfs_getbmapa.2 |    1 
> >  man/man2/ioctl_xfs_getbmapx.2 |  172 +++++++++++++++++++++++++++++++++++++++++
> >  man/man3/xfsctl.3             |   61 ++-------------
> >  4 files changed, 184 insertions(+), 51 deletions(-)
> >  create mode 100644 man/man2/ioctl_xfs_getbmap.2
> >  create mode 100644 man/man2/ioctl_xfs_getbmapa.2
> >  create mode 100644 man/man2/ioctl_xfs_getbmapx.2
> > 
> > 
> > diff --git a/man/man2/ioctl_xfs_getbmap.2 b/man/man2/ioctl_xfs_getbmap.2
> > new file mode 100644
> > index 00000000..909402fc
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_getbmap.2
> > @@ -0,0 +1 @@
> > +.so man2/ioctl_xfs_getbmapx.2
> > diff --git a/man/man2/ioctl_xfs_getbmapa.2 b/man/man2/ioctl_xfs_getbmapa.2
> > new file mode 100644
> > index 00000000..909402fc
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_getbmapa.2
> > @@ -0,0 +1 @@
> > +.so man2/ioctl_xfs_getbmapx.2
> > diff --git a/man/man2/ioctl_xfs_getbmapx.2 b/man/man2/ioctl_xfs_getbmapx.2
> > new file mode 100644
> > index 00000000..cf21ca32
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_getbmapx.2
> > @@ -0,0 +1,172 @@
> > +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> > +.\"
> > +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> > +.\" SPDX-License-Identifier: GPL-2.0+
> > +.\" %%%LICENSE_END
> > +.TH IOCTL-XFS-GETBMAPX 2 2019-06-17 "XFS"
> > +.SH NAME
> > +ioctl_xfs_getbmapx \- query extent information for an open file
> > +.SH SYNOPSIS
> > +.br
> > +.B #include <xfs/xfs_fs.h>
> > +.PP
> > +.BI "int ioctl(int " fd ", XFS_IOC_GETBMAP, struct getbmap *" arg );
> > +.br
> > +.BI "int ioctl(int " fd ", XFS_IOC_GETBMAPA, struct getbmap *" arg );
> > +.br
> > +.BI "int ioctl(int " fd ", XFS_IOC_GETBMAPX, struct getbmapx *" arg );
> > +.SH DESCRIPTION
> > +Get the block map for a segment of a file in an XFS file system.
> > +The mapping information is conveyed in a structure of the following form:
> 
> "conveyed via an array of structures of the following form"
> 
> (otherwise below we suddenly refer to "the array" which might leave
> some heads scratching)

SGTM.

> > +.PP
> > +.in +4n
> > +.nf
> > +struct getbmap {
> > +	__s64   bmv_offset;
> > +	__s64   bmv_block;
> > +	__s64   bmv_length;
> > +	__s32   bmv_count;
> > +	__s32   bmv_entries;
> > +};
> > +.fi
> > +.in
> > +.PP
> > +The
> > +.B XFS_IOC_GETBMAPX
> > +ioctl uses a larger version of that structure:
> > +.PP
> > +.in +4n
> > +.nf
> > +struct getbmapx {
> > +	__s64   bmv_offset;
> > +	__s64   bmv_block;
> > +	__s64   bmv_length;
> > +	__s32   bmv_count;
> > +	__s32   bmv_entries;
> > +	__s32   bmv_iflags;
> > +	__s32   bmv_oflags;
> > +	__s32   bmv_unused1;
> > +	__s32   bmv_unused2;
> > +};
> > +.fi
> > +.in
> > +.PP
> > +All sizes and offsets in the structure are in units of 512 bytes.
> > +.PP
> > +The first structure in the array is a header and the remaining structures in
> > +the array contain block map information on return.
> > +The header controls iterative calls to the command and should be filled out as
> > +follows:
> > +.TP
> > +.I bmv_offset
> > +The file offset of the area of interest in the file.
> > +.TP
> > +.I bmv_length
> > +The length of the area of interest in the file.
> > +If this value is set to -1, the length of the interesting area is the rest of
> > +the file.
> > +.TP
> > +.I bmv_count
> > +The length of the array, including this header.
> 
> "The number of elements in the array, including this header.  The minimum value is 2."

Yes!!  having just tripped over this 2 days ago. :)

> > +.TP
> > +.I bmv_entries
> > +The number of entries actually filled in by the call.
> > +This does not need to be filled out before the call.
> 
> I also wonder if we should say something about how to know when iterative
> calls are done.  Perhaps:
> 
> "This value may be zero if no extents were found in the requested
> range, or if iterated calls have reached the end of the requested
> range"

Ok.

> > +.TP
> > +.I bmv_iflags
> > +For the
> > +.B XFS_IOC_GETBMAPX
> > +function, this is a bitmask containing a combination of the following flags:
> > +.RS 0.4i
> > +.TP
> > +.B BMV_IF_ATTRFORK
> > +Return information about the extended attribute fork.
> > +.TP
> > +.B BMV_IF_PREALLOC
> > +Return information about unwritten pre-allocated segments.
> > +.TP
> > +.B BMV_IF_DELALLOC
> > +Return information about delayed allocation reservation segments.
> > +.TP
> > +.B BMV_IF_NO_HOLES
> > +Do not return information about holes.
> > +.RE
> > +.PD 1
> > +.PP
> > +The other
> > +.I bmv_*
> > +fields in the header are ignored.
> > +.PP
> > +On return from a call, the header is updated so that the command can be
> > +reused to obtain more information without re-initializing the structures.
> 
> Perhaps:
> 
> "On successful return from a call, the offset and length values in the header
> are updated so that the command can be reused to obtain more information."

Yes, that is much clearer.

> 
> > +The remainder of the array will be filled out by the call as follows:
> 
> "The remaining elements of the array will be filled out ..."

SGTM.

> > +
> > +.TP
> > +.I bmv_offset
> > +File offset of segment.
> > +.TP
> > +.I bmv_block
> > +Physical starting block of segment.
> > +If this is -1, then the segment is a hole.
> > +.TP
> > +.I bmv_length
> > +Length of segment.
> > +.TP
> > +.I bmv_oflags
> > +The
> > +.B XFS_IOC_GETBMAPX
> > +function will fill this field with a combination of the following flags:
> > +.RS 0.4i
> > +.TP
> > +.B BMV_OF_PREALLOC
> > +The segment is an unwritten pre-allocation.
> > +.TP
> > +.B BMV_OF_DELALLOC
> > +The segment is a delayed allocation reservation.
> > +.TP
> > +.B BMV_OF_LAST
> > +This segment is the last in the file.
> > +.TP
> > +.B BMV_OF_SHARED
> > +This segment shares blocks with other files.
> > +.RE
> > +.PD 1
> > +.PP
> > +The other
> > +.I bmv_*
> > +fields are ignored in the array of outputted records.
> 
> "are unused in the array of output records."

Ok. :)

> -Eric
> 
> > +.PP
> > +The
> > +.B XFS_IOC_GETBMAPA
> > +command is identical to
> > +.B XFS_IOC_GETBMAP
> > +except that information about the attribute fork of the file is returned.
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
> > index 89975a3c..077dd411 100644
> > --- a/man/man3/xfsctl.3
> > +++ b/man/man3/xfsctl.3
> > @@ -144,59 +144,17 @@ See
> >  .BR ioctl_xfs_fsgetxattr (2)
> >  for more information.
> >  
> > -.TP
> > -.B XFS_IOC_GETBMAP
> > -Get the block map for a segment of a file in an XFS file system.
> > -The final argument points to an arry of variables of type
> > -.BR "struct getbmap" .
> > -All sizes and offsets in the structure are in units of 512 bytes.
> > -The structure fields include:
> > -.B bmv_offset
> > -(file offset of segment),
> > -.B bmv_block
> > -(starting block of segment),
> > -.B bmv_length
> > -(length of segment),
> > -.B bmv_count
> > -(number of array entries, including the first), and
> > -.B bmv_entries
> > -(number of entries filled in).
> > -The first structure in the array is a header, and the remaining
> > -structures in the array contain block map information on return.
> > -The header controls iterative calls to the
> > +.PP
> > +.nf
> >  .B XFS_IOC_GETBMAP
> > -command.
> > -The caller fills in the
> > -.B bmv_offset
> > -and
> > -.B bmv_length
> > -fields of the header to indicate the area of interest in the file,
> > -and fills in the
> > -.B bmv_count
> > -field to indicate the length of the array.
> > -If the
> > -.B bmv_length
> > -value is set to \-1 then the length of the interesting area is the rest
> > -of the file.
> > -On return from a call, the header is updated so that the command can be
> > -reused to obtain more information, without re-initializing the structures.
> > -Also on return, the
> > -.B bmv_entries
> > -field of the header is set to the number of array entries actually filled in.
> > -The non-header structures will be filled in with
> > -.BR bmv_offset ,
> > -.BR bmv_block ,
> > -and
> > -.BR bmv_length .
> > -If a region of the file has no blocks (is a hole in the file) then the
> > -.B bmv_block
> > -field is set to \-1.
> > -
> > -.TP
> >  .B XFS_IOC_GETBMAPA
> > -Identical to
> > -.B XFS_IOC_GETBMAP
> > -except that information about the attribute fork of the file is returned.
> > +.fi
> > +.PD 0
> > +.TP
> > +.B XFS_IOC_GETBMAPX
> > +See
> > +.BR ioctl_getbmap (2)
> > +for more information.
> >  
> >  .PP
> >  .B XFS_IOC_RESVSP
> > @@ -429,6 +387,7 @@ as they are not of general use to applications.
> >  .BR ioctl_xfs_fsinumbers (2),
> >  .BR ioctl_xfs_fscounts (2),
> >  .BR ioctl_xfs_getresblks (2),
> > +.BR ioctl_xfs_getbmap (2),
> >  .BR fstatfs (2),
> >  .BR statfs (2),
> >  .BR xfs (5),
> > 
