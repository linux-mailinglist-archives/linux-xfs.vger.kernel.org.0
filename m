Return-Path: <linux-xfs+bounces-15924-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C659D9D4D
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Nov 2024 19:24:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C4422831B7
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Nov 2024 18:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F13DC1DD0D5;
	Tue, 26 Nov 2024 18:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjB7giOe"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0291DB361;
	Tue, 26 Nov 2024 18:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732645438; cv=none; b=tZXg6wiqykD75UQLIE0G5xgF4BMnR5DgmlTxyUFUJmt6VM1UgLUIM7X7CnV1uOOfu0dri7yXe5De67m6xyfIgpIFvHUpr1ig9ZfZf4jxmnLrdpEhJAHs+/jRrWcuEbDNoPS1DHm88gmbJ3t7g//Xxx03DedN8eZZQ4EF9P4cDI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732645438; c=relaxed/simple;
	bh=d4m3VCLvxYI28BelZN8HIZM+RwKa2s94Qkjp4WqvsXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8P7mT4Oqa0Um+ZWylBojFnpT1FXHv9/knI32i/pB3yJCdVgUNr/Xm8TkWRFoGXqKs1OhpRyCkLm4XQ2IIDhQ9uJYXr5bsXfUTnx7KzdKGjCt/NYckTPOah2USwROfv8k8maqUvRxe6okZWTTZNzfUL3ykZVyRdW2/9PMLykCQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjB7giOe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B90CC4CECF;
	Tue, 26 Nov 2024 18:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732645438;
	bh=d4m3VCLvxYI28BelZN8HIZM+RwKa2s94Qkjp4WqvsXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LjB7giOeRtoOjqc82//rzmlZruDxCNX8J8QymbyU3bCFfM4+dcJsjgyTZVmp7Vqn5
	 qncVEefXXMSeNw1oiJHXsK4YbRPop/8BQ4K6l6J+9nUlCXDV3x2xeEt/xN1cElRiy2
	 rT17KoJAuWIowP+31Jne3R//y6ReJ57V05kFoNT9o7iqW+xFsZm0B82oLqRZCPCaEV
	 nZGNUu06dpRbTLqQ9dLk6XvJSka52WLwJ8vTMpS9kaVzj6xZH9fBesSg1BMCHhrHmo
	 yrtdmfvzvfD0df4tkockKWY+xf86OKyyyuweWbpswA0zbPWdKLXFTTSp4kX0Esm0es
	 pnAXXHzlz56dw==
Date: Tue, 26 Nov 2024 10:23:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/21] xfs: don't lose solo dquot update transactions
Message-ID: <20241126182357.GM9438@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398090.4032920.6440798067032580972.stgit@frogsfrogsfrogs>
 <Z0VaFnJDFhcfs9K_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0VaFnJDFhcfs9K_@infradead.org>

On Mon, Nov 25, 2024 at 09:18:14PM -0800, Christoph Hellwig wrote:
> On Mon, Nov 25, 2024 at 05:29:08PM -0800, Darrick J. Wong wrote:
> > This is currently not the case anywhere in the filesystem because quota
> > updates always dirty at least one other metadata item, but a subsequent
> > bug fix will add dquot log item precommits, so we actually need a dirty
> > dquot log item prior to xfs_trans_run_precommits.  Also let's not leave
> > a logic bomb.
> 
> Unlike for the sb updates there doesn't seem to be anything in
> xfs_trans_mod_dquot that forces the transaction to be dirty, so I guess
> the fixes tag is fine here.

Correct.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D

