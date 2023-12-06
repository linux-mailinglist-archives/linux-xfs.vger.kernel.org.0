Return-Path: <linux-xfs+bounces-468-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE399806A11
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Dec 2023 09:49:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D8DE2813C0
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Dec 2023 08:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F8E419474;
	Wed,  6 Dec 2023 08:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+dTHcTl"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F02211CAE
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 08:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60599C433C7;
	Wed,  6 Dec 2023 08:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701852565;
	bh=YsJtyPxNNals3Cz3EzXAbBeKTFLZthfqzmqoA3ZMKNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z+dTHcTls0kAmVWF3AacAqEkz7v9emajv/tF2FCpB3cqvystWtQKgrStlUD19gE/J
	 xXCwURKzLZmDzDs0Ce4y1s8SAjgWz9FOEKXuc01kKFIbupl70PvcE4XSYkhttn6qWC
	 hVw3HM2aneUY8C/hotFEDnWAtEs5P+AsFSuesMNvtnDfMBZoK+SsUY/HiJJLwlTHf0
	 X4lMisZIhYEM1RsoMpoKIbDAtc/QOANj8UQsF1ThDPjs8XegMPyPltbDIElrDEFbIs
	 pecdcSdtr6v28EZS+pKaSHDxWE8UOAz2y8CcYe31zTkjddEBxq8SkFM5leB0F0dHfv
	 9Imi53FksWUDA==
Date: Wed, 6 Dec 2023 09:49:21 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: share xfs_ondisk.h with userspace
Message-ID: <gvoornqoklacg4r32zzviv6e6n5qrwtiyqskv4fq7x24b6aqi5@qvdsvlsxxkik>
References: <P2n4rCzfWQ4WXEZsETZ3TkSW3tDwzcQuEbmsjhb_BAObmT_7sYjfvdqc1VIwUn0MnFNUjQp-d3EFYwlLoAtydA==@protonmail.internalid>
 <20231204200719.15139-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204200719.15139-1-hch@lst.de>

On Mon, Dec 04, 2023 at 09:07:17PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series switches xfs_ondisk.h to use static_assert instead of the
> kernel-specific BUILD_BUG_ON_MSG and then moves it to libxfs so that
> userspace can share the same struct sanity checks.

Thanks Christoph!

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> Diffstat:
>  xfs_ondisk.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

