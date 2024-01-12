Return-Path: <linux-xfs+bounces-2783-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D5982C3DB
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jan 2024 17:43:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1F2D1C21869
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jan 2024 16:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAAAF77626;
	Fri, 12 Jan 2024 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r54vZ12w"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC7B76915;
	Fri, 12 Jan 2024 16:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2BCC433F1;
	Fri, 12 Jan 2024 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705077784;
	bh=/4jDg+M8IQvw/nCBF4y9YS85eZFlZYwlZmZWecPuG8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r54vZ12w/a7x6XR6rwc19vkF4v4SwgUblXuedgedirNC7JcAAFqvqKFTNvyA6nWOp
	 RsTQsDwG05ZVOHfCjt69lzbKnbqdUaoZyJPnN2PxX5hNxGatf38TEVDJaMWnlP3+zK
	 YS+l7SXTq5EYX4JGZrUq3XVfqzXG4v1dQcrt07P+/xBSsntcVVXXmZxSVQwHrOonIm
	 4KQsuH55dr2m/B2/VZGzrKk07MSW5fEnBkDFrbXirQDjZoJmWN8voE9WvGL08B2yEg
	 EpUI3l6xf2bNgY4VNW0/tsWyq3leNeoAPSkXID7mS0wo9QWW8dnloHchSD+WuRHhe2
	 3A7G6DlXF8fyA==
Date: Fri, 12 Jan 2024 08:43:03 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/262: call _scratch_require_xfs_scrub
Message-ID: <20240112164303.GS722975@frogsfrogsfrogs>
References: <20240112050833.2255899-1-hch@lst.de>
 <20240112050833.2255899-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112050833.2255899-4-hch@lst.de>

On Fri, Jan 12, 2024 at 06:08:32AM +0100, Christoph Hellwig wrote:
> Call _scratch_require_xfs_scrub so that the test is _notrun on kernels
> without online scrub support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With _require_scratch_xfs_scrub,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/262 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/xfs/262 b/tests/xfs/262
> index b28a6c88b..0d1fd779d 100755
> --- a/tests/xfs/262
> +++ b/tests/xfs/262
> @@ -29,6 +29,9 @@ _require_xfs_io_error_injection "force_repair"
>  echo "Format and populate"
>  _scratch_mkfs > "$seqres.full" 2>&1
>  _scratch_mount
> +
> +_scratch_require_xfs_scrub
> +
>  cp $XFS_SCRUB_PROG $SCRATCH_MNT/xfs_scrub
>  $LDD_PROG $XFS_SCRUB_PROG | sed -e '/\//!d;/linux-gate/d;/=>/ {s/.*=>[[:blank:]]*\([^[:blank:]]*\).*/\1/};s/[[:blank:]]*\([^[:blank:]]*\) (.*)/\1/' | while read lib; do
>  	cp $lib $SCRATCH_MNT/
> -- 
> 2.39.2
> 
> 

