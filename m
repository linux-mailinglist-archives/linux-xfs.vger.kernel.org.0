Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F581202D3
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Dec 2019 11:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfLPKma (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Dec 2019 05:42:30 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:43913 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727391AbfLPKm3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Dec 2019 05:42:29 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D9C966B8;
        Mon, 16 Dec 2019 05:42:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 16 Dec 2019 05:42:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        03/MReNImelJECV5QaVj6tmMmeQo/HX+AWoMptGNt70=; b=iN2P1bPGCS1u0leZ
        D3Njf9apyR4PcXYTVqJuRvmWFt8tYKCdmK4Pg15FY+JqYh8xDJPDw5liarwjR2jd
        NmDeWmKk2bDSzI3382I4sMvUA6HkYN9G4GCfOaeVB/b9Q4QtPS8tqhL9yWmHjQsi
        QyAPk7sHpZYgbWDcRd7nRPVVzDoZWVGT0y6cS05AO7z+6t7SHPPUgf+aoeCHqzlb
        XhYzEi3xTnTHji267lhVYmuF2ippBbWyxwKH2EIPgXsdKKRJlHkl/zAsdZrrn61O
        mXSxF1+L8Sbya0RDholXqxgDwAP7MhQeC6F+MfKXRvtXLQr4JKNvDEplmvveeH4G
        FdsDeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=03/MReNImelJECV5QaVj6tmMmeQo/HX+AWoMptGNt
        70=; b=gDUajxsacHDlddjO4SGCa7fFQBS7ueIkY0xD7MRXotDYxH2qs9Mb94sR1
        9Dh15AmbPmYV9BjrcTKKeAgjqirfTPB8GLnbXQikahblkDK23WD2OEbEYTZL1p/M
        8GBYttUYtvcDgWqSbu4pMs95OVd3H1FM/IseYp+wpcLG+x/StAodzU+b5+Ycca5P
        Aps1g4q/QSOzsjIIQd9WlHb85PVj2U/5g5cb6LzcptPadHANJCmmxHkQqmN/LIEo
        Hy5qJWVs6TcBYtdv+qe3o3WXuTLHnYnUEUwYxZ76bywcgPWu9YaWAMplD/mtxN3y
        3xpE4Kli3Dl4xqlAp5jiYVbQkwX4A==
X-ME-Sender: <xms:kl_3XXkR4VFvjIdmU7JM-LshOxeeYWVzPE1N4DQC6gi0kGoNqYWFDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddthedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthekredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucffohhmrghinhepmhgrrh
    gtrdhinhhfohenucfkphepuddukedrvddtkedrudekjedrvdefjeenucfrrghrrghmpehm
    rghilhhfrhhomheprhgrvhgvnhesthhhvghmrgifrdhnvghtnecuvehluhhsthgvrhfuih
    iivgeptd
X-ME-Proxy: <xmx:kl_3XfEbOL0Zhg7ZvJ-r_q8_69qbxn9aH8uA_AVAaNrEKg-am2jtSg>
    <xmx:kl_3XYpY1Xsxu-3QY7unq9BgIobaucc5432oe34soRzcll5OFIZgDg>
    <xmx:kl_3XT64mcEW5HdkiUVtFp-6l9unzp4ENASuTCcVIRtYsAnxvf0Byw>
    <xmx:kl_3Xb6Jz2_AaDPlCYeAaKiHIvzeZAVNFdUrjepq9GjPknFofcZ79w>
Received: from mickey.themaw.net (unknown [118.208.187.237])
        by mail.messagingengine.com (Postfix) with ESMTPA id 281918005C;
        Mon, 16 Dec 2019 05:42:23 -0500 (EST)
Message-ID: <3ca7f0d9bd0f93362a64e695654cb86a813771fe.camel@themaw.net>
Subject: Re: [PATCH v2] xfstests: xfs mount option sanity test
From:   Ian Kent <raven@themaw.net>
To:     Zorro Lang <zlang@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Date:   Mon, 16 Dec 2019 18:42:20 +0800
In-Reply-To: <20191216091707.GC14328@dhcp-12-102.nay.redhat.com>
References: <20191030103410.2239-1-zlang@redhat.com>
         <20191030163922.GB15224@magnolia>
         <20191030232453.GD3802@dhcp-12-102.nay.redhat.com>
         <20191211064216.GA14328@dhcp-12-102.nay.redhat.com>
         <381504a191f867dc53702454103b138eae94d61f.camel@themaw.net>
         <20191216091707.GC14328@dhcp-12-102.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-12-16 at 17:17 +0800, Zorro Lang wrote:
> On Wed, Dec 11, 2019 at 04:33:20PM +0800, Ian Kent wrote:
> > On Wed, 2019-12-11 at 14:42 +0800, Zorro Lang wrote:
> > > On Thu, Oct 31, 2019 at 07:24:53AM +0800, Zorro Lang wrote:
> > > > On Wed, Oct 30, 2019 at 09:39:22AM -0700, Darrick J. Wong
> > > > wrote:
> > > > > On Wed, Oct 30, 2019 at 06:34:10PM +0800, Zorro Lang wrote:
> > > > > > XFS is changing to suit the new mount API, so add this case
> > > > > > to
> > > > > > make
> > > > > > sure the changing won't bring in regression issue on xfs
> > > > > > mount
> > > > > > option
> > > > > > parse phase, and won't change some default behaviors
> > > > > > either.
> > > > > > 
> > > > > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > > > > ---
> > > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > V2 did below changes:
> > > > > > 1) Fix wrong output messages in _do_test function
> > > > > 
> > > > > Hmm, I still see this on 5.4-rc4:
> > > > > 
> > > > > +[FAILED]: mount /dev/loop0 /mnt/148.mnt -o logbsize=16384
> > > > > +ERROR: expect there's logbsize=16k in , but found
> > > >                                              ^^^
> > > >                                              not
> > > > 
> > > > > +[FAILED]: mount /dev/loop0 /mnt/148.mnt -o logbsize=16k
> > > > > +ERROR: expect there's logbsize=16k in , but found
> > > >                                              ^^^
> > > >                                              not
> > > > 
> > > > Sorry for this typo, I'll fix it.
> > > > 
> > > > > Oh, right, you're stripping out MKFS_OPTIONS and formatting a
> > > > > loop
> > > > > device, which on my system means you get rmapbt=1 by default
> > > > > and
> > > > > whatnot.
> > > > 
> > > > Hmm...  why rmapbt=1 cause logbsize=16k can't be displayed in
> > > > /proc/mounts?
> > > > 
> > > > Actually set MKFS_OPTIONS="" is not helpful for this case, due
> > > > to I
> > > > run
> > > > "$MKFS_XFS_PROG -f $* $LOOP_DEV" directly. I strip out
> > > > MKFS_OPTIONS,
> > > > because I use SCRACH_DEV at first :)
> > > > 
> > > > > I think the larger problem here might be that now we have to
> > > > > figure out
> > > > > the special-casing of some of these options.
> > > > 
> > > > Maybe we should avoid the testing about those behaviors can't
> > > > be
> > > > sure, if we
> > > > can't make it have a fixed output.
> > > 
> > > It's been long time passed. I still don't have a proper way to
> > > reproduce and
> > > avoid this failure you hit. Does anyone has a better idea for
> > > this
> > > case?
> > 
> > I think I understand the problem but correct me if I'm wrong.
> > 
> > Couldn't you cover both cases, pass an additional parameter that
> > says what the default is if it isn't specified as an option and
> > don't fail if it is present in the options.
> > 
> > You could check kernel versions to decide whether to pass the
> > third parameter and so decide if you need to allow for a default
> > option to account for the differing behaviour.
> 
> Hi Ian,
> 
> It's not a issue about displaying default mount options. It's:
> 
> # mount $dev_xfs $mnt -o logbsize=16k
> # findmnt --source $dev_xfs -o OPTIONS -n |grep "logbsize=16k"
> <nothing output>
> 
> The case expects there's "logbsize=16k", but it can't find that
> option.
> 
> I don't know how to reproduce it.

Yes, my mistake.

And the only way I can see the option not being printed is if the
super block info. field m_logbsize is zero and I can't see anywhere
that can happen, assuming it is set properly from the options (and
it should be AFAICS).

> 
> Thanks,
> Zorro
> 
> > Ian
> > > Thanks,
> > > Zorro
> > > 
> > > > Thanks,
> > > > Zorro
> > > > 
> > > > > --D
> > > > > 
> > > > > > 2) Remove logbufs=N and logbsize=N default display test.
> > > > > > Lastest upstream
> > > > > >    kernel displays these options in /proc/mounts by
> > > > > > default,
> > > > > > but old kernel
> > > > > >    doesn't show them except user indicate these options
> > > > > > when
> > > > > > mount xfs.
> > > > > >    Refer to 
> > > > > > https://marc.info/?l=fstests&m=157199699615477&w=2
> > > > > > 
> > > > > > Thanks,
> > > > > > Zorro
> > > > > > 
> > > > > >  tests/xfs/148     | 320
> > > > > > ++++++++++++++++++++++++++++++++++++++++++++++
> > > > > >  tests/xfs/148.out |   6 +
> > > > > >  tests/xfs/group   |   1 +
> > > > > >  3 files changed, 327 insertions(+)
> > > > > >  create mode 100755 tests/xfs/148
> > > > > >  create mode 100644 tests/xfs/148.out
> > > > > > 
> > > > > > diff --git a/tests/xfs/148 b/tests/xfs/148
> > > > > > new file mode 100755
> > > > > > index 00000000..a662f6f7
> > > > > > --- /dev/null
> > > > > > +++ b/tests/xfs/148
> > > > > > @@ -0,0 +1,320 @@
> > > > > > +#! /bin/bash
> > > > > > +# SPDX-License-Identifier: GPL-2.0
> > > > > > +# Copyright (c) 2019 Red Hat, Inc. All Rights Reserved.
> > > > > > +#
> > > > > > +# FS QA Test 148
> > > > > > +#
> > > > > > +# XFS mount options sanity check, refer to 'man 5 xfs'.
> > > > > > +#
> > > > > > +seq=`basename $0`
> > > > > > +seqres=$RESULT_DIR/$seq
> > > > > > +echo "QA output created by $seq"
> > > > > > +
> > > > > > +here=`pwd`
> > > > > > +tmp=/tmp/$$
> > > > > > +status=1	# failure is the default!
> > > > > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > > > > +
> > > > > > +_cleanup()
> > > > > > +{
> > > > > > +	cd /
> > > > > > +	rm -f $tmp.*
> > > > > > +	$UMOUNT_PROG $LOOP_MNT 2>/dev/null
> > > > > > +	if [ -n "$LOOP_DEV" ];then
> > > > > > +		_destroy_loop_device $LOOP_DEV 2>/dev/null
> > > > > > +	fi
> > > > > > +	if [ -n "$LOOP_SPARE_DEV" ];then
> > > > > > +		_destroy_loop_device $LOOP_SPARE_DEV
> > > > > > 2>/dev/null
> > > > > > +	fi
> > > > > > +	rm -f $LOOP_IMG
> > > > > > +	rm -f $LOOP_SPARE_IMG
> > > > > > +	rmdir $LOOP_MNT
> > > > > > +}
> > > > > > +
> > > > > > +# get standard environment, filters and checks
> > > > > > +. ./common/rc
> > > > > > +. ./common/filter
> > > > > > +
> > > > > > +# remove previous $seqres.full before test
> > > > > > +rm -f $seqres.full
> > > > > > +
> > > > > > +# real QA test starts here
> > > > > > +_supported_fs xfs
> > > > > > +_supported_os Linux
> > > > > > +_require_test
> > > > > > +_require_loop
> > > > > > +_require_xfs_io_command "falloc"
> > > > > > +
> > > > > > +LOOP_IMG=$TEST_DIR/$seq.dev
> > > > > > +LOOP_SPARE_IMG=$TEST_DIR/$seq.logdev
> > > > > > +LOOP_MNT=$TEST_DIR/$seq.mnt
> > > > > > +
> > > > > > +echo "** create loop device"
> > > > > > +$XFS_IO_PROG -f -c "falloc 0 1g" $LOOP_IMG
> > > > > > +LOOP_DEV=`_create_loop_device $LOOP_IMG`
> > > > > > +
> > > > > > +echo "** create loop log device"
> > > > > > +$XFS_IO_PROG -f -c "falloc 0 512m" $LOOP_SPARE_IMG
> > > > > > +LOOP_SPARE_DEV=`_create_loop_device $LOOP_SPARE_IMG`
> > > > > > +
> > > > > > +echo "** create loop mount point"
> > > > > > +rmdir $LOOP_MNT 2>/dev/null
> > > > > > +mkdir -p $LOOP_MNT || _fail "cannot create loopback mount
> > > > > > point"
> > > > > > +
> > > > > > +# avoid the effection from MKFS_OPTIONS
> > > > > > +MKFS_OPTIONS=""
> > > > > > +do_mkfs()
> > > > > > +{
> > > > > > +	$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs
> > > > > > > $seqres.full 2>$tmp.mkfs
> > > > > > +	if [ "${PIPESTATUS[0]}" -ne 0 ]; then
> > > > > > +		_fail "Fails on _mkfs_dev $* $LOOP_DEV"
> > > > > > +	fi
> > > > > > +	. $tmp.mkfs
> > > > > > +}
> > > > > > +
> > > > > > +is_dev_mounted()
> > > > > > +{
> > > > > > +	findmnt --source $LOOP_DEV >/dev/null
> > > > > > +	return $?
> > > > > > +}
> > > > > > +
> > > > > > +get_mount_info()
> > > > > > +{
> > > > > > +	findmnt --source $LOOP_DEV -o OPTIONS -n
> > > > > > +}
> > > > > > +
> > > > > > +force_unmount()
> > > > > > +{
> > > > > > +	$UMOUNT_PROG $LOOP_MNT >/dev/null 2>&1
> > > > > > +}
> > > > > > +
> > > > > > +# _do_test <mount options> <should be mounted?> [<key
> > > > > > string>
> > > > > > <key should be found?>]
> > > > > > +_do_test()
> > > > > > +{
> > > > > > +	local opts="$1"
> > > > > > +	local mounted="$2"	# pass or fail
> > > > > > +	local key="$3"
> > > > > > +	local found="$4"	# true or false
> > > > > > +	local rc
> > > > > > +	local info
> > > > > > +
> > > > > > +	# mount test
> > > > > > +	_mount $LOOP_DEV $LOOP_MNT $opts 2>/dev/null
> > > > > > +	rc=$?
> > > > > > +	if [ $rc -eq 0 ];then
> > > > > > +		if [ "${mounted}" = "fail" ];then
> > > > > > +			echo "[FAILED]: mount $LOOP_DEV
> > > > > > $LOOP_MNT $opts"
> > > > > > +			echo "ERROR: expect ${mounted}, but
> > > > > > pass"
> > > > > > +			return 1
> > > > > > +		fi
> > > > > > +		is_dev_mounted
> > > > > > +		if [ $? -ne 0 ];then
> > > > > > +			echo "[FAILED]: mount $LOOP_DEV
> > > > > > $LOOP_MNT $opts"
> > > > > > +			echo "ERROR: fs not mounted even mount
> > > > > > return 0"
> > > > > > +			return 1
> > > > > > +		fi
> > > > > > +	else
> > > > > > +		if [ "${mount_ret}" = "pass" ];then
> > > > > > +			echo "[FAILED]: mount $LOOP_DEV
> > > > > > $LOOP_MNT $opts"
> > > > > > +			echo "ERROR: expect ${mounted}, but
> > > > > > fail"
> > > > > > +			return 1
> > > > > > +		fi
> > > > > > +		is_dev_mounted
> > > > > > +		if [ $? -eq 0 ];then
> > > > > > +			echo "[FAILED]: mount $LOOP_DEV
> > > > > > $LOOP_MNT $opts"
> > > > > > +			echo "ERROR: fs is mounted even mount
> > > > > > return non-zero"
> > > > > > +			return 1
> > > > > > +		fi
> > > > > > +	fi
> > > > > > +
> > > > > > +	# Skip below checking if "$key" argument isn't
> > > > > > specified
> > > > > > +	if [ -z "$key" ];then
> > > > > > +		return 0
> > > > > > +	fi
> > > > > > +	# Check the mount options after fs mounted.
> > > > > > +	info=`get_mount_info`
> > > > > > +	echo $info | grep -q "${key}"
> > > > > > +	rc=$?
> > > > > > +	if [ $rc -eq 0 ];then
> > > > > > +		if [ "$found" != "true" ];then
> > > > > > +			echo "[FAILED]: mount $LOOP_DEV
> > > > > > $LOOP_MNT $opts"
> > > > > > +			echo "ERROR: expect there's not $key in
> > > > > > $info, but not found"
> > > > > > +			return 1
> > > > > > +		fi
> > > > > > +	else
> > > > > > +		if [ "$found" != "false" ];then
> > > > > > +			echo "[FAILED]: mount $LOOP_DEV
> > > > > > $LOOP_MNT $opts"
> > > > > > +			echo "ERROR: expect there's $key in
> > > > > > $info, but found"
> > > > > > +			return 1
> > > > > > +		fi
> > > > > > +	fi
> > > > > > +
> > > > > > +	return 0
> > > > > > +}
> > > > > > +
> > > > > > +do_test()
> > > > > > +{
> > > > > > +	# force unmount before testing
> > > > > > +	force_unmount
> > > > > > +	_do_test "$@"
> > > > > > +	# force unmount after testing
> > > > > > +	force_unmount
> > > > > > +}
> > > > > > +
> > > > > > +echo "** start xfs mount testing ..."
> > > > > > +# Test allocsize=size
> > > > > > +# Valid values for this option are page size (typically
> > > > > > 4KiB)
> > > > > > through to 1GiB
> > > > > > +do_mkfs
> > > > > > +if [ $dbsize -ge 1024 ];then
> > > > > > +	blsize="$((dbsize / 1024))k"
> > > > > > +fi
> > > > > > +do_test "" pass "allocsize" "false"
> > > > > > +do_test "-o allocsize=$blsize" pass "allocsize=$blsize"
> > > > > > "true"
> > > > > > +do_test "-o allocsize=1048576k" pass "allocsize=1048576k"
> > > > > > "true"
> > > > > > +do_test "-o allocsize=$((dbsize / 2))" fail
> > > > > > +do_test "-o allocsize=2g" fail
> > > > > > +
> > > > > > +# Test attr2
> > > > > > +do_mkfs -m crc=1
> > > > > > +do_test "" pass "attr2" "true"
> > > > > > +do_test "-o attr2" pass "attr2" "true"
> > > > > > +do_test "-o noattr2" fail
> > > > > > +do_mkfs -m crc=0
> > > > > > +do_test "" pass "attr2" "true"
> > > > > > +do_test "-o attr2" pass "attr2" "true"
> > > > > > +do_test "-o noattr2" pass "attr2" "false"
> > > > > > +
> > > > > > +# Test discard
> > > > > > +do_mkfs
> > > > > > +do_test "" pass "discard" "false"
> > > > > > +do_test "-o discard" pass "discard" "true"
> > > > > > +do_test "-o nodiscard" pass "discard" "false"
> > > > > > +
> > > > > > +# Test grpid|bsdgroups|nogrpid|sysvgroups
> > > > > > +do_test "" pass "grpid" "false"
> > > > > > +do_test "-o grpid" pass "grpid" "true"
> > > > > > +do_test "-o bsdgroups" pass "grpid" "true"
> > > > > > +do_test "-o nogrpid" pass "grpid" "false"
> > > > > > +do_test "-o sysvgroups" pass "grpid" "false"
> > > > > > +
> > > > > > +# Test filestreams
> > > > > > +do_test "" pass "filestreams" "false"
> > > > > > +do_test "-o filestreams" pass "filestreams" "true"
> > > > > > +
> > > > > > +# Test ikeep
> > > > > > +do_test "" pass "ikeep" "false"
> > > > > > +do_test "-o ikeep" pass "ikeep" "true"
> > > > > > +do_test "-o noikeep" pass "ikeep" "false"
> > > > > > +
> > > > > > +# Test inode32|inode64
> > > > > > +do_test "" pass "inode64" "true"
> > > > > > +do_test "-o inode32" pass "inode32" "true"
> > > > > > +do_test "-o inode64" pass "inode64" "true"
> > > > > > +
> > > > > > +# Test largeio
> > > > > > +do_test "" pass "largeio" "false"
> > > > > > +do_test "-o largeio" pass "largeio" "true"
> > > > > > +do_test "-o nolargeio" pass "largeio" "false"
> > > > > > +
> > > > > > +# Test logbufs=value. Valid numbers range from 2–8
> > > > > > inclusive.
> > > > > > +# New kernel (refer to 4f62282a3696 xfs: cleanup
> > > > > > xlog_get_iclog_buffer_size)
> > > > > > +# prints "logbufs=N" in /proc/mounts, but old kernel not.
> > > > > > So
> > > > > > the default
> > > > > > +# 'display' about logbufs can't be expected, disable this
> > > > > > test.
> > > > > > +#do_test "" pass "logbufs" "false"
> > > > > > +do_test "-o logbufs=8" pass "logbufs=8" "true"
> > > > > > +do_test "-o logbufs=2" pass "logbufs=2" "true"
> > > > > > +do_test "-o logbufs=1" fail
> > > > > > +do_test "-o logbufs=9" fail
> > > > > > +do_test "-o logbufs=99999999999999" fail
> > > > > > +
> > > > > > +# Test logbsize=value.
> > > > > > +do_mkfs -m crc=1 -l version=2
> > > > > > +# New kernel (refer to 4f62282a3696 xfs: cleanup
> > > > > > xlog_get_iclog_buffer_size)
> > > > > > +# prints "logbsize=N" in /proc/mounts, but old kernel not.
> > > > > > So
> > > > > > the default
> > > > > > +# 'display' about logbsize can't be expected, disable this
> > > > > > test.
> > > > > > +#do_test "" pass "logbsize" "false"
> > > > > > +do_test "-o logbsize=16384" pass "logbsize=16k" "true"
> > > > > > +do_test "-o logbsize=16k" pass "logbsize=16k" "true"
> > > > > > +do_test "-o logbsize=32k" pass "logbsize=32k" "true"
> > > > > > +do_test "-o logbsize=64k" pass "logbsize=64k" "true"
> > > > > > +do_test "-o logbsize=128k" pass "logbsize=128k" "true"
> > > > > > +do_test "-o logbsize=256k" pass "logbsize=256k" "true"
> > > > > > +do_test "-o logbsize=8k" fail
> > > > > > +do_test "-o logbsize=512k" fail
> > > > > > +do_mkfs -m crc=0 -l version=1
> > > > > > +# New kernel (refer to 4f62282a3696 xfs: cleanup
> > > > > > xlog_get_iclog_buffer_size)
> > > > > > +# prints "logbsize=N" in /proc/mounts, but old kernel not.
> > > > > > So
> > > > > > the default
> > > > > > +# 'display' about logbsize can't be expected, disable this
> > > > > > test.
> > > > > > +#do_test "" pass "logbsize" "false"
> > > > > > +do_test "-o logbsize=16384" pass "logbsize=16k" "true"
> > > > > > +do_test "-o logbsize=16k" pass "logbsize=16k" "true"
> > > > > > +do_test "-o logbsize=32k" pass "logbsize=32k" "true"
> > > > > > +do_test "-o logbsize=64k" fail
> > > > > > +
> > > > > > +# Test logdev
> > > > > > +do_mkfs
> > > > > > +do_test "" pass "logdev" "false"
> > > > > > +do_test "-o logdev=$LOOP_SPARE_DEV" fail
> > > > > > +do_mkfs -l logdev=$LOOP_SPARE_DEV
> > > > > > +do_test "-o logdev=$LOOP_SPARE_DEV" pass
> > > > > > "logdev=$LOOP_SPARE_DEV" "true"
> > > > > > +do_test "" fail
> > > > > > +
> > > > > > +# Test noalign
> > > > > > +do_mkfs
> > > > > > +do_test "" pass "noalign" "false"
> > > > > > +do_test "-o noalign" pass "noalign" "true"
> > > > > > +
> > > > > > +# Test norecovery
> > > > > > +do_test "" pass "norecovery" "false"
> > > > > > +do_test "-o norecovery,ro" pass "norecovery" "true"
> > > > > > +do_test "-o norecovery" fail
> > > > > > +
> > > > > > +# Test nouuid
> > > > > > +do_test "" pass "nouuid" "false"
> > > > > > +do_test "-o nouuid" pass "nouuid" "true"
> > > > > > +
> > > > > > +# Test noquota
> > > > > > +do_test "" pass "noquota" "true"
> > > > > > +do_test "-o noquota" pass "noquota" "true"
> > > > > > +
> > > > > > +# Test uquota/usrquota/quota/uqnoenforce/qnoenforce
> > > > > > +do_test "" pass "usrquota" "false"
> > > > > > +do_test "-o uquota" pass "usrquota" "true"
> > > > > > +do_test "-o usrquota" pass "usrquota" "true"
> > > > > > +do_test "-o quota" pass "usrquota" "true"
> > > > > > +do_test "-o uqnoenforce" pass "usrquota" "true"
> > > > > > +do_test "-o qnoenforce" pass "usrquota" "true"
> > > > > > +
> > > > > > +# Test gquota/grpquota/gqnoenforce
> > > > > > +do_test "" pass "grpquota" "false"
> > > > > > +do_test "-o gquota" pass "grpquota" "true"
> > > > > > +do_test "-o grpquota" pass "grpquota" "true"
> > > > > > +do_test "-o gqnoenforce" pass "gqnoenforce" "true"
> > > > > > +
> > > > > > +# Test pquota/prjquota/pqnoenforce
> > > > > > +do_test "" pass "prjquota" "false"
> > > > > > +do_test "-o pquota" pass "prjquota" "true"
> > > > > > +do_test "-o prjquota" pass "prjquota" "true"
> > > > > > +do_test "-o pqnoenforce" pass "pqnoenforce" "true"
> > > > > > +
> > > > > > +# Test sunit=value and swidth=value
> > > > > > +do_mkfs -d sunit=128,swidth=128
> > > > > > +do_test "-o sunit=8,swidth=8" pass "sunit=8,swidth=8"
> > > > > > "true"
> > > > > > +do_test "-o sunit=8,swidth=64" pass "sunit=8,swidth=64"
> > > > > > "true"
> > > > > > +do_test "-o sunit=128,swidth=128" pass
> > > > > > "sunit=128,swidth=128"
> > > > > > "true"
> > > > > > +do_test "-o sunit=256,swidth=256" pass
> > > > > > "sunit=256,swidth=256"
> > > > > > "true"
> > > > > > +do_test "-o sunit=2,swidth=2" fail
> > > > > > +
> > > > > > +# Test swalloc
> > > > > > +do_mkfs
> > > > > > +do_test "" pass "swalloc" "false"
> > > > > > +do_test "-o swalloc" pass "swalloc" "true"
> > > > > > +
> > > > > > +# Test wsync
> > > > > > +do_test "" pass "wsync" "false"
> > > > > > +do_test "-o wsync" pass "wsync" "true"
> > > > > > +
> > > > > > +echo "** end of testing"
> > > > > > +# success, all done
> > > > > > +status=0
> > > > > > +exit
> > > > > > diff --git a/tests/xfs/148.out b/tests/xfs/148.out
> > > > > > new file mode 100644
> > > > > > index 00000000..a71d9231
> > > > > > --- /dev/null
> > > > > > +++ b/tests/xfs/148.out
> > > > > > @@ -0,0 +1,6 @@
> > > > > > +QA output created by 148
> > > > > > +** create loop device
> > > > > > +** create loop log device
> > > > > > +** create loop mount point
> > > > > > +** start xfs mount testing ...
> > > > > > +** end of testing
> > > > > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > > > > index f4ebcd8c..019aebad 100644
> > > > > > --- a/tests/xfs/group
> > > > > > +++ b/tests/xfs/group
> > > > > > @@ -145,6 +145,7 @@
> > > > > >  145 dmapi
> > > > > >  146 dmapi
> > > > > >  147 dmapi
> > > > > > +148 auto quick mount
> > > > > >  150 dmapi
> > > > > >  151 dmapi
> > > > > >  152 dmapi
> > > > > > -- 
> > > > > > 2.20.1
> > > > > > 

