Return-Path: <linux-xfs+bounces-17129-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A3159F81D6
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Dec 2024 18:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D42157A2698
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Dec 2024 17:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE4C319E7F7;
	Thu, 19 Dec 2024 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mIJfKBPc"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A17D155342;
	Thu, 19 Dec 2024 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629431; cv=none; b=gbN7wHzA/kTjzKT3BphRm1LUqwDpSnMth3lsvg+AIIT8JWnLDjqkAyjISQmeX0IaU2gtCrCnl/HlCN4eZLUmxCrdCDo7b9LLNaGwO46Jx59uZuuH56KsAj2p7SW2Fn3Mc6P+aoZ1L/HAT4dWbMdbOTc9B2gQRoPkKVxKgDycMsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629431; c=relaxed/simple;
	bh=/vW1oZa4bFhdJ0eqozScp05up+dOnLaod4u+l0TQPRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FvPggh2tFQc//ch0aOwDlxe48oXu2zKqYkLB3NExPF3l2VNPNQxhH5LIhf9757oNeXdz7isF4f7LapYfAaufqk9GXPNBDFpHP45EqP8IgGnqMQbYK20q0L1BYhWsol7cuP2+S4vZ143rWrjkE9rKhO9p6I60qLHqBvF6YoC+5rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mIJfKBPc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA0AC4CECE;
	Thu, 19 Dec 2024 17:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734629431;
	bh=/vW1oZa4bFhdJ0eqozScp05up+dOnLaod4u+l0TQPRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mIJfKBPcg7h4uPJMLNcth2GShQCDQRqkjaKxOCp6KPq/VopIgvVJ5zz5u95IBzbas
	 895WwwMGJkngxCWHc9+YSJnaQw2PkmG8w0MN5jYU67evqge2kJPKX3PDetmvFYNl+A
	 wSjSToKtv/XZ9tY45CIGwFqgXMX1hE82mAL+iyHQ0Fp/trVz1U7dJB+hm1as9nn55U
	 7Fw8RPizZ/x3XgEvIZ1UyGbnEooz5NsFAIXHtpan/6XoxYw1c7BRXiV+Gar8e0/AO8
	 14EgjrUqzyeN0rPrwLlk7cQ9NonU0uORoP6Ak8KSCX8J5dtUkERE4vakjIHMIezS9G
	 dUaFd0h0GPHiA==
Date: Thu, 19 Dec 2024 09:30:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/8] iomap: add a IOMAP_F_ZONE_APPEND flag
Message-ID: <20241219173030.GJ6174@frogsfrogsfrogs>
References: <20241211085420.1380396-1-hch@lst.de>
 <20241211085420.1380396-4-hch@lst.de>
 <20241212180547.GG6678@frogsfrogsfrogs>
 <20241216045554.GA16580@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241216045554.GA16580@lst.de>

On Mon, Dec 16, 2024 at 05:55:54AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 10:05:47AM -0800, Darrick J. Wong wrote:
> > >  #endif /* CONFIG_BUFFER_HEAD */
> > >  #define IOMAP_F_XATTR		(1U << 5)
> > >  #define IOMAP_F_BOUNDARY	(1U << 6)
> > > +#define IOMAP_F_ZONE_APPEND	(1U << 7)
> > 
> > Needs a corresponding update in Documentation/iomap/ before we merge
> > this series.
> 
> Btw, while doing these updates I start to really despise
> Documentation/filesystems/iomap/.  It basically just duplicates what's
> alredy in the code comments, just far away from the code to which it
> belongs in that awkward RST format.  I'm not sure what it is supposed
> to buy us?

The iomap documentation has been helpful for the people working on
porting existing filesystems to iomap, because it provides a story for
"if you want to implement file operation X, this is how you'd do that in
iomap".  Seeing as we're coming up on -rc4 now, do you want to just send
your iomap patches and I'll go deal with the docs?

That way we have two people who understand what the two new flags mean.
:)

--D

