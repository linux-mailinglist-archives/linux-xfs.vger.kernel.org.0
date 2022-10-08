Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDA65F8238
	for <lists+linux-xfs@lfdr.de>; Sat,  8 Oct 2022 03:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiJHB7r (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Oct 2022 21:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiJHB7m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2022 21:59:42 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAB695BE;
        Fri,  7 Oct 2022 18:59:38 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id mg6so4125299qvb.10;
        Fri, 07 Oct 2022 18:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LCWqk8XNjUEog+dpKmkrThcl3iV6GkMHD85IOWg1CLI=;
        b=lG29NiYAk2ZwwkOirO1RUHbQw1SNzK3+7J2Gny3ZFiwlvS3AqCI209/V3/aPNROS4B
         hvKmtqEiNFeafAeJ8HP05g+D4AVWcMU4rXbVTEU+idNLg8HHJKe/LaFeNn4Jxa7O82QF
         L7FyYir5Hu/cWwMTL+yV4FvkZHcCDjXc/QCx0RG6pAsW/GGpnhb2a8IX9//nX2+VdUMP
         aaPQInrY/B4Y7DwJANHZF5oodxJ+ktgBynxeL7EvzqOzF1l067LF0JU00/z0lZDjafu5
         sZu3M2knn+4Ofos7WOLAh8S7eK0m01r83xrHq7AV/5NjVJ8iRRfH57yxBOMmlYzW4nRT
         oElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LCWqk8XNjUEog+dpKmkrThcl3iV6GkMHD85IOWg1CLI=;
        b=q4PWaK2+QkanU0rhLi35NoZ08zZZCkyBJUXUsavTAuUUwOMy5TLYuIoTXWZoG9zJAA
         aBjqVq7tLsUTH5/Yfm2bB/69Nv9jeMwwvuj54ptaLRtoG/fVHC0/O4RPKAdxSGWsg3G6
         vegN8TD9GzeU2pNOV/gy0KhpNOUJW5gWd0Rnk/gHQV/U1SlhckdcZf73B1MKv+tmlsaC
         E73QxcqSiTwIWCOI2GiqoTu1q2WVVL3IzVFJaFbZz70Rw1/KA6ZIzXJBUySf0aGG6XdO
         JAMRttqlZYrth/4y2HWV4q12bzYUGMDlvX/iwZ4beK5o5uF+2z/cItRTHs6LwUyrrHHy
         drmA==
X-Gm-Message-State: ACrzQf0aDf5YQz5AySXiDdHEzZNTYLujORNvrzafGKiqL2sfQ00mex1F
        I3iwQEl00Bvj0tMxi3gPKWFUQXePDt+WvwQo
X-Google-Smtp-Source: AMsMyM6BjVeoi5nZRaTKer0XL0QijW1CKJvG89t1vQxjJCU6jIkZXTFnuSAgvEAWKMY0d3zVs+kkpA==
X-Received: by 2002:ad4:5765:0:b0:4b1:bf78:83cd with SMTP id r5-20020ad45765000000b004b1bf7883cdmr6375725qvx.81.1665194377691;
        Fri, 07 Oct 2022 18:59:37 -0700 (PDT)
Received: from ?IPV6:2601:18f:801:e210:abfc:537a:d62c:c353? ([2601:18f:801:e210:abfc:537a:d62c:c353])
        by smtp.gmail.com with ESMTPSA id w3-20020ac84d03000000b0039014fd4b9bsm3236347qtv.47.2022.10.07.18.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 18:59:37 -0700 (PDT)
Message-ID: <fe8aa034-ec20-f316-ae03-33f52ecc3001@gmail.com>
Date:   Fri, 7 Oct 2022 21:59:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH] xfs: test for fixing wrong root inode number
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Hironori Shiina <shiina.hironori@fujitsu.com>
References: <20220928210337.417054-1-shiina.hironori@fujitsu.com>
 <20220929014955.pxou2qymdumvijtt@zlang-mailbox>
 <eae39d48-1fc1-09dc-7f5e-b1112c880584@gmail.com>
 <20221002042708.fshgqyqyhidgsx7z@zlang-mailbox> <Yztcg/8nbS0BDedf@magnolia>
From:   Hironori Shiina <shiina.hironori@gmail.com>
In-Reply-To: <Yztcg/8nbS0BDedf@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/3/22 18:04, Darrick J. Wong wrote:
> On Sun, Oct 02, 2022 at 12:27:08PM +0800, Zorro Lang wrote:
>> On Fri, Sep 30, 2022 at 11:01:51AM -0400, Hironori Shiina wrote:
>>>
>>>
>>> On 9/28/22 21:49, Zorro Lang wrote:
>>>> On Wed, Sep 28, 2022 at 05:03:37PM -0400, Hironori Shiina wrote:
>>>>> Test '-x' option of xfsrestore. With this option, a wrong root inode
>>>>> number is corrected. A root inode number can be wrong in a dump created
>>>>> by problematic xfsdump (v3.1.7 - v3.1.9) with blukstat misuse. This
>>>>> patch adds a dump with a wrong inode number created by xfsdump 3.1.8.
>>>>>
>>>>> Link: https://lore.kernel.org/linux-xfs/20201113125127.966243-1-hsiangkao@redhat.com/
>>>>> Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
>>>>> ---
>>>>>  common/dump                    |   2 +-
>>>>>  src/root-inode-broken-dumpfile | Bin 0 -> 21648 bytes
>>>>>  tests/xfs/554                  |  37 +++++++++++++++++++++
>>>>>  tests/xfs/554.out              |  57 +++++++++++++++++++++++++++++++++
>>>>>  4 files changed, 95 insertions(+), 1 deletion(-)
>>>>>  create mode 100644 src/root-inode-broken-dumpfile
>>>>>  create mode 100644 tests/xfs/554
>>>>>  create mode 100644 tests/xfs/554.out
>>>>>
>>>>> diff --git a/common/dump b/common/dump
>>>>> index 8e0446d9..50b2ba03 100644
>>>>> --- a/common/dump
>>>>> +++ b/common/dump
>>>>> @@ -1003,7 +1003,7 @@ _parse_restore_args()
>>>>>          --no-check-quota)
>>>>>              do_quota_check=false
>>>>>              ;;
>>>>> -	-K|-R)
>>>>> +	-K|-R|-x)
>>>>>  	    restore_args="$restore_args $1"
>>>>>              ;;
>>>>>  	*)
>>>>> diff --git a/src/root-inode-broken-dumpfile b/src/root-inode-broken-dumpfile
>>>>> new file mode 100644
>>>>> index 0000000000000000000000000000000000000000..9a42e65d8047497be31f3abbaf4223ae384fd14d
>>>>> GIT binary patch
>>>>> literal 21648
>>>>> zcmeI)K}ge49KiAC_J<CEBr!0AwBf~zbCHB}5DyxL6eU8Jnqylvayj;2VuG+d)TN6;
>>>>> z5J8vlAaw9hXi(UousT$Sin@BRJfwHM)O+*2*njz_zc+h*ckuV#@BMuKe;;JbgTL{<
>>>>> z!SwZ9zC#ERe%reLe5&cz2e}qM<!i2dXQHt^{^`d1Qx{)MMzW#$%dR@J={0`IRsGx4
>>>>> z(yn@Oi-nBqCOVIG?&{kpwnv~&w_>6_ozY1^fph=w8(=^oTg&wOe=(WQByyQ_Hfd|4
>>>>> z^o76<0!zn#v>k3blbU)nzx=KF^}-G%R;OaQYsHwGDkO`kD^@q^(_Ac_8H<gKj^>a0
>>>>> z6p*%BK>q#b>2EE%^!@f?Z`-p+tI@M}qmMm@zMJk>K1U^=d~G^NUG?X4vkvKtOf-3Y
>>>>> zpVM9YgM9Y7{*P0ApJNUh^uk1wCnA6V0tg_000IagfB*srAb<b@2q1s}0tg_000Iag
>>>>> zfB*srAb<b@2q1s}0tg_000IagfB*srAb<b@2q1s}0tg_000IagfB*srAb`MM1p>_h
>>>>> z2-R=Q9ooK1{l9<Dy8IIMUVXr9BW9uI1x7};j+kij|5kLI^32no;n|PvqD74ZOlJ#n
>>>>> z0-~CKSlx#liMS>jt232#==00xPqwp;gsZrjc?`PPxaCE~>3(^o5-%+Nj=HegJFK2b
>>>>> z=l5zT4IDgO=sJ1zp=jyrALvcQJK|j;sN2_jUmobjN<!S6m1{G<LZ^+JP;T!|3{9)w
>>>>> eGf&ioo}iw|li2&4IyG;z<}vrl)Mic2`t2{52##q0
>>>>>
>>>>> literal 0
>>>>> HcmV?d00001
>>>>
>>>> Please don't try to add a binary file to fstests directly.
>>>>
>>>>>
>>>>> diff --git a/tests/xfs/554 b/tests/xfs/554
>>>>> new file mode 100644
>>>>> index 00000000..13bc62c7
>>>>> --- /dev/null
>>>>> +++ b/tests/xfs/554
>>>>> @@ -0,0 +1,37 @@
>>>>> +#! /bin/bash
>>>>> +# SPDX-License-Identifier: GPL-2.0
>>>>> +# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
>>>>> +#
>>>>> +# FS QA Test No. 554
>>>>> +#
>>>>> +# Test restoring a dumpfile with a wrong root inode number created by
>>>>> +# xfsdump 3.1.8.
>>>>> +# This test restores the checked-in broken dump with '-x' flag.
>>>>> +#
>>>>> +
>>>>> +. ./common/preamble
>>>>> +_begin_fstest auto quick dump
>>>>> +
>>>>> +# Import common functions.
>>>>> +. ./common/dump
>>>>> +
>>>>> +# real QA test starts here
>>>>> +_supported_fs xfs
>>>>> +_require_scratch
>>>>
>>>> The -x option is a new feature for xfsdump, not all system support that. So
>>>> we need to _notrun if test on a system doesn't support it. A separated
>>>> _require_* helper would be better if there'll be more testing about this
>>>> new feature. Or a local detection in this case is fine too (can be moved as
>>>> a common helper later).
>>>>
>>>>> +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
>>>>> +_scratch_mount
>>>>> +
>>>>> +# Create dumpdir for comparing with restoredir
>>>>> +rm -rf $dump_dir
>>>>> +mkdir $dump_dir || _fail "failed to mkdir $restore_dir"
>>>>           ^^                                  ^^
>>>>
>>>> Are you trying to create a dump dir or restore dir?
>>>>
>>>>> +touch $dump_dir/FILE_1019
>>>>> +
>>>>> +_do_restore_toc -x -f $here/src/root-inode-broken-dumpfile
>>>>
>>>> Why I didn't see how you generate this broken dumpfile in this case?
>>>>
>>>> Oh... I see, you want to store a dumpfile in fstests source code directly.
>>>> I thought you submited that file accidentally...
>>>>
>>>> No, we don't do things like this way, please try to generate the dumpfile
>>>> in this test case at first, then restore it. For example using xfs_db to
>>>> break a xfs, or using some tricky method (likes xfs/545).
>>>>
>>>
>>> Thank you for the comments. I will try another approach. I'm having
>>> trouble creating a dumpfile for this test. Because xfsdump was already
>>> fixed, xfsdump no longer generates a corrupted dumpfile even if there is
>>> a lower inode number than a root inode.
>>
>> Oh, I see. You can try, but I think it's hard. It maybe not suitable to be a
>> fstests case, if it has to depend on a binary fs dump file. If so, We can cover
>> it on other place, with this existed "bad" dump file.
> 
> How difficult is it to create a dumpfile with a broken root inode?
> Is it a simple matter of creating a good dump and patching a few bytes,
> or do we end up having to patch the whole file?
> 
> (The reason I ask is that I've heard about this problem for ages but
> I don't actually know how to create a bad dump...)
> 

As I dug into the data structure, I succeeded in creating a dumpfile with a wrong
root inode by modifying `content_inode_hdr_t.cih_rootino` and
`global_hdr_t.gh_checksum`.

After creating a inode with a lower number than the root inode with the method in
generic/545, I modified a dumpfile as follows:
---
_do_dump_file

# Break dumpfile
old_checksum=$(od -A n -j 12 -N 4 -i --endian=big $dump_file)
gap=$(($root_inum - $inum))
new_checksum=$(($old_checksum + ($gap >> 32) + ($gap & 0x00000000ffffffff)))
v=($(printf "%016x" $inum |  awk -v FS='' '{for (i=1; i<=NF; i+=2) print $i$(i+1)}'))
echo -en "\x${v[0]}\x${v[1]}\x${v[2]}\x${v[3]}\x${v[4]}\x${v[5]}\x${v[6]}\x${v[7]}" | dd of=$dump_file bs=1 seek=3928 conv=notrunc
v=($(printf "%016x" $new_checksum |  awk -v FS='' '{for (i=9; i<=NF; i+=2) print $i$(i+1)}'))
echo -en "\x${v[0]}\x${v[1]}\x${v[2]}\x${v[3]}" | dd of=$dump_file bs=1 seek=12 conv=notrunc

_do_restore_file -x
---
(I'm afraid I'm not so familiar with editing a binary file.)

The offset of `global_hdr_t.gh_checksum` is 12.
The offset of `content_inode_hdr_t.cih_rootino` is:
  global_hdr_t.gh_upper (0x400) + drive_hdr_t.dh_upper (0x400) + 
  media_hdr_t.mh_upper (0x400) + content_hdr_t.ch_specific (0x340) +
  content_inode_hdr_t.cih_rootino (0x18) = 0xf58 (3928)

Thanks,
Hiro

> --D
> 
>> Thanks,
>> Zorro
>>
>>>
>>>>> +
>>>>> +_do_restore_file -x -f $here/src/root-inode-broken-dumpfile -L stress_545
>>>>> +_diff_compare_sub
>>>>> +_ls_nodate_compare_sub
>>>>> +
>>>>> +# success, all done
>>>>> +status=0
>>>>> +exit
>>>>> diff --git a/tests/xfs/554.out b/tests/xfs/554.out
>>>>> new file mode 100644
>>>>> index 00000000..40a3f3a4
>>>>> --- /dev/null
>>>>> +++ b/tests/xfs/554.out
>>>>> @@ -0,0 +1,57 @@
>>>>> +QA output created by 554
>>>>> +Contents of dump ...
>>>>> +xfsrestore  -x -f DUMP_FILE -t
>>>>> +xfsrestore: using file dump (drive_simple) strategy
>>>>> +xfsrestore: searching media for dump
>>>>> +xfsrestore: examining media file 0
>>>>> +xfsrestore: dump description: 
>>>>> +xfsrestore: hostname: xfsdump
>>>>> +xfsrestore: mount point: SCRATCH_MNT
>>>>> +xfsrestore: volume: SCRATCH_DEV
>>>>> +xfsrestore: session time: TIME
>>>>> +xfsrestore: level: 0
>>>>> +xfsrestore: session label: "stress_545"
>>>>> +xfsrestore: media label: "stress_tape_media"
>>>>> +xfsrestore: file system ID: ID
>>>>> +xfsrestore: session id: ID
>>>>> +xfsrestore: media ID: ID
>>>>> +xfsrestore: searching media for directory dump
>>>>> +xfsrestore: reading directories
>>>>> +xfsrestore: found fake rootino #128, will fix.
>>>>> +xfsrestore: fix root # to 1024 (bind mount?)
>>>>> +xfsrestore: 2 directories and 2 entries processed
>>>>> +xfsrestore: directory post-processing
>>>>> +xfsrestore: reading non-directory files
>>>>> +xfsrestore: table of contents display complete: SECS seconds elapsed
>>>>> +xfsrestore: Restore Status: SUCCESS
>>>>> +
>>>>> +dumpdir/FILE_1019
>>>>> +Restoring from file...
>>>>> +xfsrestore  -x -f DUMP_FILE  -L stress_545 RESTORE_DIR
>>>>> +xfsrestore: using file dump (drive_simple) strategy
>>>>> +xfsrestore: searching media for dump
>>>>> +xfsrestore: examining media file 0
>>>>> +xfsrestore: found dump matching specified label:
>>>>> +xfsrestore: hostname: xfsdump
>>>>> +xfsrestore: mount point: SCRATCH_MNT
>>>>> +xfsrestore: volume: SCRATCH_DEV
>>>>> +xfsrestore: session time: TIME
>>>>> +xfsrestore: level: 0
>>>>> +xfsrestore: session label: "stress_545"
>>>>> +xfsrestore: media label: "stress_tape_media"
>>>>> +xfsrestore: file system ID: ID
>>>>> +xfsrestore: session id: ID
>>>>> +xfsrestore: media ID: ID
>>>>> +xfsrestore: searching media for directory dump
>>>>> +xfsrestore: reading directories
>>>>> +xfsrestore: found fake rootino #128, will fix.
>>>>> +xfsrestore: fix root # to 1024 (bind mount?)
>>>>> +xfsrestore: 2 directories and 2 entries processed
>>>>> +xfsrestore: directory post-processing
>>>>> +xfsrestore: restoring non-directory files
>>>>> +xfsrestore: restore complete: SECS seconds elapsed
>>>>> +xfsrestore: Restore Status: SUCCESS
>>>>> +Comparing dump directory with restore directory
>>>>> +Files DUMP_DIR/FILE_1019 and RESTORE_DIR/DUMP_SUBDIR/FILE_1019 are identical
>>>>> +Comparing listing of dump directory with restore directory
>>>>> +Files TMP.dump_dir and TMP.restore_dir are identical
>>>>> -- 
>>>>> 2.37.3
>>>>>
>>>>
>>>
>>
