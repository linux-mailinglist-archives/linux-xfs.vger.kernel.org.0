Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6049F5078B3
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Apr 2022 20:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357152AbiDSSZ7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Apr 2022 14:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357818AbiDSSXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 14:23:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A0AA45534
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 11:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650392223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mZMU64lLJz+DLIoQPpg8tp7U3zbnZPeU5GfMSx9OKtc=;
        b=aCFLz0b98nM1w/f+9yqGCMvauG7V3WY0xu0BvL2OWLdhWGi/RNxAJb+FzcS0StkPqjJ4wK
        F6TQ1+RB9tzoNCG87viArYtIWpQ37yb55IdPhJ+O3vIHz66rM28VFIt/tmnEjxdOl77igZ
        uwhrilw0l6pCghlF8ew3XeSA2khpTaM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-N6QFlKC8PFO7fxeL_AkPgg-1; Tue, 19 Apr 2022 14:17:02 -0400
X-MC-Unique: N6QFlKC8PFO7fxeL_AkPgg-1
Received: by mail-qt1-f199.google.com with SMTP id o2-20020ac86982000000b002f1d71c97b8so9613928qtq.2
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 11:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=mZMU64lLJz+DLIoQPpg8tp7U3zbnZPeU5GfMSx9OKtc=;
        b=3k+igfdXT/qp5kZhfRjipWenSo2xHt3Y5sDrk7pa4+G5C0jZ1DFNj4d+4vHiBpwg/S
         bxmz/UpWozL7VxnosQQ4Ukd06bReEbXbshat9FVxgBVzcoX6K64admr2HaaWuYKb6TzF
         ljvslI0KspomuTXpqvuvnqXt8FPjdTsAnNclekDBuIeIPNNTIVi6VeyVnXblj9S7qL2M
         s4xwRsii+4IL1DapTcIxlF5UNhZoOqspXiPry9bcxz5tF9o3duB1EIPhFLKQaPEtyIK5
         hhYkyDbm4Ey4rNbXu9+I9cdWKNhZt65v2qlp6vLa08G7hPobgk2h3s9k21gVelyVJ3eU
         ziyQ==
X-Gm-Message-State: AOAM531zAJjWhnFyLjT1i7XXvIs0zZgJECJTNHJzQ+6BIfQdfidFAy2E
        YUUrsvtXdzDtgqMQ86QlJV+wHF7bk84mnm+fzrEuVbtWgCo8ixIYyXeEnXlWAvAegc0eRsgBCz1
        Zc9s+Icl8WK/ZulxqXBJg
X-Received: by 2002:a05:6214:21af:b0:443:e253:61fa with SMTP id t15-20020a05621421af00b00443e25361famr12621488qvc.31.1650392221700;
        Tue, 19 Apr 2022 11:17:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoBfGLTIn9506U6AF4wkuByJTZxz4IyyPBElNbgdAKxCWezo3/cDmpzuPjibk4ihwPnLrfkw==
X-Received: by 2002:a05:6214:21af:b0:443:e253:61fa with SMTP id t15-20020a05621421af00b00443e25361famr12621470qvc.31.1650392221392;
        Tue, 19 Apr 2022 11:17:01 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f16-20020a05622a105000b002ed4688f116sm418137qte.86.2022.04.19.11.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 11:17:00 -0700 (PDT)
Date:   Wed, 20 Apr 2022 02:16:54 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, sandeen@redhat.com
Subject: Re: [PATCH v3 1/2] fstests: remove _wipe_fs from dump testing
 entirely
Message-ID: <20220419181654.nhhrsreqrbzvwzau@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, sandeen@redhat.com
References: <20220418170326.425762-1-zlang@redhat.com>
 <20220418170326.425762-2-zlang@redhat.com>
 <20220419155630.GJ17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419155630.GJ17025@magnolia>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 08:56:30AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 19, 2022 at 01:03:25AM +0800, Zorro Lang wrote:
> > The _wipe_fs function in common/dump is a historical remnant of
> > xfstests, it's easy to cause confusion now. Now xfstests tend to
> > call `require_scratch && scratch_mkfs && scratch_mount` in each case
> > itself, we don't need to use a function to do that specially, so
> > remove _wipe_fs entirely.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >  common/dump   | 17 -----------------
> >  tests/xfs/022 |  3 +++
> >  tests/xfs/023 |  3 +++
> >  tests/xfs/024 |  3 +++
> >  tests/xfs/025 |  3 +++
> >  tests/xfs/026 |  3 +++
> >  tests/xfs/027 |  3 +++
> >  tests/xfs/028 |  7 +++----
> >  tests/xfs/035 |  3 +++
> >  tests/xfs/036 |  3 +++
> >  tests/xfs/037 |  3 +++
> >  tests/xfs/038 |  3 +++
> >  tests/xfs/039 |  3 +++
> >  tests/xfs/043 |  5 ++++-
> >  tests/xfs/046 |  3 +++
> >  tests/xfs/047 |  7 +++----
> >  tests/xfs/055 |  4 ++++
> >  tests/xfs/056 |  3 +++
> >  tests/xfs/059 |  3 +++
> >  tests/xfs/060 |  3 +++
> >  tests/xfs/061 |  3 +++
> >  tests/xfs/063 |  3 +++
> >  tests/xfs/064 |  3 +++
> >  tests/xfs/065 |  3 ++-
> >  tests/xfs/066 |  3 +++
> >  tests/xfs/068 |  3 +++
> >  tests/xfs/266 |  3 +++
> >  tests/xfs/267 |  4 +++-
> >  tests/xfs/268 |  4 +++-
> >  tests/xfs/281 |  4 +++-
> >  tests/xfs/282 |  4 +++-
> >  tests/xfs/283 |  4 +++-
> >  tests/xfs/296 |  4 ++--
> >  tests/xfs/301 |  2 ++
> >  tests/xfs/302 |  3 ++-
> >  35 files changed, 100 insertions(+), 35 deletions(-)
> > 
> > diff --git a/common/dump b/common/dump
> > index ea16d442..6de7dab4 100644
> > --- a/common/dump
> > +++ b/common/dump
> > @@ -217,14 +217,6 @@ _require_tape()
> >      _set_variable
> >  }
> >  
> > -_wipe_fs()
> > -{
> > -    _require_scratch
> > -
> > -    _scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > -    _scratch_mount >>$seqres.full
> > -}
> > -
> >  #
> >  # Cleanup created dirs and files
> >  # Called by trap
> > @@ -289,7 +281,6 @@ _create_dumpdir_stress_num()
> >      echo "Creating directory system to dump using fsstress."
> >  
> >      _count=$1
> > -    _wipe_fs
> 
> The _create_dumpdir* helpers no longer format and mount the filesystem?
> What about the case of xfs/035 where we write an fs, dump it, create
> *another* fs, dump that, and restore the second dump?  The scratch fs no
> longer gets reformatted, AFAICT.

Oh, I didn't notice that xfs/035 has another _create_dumpdir_fill2. How about
mkfs and mount SCRATCH_DEV again, before calling _create_dumpdir_fill2:
  _scratch_unmount
  _scratch_mkfs_xfs >>$seqres.full
  _scratch_mount

It might be also clear that the case re-create fs before _create_dumpdir_*.
I'll fix that in next version.

> 
> I think it's appropriate to move the _require_scratch to into the
> calling tests themselves, but I think the mkfs+mount should replace the
> _wipe_fs calls in all these helper functions.

I think the _create_dumpdir_* isn't necessary to be run on a clean filesystem
which just be mkfs. If a case need a clean filesystem, how about let them clean
it by themselves clearly :)

Thanks,
Zorro

> 
> --D
> 
> >  
> >      _param="-f link=10 -f creat=10 -f mkdir=10 -f truncate=5 -f symlink=10"
> >      rm -rf $dump_dir
> > @@ -567,7 +558,6 @@ End-of-File
> >  
> >  _create_dumpdir_largefile()
> >  {
> > -    _wipe_fs
> >      mkdir -p $dump_dir || _fail "cannot mkdir \"$dump_dir\""
> >      _largesize=4294967297
> >      _largefile=$dump_dir/largefile
> > @@ -579,7 +569,6 @@ _create_dumpdir_largefile()
> >  
> >  _create_dumpdir_fill()
> >  {
> > -    _wipe_fs
> >      _mk_fillconfig1
> >      _do_create_dumpdir_fill
> >      _stable_fs
> > @@ -587,7 +576,6 @@ _create_dumpdir_fill()
> >  
> >  _create_dumpdir_fill2()
> >  {
> > -    _wipe_fs
> >      _mk_fillconfig2
> >      _do_create_dumpdir_fill
> >      _stable_fs
> > @@ -595,7 +583,6 @@ _create_dumpdir_fill2()
> >  
> >  _create_dumpdir_fill_perm()
> >  {
> > -    _wipe_fs
> >      _mk_fillconfig_perm
> >      _do_create_dumpdir_fill
> >      _stable_fs
> > @@ -603,7 +590,6 @@ _create_dumpdir_fill_perm()
> >  
> >  _create_dumpdir_fill_ea()
> >  {
> > -    _wipe_fs
> >      _mk_fillconfig_ea
> >      _do_create_dumpdir_fill
> >      _stable_fs
> > @@ -615,7 +601,6 @@ _create_dumpdir_fill_ea()
> >  #
> >  _create_dumpdir_fill_multi()
> >  {
> > -    _wipe_fs
> >      _mk_fillconfig_multi
> >      _do_create_dumpdir_fill
> >      _stable_fs
> > @@ -720,7 +705,6 @@ End-of-File
> >  
> >  _create_dumpdir_symlinks()
> >  {
> > -    _wipe_fs
> >      _mk_symlink_config
> >      _do_create_dump_symlinks
> >      _stable_fs
> > @@ -771,7 +755,6 @@ _modify_level()
> >  _create_dumpdir_hardlinks()
> >  {
> >      _numsets=$1
> > -    _wipe_fs
> >      echo "Creating directory system of hardlinks to incrementally dump."
> >  
> >      mkdir -p $dump_dir || _fail "cannot mkdir \"$dump_dir\""
> > diff --git a/tests/xfs/022 b/tests/xfs/022
> > index 9334bc41..2f011b28 100755
> > --- a/tests/xfs/022
> > +++ b/tests/xfs/022
> > @@ -29,6 +29,9 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_tape $TAPE_DEV
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  # note: fsstress uses an endian dependent random number generator, running this
> >  # will produce different output for big/little endian machines.
> > diff --git a/tests/xfs/023 b/tests/xfs/023
> > index 1ff406a6..f6f6503a 100755
> > --- a/tests/xfs/023
> > +++ b/tests/xfs/023
> > @@ -28,6 +28,9 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_tape $TAPE_DEV
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  _create_dumpdir_fill
> >  _erase_hard
> >  _do_dump_sub
> > diff --git a/tests/xfs/024 b/tests/xfs/024
> > index a277c83f..83a8882c 100755
> > --- a/tests/xfs/024
> > +++ b/tests/xfs/024
> > @@ -26,6 +26,9 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_tape $TAPE_DEV
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  _create_dumpdir_fill
> >  # ensure file/dir timestamps precede dump timestamp
> >  sleep 2
> > diff --git a/tests/xfs/025 b/tests/xfs/025
> > index b7a5b3bb..bafe82d7 100755
> > --- a/tests/xfs/025
> > +++ b/tests/xfs/025
> > @@ -26,6 +26,9 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_tape $TAPE_DEV
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  _create_dumpdir_fill
> >  _erase_hard
> >  _do_dump_min
> > diff --git a/tests/xfs/026 b/tests/xfs/026
> > index 29ebb5aa..fba385dc 100755
> > --- a/tests/xfs/026
> > +++ b/tests/xfs/026
> > @@ -24,6 +24,9 @@ _cleanup()
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_dumpdir_fill
> >  _do_dump_file
> > diff --git a/tests/xfs/027 b/tests/xfs/027
> > index a0dcf8b3..16cd203d 100755
> > --- a/tests/xfs/027
> > +++ b/tests/xfs/027
> > @@ -24,6 +24,9 @@ _cleanup()
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_dumpdir_fill
> >  _do_dump_restore
> > diff --git a/tests/xfs/028 b/tests/xfs/028
> > index b7c9d16b..1ff9d7d2 100755
> > --- a/tests/xfs/028
> > +++ b/tests/xfs/028
> > @@ -24,10 +24,9 @@ _cleanup()
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > -
> > -# wipe test dir clean first
> > -# so dump can be real quick
> > -_wipe_fs
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  #
> >  # Create 5 dumps
> > diff --git a/tests/xfs/035 b/tests/xfs/035
> > index 03cb7a76..d23cca95 100755
> > --- a/tests/xfs/035
> > +++ b/tests/xfs/035
> > @@ -25,6 +25,9 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_tape $TAPE_DEV
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  _create_dumpdir_fill
> >  _erase_hard
> >  _do_dump -L $seq.1
> > diff --git a/tests/xfs/036 b/tests/xfs/036
> > index 191345c5..73eb7cd5 100755
> > --- a/tests/xfs/036
> > +++ b/tests/xfs/036
> > @@ -25,6 +25,9 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_tape $RMT_IRIXTAPE_DEV
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  _create_dumpdir_fill
> >  _erase_soft
> >  _do_dump_min -o -F
> > diff --git a/tests/xfs/037 b/tests/xfs/037
> > index b3fbbedd..b19ba9e9 100755
> > --- a/tests/xfs/037
> > +++ b/tests/xfs/037
> > @@ -24,6 +24,9 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_tape $RMT_TAPE_DEV
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  _create_dumpdir_fill
> >  _erase_soft
> >  _do_dump_min -o -F
> > diff --git a/tests/xfs/038 b/tests/xfs/038
> > index 633c51e0..397c354d 100755
> > --- a/tests/xfs/038
> > +++ b/tests/xfs/038
> > @@ -24,6 +24,9 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_tape $RMT_TAPE_DEV
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  _create_dumpdir_fill
> >  _erase_hard
> >  _do_dump
> > diff --git a/tests/xfs/039 b/tests/xfs/039
> > index e3a98921..d54e9975 100755
> > --- a/tests/xfs/039
> > +++ b/tests/xfs/039
> > @@ -25,6 +25,9 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_tape $RMT_IRIXTAPE_DEV
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  _create_dumpdir_fill
> >  _erase_soft
> >  _do_dump -o -F
> > diff --git a/tests/xfs/043 b/tests/xfs/043
> > index 5b198dde..415ed16e 100755
> > --- a/tests/xfs/043
> > +++ b/tests/xfs/043
> > @@ -26,7 +26,10 @@ _cleanup()
> >  # real QA test starts here
> >  _supported_fs xfs
> >  
> > -_require_tape $TAPE_DEV 
> > +_require_tape $TAPE_DEV
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  _create_dumpdir_fill
> >  _erase_hard
> >  _do_dump_sub
> > diff --git a/tests/xfs/046 b/tests/xfs/046
> > index 94d1c051..48daff87 100755
> > --- a/tests/xfs/046
> > +++ b/tests/xfs/046
> > @@ -22,6 +22,9 @@ _cleanup()
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_dumpdir_symlinks
> >  _do_dump_file
> > diff --git a/tests/xfs/047 b/tests/xfs/047
> > index f83a2c94..6d0dc5f7 100755
> > --- a/tests/xfs/047
> > +++ b/tests/xfs/047
> > @@ -22,10 +22,9 @@ _cleanup()
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > -
> > -# wipe test dir clean first
> > -# so dump can be real quick
> > -_wipe_fs
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  #
> >  # Create 5 dumps
> > diff --git a/tests/xfs/055 b/tests/xfs/055
> > index 1e3ba6ac..c6ecae3d 100755
> > --- a/tests/xfs/055
> > +++ b/tests/xfs/055
> > @@ -25,6 +25,10 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_tape $RMT_TAPE_USER@$RMT_IRIXTAPE_DEV
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> > +
> >  _create_dumpdir_fill
> >  _erase_soft
> >  _do_dump -o -F
> > diff --git a/tests/xfs/056 b/tests/xfs/056
> > index 4ee473f6..f742f419 100755
> > --- a/tests/xfs/056
> > +++ b/tests/xfs/056
> > @@ -25,6 +25,9 @@ _cleanup()
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_dumpdir_fill_perm
> >  _do_dump_file
> > diff --git a/tests/xfs/059 b/tests/xfs/059
> > index 4bbfb5f5..515ef2a4 100755
> > --- a/tests/xfs/059
> > +++ b/tests/xfs/059
> > @@ -26,6 +26,9 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_multi_stream
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_dumpdir_fill_multi
> >  _do_dump_multi_file --multi 4
> > diff --git a/tests/xfs/060 b/tests/xfs/060
> > index 4b15c6c2..0c0dc981 100755
> > --- a/tests/xfs/060
> > +++ b/tests/xfs/060
> > @@ -26,6 +26,9 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_multi_stream
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_dumpdir_fill_multi
> >  _do_dump_multi_file --multi 4
> > diff --git a/tests/xfs/061 b/tests/xfs/061
> > index c5d4a2d1..0b20cc30 100755
> > --- a/tests/xfs/061
> > +++ b/tests/xfs/061
> > @@ -24,6 +24,9 @@ _cleanup()
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  # src/dumpfile based on dumping from
> >  # _create_dumpdir_fill_perm (small dump)
> > diff --git a/tests/xfs/063 b/tests/xfs/063
> > index 2d1d2cbc..660b300f 100755
> > --- a/tests/xfs/063
> > +++ b/tests/xfs/063
> > @@ -26,6 +26,9 @@ _cleanup()
> >  _supported_fs xfs
> >  
> >  _require_attrs trusted user
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  # create files with EAs
> >  _create_dumpdir_fill_ea
> > diff --git a/tests/xfs/064 b/tests/xfs/064
> > index e4e713cd..a81b226b 100755
> > --- a/tests/xfs/064
> > +++ b/tests/xfs/064
> > @@ -36,6 +36,9 @@ _ls_size_filter()
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_dumpdir_hardlinks 9
> >  
> > diff --git a/tests/xfs/065 b/tests/xfs/065
> > index 0df7477f..8485dee6 100755
> > --- a/tests/xfs/065
> > +++ b/tests/xfs/065
> > @@ -70,7 +70,8 @@ _scratch_unmount
> >  # files and directories
> >  #
> >  
> > -_wipe_fs
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  mkdir -p $dump_dir || _fail "cannot mkdir \"$dump_dir\""
> >  cd $dump_dir
> >  
> > diff --git a/tests/xfs/066 b/tests/xfs/066
> > index 5f0a74e3..2c369ad7 100755
> > --- a/tests/xfs/066
> > +++ b/tests/xfs/066
> > @@ -24,6 +24,7 @@ _cleanup()
> >  # real QA test starts here
> >  _supported_fs xfs
> >  _require_test
> > +_require_scratch
> >  
> >  _my_stat_filter()
> >  {
> > @@ -37,6 +38,8 @@ else
> >  	_notrun "Installed libc doesn't correctly handle setrlimit/ftruncate64"
> >  fi
> >  
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  _create_dumpdir_largefile
> >  echo "ls dumpdir/largefile"
> >  stat $dump_dir/largefile | _my_stat_filter
> > diff --git a/tests/xfs/068 b/tests/xfs/068
> > index 103466c3..f80b53e5 100755
> > --- a/tests/xfs/068
> > +++ b/tests/xfs/068
> > @@ -28,6 +28,9 @@ _cleanup()
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_dumpdir_stress_num 4096
> >  
> > diff --git a/tests/xfs/266 b/tests/xfs/266
> > index 549fff3b..eeca8822 100755
> > --- a/tests/xfs/266
> > +++ b/tests/xfs/266
> > @@ -50,12 +50,15 @@ filter_cumulative_quota_updates() {
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > +_require_scratch
> >  
> >  $XFSDUMP_PROG -h 2>&1 | grep -q -e -D
> >  if [ $? -ne 0 ]; then
> >      _notrun "requires xfsdump -D"
> >  fi
> >  
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  _create_dumpdir_fill
> >  # ensure file/dir timestamps precede dump timestamp
> >  sleep 2
> > diff --git a/tests/xfs/267 b/tests/xfs/267
> > index 62d39aba..89b968be 100755
> > --- a/tests/xfs/267
> > +++ b/tests/xfs/267
> > @@ -34,7 +34,6 @@ _create_files()
> >  biggg		41943040	$nobody	$nobody  777    attr1 some_text1  root
> >  End-of-File
> >  
> > -    _wipe_fs
> >      _do_create_dumpdir_fill
> >      _stable_fs
> >  }
> > @@ -48,6 +47,9 @@ _supported_fs xfs
> >  
> >  _require_tape $TAPE_DEV
> >  _require_attrs trusted
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_files
> >  _erase_hard
> > diff --git a/tests/xfs/268 b/tests/xfs/268
> > index b1dd312d..8c991fba 100755
> > --- a/tests/xfs/268
> > +++ b/tests/xfs/268
> > @@ -37,7 +37,6 @@ bigg1		12582912	$nobody	$nobody  777    attr1 some_text1  root
> >  bigg2		12582912	$nobody	$nobody  777    attr2 some_text2  user
> >  End-of-File
> >  
> > -    _wipe_fs
> >      _do_create_dumpdir_fill
> >      _stable_fs
> >  }
> > @@ -51,6 +50,9 @@ _supported_fs xfs
> >  
> >  _require_tape $TAPE_DEV
> >  _require_attrs trusted user
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_files
> >  _erase_hard
> > diff --git a/tests/xfs/281 b/tests/xfs/281
> > index ea114761..6b148a94 100755
> > --- a/tests/xfs/281
> > +++ b/tests/xfs/281
> > @@ -22,8 +22,10 @@ _cleanup()
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > -
> >  _require_legacy_v2_format
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_dumpdir_fill
> >  
> > diff --git a/tests/xfs/282 b/tests/xfs/282
> > index 07a4623a..50303b08 100755
> > --- a/tests/xfs/282
> > +++ b/tests/xfs/282
> > @@ -24,8 +24,10 @@ _cleanup()
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > -
> >  _require_legacy_v2_format
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_dumpdir_fill
> >  # ensure file/dir timestamps precede dump timestamp
> > diff --git a/tests/xfs/283 b/tests/xfs/283
> > index 47fd4c3a..59ea5f3b 100755
> > --- a/tests/xfs/283
> > +++ b/tests/xfs/283
> > @@ -24,8 +24,10 @@ _cleanup()
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > -
> >  _require_legacy_v2_format
> > +_require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  _create_dumpdir_fill
> >  # ensure file/dir timestamps precede dump timestamp
> > diff --git a/tests/xfs/296 b/tests/xfs/296
> > index 4eaf049b..efd303e2 100755
> > --- a/tests/xfs/296
> > +++ b/tests/xfs/296
> > @@ -28,8 +28,8 @@ _supported_fs xfs
> >  _require_scratch
> >  _require_command "$SETCAP_PROG" setcap
> >  _require_command "$GETCAP_PROG" getcap
> > -
> > -_wipe_fs
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  mkdir -p $dump_dir
> >  echo test > $dump_dir/testfile
> > diff --git a/tests/xfs/301 b/tests/xfs/301
> > index d44533d6..71ec1420 100755
> > --- a/tests/xfs/301
> > +++ b/tests/xfs/301
> > @@ -27,6 +27,8 @@ _cleanup()
> >  # Modify as appropriate.
> >  _supported_fs xfs
> >  _require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  # Extended attributes
> >  attr_name=attrname
> > diff --git a/tests/xfs/302 b/tests/xfs/302
> > index 6587a6e6..2e16890c 100755
> > --- a/tests/xfs/302
> > +++ b/tests/xfs/302
> > @@ -26,9 +26,10 @@ _cleanup()
> >  # Modify as appropriate.
> >  _supported_fs xfs
> >  _require_scratch
> > +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> > +_scratch_mount
> >  
> >  echo "Silence is golden."
> > -_wipe_fs
> >  mkdir $dump_dir >> $seqres.full 2>&1 || _fail "mkdir \"$dump_dir\" failed"
> >  for i in `seq 1 4`; do
> >  	$XFS_IO_PROG -f -c "truncate 1t" $dump_dir/sparsefile$i \
> > -- 
> > 2.31.1
> > 
> 

