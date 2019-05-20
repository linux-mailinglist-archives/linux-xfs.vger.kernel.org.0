Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEA223D98
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 18:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390026AbfETQg3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 12:36:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60170 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731223AbfETQg2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:36:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KGOIsF010007;
        Mon, 20 May 2019 16:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=yShB00bvQqpl21pAkKybHsXEvI+rBNupBbtTGiTT9Tc=;
 b=cMww61kIxVcxippxEKjOWaLfAco907XzPQgcbwpltYXotWiZwS0sdDhsjBDC3VUjOfiD
 kk82kQfhZBD7mDk640oRg32ek5q4ag4Ue/NT8hCJS+beD3piqIvTj+QSRXlrH+EJAuAx
 fU7LMwN8bkh5Q0LJ4/K1D315xnFI4TZOyq+BBXe3zDjrp5OWdXVHD8OvfaNbSkMaS/OG
 zlZVEZKdjdfAEJHjlJbVFM3tbC9XABDz+PKW6h7x8j5ceaBshOW6y5onhx/HH3H8L0V8
 /6UHECCh688bEOPsveP9L8ck/kuuOUPyV4lIEQLaUSmjUtsuG86PdvtP8u4Wt+eeFTnY og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2sj9ft876t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 16:36:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KGZRfC189604;
        Mon, 20 May 2019 16:36:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2sks1xpuyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 16:36:25 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KGaP3V010429;
        Mon, 20 May 2019 16:36:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 16:36:24 +0000
Date:   Mon, 20 May 2019 09:36:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH ] xfs: validate unicode filesystem labels
Message-ID: <20190520163624.GB5334@magnolia>
References: <155724823157.2624769.14347748235168250309.stgit@magnolia>
 <155724824306.2624769.17050442466246363524.stgit@magnolia>
 <20190511073732.GH15846@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190511073732.GH15846@desktop>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9262 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200106
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9262 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200106
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 11, 2019 at 03:37:32PM +0800, Eryu Guan wrote:
> On Tue, May 07, 2019 at 09:57:23AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure we can set and retrieve unicode labels, including emoji.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/739     |  169 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/739.out |    1 
> >  tests/xfs/group   |    1 
> >  3 files changed, 171 insertions(+)
> >  create mode 100755 tests/xfs/739
> >  create mode 100644 tests/xfs/739.out
> > 
> > 
> > diff --git a/tests/xfs/739 b/tests/xfs/739
> > new file mode 100755
> > index 00000000..f8796cc3
> > --- /dev/null
> > +++ b/tests/xfs/739
> > @@ -0,0 +1,169 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0+
> > +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 739
> > +#
> > +# Create a directory with multiple filenames that all appear the same
> > +# (in unicode, anyway) but point to different inodes.  In theory all
> > +# Linux filesystems should allow this (filenames are a sequence of
> > +# arbitrary bytes) even if the user implications are horrifying.
> > +#
> > +seq=`basename "$0"`
> > +seqres="$RESULT_DIR/$seq"
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +_supported_os Linux
> > +_supported_fs xfs
> > +_require_scratch_nocheck
> > +_require_xfs_io_command 'label'
> > +
> > +# Only run this on xfs if xfs_scrub is available and has the unicode checker
> > +check_xfs_scrub() {
> 
> This function has multiple copies in different tests now, e.g.
> generic/45{34} and xfs/262, make it a common helper?

Ok.

> > +	_scratch_mkfs >> $seqres.full 2>&1
> > +	_scratch_mount >> $seqres.full 2>&1
> > +	_supports_xfs_scrub "$SCRATCH_MNT" "$SCRATCH_DEV"
> > +	res=$?
> > +	_scratch_unmount
> > +
> > +	test $res -ne 0 && return 1
> > +
> > +	# We only care if xfs_scrub has unicode string support...
> > +	if ! type ldd > /dev/null 2>&1 || \
> > +	   ! ldd "${XFS_SCRUB_PROG}" | grep -q libicui18n; then
> > +		return 1
> > +	fi
> > +
> > +	return 0
> > +}
> > +
> > +want_scrub=
> > +check_xfs_scrub && want_scrub=yes
> > +
> > +filter_scrub() {
> > +	grep 'Unicode' | sed -e 's/^.*Duplicate/Duplicate/g'
> > +}
> > +
> > +maybe_scrub() {
> > +	test "$want_scrub" = "yes" || return
> > +
> > +	output="$(LC_ALL="C.UTF-8" ${XFS_SCRUB_PROG} -v -n "${SCRATCH_MNT}" 2>&1)"
> > +	echo "xfs_scrub output:" >> $seqres.full
> > +	echo "$output" >> $seqres.full
> > +	echo "$output" >> $tmp.scrub
> > +}
> > +
> > +testlabel() {
> > +	local label="$(echo -e "$1")"
> > +	local expected_label="label = \"$label\""
> > +
> > +	echo "Formatting label '$1'." >> $seqres.full
> > +	# First, let's see if we can recover the label when we set it
> > +	# with mkfs.
> > +	_scratch_mkfs -L "$label" >> $seqres.full 2>&1
> > +	_scratch_mount >> $seqres.full 2>&1
> > +	blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g" >> $seqres.full
> > +	blkid -d -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g" >> $seqres.full
> > +
> > +	# Did it actually stick?
> > +	local actual_label="$($XFS_IO_PROG -c label $SCRATCH_MNT)"
> > +	echo "$actual_label" >> $seqres.full
> > +
> > +	if [ "${actual_label}" != "${expected_label}" ]; then
> > +		echo "Saw '${expected_label}', expected '${actual_label}'."
> > +	fi
> > +	maybe_scrub
> > +	_scratch_unmount
> > +
> > +	# Now let's try setting the label online to see what happens.
> > +	echo "Setting label '$1'." >> $seqres.full
> > +	_scratch_mkfs >> $seqres.full 2>&1
> > +	_scratch_mount >> $seqres.full 2>&1
> > +	$XFS_IO_PROG -c "label -s $label" $SCRATCH_MNT >> $seqres.full
> > +	blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g" >> $seqres.full
> > +	blkid -d -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g" >> $seqres.full
> > +	_scratch_cycle_mount
> > +
> > +	# Did it actually stick?
> > +	local actual_label="$($XFS_IO_PROG -c label $SCRATCH_MNT)"
> > +	echo "$actual_label" >> $seqres.full
> > +
> > +	if [ "${actual_label}" != "${expected_label}" ]; then
> > +		echo "Saw '${expected_label}'; expected '${actual_label}'."
> > +	fi
> > +	maybe_scrub
> > +	_scratch_unmount
> > +}
> > +
> > +# Simple test
> > +testlabel "simple"
> > +
> > +# Two different renderings of the same label
> > +testlabel "caf\xc3\xa9.fs"
> > +testlabel "cafe\xcc\x81.fs"
> > +
> > +# Arabic code point can expand into a muuuch longer series
> > +testlabel "xfs_\xef\xb7\xba.fs"
> > +
> > +# Fake slash?
> > +testlabel "urk\xc0\xafmoo"
> > +
> > +# Emoji: octopus butterfly owl giraffe
> > +testlabel "\xf0\x9f\xa6\x91\xf0\x9f\xa6\x8b\xf0\x9f\xa6\x89"
> > +
> > +# unicode rtl widgets too...
> > +testlabel "mo\xe2\x80\xaegnp.txt"
> > +testlabel "motxt.png"
> > +
> > +# mixed-script confusables
> > +testlabel "mixed_t\xce\xbfp"
> > +testlabel "mixed_top"
> > +
> > +# single-script spoofing
> > +testlabel "a\xe2\x80\x90b.fs"
> > +testlabel "a-b.fs"
> > +
> > +testlabel "dz_dze.fs"
> > +testlabel "dz_\xca\xa3e.fs"
> > +
> > +# symbols
> > +testlabel "_Rs.fs"
> > +testlabel "_\xe2\x82\xa8.fs"
> > +
> > +# zero width joiners
> > +testlabel "moocow.fs"
> > +testlabel "moo\xe2\x80\x8dcow.fs"
> > +
> > +# combining marks
> > +testlabel "\xe1\x80\x9c\xe1\x80\xad\xe1\x80\xaf.fs"
> > +testlabel "\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.fs"
> > +
> > +# fake dotdot entry
> > +testlabel ".\xe2\x80\x8d"
> > +testlabel "..\xe2\x80\x8d"
> > +
> > +# Did scrub choke on anything?
> > +if [ "$want_scrub" = "yes" ]; then
> > +	grep -q "^Warning.*gnp.txt.*suspicious text direction" $tmp.scrub || \
> > +		echo "No complaints about direction overrides?"
> > +	grep -q "^Warning.*control characters" $tmp.scrub || \
> > +		echo "No complaints about control characters?"
> > +fi
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/739.out b/tests/xfs/739.out
> > new file mode 100644
> > index 00000000..f4f653e2
> > --- /dev/null
> > +++ b/tests/xfs/739.out
> > @@ -0,0 +1 @@
> > +QA output created by 739
> 
> "Silence is golden" ?

Ok.

--D

> Thanks,
> Eryu
> 
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index e71b058f..c8620d72 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -501,3 +501,4 @@
> >  501 auto quick unlink
> >  502 auto quick unlink
> >  503 auto copy metadump
> > +739 auto quick mkfs label
> > 
