Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2AFD60E776
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Oct 2022 20:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiJZScJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Oct 2022 14:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234561AbiJZSbx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 14:31:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E541C97D53;
        Wed, 26 Oct 2022 11:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8F223CE2403;
        Wed, 26 Oct 2022 18:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4866AC433C1;
        Wed, 26 Oct 2022 18:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666809030;
        bh=7HJkVOZBWdUrQYxV2/M9wD3kC+uWchsa5cgSUSezjrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AVz2gnCqekRYFNAYIhkmYJ7E5r4QBNSo9V7i9krtrIg7k5fCWq7xTo6zM52gUwXBx
         cTe5BxV1CkcW6lP8PO1fNPupIRbCSkxX+62aSMwcFhbzSRqn92WciWJgHrlx5y6xI4
         nTXt/xbv76At3KAC28a9QGYailRp53VjKLJ0WFfueN8kvsIGZTzaz3jqtHF69F79oF
         CjY2o1T5LoCd6bzNUSfmSmMxSrfLu/ps+7j6F/byo3BoYZHBjwsXy1c0wi+fhsuCNP
         07ZjLp18KPwksZJ87zm+m2kGNBYAiDHCNUuBxZ8/RFNNIC8YoNgll7+mDvgu1QQgKM
         TlSODHGP2Mabg==
Date:   Wed, 26 Oct 2022 11:30:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: new test to ensure xfs can capture IO errors
 correctly
Message-ID: <Y1l8xRaTpeH3Nu0l@magnolia>
References: <20221026165747.1146281-1-zlang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026165747.1146281-1-zlang@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 12:57:47AM +0800, Zorro Lang wrote:
> There was a known xfs crash bug fixed by e001873853d8 ("xfs: ensure
> we capture IO errors correctly"), so trys to cover this bug and make
> sure xfs can capture IO errors correctly, won't panic and hang again.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> When I tried to tidy up our internal test cases recently, I found a very
> old case which trys to cover e001873853d8 ("xfs: ensure we capture IO errors
> correctly") which fix by Dave. At that time, we didn't support xfs injection,
> so we tested it by a systemtap script [1] to inject an ioerror.
> 
> Now this bug has been fixed long long time ago (9+ years), and that stap script
> is already out of date, can't work with new kernel. But good news is we have xfs
> injection now, so I try to resume this test case in fstests.
> 
> I didn't verify if this case can reproduce that bug on old rhel (which doesn't
> support error injection). The original case tried to inject errno 11, I'm
> not sure if it's worth trying more other errors. I searched "buf_ioerror" in
> fstests, found nothing. So maybe this bug is old enough, but it's worth covering
> this kind of test. So feel free to tell me if you have any suggestions :)
> 
> Thanks,
> Zorro
> 
> [1]
> probe module("xfs").function("xfs_buf_bio_end_io")
> {
>         if ($error == 0) {
>                 if ($bio->bi_rw & (1 << 4)) {
>                         $error = -11;
>                         printf("%s: comm %s, pid %d, setting error 11\n",
>                                 probefunc(), execname(), pid());
>                         print_stack(backtrace());
>                 }
>         }
> }
> 
>  tests/xfs/554     | 53 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/554.out |  4 ++++
>  2 files changed, 57 insertions(+)
>  create mode 100755 tests/xfs/554
>  create mode 100644 tests/xfs/554.out
> 
> diff --git a/tests/xfs/554 b/tests/xfs/554
> new file mode 100755
> index 00000000..6935bfc0
> --- /dev/null
> +++ b/tests/xfs/554
> @@ -0,0 +1,53 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 YOUR NAME HERE.  All Rights Reserved.

Mr. YOUR HERE,

Please write your real name in the copyright statement.

> +#
> +# FS QA Test 554
> +#
> +# There was a known xfs crash bug fixed by e001873853d8 ("xfs: ensure we
> +# capture IO errors correctly"), so trys to cover this bug and make sure
> +# xfs can capture IO errors correctly, won't panic and hang again.
> +#
> +. ./common/preamble
> +_begin_fstest auto eio
> +
> +_cleanup()
> +{
> +	$KILLALL_PROG -q fsstress 2> /dev/null
> +	# ensures all fsstress processes died
> +	wait
> +	# log replay, due to the buf_ioerror injection might leave dirty log
> +	_scratch_cycle_mount
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +# Import common functions.
> +. ./common/inject
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_command "$KILLALL_PROG" "killall"
> +_require_scratch
> +_require_xfs_debug
> +_require_xfs_io_error_injection "buf_ioerror"
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +echo "Inject buf ioerror tag"
> +_scratch_inject_error buf_ioerror 11
> +
> +echo "Random I/Os testing ..."
> +$FSSTRESS_PROG $FSSTRESS_AVOID -d $SCRATCH_MNT -n 50000 -p 100 >> $seqres.full &
> +for ((i=0; i<5; i++));do
> +	# Clear caches, then trys to use 'find' to trigger readahead

BUF_IOERROR only seems to apply to async writes:

static void
xfs_buf_bio_end_io(
	struct bio		*bio)
{
	struct xfs_buf		*bp = (struct xfs_buf *)bio->bi_private;

	if (!bio->bi_status &&
	    (bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
	    XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
		bio->bi_status = BLK_STS_IOERR;

So I don't see how this would reproduce the problem of b_error not being
cleared after a failed readahead and re-read?

--D

> +	echo 3 > /proc/sys/vm/drop_caches
> +	find $SCRATCH_MNT >/dev/null 2>&1
> +	sleep 3
> +done
> +
> +echo "No hang or panic"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> new file mode 100644
> index 00000000..26910daa
> --- /dev/null
> +++ b/tests/xfs/554.out
> @@ -0,0 +1,4 @@
> +QA output created by 554
> +Inject buf ioerror tag
> +Random I/Os testing ...
> +No hang or panic
> -- 
> 2.31.1
> 
