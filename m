Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E775E70EF
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Sep 2022 02:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiIWAyM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Sep 2022 20:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiIWAyK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 20:54:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DBF5A2DD
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 17:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663894446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pPTY6Jhwli0uq1P//XQgfRtWfaWYTO2TH2Ni8gzgiXA=;
        b=Z6IZhjz1WF9vTCT4sUcF9IQ689t23DLWCCvaSJUBVY79rnB1D7nIDi6edj4OO4o2pTWDMN
        W53pNG5p/cRPpLRfRqxExHb4+xATgTwaDD1scSxa+g9XqE4rmZYCfw34zYpJTXyEi17VtP
        2pltQHDcdofVxHKGPu6wFUC/HCaFhT8=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-306-1EJ39yiRN7GaI_dErnUOFw-1; Thu, 22 Sep 2022 20:53:57 -0400
X-MC-Unique: 1EJ39yiRN7GaI_dErnUOFw-1
Received: by mail-pj1-f69.google.com with SMTP id 2-20020a17090a0b8200b001fdb8fd5f29so5693637pjr.8
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 17:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=pPTY6Jhwli0uq1P//XQgfRtWfaWYTO2TH2Ni8gzgiXA=;
        b=JTDQsgMXS0Z8kpwCX8YdqvNUCa8WRzmbXeE4QFSb4+VerJQIKJDHkidtLanrdpxiAh
         9LfkADPhjSpDp0ErJUiB8GrdsvYJrcOqa6EOso2iBuVSaO51bHRmbhzDclm6s4XR8F5D
         ysay6whwleMoUjGsXPL67YvdiyxAmv1rMruichjWmo6kfztslTsGk8wwnedERPtUNQuu
         eXTBbTZ8texImhi4R3EQeMDV2b64KQXSWLdUDZY/z3f/yEuCm8UdEwygrFxbmhKyvJxT
         QEE0NS1xky0pKFsJdLchUzig1ykYBjMRJ+Frhr0mF0wq82VnHR8N0TrJUedHCKoKW44s
         vAJQ==
X-Gm-Message-State: ACrzQf2j4uPEB0Uw8xNll13cQ+r0TMcJq0ADyPHVAL8O8eKDBlPpRRuG
        k+o5MK66Fov0M8L0q2xdMGb1d6P75+JH1j41jA2EKi3BKJCn5FWU+Xj1JHbRWuKA0r8H/IQ2Ho7
        +AzCPkTEZ7BHGkrDXa4BF
X-Received: by 2002:a17:90b:3ec9:b0:203:27a3:166f with SMTP id rm9-20020a17090b3ec900b0020327a3166fmr18079381pjb.109.1663894435549;
        Thu, 22 Sep 2022 17:53:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM47CJx8E2KfRurznhbkRnYbY4qcfReN2kCcbQjOvE5NLZ/0/GfJCp6vCGE/gA0EZC60mk2EEg==
X-Received: by 2002:a17:90b:3ec9:b0:203:27a3:166f with SMTP id rm9-20020a17090b3ec900b0020327a3166fmr18079347pjb.109.1663894434915;
        Thu, 22 Sep 2022 17:53:54 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7842a000000b00546d8c2185dsm5207286pfn.170.2022.09.22.17.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 17:53:54 -0700 (PDT)
Date:   Fri, 23 Sep 2022 08:53:50 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] xfstests: Add parent pointer test
Message-ID: <20220923005350.fhnfr52mdsnqsazv@zlang-mailbox>
References: <20220614220129.20847-1-catherine.hoang@oracle.com>
 <20220614220129.20847-2-catherine.hoang@oracle.com>
 <20220922163759.ivffu46l2xiy7tq6@zlang-mailbox>
 <5605ee82c1c85531bd91b497cb87c545695408db.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5605ee82c1c85531bd91b497cb87c545695408db.camel@oracle.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 22, 2022 at 06:45:09PM +0000, Allison Henderson wrote:
> On Fri, 2022-09-23 at 00:37 +0800, Zorro Lang wrote:
> > On Tue, Jun 14, 2022 at 03:01:29PM -0700, Catherine Hoang wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > > 
> > > This patch adds a test for basic parent pointer operations,
> > > including link, unlink, rename, overwrite, hardlinks and
> > > error inject.
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > > ---
> > > �common/parent������ |� 196 +++++++++
> > > �common/rc���������� |��� 3 +
> > > �doc/group-names.txt |��� 1 +
> > > �tests/xfs/547������ |� 126 ++++++
> > > �tests/xfs/547.out�� |�� 59 +++
> > > �tests/xfs/548������ |�� 97 +++++
> > > �tests/xfs/548.out�� | 1002
> > > +++++++++++++++++++++++++++++++++++++++++++
> > > �tests/xfs/549������ |� 110 +++++
> > > �tests/xfs/549.out�� |�� 14 +
> > > �9 files changed, 1608 insertions(+)
> > > �create mode 100644 common/parent
> > > �create mode 100755 tests/xfs/547
> > > �create mode 100644 tests/xfs/547.out
> > > �create mode 100755 tests/xfs/548
> > > �create mode 100644 tests/xfs/548.out
> > > �create mode 100755 tests/xfs/549
> > > �create mode 100644 tests/xfs/549.out
> > > 
> > > diff --git a/common/parent b/common/parent
> > > new file mode 100644
> > > index 00000000..0af12553
> > > --- /dev/null
> > > +++ b/common/parent
> > > @@ -0,0 +1,196 @@
> > > +#
> > > +# Parent pointer common functions
> > > +#
> > > +
> > > +#
> > > +# parse_parent_pointer parents parent_inode parent_pointer_name
> > > +#
> > > +# Given a list of parent pointers, find the record that matches
> > > +# the given inode and filename
> > > +#
> > > +# inputs:
> > > +# parents������: A list of parent pointers in the format of:
> > > +#��������������� inode/generation/name_length/name
> > > +# parent_inode�: The parent inode to search for
> > > +# parent_name��: The parent name to search for
> > > +#
> > > +# outputs:
> > > +# PPINO�������� : Parent pointer inode
> > > +# PPGEN�������� : Parent pointer generation
> > > +# PPNAME������� : Parent pointer name
> > > +# PPNAME_LEN��� : Parent pointer name length
> > > +#
> > > +_parse_parent_pointer()
> > > +{
> > > +�������local parents=$1
> > > +�������local pino=$2
> > > +�������local parent_pointer_name=$3
> > > +
> > > +�������local found=0
> > > +
> > > +�������# Find the entry that has the same inode as the parent
> > > +�������# and parse out the entry info
> > > +�������while IFS=\/ read PPINO PPGEN PPNAME_LEN PPNAME; do
> > > +���������������if [ "$PPINO" != "$pino" ]; then
> > > +�����������������������continue
> > > +���������������fi
> > > +
> > > +���������������if [ "$PPNAME" != "$parent_pointer_name" ]; then
> > > +�����������������������continue
> > > +���������������fi
> > > +
> > > +���������������found=1
> > > +���������������break
> > > +�������done <<< $(echo "$parents")
> > > +
> > > +�������# Check to see if we found anything
> > > +�������# We do not fail the test because we also use this
> > > +�������# routine to verify when parent pointers should
> > > +�������# be removed or updated� (ie a rename or a move
> > > +�������# operation changes your parent pointer)
> > > +�������if [ $found -eq "0" ]; then
> > > +���������������return 1
> > > +�������fi
> > > +
> > > +�������# Verify the parent pointer name length is correct
> > > +�������if [ "$PPNAME_LEN" -ne "${#parent_pointer_name}" ]
> > > +�������then
> > > +���������������_fail "Bad parent pointer reclen"
> > > +�������fi
> > > +
> > > +�������#return sucess
> > > +�������return 0
> > > +}
> > > +
> > > +#
> > > +# _verify_parent parent_path parent_pointer_name child_path
> > > +#
> > > +# Verify that the given child path lists the given parent as a
> > > parent pointer
> > > +# and that the parent pointer name matches the given name
> > > +#
> > > +# Examples:
> > > +#
> > > +# #simple example
> > > +# mkdir testfolder1
> > > +# touch testfolder1/file1
> > > +# verify_parent testfolder1 file1 testfolder1/file1
> > > +#
> > > +# # In this above example, we want to verify that "testfolder1"
> > > +# # appears as a parent pointer of "testfolder1/file1".�
> > > Additionally
> > > +# # we verify that the name record of the parent pointer is
> > > "file1"
> > > +#
> > > +#
> > > +# #hardlink example
> > > +# mkdir testfolder1
> > > +# mkdir testfolder2
> > > +# touch testfolder1/file1
> > > +# ln testfolder1/file1 testfolder2/file1_ln
> > > +# verify_parent testfolder2 file1_ln testfolder1/file1
> > > +#
> > > +# # In this above example, we want to verify that "testfolder2"
> > > +# # appears as a parent pointer of "testfolder1/file1".�
> > > Additionally
> > > +# # we verify that the name record of the parent pointer is
> > > "file1_ln"
> > > +#
> > > +_verify_parent()
> > > +{
> > > +

useless empty line ^^

> > > +�������local parent_path=$1
> > > +�������local parent_pointer_name=$2
> > > +�������local child_path=$3
> > > +
> > > +�������local parent_ppath="$parent_path/$parent_pointer_name"
> > > +
> > > +�������# Verify parent exists
> > > +�������if [ ! -d $SCRATCH_MNT/$parent_path ]; then
> > > +���������������_fail "$SCRATCH_MNT/$parent_path not found"
> > > +�������else
> > > +���������������echo "*** $parent_path OK"
> > > +�������fi
> > > +
> > > +�������# Verify child exists
> > > +�������if [ ! -f $SCRATCH_MNT/$child_path ]; then
> > > +���������������_fail "$SCRATCH_MNT/$child_path not found"
> > > +�������else
> > > +���������������echo "*** $child_path OK"
> > > +�������fi
> > > +
> > > +�������# Verify the parent pointer name exists as a child of the
> > > parent
> > > +�������if [ ! -f $SCRATCH_MNT/$parent_ppath ]; then
> > > +���������������_fail "$SCRATCH_MNT/$parent_ppath not found"
> > > +�������else
> > > +���������������echo "*** $parent_ppath OK"
> > > +�������fi
> > > +
> > > +�������# Get the inodes of both parent and child
> > > +�������pino="$(stat -c '%i' $SCRATCH_MNT/$parent_path)"
> > > +�������cino="$(stat -c '%i' $SCRATCH_MNT/$child_path)"
> > > +
> > > +�������# Get all the parent pointers of the child
> > > +�������parents=($($XFS_IO_PROG -x -c "parent -f -i $pino -n
> > > $parent_pointer_name" $SCRATCH_MNT/$child_path))
> > > +�������if [[ $? != 0 ]]; then
> > > +��������������� _fail "No parent pointers found for $child_path"
> > > +�������fi
> > > +
> > > +�������# Parse parent pointer output.
> > > +�������# This sets PPINO PPGEN PPNAME PPNAME_LEN
> > > +�������_parse_parent_pointer $parents $pino $parent_pointer_name
> > > +
> > > +�������# If we didnt find one, bail out
> > > +�������if [ $? -ne 0 ]; then
> > > +���������������_fail "No parent pointer record found for
> > > $parent_path in $child_path"
> > > +�������fi
> > > +
> > > +�������# Verify the inode generated by the parent pointer name is
> > > +�������# the same as the child inode
> > > +�������pppino="$(stat -c '%i' $SCRATCH_MNT/$parent_ppath)"
> > > +�������if [ $cino -ne $pppino ]
> > > +�������then
> > > +���������������_fail "Bad parent pointer name value for
> > > $child_path."\
> > > +�������������������������������"$SCRATCH_MNT/$parent_ppath belongs
> > > to inode $PPPINO, but should be $cino"
> > > +�������fi
> > > +
> > > +�������echo "*** Verified parent pointer:"\
> > > +�����������������������"name:$PPNAME, namelen:$PPNAME_LEN"
> > > +�������echo "*** Parent pointer OK for child $child_path"
> > > +}
> > > +
> > > +#
> > > +# _verify_parent parent_pointer_name pino child_path
> > > +#
> > > +# Verify that the given child path contains no parent pointer
> > > entry
> > > +# for the given inode and file name
> > > +#
> > > +_verify_no_parent()
> > > +{
> > > +

empty line at beginning too, is it a code style?

> > > +�������local parent_pname=$1
> > > +�������local pino=$2
> > > +�������local child_path=$3
> > > +
> > > +�������# Verify child exists
> > > +�������if [ ! -f $SCRATCH_MNT/$child_path ]; then
> > > +���������������_fail "$SCRATCH_MNT/$child_path not found"
> > > +�������else
> > > +���������������echo "*** $child_path OK"
> > > +�������fi
> > > +
> > > +�������# Get all the parent pointers of the child
> > > +�������local parents=($($XFS_IO_PROG -x -c "parent -f -i $pino -n
> > > $parent_pname" $SCRATCH_MNT/$child_path))
> > 
> > I didn't see anywhere (in this patch) call `_require_xfs_io_command
> > parent`.
> > Shouldn't we make sure the "parent" feature is support by userspace
> > and
> > kernel both?
> Sure, I think you're right, we can add "_require_xfs_io_command parent"
> at the top of the tests

Thanks, by the way, can you separate this patch to 3~4 patches as a patchset,
it's a little hard for me to go through this long patch and page up and down
to review sometimes :)

> 
> > 
> > > +�������if [[ $? != 0 ]]; then
> > > +���������������return 0
> > > +�������fi
> > > +
> > > +�������# Parse parent pointer output.
> > > +�������# This sets PPINO PPGEN PPNAME PPNAME_LEN
> > > +�������_parse_parent_pointer $parents $pino $parent_pname
> > > +
> > > +�������# If we didnt find one, return sucess
> > > +�������if [ $? -ne 0 ]; then
> > > +���������������return 0
> > > +�������fi
> > > +
> > > +�������_fail "Parent pointer entry found where none should:"\
> > > +�����������������������"inode:$PPINO, gen:$PPGEN,"
> > > +�����������������������"name:$PPNAME, namelen:$PPNAME_LEN"
> > > +}
> > > +
> > > diff --git a/common/rc b/common/rc
> > > index 4201a059..68752cdc 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -2701,6 +2701,9 @@ _require_xfs_io_command()
> > > ����������������echo $testio | grep -q "invalid option" && \
> > > ������������������������_notrun "xfs_io $command support is
> > > missing"
> > > ����������������;;
> > > +�������"parent")
> > > +���������������testio=`$XFS_IO_PROG -x -c "parent" $TEST_DIR 2>&1`
> > > +���������������;;
> > > ��������"pwrite")
> > > ����������������# -N (RWF_NOWAIT) only works with direct vectored
> > > I/O writes
> > > ����������������local pwrite_opts=" "
> > > diff --git a/doc/group-names.txt b/doc/group-names.txt
> > > index e8e3477e..98bbe3b7 100644
> > > --- a/doc/group-names.txt
> > > +++ b/doc/group-names.txt
> > > @@ -77,6 +77,7 @@ nfs4_acl��������������NFSv4 access control lists
> > > �nonsamefs��������������overlayfs layers on different filesystems
> > > �online_repair����������online repair functionality tests
> > > �other������������������dumping ground, do not add more tests to
> > > this group
> > > +parent�����������������Parent pointer tests
> > > �pattern������������������������specific IO pattern tests
> > > �perms������������������access control and permission checking
> > > �pipe�������������������pipe functionality
> > > diff --git a/tests/xfs/547 b/tests/xfs/547
> > > new file mode 100755
> > > index 00000000..5c7d1d45
> > > --- /dev/null
> > > +++ b/tests/xfs/547
> > > @@ -0,0 +1,126 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022, Oracle and/or its affiliates.� All Rights
> > > Reserved.
> > > +#
> > > +# FS QA Test 547
> > > +#
> > > +# simple parent pointer test
> > > +#
> > > +
> > > +. ./common/preamble
> > > +_begin_fstest auto quick parent
> > > +
> > > +cleanup()
> > > +{
> > > +�������cd /
> > > +�������rm -f $tmp.*
> > > +�������echo 0 > /sys/fs/xfs/debug/larp
> > > +}
> > > +
> > > +full()
> > > +{
> > > +��� echo ""����������� >>$seqres.full
> > > +��� echo "*** $* ***"� >>$seqres.full
> > > +��� echo ""����������� >>$seqres.full
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/filter
> > > +. ./common/reflink
> > > +. ./common/inject
> > > +. ./common/parent
> > > +
> > > +# Modify as appropriate
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_require_xfs_sysfs debug/larp
> > > +_require_xfs_io_error_injection "larp"
> > > +
> > > +echo 1 > /sys/fs/xfs/debug/larp

I remembered last time you backup the value of the xfs/debug/larp, then restore
it in cleanup, refer to xfs/018 (it might be recommended by Dave?).

> > > +
> > > +# real QA test starts here
> > > +
> > > +# Create a directory tree using a protofile and
> > > +# make sure all inodes created have parent pointers
> > > +
> > > +protofile=$tmp.proto
> > > +
> > > +cat >$protofile <<EOF
> > > +DUMMY1
> > > +0 0
> > > +: root directory
> > > +d--777 3 1
> > > +: a directory
> > > +testfolder1 d--755 3 1
> > > +file1 ---755 3 1 /dev/null
> > > +$
> > > +: back in the root
> > > +testfolder2 d--755 3 1
> > > +file2 ---755 3 1 /dev/null
> > > +: done
> > > +$
> > > +EOF
> > > +
> > > +if [ $? -ne 0 ]
> > > +then
> > > +��� _fail "failed to create test protofile"
> > > +fi
> > > +
> > > +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
> > > +�������|| _fail "mkfs failed"
> > 
> > I think we'd better to check if current fs userspace and kernel
> > support
> > "parent" feature. If it's supported, then we should report failure if
> > mkfs fails. Or we should skip the test before real testing start.
> > (same
> > below)
> Alrighty, we can add a _require_xfs_mkfs_parent function over in
> common/xfs

I'm wondering if old kernel can mount xfs with "parent=1"? If not, we need
a _require_xfs_parent. For example we have below 3 function in common/xfs:

_require_xfs_mkfs_crc : check if current mkfs.xfs support crc=1 option
_require_xfs_crc : check if current kernel can mount a xfs with crc=1
_require_scratch_xfs_crc : check if current SCRATCH_DEV is crc enabled

As the parent feature isn't big as crc feature, so I think you can refer
to _require_xfs_sparse_inodes or _require_xfs_nrext64, check mkfs and kernel
support parent feature in one function. Then you can use:

  _require_xfs_parent # check mkfs and kernel/mount support parent feature
  _require_xfs_io_command parent # check if xfs_io support parent command

at the beginning of each cases.



Thanks,
Zorro

> 
> Thanks for the reviews!
> Allison
> 
> > 
> > Thanks,
> > Zorro
> > 
> > > +_check_scratch_fs
> > > +
> > > +_scratch_mount >>$seqres.full 2>&1 \
> > > +�������|| _fail "mount failed"
> > > +
> > > +testfolder1="testfolder1"
> > > +testfolder2="testfolder2"
> > > +file1="file1"
> > > +file2="file2"
> > > +file3="file3"
> > > +file4="file4"
> > > +file5="file5"
> > > +file1_ln="file1_link"
> > > +
> > > +echo ""
> > > +# Create parent pointer test
> > > +_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1"
> > > +
> > > +echo ""
> > > +# Move parent pointer test
> > > +mv $SCRATCH_MNT/$testfolder1/$file1
> > > $SCRATCH_MNT/$testfolder2/$file1
> > > +_verify_parent "$testfolder2" "$file1" "$testfolder2/$file1"
> > > +
> > > +echo ""
> > > +# Hard link parent pointer test
> > > +ln $SCRATCH_MNT/$testfolder2/$file1
> > > $SCRATCH_MNT/$testfolder1/$file1_ln
> > > +_verify_parent "$testfolder1" "$file1_ln"�
> > > "$testfolder1/$file1_ln"
> > > +_verify_parent "$testfolder1" "$file1_ln"� "$testfolder2/$file1"
> > > +_verify_parent "$testfolder2" "$file1"����
> > > "$testfolder1/$file1_ln"
> > > +_verify_parent "$testfolder2" "$file1"���� "$testfolder2/$file1"
> > > +
> > > +echo ""
> > > +# Remove hard link parent pointer test
> > > +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file1)"
> > > +rm $SCRATCH_MNT/$testfolder2/$file1
> > > +_verify_parent��� "$testfolder1" "$file1_ln"
> > > "$testfolder1/$file1_ln"
> > > +_verify_no_parent "$file1" "$ino" "$testfolder1/$file1_ln"
> > > +
> > > +echo ""
> > > +# Rename parent pointer test
> > > +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln)"
> > > +mv $SCRATCH_MNT/$testfolder1/$file1_ln
> > > $SCRATCH_MNT/$testfolder1/$file2
> > > +_verify_parent��� "$testfolder1" "$file2"��� "$testfolder1/$file2"
> > > +_verify_no_parent "$file1_ln" "$ino" "$testfolder1/$file2"
> > > +
> > > +echo ""
> > > +# Over write parent pointer test
> > > +touch $SCRATCH_MNT/$testfolder2/$file3
> > > +_verify_parent��� "$testfolder2" "$file3"��� "$testfolder2/$file3"
> > > +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file3)"
> > > +mv -f $SCRATCH_MNT/$testfolder2/$file3
> > > $SCRATCH_MNT/$testfolder1/$file2
> > > +_verify_parent��� "$testfolder1" "$file2"��� "$testfolder1/$file2"
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/547.out b/tests/xfs/547.out
> > > new file mode 100644
> > > index 00000000..e0ce9e65
> > > --- /dev/null
> > > +++ b/tests/xfs/547.out
> > > @@ -0,0 +1,59 @@
> > > +QA output created by 547
> > > +
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +
> > > +*** testfolder2 OK
> > > +*** testfolder2/file1 OK
> > > +*** testfolder2/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder2/file1
> > > +
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link OK
> > > +*** testfolder1/file1_link OK
> > > +*** Verified parent pointer: name:file1_link, namelen:10
> > > +*** Parent pointer OK for child testfolder1/file1_link
> > > +*** testfolder1 OK
> > > +*** testfolder2/file1 OK
> > > +*** testfolder1/file1_link OK
> > > +*** Verified parent pointer: name:file1_link, namelen:10
> > > +*** Parent pointer OK for child testfolder2/file1
> > > +*** testfolder2 OK
> > > +*** testfolder1/file1_link OK
> > > +*** testfolder2/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link
> > > +*** testfolder2 OK
> > > +*** testfolder2/file1 OK
> > > +*** testfolder2/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder2/file1
> > > +
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link OK
> > > +*** testfolder1/file1_link OK
> > > +*** Verified parent pointer: name:file1_link, namelen:10
> > > +*** Parent pointer OK for child testfolder1/file1_link
> > > +*** testfolder1/file1_link OK
> > > +
> > > +*** testfolder1 OK
> > > +*** testfolder1/file2 OK
> > > +*** testfolder1/file2 OK
> > > +*** Verified parent pointer: name:file2, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file2
> > > +*** testfolder1/file2 OK
> > > +
> > > +*** testfolder2 OK
> > > +*** testfolder2/file3 OK
> > > +*** testfolder2/file3 OK
> > > +*** Verified parent pointer: name:file3, namelen:5
> > > +*** Parent pointer OK for child testfolder2/file3
> > > +*** testfolder1 OK
> > > +*** testfolder1/file2 OK
> > > +*** testfolder1/file2 OK
> > > +*** Verified parent pointer: name:file2, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file2
> > > diff --git a/tests/xfs/548 b/tests/xfs/548
> > > new file mode 100755
> > > index 00000000..229d871a
> > > --- /dev/null
> > > +++ b/tests/xfs/548
> > > @@ -0,0 +1,97 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022, Oracle and/or its affiliates.� All Rights
> > > Reserved.
> > > +#
> > > +# FS QA Test 548
> > > +#
> > > +# multi link parent pointer test
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick parent
> > > +
> > > +cleanup()
> > > +{
> > > +�������cd /
> > > +�������rm -f $tmp.*
> > > +�������echo 0 > /sys/fs/xfs/debug/larp
> > > +}
> > > +
> > > +full()
> > > +{
> > > +��� echo ""����������� >>$seqres.full
> > > +��� echo "*** $* ***"� >>$seqres.full
> > > +��� echo ""����������� >>$seqres.full
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/filter
> > > +. ./common/reflink
> > > +. ./common/inject
> > > +. ./common/parent
> > > +
> > > +# Modify as appropriate
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_require_xfs_io_error_injection "larp"
> > > +_require_xfs_sysfs debug/larp
> > > +
> > > +echo 1 > /sys/fs/xfs/debug/larp
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Create a directory tree using a protofile and
> > > +# make sure all inodes created have parent pointers
> > > +
> > > +protofile=$tmp.proto
> > > +
> > > +cat >$protofile <<EOF
> > > +DUMMY1
> > > +0 0
> > > +: root directory
> > > +d--777 3 1
> > > +: a directory
> > > +testfolder1 d--755 3 1
> > > +file1 ---755 3 1 /dev/null
> > > +: done
> > > +$
> > > +EOF
> > > +
> > > +if [ $? -ne 0 ]
> > > +then
> > > +��� _fail "failed to create test protofile"
> > > +fi
> > > +
> > > +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqresres.full 2>&1
> > > \
> > > +�������|| _fail "mkfs failed"
> > > +_check_scratch_fs
> > > +
> > > +_scratch_mount >>$seqres.full 2>&1 \
> > > +�������|| _fail "mount failed"
> > > +
> > > +testfolder1="testfolder1"
> > > +testfolder2="testfolder2"
> > > +file1="file1"
> > > +file2="file2"
> > > +file3="file3"
> > > +file4="file4"
> > > +file5="file5"
> > > +file1_ln="file1_link"
> > > +
> > > +echo ""
> > > +# Multi link parent pointer test
> > > +NLINKS=100
> > > +for (( j=0; j<$NLINKS; j++ )); do
> > > +�������ln $SCRATCH_MNT/$testfolder1/$file1
> > > $SCRATCH_MNT/$testfolder1/$file1_ln.$j
> > > +�������_verify_parent��� "$testfolder1" "$file1_ln.$j"���
> > > "$testfolder1/$file1"
> > > +�������_verify_parent��� "$testfolder1" "$file1"���������
> > > "$testfolder1/$file1_ln.$j"
> > > +done
> > > +# Multi unlink parent pointer test
> > > +for (( j=$NLINKS-1; j<=0; j-- )); do
> > > +�������ino="$(stat -c '%i'
> > > $SCRATCH_MNT/$testfolder1/$file1_ln.$j)"
> > > +�������rm $SCRATCH_MNT/$testfolder1/$file1_ln.$j
> > > +�������_verify_no_parent "$file1_ln.$j" "$ino"
> > > "$testfolder1/$file1"
> > > +done
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/548.out b/tests/xfs/548.out
> > > new file mode 100644
> > > index 00000000..afdc083b
> > > --- /dev/null
> > > +++ b/tests/xfs/548.out
> > > @@ -0,0 +1,1002 @@
> > > +QA output created by 548
> > > +
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.0 OK
> > > +*** Verified parent pointer: name:file1_link.0, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.0 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.0
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.1 OK
> > > +*** Verified parent pointer: name:file1_link.1, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.1 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.2 OK
> > > +*** Verified parent pointer: name:file1_link.2, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.2 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.2
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.3 OK
> > > +*** Verified parent pointer: name:file1_link.3, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.3 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.3
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.4 OK
> > > +*** Verified parent pointer: name:file1_link.4, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.4 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.4
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.5 OK
> > > +*** Verified parent pointer: name:file1_link.5, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.5 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.5
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.6 OK
> > > +*** Verified parent pointer: name:file1_link.6, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.6 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.6
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.7 OK
> > > +*** Verified parent pointer: name:file1_link.7, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.7 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.7
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.8 OK
> > > +*** Verified parent pointer: name:file1_link.8, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.8 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.8
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.9 OK
> > > +*** Verified parent pointer: name:file1_link.9, namelen:12
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.9 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.9
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.10 OK
> > > +*** Verified parent pointer: name:file1_link.10, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.10 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.10
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.11 OK
> > > +*** Verified parent pointer: name:file1_link.11, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.11 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.11
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.12 OK
> > > +*** Verified parent pointer: name:file1_link.12, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.12 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.12
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.13 OK
> > > +*** Verified parent pointer: name:file1_link.13, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.13 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.13
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.14 OK
> > > +*** Verified parent pointer: name:file1_link.14, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.14 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.14
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.15 OK
> > > +*** Verified parent pointer: name:file1_link.15, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.15 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.15
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.16 OK
> > > +*** Verified parent pointer: name:file1_link.16, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.16 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.16
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.17 OK
> > > +*** Verified parent pointer: name:file1_link.17, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.17 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.17
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.18 OK
> > > +*** Verified parent pointer: name:file1_link.18, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.18 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.18
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.19 OK
> > > +*** Verified parent pointer: name:file1_link.19, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.19 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.19
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.20 OK
> > > +*** Verified parent pointer: name:file1_link.20, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.20 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.20
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.21 OK
> > > +*** Verified parent pointer: name:file1_link.21, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.21 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.21
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.22 OK
> > > +*** Verified parent pointer: name:file1_link.22, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.22 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.22
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.23 OK
> > > +*** Verified parent pointer: name:file1_link.23, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.23 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.23
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.24 OK
> > > +*** Verified parent pointer: name:file1_link.24, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.24 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.24
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.25 OK
> > > +*** Verified parent pointer: name:file1_link.25, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.25 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.25
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.26 OK
> > > +*** Verified parent pointer: name:file1_link.26, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.26 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.26
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.27 OK
> > > +*** Verified parent pointer: name:file1_link.27, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.27 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.27
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.28 OK
> > > +*** Verified parent pointer: name:file1_link.28, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.28 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.28
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.29 OK
> > > +*** Verified parent pointer: name:file1_link.29, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.29 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.29
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.30 OK
> > > +*** Verified parent pointer: name:file1_link.30, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.30 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.30
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.31 OK
> > > +*** Verified parent pointer: name:file1_link.31, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.31 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.31
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.32 OK
> > > +*** Verified parent pointer: name:file1_link.32, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.32 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.32
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.33 OK
> > > +*** Verified parent pointer: name:file1_link.33, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.33 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.33
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.34 OK
> > > +*** Verified parent pointer: name:file1_link.34, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.34 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.34
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.35 OK
> > > +*** Verified parent pointer: name:file1_link.35, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.35 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.35
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.36 OK
> > > +*** Verified parent pointer: name:file1_link.36, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.36 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.36
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.37 OK
> > > +*** Verified parent pointer: name:file1_link.37, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.37 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.37
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.38 OK
> > > +*** Verified parent pointer: name:file1_link.38, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.38 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.38
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.39 OK
> > > +*** Verified parent pointer: name:file1_link.39, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.39 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.39
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.40 OK
> > > +*** Verified parent pointer: name:file1_link.40, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.40 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.40
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.41 OK
> > > +*** Verified parent pointer: name:file1_link.41, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.41 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.41
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.42 OK
> > > +*** Verified parent pointer: name:file1_link.42, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.42 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.42
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.43 OK
> > > +*** Verified parent pointer: name:file1_link.43, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.43 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.43
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.44 OK
> > > +*** Verified parent pointer: name:file1_link.44, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.44 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.44
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.45 OK
> > > +*** Verified parent pointer: name:file1_link.45, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.45 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.45
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.46 OK
> > > +*** Verified parent pointer: name:file1_link.46, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.46 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.46
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.47 OK
> > > +*** Verified parent pointer: name:file1_link.47, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.47 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.47
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.48 OK
> > > +*** Verified parent pointer: name:file1_link.48, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.48 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.48
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.49 OK
> > > +*** Verified parent pointer: name:file1_link.49, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.49 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.49
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.50 OK
> > > +*** Verified parent pointer: name:file1_link.50, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.50 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.50
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.51 OK
> > > +*** Verified parent pointer: name:file1_link.51, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.51 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.51
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.52 OK
> > > +*** Verified parent pointer: name:file1_link.52, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.52 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.52
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.53 OK
> > > +*** Verified parent pointer: name:file1_link.53, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.53 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.53
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.54 OK
> > > +*** Verified parent pointer: name:file1_link.54, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.54 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.54
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.55 OK
> > > +*** Verified parent pointer: name:file1_link.55, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.55 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.55
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.56 OK
> > > +*** Verified parent pointer: name:file1_link.56, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.56 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.56
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.57 OK
> > > +*** Verified parent pointer: name:file1_link.57, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.57 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.57
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.58 OK
> > > +*** Verified parent pointer: name:file1_link.58, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.58 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.58
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.59 OK
> > > +*** Verified parent pointer: name:file1_link.59, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.59 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.59
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.60 OK
> > > +*** Verified parent pointer: name:file1_link.60, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.60 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.60
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.61 OK
> > > +*** Verified parent pointer: name:file1_link.61, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.61 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.61
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.62 OK
> > > +*** Verified parent pointer: name:file1_link.62, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.62 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.62
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.63 OK
> > > +*** Verified parent pointer: name:file1_link.63, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.63 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.63
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.64 OK
> > > +*** Verified parent pointer: name:file1_link.64, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.64 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.64
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.65 OK
> > > +*** Verified parent pointer: name:file1_link.65, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.65 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.65
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.66 OK
> > > +*** Verified parent pointer: name:file1_link.66, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.66 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.66
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.67 OK
> > > +*** Verified parent pointer: name:file1_link.67, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.67 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.67
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.68 OK
> > > +*** Verified parent pointer: name:file1_link.68, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.68 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.68
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.69 OK
> > > +*** Verified parent pointer: name:file1_link.69, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.69 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.69
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.70 OK
> > > +*** Verified parent pointer: name:file1_link.70, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.70 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.70
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.71 OK
> > > +*** Verified parent pointer: name:file1_link.71, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.71 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.71
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.72 OK
> > > +*** Verified parent pointer: name:file1_link.72, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.72 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.72
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.73 OK
> > > +*** Verified parent pointer: name:file1_link.73, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.73 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.73
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.74 OK
> > > +*** Verified parent pointer: name:file1_link.74, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.74 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.74
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.75 OK
> > > +*** Verified parent pointer: name:file1_link.75, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.75 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.75
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.76 OK
> > > +*** Verified parent pointer: name:file1_link.76, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.76 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.76
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.77 OK
> > > +*** Verified parent pointer: name:file1_link.77, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.77 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.77
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.78 OK
> > > +*** Verified parent pointer: name:file1_link.78, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.78 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.78
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.79 OK
> > > +*** Verified parent pointer: name:file1_link.79, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.79 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.79
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.80 OK
> > > +*** Verified parent pointer: name:file1_link.80, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.80 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.80
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.81 OK
> > > +*** Verified parent pointer: name:file1_link.81, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.81 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.81
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.82 OK
> > > +*** Verified parent pointer: name:file1_link.82, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.82 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.82
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.83 OK
> > > +*** Verified parent pointer: name:file1_link.83, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.83 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.83
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.84 OK
> > > +*** Verified parent pointer: name:file1_link.84, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.84 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.84
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.85 OK
> > > +*** Verified parent pointer: name:file1_link.85, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.85 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.85
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.86 OK
> > > +*** Verified parent pointer: name:file1_link.86, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.86 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.86
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.87 OK
> > > +*** Verified parent pointer: name:file1_link.87, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.87 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.87
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.88 OK
> > > +*** Verified parent pointer: name:file1_link.88, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.88 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.88
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.89 OK
> > > +*** Verified parent pointer: name:file1_link.89, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.89 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.89
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.90 OK
> > > +*** Verified parent pointer: name:file1_link.90, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.90 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.90
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.91 OK
> > > +*** Verified parent pointer: name:file1_link.91, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.91 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.91
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.92 OK
> > > +*** Verified parent pointer: name:file1_link.92, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.92 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.92
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.93 OK
> > > +*** Verified parent pointer: name:file1_link.93, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.93 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.93
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.94 OK
> > > +*** Verified parent pointer: name:file1_link.94, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.94 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.94
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.95 OK
> > > +*** Verified parent pointer: name:file1_link.95, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.95 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.95
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.96 OK
> > > +*** Verified parent pointer: name:file1_link.96, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.96 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.96
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.97 OK
> > > +*** Verified parent pointer: name:file1_link.97, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.97 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.97
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.98 OK
> > > +*** Verified parent pointer: name:file1_link.98, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.98 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.98
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1 OK
> > > +*** testfolder1/file1_link.99 OK
> > > +*** Verified parent pointer: name:file1_link.99, namelen:13
> > > +*** Parent pointer OK for child testfolder1/file1
> > > +*** testfolder1 OK
> > > +*** testfolder1/file1_link.99 OK
> > > +*** testfolder1/file1 OK
> > > +*** Verified parent pointer: name:file1, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file1_link.99
> > > diff --git a/tests/xfs/549 b/tests/xfs/549
> > > new file mode 100755
> > > index 00000000..e8e74b8a
> > > --- /dev/null
> > > +++ b/tests/xfs/549
> > > @@ -0,0 +1,110 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022, Oracle and/or its affiliates.� All Rights
> > > Reserved.
> > > +#
> > > +# FS QA Test 549
> > > +#
> > > +# parent pointer inject test
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick parent
> > > +
> > > +cleanup()
> > > +{
> > > +�������cd /
> > > +�������rm -f $tmp.*
> > > +�������echo 0 > /sys/fs/xfs/debug/larp
> > > +}
> > > +
> > > +full()
> > > +{
> > > +��� echo ""����������� >>$seqres.full
> > > +��� echo "*** $* ***"� >>$seqres.full
> > > +��� echo ""����������� >>$seqres.full
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/filter
> > > +. ./common/reflink
> > > +. ./common/inject
> > > +. ./common/parent
> > > +
> > > +# Modify as appropriate
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_require_xfs_sysfs debug/larp
> > > +_require_xfs_io_error_injection "larp"
> > > +
> > > +echo 1 > /sys/fs/xfs/debug/larp
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Create a directory tree using a protofile and
> > > +# make sure all inodes created have parent pointers
> > > +
> > > +protofile=$tmp.proto
> > > +
> > > +cat >$protofile <<EOF
> > > +DUMMY1
> > > +0 0
> > > +: root directory
> > > +d--777 3 1
> > > +: a directory
> > > +testfolder1 d--755 3 1
> > > +file1 ---755 3 1 /dev/null
> > > +$
> > > +: back in the root
> > > +testfolder2 d--755 3 1
> > > +file2 ---755 3 1 /dev/null
> > > +: done
> > > +$
> > > +EOF
> > > +
> > > +if [ $? -ne 0 ]
> > > +then
> > > +��� _fail "failed to create test protofile"
> > > +fi
> > > +
> > > +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
> > > +�������|| _fail "mkfs failed"
> > > +_check_scratch_fs
> > > +
> > > +_scratch_mount >>$seqres.full 2>&1 \
> > > +�������|| _fail "mount failed"
> > > +
> > > +testfolder1="testfolder1"
> > > +testfolder2="testfolder2"
> > > +file1="file1"
> > > +file2="file2"
> > > +file3="file3"
> > > +file4="file4"
> > > +file5="file5"
> > > +file1_ln="file1_link"
> > > +
> > > +echo ""
> > > +
> > > +# Create files
> > > +touch $SCRATCH_MNT/$testfolder1/$file4
> > > +_verify_parent��� "$testfolder1" "$file4" "$testfolder1/$file4"
> > > +
> > > +# Inject error
> > > +_scratch_inject_error "larp"
> > > +
> > > +# Move files
> > > +mv $SCRATCH_MNT/$testfolder1/$file4
> > > $SCRATCH_MNT/$testfolder2/$file5 2>&1 | _filter_scratch
> > > +
> > > +# FS should be shut down, touch will fail
> > > +touch $SCRATCH_MNT/$testfolder2/$file5 2>&1 | _filter_scratch
> > > +
> > > +# Remount to replay log
> > > +_scratch_remount_dump_log >> $seqres.full
> > > +
> > > +# FS should be online, touch should succeed
> > > +touch $SCRATCH_MNT/$testfolder2/$file5
> > > +
> > > +# Check files again
> > > +_verify_parent��� "$testfolder2" "$file5" "$testfolder2/$file5"
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/549.out b/tests/xfs/549.out
> > > new file mode 100644
> > > index 00000000..1af49c73
> > > --- /dev/null
> > > +++ b/tests/xfs/549.out
> > > @@ -0,0 +1,14 @@
> > > +QA output created by 549
> > > +
> > > +*** testfolder1 OK
> > > +*** testfolder1/file4 OK
> > > +*** testfolder1/file4 OK
> > > +*** Verified parent pointer: name:file4, namelen:5
> > > +*** Parent pointer OK for child testfolder1/file4
> > > +mv: cannot stat 'SCRATCH_MNT/testfolder1/file4': Input/output
> > > error
> > > +touch: cannot touch 'SCRATCH_MNT/testfolder2/file5': Input/output
> > > error
> > > +*** testfolder2 OK
> > > +*** testfolder2/file5 OK
> > > +*** testfolder2/file5 OK
> > > +*** Verified parent pointer: name:file5, namelen:5
> > > +*** Parent pointer OK for child testfolder2/file5
> > > -- 
> > > 2.25.1
> > > 
> > 
> 

