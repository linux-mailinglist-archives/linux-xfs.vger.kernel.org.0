Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7684AB5A
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 22:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbfFRUEd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 16:04:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51330 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730189AbfFRUEc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 16:04:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IK49f5001273;
        Tue, 18 Jun 2019 20:04:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=F9/Zyy1PlQ4liCRmbNMDiUvc3Vg/fFpI3wjUe6AsRy0=;
 b=ehLVpdVuJG4/t26hAxOTpjJOy1/U5Uxxg/2AzrS2xbRI0cMgrrXTX+JqzNLnIqoUjZTE
 oQdHtFJM/gtv0EnkphV2GtuoNXiQBhkXb1FQkRmEJXtXpCrI5f76oinHK1V3byA6qAH3
 N3zzg3TrhcLUwDr4zCJhSK2/sqnhX7FbGRHIP/b3YRJ2KSc++V6eHtq6PzRZdIFXKnIL
 Gsu1Rih68cFbwpYNQvOADPQZ33VxLHJQaJ3dsEhJlHeA8q4ssgfiFKNwZAKryXFp43OY
 43HeHVAvkqLwBz6bQfDQvgK68TmJe9wfZ4uBLe+Tt/ZOUGq1T4uW6gcAwMN7L+yQ9ysC MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t4saqeheg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 20:04:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IK3aVt125903;
        Tue, 18 Jun 2019 20:04:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t59ge1ubr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 20:04:30 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IK4SYC026006;
        Tue, 18 Jun 2019 20:04:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 20:04:28 +0000
Date:   Tue, 18 Jun 2019 13:04:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] libxfs: break out fs shutdown manpage
Message-ID: <20190618200427.GQ5387@magnolia>
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993579746.2343530.1053923086240021800.stgit@magnolia>
 <d041c695-f438-c202-4c78-9273d3bdfa2a@sandeen.net>
 <20190618195611.GP5387@magnolia>
 <1047033c-fdd9-7773-af30-c92515184589@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1047033c-fdd9-7773-af30-c92515184589@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 18, 2019 at 03:00:43PM -0500, Eric Sandeen wrote:
> 
> 
> On 6/18/19 2:56 PM, Darrick J. Wong wrote:
> > On Mon, Jun 17, 2019 at 12:27:26PM -0500, Eric Sandeen wrote:
> >> On 6/7/19 2:29 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> Create a separate manual page for the fs shutdown ioctl so we can
> >>> document how it works.
> >>>
> >>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>> ---
> >>>  man/man2/ioctl_xfs_goingdown.2 |   61 ++++++++++++++++++++++++++++++++++++++++
> >>>  man/man3/xfsctl.3              |    7 +++++
> >>>  2 files changed, 68 insertions(+)
> >>>  create mode 100644 man/man2/ioctl_xfs_goingdown.2
> >>>
> >>>
> >>> diff --git a/man/man2/ioctl_xfs_goingdown.2 b/man/man2/ioctl_xfs_goingdown.2
> >>> new file mode 100644
> >>> index 00000000..e9a56f28
> >>> --- /dev/null
> >>> +++ b/man/man2/ioctl_xfs_goingdown.2
> >>> @@ -0,0 +1,61 @@
> >>> +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> >>> +.\"
> >>> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> >>> +.\" SPDX-License-Identifier: GPL-2.0+
> >>> +.\" %%%LICENSE_END
> >>> +.TH IOCTL-XFS-GOINGDOWN 2 2019-04-16 "XFS"
> >>> +.SH NAME
> >>> +ioctl_xfs_goingdown \- shut down an XFS filesystem
> >>> +.SH SYNOPSIS
> >>> +.br
> >>> +.B #include <xfs/xfs_fs.h>
> >>> +.PP
> >>> +.BI "int ioctl(int " fd ", XFS_IOC_GOINGDOWN, uint32_t " flags );
> >>> +.SH DESCRIPTION
> >>> +Shuts down a live XFS filesystem.
> >>> +This is a software initiated hard shutdown and should be avoided whenever
> >>> +possible.
> >>> +After this call completes, the filesystem will be totally unusable and must be
> >>> +unmounted.
> >>> +
> >>> +.PP
> >>> +.I flags
> >>> +can be one of the following:
> >>> +.RS 0.4i
> >>> +.TP
> >>> +.B XFS_FSOP_GOING_FLAGS_DEFAULT
> >>> +Flush all dirty data and in-core state to disk, flush the log, then shut down.
> >>> +.TP
> >>> +.B XFS_FSOP_GOING_FLAGS_LOGFLUSH
> >>> +Flush all pending transactions to the log, then shut down, leaving all dirty
> >>> +data unwritten.
> >>> +.TP
> >>> +.B XFS_FSOP_GOING_FLAGS_NOLOGFLUSH
> >>> +Shut down, leaving all dirty transactions and dirty data.
> >>
> >> leaving it ... what?
> >>
> >> Maybe "Shut down, without flushing any dirty transactions or data to disk."
> > 
> > "Shut down immediately, without writing pending transactions or dirty data
> > to disk." ?
> 
> The two other cases use "flush" terminology so I was sticking with that.  If
> "write" is less jargon-y then I'd do it for all of them - using similar terminology
> for all 3 cases helps the reader understand the differences more clearly, I think.

I ended up editing it some more:

       flags can be one of the following:

           XFS_FSOP_GOING_FLAGS_DEFAULT
                  Flush all dirty data  and  in-core  state  to  disk,
                  flush  pending  transactions  to  the  log, and shut
                  down.

           XFS_FSOP_GOING_FLAGS_LOGFLUSH
                  Flush all pending transactions to the log  and  shut
                  down, leaving all dirty data unwritten.

           XFS_FSOP_GOING_FLAGS_NOLOGFLUSH
                  Shut   down  immediately,  without  writing  pending
                  transactions or dirty data to disk.

--D

> -Eric
