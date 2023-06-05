Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CE67232E7
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Jun 2023 00:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbjFEWGM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Jun 2023 18:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjFEWGL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 18:06:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EBD9C;
        Mon,  5 Jun 2023 15:06:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6688962940;
        Mon,  5 Jun 2023 22:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB34AC433D2;
        Mon,  5 Jun 2023 22:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686002769;
        bh=dRxlo7wgdcOHf8JwX9xQXwG6QRhjFjQvkGj5jEYrusY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qMAwwa4m4ZVlKKIvCQnuGvFv1QHfyqq/kKQfLUTAoHRMu/0fqCb6zEr1zgZZu8idP
         mTMYHZX0R8x80tLFbulQLpxXCfUo3OHFXL+xyOWA8CZ8sDMeKN0P8lvFjpIIDiosOK
         eVkb51k/MdFKTHFCgOyOrZlY51uRHz6zDZaa2LKgGHeNLaffqugriIJ79TlEAfOg/e
         +Rm2aW7qSH3j9d3JoHl4nZHVHntcbJF5DnrFHve8bkFEzLGhTkCX0KKJVjHUVVf55e
         VKLKYaIUv/a5HwA5pOuVX1eUBjoguvlxN3w1y1ZNV1AUtX6SHjREsm+FEmSWxBdMKO
         87l8WbNmoJMTA==
Date:   Mon, 5 Jun 2023 15:06:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH V3] mkfs.xfs: test that shipped config files work properly
Message-ID: <20230605220609.GD1325469@frogsfrogsfrogs>
References: <1685999495-7998-1-git-send-email-sandeen@redhat.com>
 <1685999674-8626-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685999674-8626-1-git-send-email-sandeen@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 04:14:34PM -0500, Eric Sandeen wrote:
> Sanity check the shipped mkfs.xfs config files by using
> them to format the scratch device.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/569     | 32 ++++++++++++++++++++++++++++++++
>  tests/xfs/569.out |  2 ++
>  2 files changed, 34 insertions(+)
>  create mode 100755 tests/xfs/569
>  create mode 100644 tests/xfs/569.out
> 
> diff --git a/tests/xfs/569 b/tests/xfs/569
> new file mode 100755
> index 0000000..e890270
> --- /dev/null
> +++ b/tests/xfs/569
> @@ -0,0 +1,32 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 569
> +#
> +# Check for any installed example mkfs config files and validate that
> +# mkfs.xfs can properly use them.
> +#
> +. ./common/preamble
> +_begin_fstest mkfs
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_require_scratch
> +
> +ls /usr/share/xfsprogs/mkfs/*.conf &>/dev/null || \
> +	_notrun "No mkfs.xfs config files installed"
> +
> +# We only fail if mkfs.xfs fails outright, ignoring warnings etc
> +echo "Silence is golden"
> +
> +for CONFIG in /usr/share/xfsprogs/mkfs/*.conf; do
> +	$MKFS_XFS_PROG -c options=$CONFIG -f $SCRATCH_DEV &>>$seqres.full || \
> +		echo "mkfs.xfs config file $CONFIG failed"
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/569.out b/tests/xfs/569.out
> new file mode 100644
> index 0000000..c7aaf10
> --- /dev/null
> +++ b/tests/xfs/569.out
> @@ -0,0 +1,2 @@
> +QA output created by 569
> +Silence is golden
> -- 
> 1.8.3.1
> 
