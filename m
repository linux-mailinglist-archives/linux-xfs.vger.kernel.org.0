Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C87C642DE7
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 19:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389803AbfFLRyi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 13:54:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41330 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389700AbfFLRyh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 13:54:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5CHn0VS039372;
        Wed, 12 Jun 2019 17:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=ZIB6v0lt/v/pB5pXL4nnQP2SW07fqAIyLgBAuVKD1Mo=;
 b=drg3zBK+Yt3ISbNdQYYqZEnWAQXdCzWV7NtYmqYnXoeMcp/m1IWmP/oZKI0ONNTVpAO9
 G3y/XIqKKraD8ahiMBiZA+E9+ltF8DJnqPr8y1CCo05GcOlTpLFbR9edDaZLKCANqoJa
 +yMbpqfKok9RSuu5KOTMQ9MnFWpyORc2NDyhKaGHaL0Nakh8+epkMAXfT2nhywzsHDhk
 OPAp/7DkURQpWZ4a6P5sAk5IMaYatF13C3yszuBWF+1vtShduqUTRn/lmOz30e78HEUk
 8s1rfXBJ9LUKSkB2kIE3PKGBdHhN+H/qCVOMcG3GQhQjwIbu5XX4T2B0iDj+uNIeWtdq Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t04etw5sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 17:54:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5CHrKwv105760;
        Wed, 12 Jun 2019 17:54:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t024v3y6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 17:54:17 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5CHsGQ9006437;
        Wed, 12 Jun 2019 17:54:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Jun 2019 10:54:15 -0700
Date:   Wed, 12 Jun 2019 10:54:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: create simplified inode walk function
Message-ID: <20190612175414.GE3773859@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968497450.1657646.15305138327955918345.stgit@magnolia>
 <20190610135816.GA6473@bfoster>
 <20190610165909.GI1871505@magnolia>
 <20190610175509.GF6473@bfoster>
 <20190610231134.GM1871505@magnolia>
 <20190611223341.GD14363@dread.disaster.area>
 <20190611230514.GU1871505@magnolia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20190611230514.GU1871505@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9286 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9286 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 11, 2019 at 04:05:14PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 12, 2019 at 08:33:41AM +1000, Dave Chinner wrote:
> > On Mon, Jun 10, 2019 at 04:11:34PM -0700, Darrick J. Wong wrote:
> > > On Mon, Jun 10, 2019 at 01:55:10PM -0400, Brian Foster wrote:
> > > > > I could extend the comment to explain why we don't use PAGE_SIZE...
> > > > > 
> > > > 
> > > > Sounds good, though what I think would be better is to define a
> > > > IWALK_DEFAULT_RECS or some such somewhere and put the calculation
> > > > details with that.
> > > > 
> > > > Though now that you point out the readahead thing, aren't we at risk of
> > > > a similar problem for users who happen to pass a really large userspace
> > > > buffer? Should we cap the kernel allocation/readahead window in all
> > > > cases and not just the default case?
> > > 
> > > Hmm, that's right, we don't want to let userspace arbitrarily determine
> > > the size of the buffer, and I think the current implementation caps it
> > > the readahaead at ... oh, PAGE_SIZE / sizeof(xfs_inogrp_t).
> > > 
> > > Oh, right, and in the V1 patchset Dave said that we should constrain
> > > readahead even further.
> > 
> > Right, I should explain a bit further why, too - it's about
> > performance.  I've found that a user buffer size of ~1024 inodes is
> > generally enough to max out performance of bulkstat. i.e. somewhere
> > around 1000 inodes per syscall is enough to mostly amortise all of
> > the cost of syscall, setup, readahead, etc vs the CPU overhead of
> > copying all the inodes into the user buffer.
> > 
> > Once the user buffer goes over a few thousand inodes, performance
> > then starts to tail back off - we don't get any gains from trying to
> > bulkstat tens of thousands of inodes at a time, especially under
> > memory pressure because that can push us into readahead and buffer
> > cache thrashing.
> 
> <nod> I don't mind setting the max inobt record cache buffer size to a
> smaller value (1024 bytes == 4096 inodes readahead?) so we can get a
> little farther into future hardware scalability (or decreases in syscall
> performance :P).
> 
> I guess the question here is how to relate the number of inodes the user
> asked for to how many inobt records we have to read to find that many
> allocated inodes?  Or in other words, what's the average ir_freecount
> across all the inobt records?

Partial results computed by using xfs_db to dump all the inobt records
in the fs to look at averge freecounts, and the number of inobt records
with zero freecount:

Development workstation / and /home:
4678 total, zerofree 72.49%, avg freecount 4.24
107940 total, zerofree 94.84%, avg freecount 0.78

This laptop /, /home, and /boot:
4613 total, zerofree 80.73%, avg freecount 3.11
49660 total, zerofree 99.54%, avg freecount 0.04
10 total, zerofree 20.00%, avg freecount 27.40

Backup server / and /home:
3897 total, zerofree 22.99%, avg freecount 27.08
55995 total, zerofree 99.87%, avg freecount 0.01

(Note that the root fs is nearly out of space now, thanks journald...)

xfstests host / and $TEST_DIR:
1834 total, zerofree 76.28%, avg freecount 3.31
20097 total, zerofree 83.41%, avg freecount 3.62

The script I used to generate these reports is attached.  From this
admittedly cursory output I "conclude" that bulkstat could get away with
prefetching (icount / 48) inobt records up to a max of 1000 inodes.
A more conservative estimate would be (icount / 32) inobt records.

--D

> 
> Note that this is technically a decrease since the old code would
> reserve 16K for this purpose...
> 
> > > > > /*
> > > > >  * Note: We hardcode 4096 here (instead of, say, PAGE_SIZE) because we want to
> > > > >  * constrain the amount of inode readahead to 16k inodes regardless of CPU:
> > > > >  *
> > > > >  * 4096 bytes / 16 bytes per inobt record = 256 inobt records
> > > > >  * 256 inobt records * 64 inodes per record = 16384 inodes
> > > > >  * 16384 inodes * 512 bytes per inode(?) = 8MB of inode readahead
> > > > >  */
> > 
> > Hence I suspect that even this is overkill - it makes no sense to
> > have a huge readahead window when there has been no measurable
> > performance benefit to doing large inode count bulkstat syscalls.
> > 
> > And, FWIW, readahead probably should also be capped at what the user
> > buffer can hold - no point in reading 16k inodes when the output
> > buffer can only fit 1000 inodes...
> 
> It already is -- the icount parameter from userspace is (eventually) fed
> to xfs_iwalk-set_prefetch.
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com

--8t9RHnE3ZwKMSgU+
Content-Type: application/x-sh
Content-Disposition: attachment; filename="xfsinoload.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0A# Report histogram of inobt record freecounts=0A=0Adie() {=
=0A	echo "$@" >> /dev/stderr=0A	exit 1=0A}=0A=0Adev=3D"$1"=0Atest -b "${dev=
}" || die "${dev}: not a block device"=0A=0Aagcount=3D"$(xfs_info "${dev}" =
| grep agcount=3D | sed -e 's/^.*agcount=3D\([0-9]*\).*$/\1/g')"=0Asparse=
=3D=0Axfs_info "${dev}" | grep -q sparse=3D1 && sparse=3Dyes=0A=0Arm -f /tm=
p/barf=0Aseq 0 "$(( agcount - 1 ))" | while read ag; do=0A	xfs_db -f -c "ag=
i ${ag}" -c "addr root" -c "btdump" "${dev}"=0Adone > /tmp/barf=0A=0Acol=3D=
2=0Atest -n "${sparse}" && col=3D4=0Agrep : /tmp/barf | awk -F ',' "{print =
\$${col}}" | sort | uniq -c | sort -g -k 1 | awk '{print $0; if ($2 =3D=3D =
0) zerofree_nr =3D $1; freecount_total +=3D ($1 * $2); total +=3D $1;}END{p=
rintf("%d inobt recs; zero free %.2f%% of recs; avg freecount %.2f\n", tota=
l, zerofree_nr * 100.0 / total, freecount_total / total);}'=0A
--8t9RHnE3ZwKMSgU+--
