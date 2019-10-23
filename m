Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E24E1187
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Oct 2019 07:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387829AbfJWFWO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 23 Oct 2019 01:22:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47094 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732286AbfJWFWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Oct 2019 01:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571808133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mLUbM7iEO9/2atXJpyYo2Ae89OMhLysXSTDVFfGyuxE=;
        b=cJEJ/OfZrGwk2HPjZxckFDgkyeRjbBebMMkXfXvN3aAM6ETTdx7uItu/UpG0RqsY61KR4G
        rdj4HIARfhoZTrfUpPX2hAIvW7SZIfUUanQgP0iF85ZfhvC56ZaUujwf6payaPt8h5jSwL
        n8ezaI2r28cEFCJbsn2S1jKIKs6jCxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-V7qm6oKNOtW1kSE9hnaxtw-1; Wed, 23 Oct 2019 01:22:09 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD7241800D6B;
        Wed, 23 Oct 2019 05:22:08 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E88FA600CC;
        Wed, 23 Oct 2019 05:22:07 +0000 (UTC)
Date:   Wed, 23 Oct 2019 13:30:27 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Ian Kent <ikent@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: xfs mount option sanity test
Message-ID: <20191023053027.GV7239@dhcp-12-102.nay.redhat.com>
References: <20191022100118.18506-1-zlang@redhat.com>
 <7e96f69cd6067e202aac59c70616c643ad63c27d.camel@redhat.com>
 <20191023042052.GT7239@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191023042052.GT7239@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: V7qm6oKNOtW1kSE9hnaxtw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 23, 2019 at 12:20:52PM +0800, Zorro Lang wrote:
> On Wed, Oct 23, 2019 at 11:38:26AM +0800, Ian Kent wrote:
> > On Tue, 2019-10-22 at 18:01 +0800, Zorro Lang wrote:
> > > XFS is changing to suit the new mount API, so add this case to make
> > > sure the changing won't bring in regression issue on xfs mount option
> > > parse phase, and won't change some default behaviors either.
> >=20
> > This looks great, it looks quite comprehensive.
>=20
> This case test each xfs mount (not include rtdev) option one by one, but =
didn't
> test their combination. If you think testing option combination is necess=
ary,
> I'll write another case to do that, as this case is big enough.

Hmm... by reading your patchset, looks like I'd better to test xfs ro/rw *r=
emount*
too.

>=20
> >=20
> > I'll give it a try once I've done the recently requested changes
> > to my mount api series and let you know how it goes.
> >=20
> > Presumably the test passes when using the current master branch of
> > the xfs-linux tree, correct?
>=20
> I tested on latest RHEL-8, and test passed. I'm doing more test on old(RH=
EL-7)
> and new(xfs-linux for-next) kernel.
>=20
> Thanks,
> Zorro
>=20
> >=20
> > Ian
> >=20
> > >=20
> > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > ---
> > >  tests/xfs/148     | 315
> > > ++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/148.out |   6 +
> > >  tests/xfs/group   |   1 +
> > >  3 files changed, 322 insertions(+)
> > >  create mode 100755 tests/xfs/148
> > >  create mode 100644 tests/xfs/148.out
> > >=20
> > > diff --git a/tests/xfs/148 b/tests/xfs/148
> > > new file mode 100755
> > > index 00000000..5c268f18
> > > --- /dev/null
> > > +++ b/tests/xfs/148
> > > @@ -0,0 +1,315 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2019 Red Hat, Inc. All Rights Reserved.
> > > +#
> > > +# FS QA Test 148
> > > +#
> > > +# XFS mount options sanity check, refer to 'man 5 xfs'.
> > > +#
> > > +seq=3D`basename $0`
> > > +seqres=3D$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=3D`pwd`
> > > +tmp=3D/tmp/$$
> > > +status=3D1=09# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +=09cd /
> > > +=09rm -f $tmp.*
> > > +=09$UMOUNT_PROG $LOOP_MNT 2>/dev/null
> > > +=09if [ -n "$LOOP_DEV" ];then
> > > +=09=09_destroy_loop_device $LOOP_DEV 2>/dev/null
> > > +=09fi
> > > +=09if [ -n "$LOOP_SPARE_DEV" ];then
> > > +=09=09_destroy_loop_device $LOOP_SPARE_DEV 2>/dev/null
> > > +=09fi
> > > +=09rm -f $LOOP_IMG
> > > +=09rm -f $LOOP_SPARE_IMG
> > > +=09rmdir $LOOP_MNT
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +
> > > +# remove previous $seqres.full before test
> > > +rm -f $seqres.full
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_supported_os Linux
> > > +_require_test
> > > +_require_loop
> > > +_require_xfs_io_command "falloc"
> > > +
> > > +LOOP_IMG=3D$TEST_DIR/$seq.dev
> > > +LOOP_SPARE_IMG=3D$TEST_DIR/$seq.logdev
> > > +LOOP_MNT=3D$TEST_DIR/$seq.mnt
> > > +
> > > +echo "** create loop device"
> > > +$XFS_IO_PROG -f -c "falloc 0 1g" $LOOP_IMG
> > > +LOOP_DEV=3D`_create_loop_device $LOOP_IMG`
> > > +
> > > +echo "** create loop log device"
> > > +$XFS_IO_PROG -f -c "falloc 0 512m" $LOOP_SPARE_IMG
> > > +LOOP_SPARE_DEV=3D`_create_loop_device $LOOP_SPARE_IMG`
> > > +
> > > +echo "** create loop mount point"
> > > +rmdir $LOOP_MNT 2>/dev/null
> > > +mkdir -p $LOOP_MNT || _fail "cannot create loopback mount point"
> > > +
> > > +# avoid the effection from MKFS_OPTIONS
> > > +MKFS_OPTIONS=3D""
> > > +do_mkfs()
> > > +{
> > > +=09$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs >$seqres.full
> > > 2>$tmp.mkfs
> > > +=09if [ "${PIPESTATUS[0]}" -ne 0 ]; then
> > > +=09=09_fail "Fails on _mkfs_dev $* $LOOP_DEV"
> > > +=09fi
> > > +=09. $tmp.mkfs
> > > +}
> > > +
> > > +is_dev_mounted()
> > > +{
> > > +=09findmnt --source $LOOP_DEV >/dev/null
> > > +=09return $?
> > > +}
> > > +
> > > +get_mount_info()
> > > +{
> > > +=09findmnt --source $LOOP_DEV -o OPTIONS -n
> > > +}
> > > +
> > > +force_unmount()
> > > +{
> > > +=09$UMOUNT_PROG $LOOP_MNT >/dev/null 2>&1
> > > +}
> > > +
> > > +# _do_test <mount options> <should be mounted?> [<key string> <key
> > > should be found?>]
> > > +_do_test()
> > > +{
> > > +=09local opts=3D"$1"
> > > +=09local mounted=3D"$2"=09# pass or fail
> > > +=09local key=3D"$3"
> > > +=09local found=3D"$4"=09# true or false
> > > +=09local rc
> > > +=09local info
> > > +
> > > +=09# mount test
> > > +=09_mount $LOOP_DEV $LOOP_MNT $opts 2>/dev/null
> > > +=09rc=3D$?
> > > +=09if [ $rc -eq 0 ];then
> > > +=09=09if [ "${mounted}" =3D "fail" ];then
> > > +=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT
> > > $opts"
> > > +=09=09=09echo "ERROR: expect ${mounted}, but pass"
> > > +=09=09=09return 1
> > > +=09=09fi
> > > +=09=09is_dev_mounted
> > > +=09=09if [ $? -ne 0 ];then
> > > +=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT
> > > $opts"
> > > +=09=09=09echo "ERROR: fs not mounted even mount return
> > > 0"
> > > +=09=09=09return 1
> > > +=09=09fi
> > > +=09else
> > > +=09=09if [ "${mount_ret}" =3D "pass" ];then
> > > +=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT
> > > $opts"
> > > +=09=09=09echo "ERROR: expect ${mounted}, but fail"
> > > +=09=09=09return 1
> > > +=09=09fi
> > > +=09=09is_dev_mounted
> > > +=09=09if [ $? -eq 0 ];then
> > > +=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT
> > > $opts"
> > > +=09=09=09echo "ERROR: fs is mounted even mount return
> > > non-zero"
> > > +=09=09=09return 1
> > > +=09=09fi
> > > +=09fi
> > > +
> > > +=09# Skip below checking if "$key" argument isn't specified
> > > +=09if [ -z "$key" ];then
> > > +=09=09return 0
> > > +=09fi
> > > +=09# Check the mount options after fs mounted.
> > > +=09info=3D`get_mount_info`
> > > +=09echo $info | grep -q "${key}"
> > > +=09rc=3D$?
> > > +=09if [ $rc -eq 0 ];then
> > > +=09=09if [ "$found" !=3D "true" ];then
> > > +=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT
> > > $opts"
> > > +=09=09=09echo "ERROR: expect there's $key in $info, but
> > > not found"
> > > +=09=09=09return 1
> > > +=09=09fi
> > > +=09else
> > > +=09=09if [ "$found" !=3D "false" ];then
> > > +=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT
> > > $opts"
> > > +=09=09=09echo "ERROR: expect there's not $key in $info,
> > > but found"
> > > +=09=09=09return 1
> > > +=09=09fi
> > > +=09fi
> > > +
> > > +=09return 0
> > > +}
> > > +
> > > +do_test()
> > > +{
> > > +=09# force unmount before testing
> > > +=09force_unmount
> > > +=09_do_test "$@"
> > > +=09# force unmount after testing
> > > +=09force_unmount
> > > +}
> > > +
> > > +echo "** start xfs mount testing ..."
> > > +# Test allocsize=3Dsize
> > > +# Valid values for this option are page size (typically 4KiB)
> > > through to 1GiB
> > > +do_mkfs
> > > +if [ $dbsize -ge 1024 ];then
> > > +=09blsize=3D"$((dbsize / 1024))k"
> > > +fi
> > > +do_test "" pass "allocsize" "false"
> > > +do_test "-o allocsize=3D$blsize" pass "allocsize=3D$blsize" "true"
> > > +do_test "-o allocsize=3D1048576k" pass "allocsize=3D1048576k" "true"
> > > +do_test "-o allocsize=3D$((dbsize / 2))" fail
> > > +do_test "-o allocsize=3D2g" fail
> > > +
> > > +# Test attr2
> > > +do_mkfs -m crc=3D1
> > > +do_test "" pass "attr2" "true"
> > > +do_test "-o attr2" pass "attr2" "true"
> > > +do_test "-o noattr2" fail
> > > +do_mkfs -m crc=3D0
> > > +do_test "" pass "attr2" "true"
> > > +do_test "-o attr2" pass "attr2" "true"
> > > +do_test "-o noattr2" pass "attr2" "false"
> > > +
> > > +# Test discard
> > > +do_mkfs
> > > +do_test "" pass "discard" "false"
> > > +do_test "-o discard" pass "discard" "true"
> > > +do_test "-o nodiscard" pass "discard" "false"
> > > +
> > > +# Test grpid|bsdgroups|nogrpid|sysvgroups
> > > +do_test "" pass "grpid" "false"
> > > +do_test "-o grpid" pass "grpid" "true"
> > > +do_test "-o bsdgroups" pass "grpid" "true"
> > > +do_test "-o nogrpid" pass "grpid" "false"
> > > +do_test "-o sysvgroups" pass "grpid" "false"
> > > +
> > > +# Test filestreams
> > > +do_test "" pass "filestreams" "false"
> > > +do_test "-o filestreams" pass "filestreams" "true"
> > > +
> > > +# Test ikeep
> > > +do_test "" pass "ikeep" "false"
> > > +do_test "-o ikeep" pass "ikeep" "true"
> > > +do_test "-o noikeep" pass "ikeep" "false"
> > > +
> > > +# Test inode32|inode64
> > > +do_test "" pass "inode64" "true"
> > > +do_test "-o inode32" pass "inode32" "true"
> > > +do_test "-o inode64" pass "inode64" "true"
> > > +
> > > +# Test largeio
> > > +do_test "" pass "largeio" "false"
> > > +do_test "-o largeio" pass "largeio" "true"
> > > +do_test "-o nolargeio" pass "largeio" "false"
> > > +
> > > +# Test logbufs=3Dvalue. Valid numbers range from 2=E2=80=938 inclusi=
ve.
> > > +do_test "" pass "logbufs" "false"
> > > +do_test "-o logbufs=3D8" pass "logbufs=3D8" "true"
> > > +do_test "-o logbufs=3D2" pass "logbufs=3D2" "true"
> > > +do_test "-o logbufs=3D1" fail
> > > +###### but it gets logbufs=3D8 now, why? bug? #######
> > > +# do_test "-o logbufs=3D0" fail
> > > +do_test "-o logbufs=3D9" fail
> > > +do_test "-o logbufs=3D99999999999999" fail
> > > +
> > > +# Test logbsize=3Dvalue.
> > > +do_mkfs -m crc=3D1 -l version=3D2
> > > +do_test "" pass "logbsize" "false"
> > > +do_test "-o logbsize=3D16384" pass "logbsize=3D16k" "true"
> > > +do_test "-o logbsize=3D16k" pass "logbsize=3D16k" "true"
> > > +do_test "-o logbsize=3D32k" pass "logbsize=3D32k" "true"
> > > +do_test "-o logbsize=3D64k" pass "logbsize=3D64k" "true"
> > > +do_test "-o logbsize=3D128k" pass "logbsize=3D128k" "true"
> > > +do_test "-o logbsize=3D256k" pass "logbsize=3D256k" "true"
> > > +do_test "-o logbsize=3D8k" fail
> > > +do_test "-o logbsize=3D512k" fail
> > > +####### it's invalid, but it set to default size 32k
> > > +# do_test "-o logbsize=3D0" false
> > > +do_mkfs -m crc=3D0 -l version=3D1
> > > +do_test "" pass "logbsize" "false"
> > > +do_test "-o logbsize=3D16384" pass "logbsize=3D16k" "true"
> > > +do_test "-o logbsize=3D16k" pass "logbsize=3D16k" "true"
> > > +do_test "-o logbsize=3D32k" pass "logbsize=3D32k" "true"
> > > +do_test "-o logbsize=3D64k" fail
> > > +
> > > +# Test logdev
> > > +do_mkfs
> > > +do_test "" pass "logdev" "false"
> > > +do_test "-o logdev=3D$LOOP_SPARE_DEV" fail
> > > +do_mkfs -l logdev=3D$LOOP_SPARE_DEV
> > > +do_test "-o logdev=3D$LOOP_SPARE_DEV" pass "logdev=3D$LOOP_SPARE_DEV=
"
> > > "true"
> > > +do_test "" fail
> > > +
> > > +# Test noalign
> > > +do_mkfs
> > > +do_test "" pass "noalign" "false"
> > > +do_test "-o noalign" pass "noalign" "true"
> > > +
> > > +# Test norecovery
> > > +do_test "" pass "norecovery" "false"
> > > +do_test "-o norecovery,ro" pass "norecovery" "true"
> > > +do_test "-o norecovery" fail
> > > +
> > > +# Test nouuid
> > > +do_test "" pass "nouuid" "false"
> > > +do_test "-o nouuid" pass "nouuid" "true"
> > > +
> > > +# Test noquota
> > > +do_test "" pass "noquota" "true"
> > > +do_test "-o noquota" pass "noquota" "true"
> > > +
> > > +# Test uquota/usrquota/quota/uqnoenforce/qnoenforce
> > > +do_test "" pass "usrquota" "false"
> > > +do_test "-o uquota" pass "usrquota" "true"
> > > +do_test "-o usrquota" pass "usrquota" "true"
> > > +do_test "-o quota" pass "usrquota" "true"
> > > +do_test "-o uqnoenforce" pass "usrquota" "true"
> > > +do_test "-o qnoenforce" pass "usrquota" "true"
> > > +
> > > +# Test gquota/grpquota/gqnoenforce
> > > +do_test "" pass "grpquota" "false"
> > > +do_test "-o gquota" pass "grpquota" "true"
> > > +do_test "-o grpquota" pass "grpquota" "true"
> > > +do_test "-o gqnoenforce" pass "gqnoenforce" "true"
> > > +
> > > +# Test pquota/prjquota/pqnoenforce
> > > +do_test "" pass "prjquota" "false"
> > > +do_test "-o pquota" pass "prjquota" "true"
> > > +do_test "-o prjquota" pass "prjquota" "true"
> > > +do_test "-o pqnoenforce" pass "pqnoenforce" "true"
> > > +
> > > +# Test sunit=3Dvalue and swidth=3Dvalue
> > > +do_mkfs -d sunit=3D128,swidth=3D128
> > > +do_test "-o sunit=3D8,swidth=3D8" pass "sunit=3D8,swidth=3D8" "true"
> > > +do_test "-o sunit=3D8,swidth=3D64" pass "sunit=3D8,swidth=3D64" "tru=
e"
> > > +do_test "-o sunit=3D128,swidth=3D128" pass "sunit=3D128,swidth=3D128=
" "true"
> > > +do_test "-o sunit=3D256,swidth=3D256" pass "sunit=3D256,swidth=3D256=
" "true"
> > > +do_test "-o sunit=3D2,swidth=3D2" fail
> > > +
> > > +# Test swalloc
> > > +do_mkfs
> > > +do_test "" pass "swalloc" "false"
> > > +do_test "-o swalloc" pass "swalloc" "true"
> > > +
> > > +# Test wsync
> > > +do_test "" pass "wsync" "false"
> > > +do_test "-o wsync" pass "wsync" "true"
> > > +
> > > +echo "** end of testing"
> > > +# success, all done
> > > +status=3D0
> > > +exit
> > > diff --git a/tests/xfs/148.out b/tests/xfs/148.out
> > > new file mode 100644
> > > index 00000000..a71d9231
> > > --- /dev/null
> > > +++ b/tests/xfs/148.out
> > > @@ -0,0 +1,6 @@
> > > +QA output created by 148
> > > +** create loop device
> > > +** create loop log device
> > > +** create loop mount point
> > > +** start xfs mount testing ...
> > > +** end of testing
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index f4ebcd8c..019aebad 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -145,6 +145,7 @@
> > >  145 dmapi
> > >  146 dmapi
> > >  147 dmapi
> > > +148 auto quick mount
> > >  150 dmapi
> > >  151 dmapi
> > >  152 dmapi
> >=20

