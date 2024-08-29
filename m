Return-Path: <linux-xfs+bounces-12468-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9E14964459
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Aug 2024 14:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDC1A1C2383C
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Aug 2024 12:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F6EB19309C;
	Thu, 29 Aug 2024 12:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VosTZRuL"
X-Original-To: linux-xfs@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E33B18D63A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 12:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724934340; cv=none; b=D7NA93kbevJUMD/sG9vLkviukEKCGxRAC7Mzo8pLQPUykggWKpe0PCw4IDVs2W+Vd9uuWyYz8NR/edWTTWY2zeWgLUR5/XgcbMG9JBajHavdoi1fNeK2yMqKvo/2/EFs9uHxlAbkGi0jdpwK1g1QkhO9HlafgCR0M6DU3n5jSSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724934340; c=relaxed/simple;
	bh=7CXvtXHwO0028/VdHCk+FBpUlRfs1h+HrgKjZj2uM+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PeeX0b3iCdgVced/Dcwn9kV+H/2rNP1NEMs0pnKtmwaNpSDgldcC7kVrJiM2AjEtZ97yusa0pf8JJY5sXqYj3X6kSq+2wdFLSJQOMmC8GKmBHLV4B725A0FE/Fh+SO5S5KSG2E+gDyWYDxNBX4eQAkt9cgSHyxwlVFn5JeASkrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VosTZRuL; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 29 Aug 2024 08:25:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724934336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5KQbrmkoQxoBGxp8VqgXK/PzFblLA70k6UhDahc0x+s=;
	b=VosTZRuLYIhjCzW4dw8M4AIVk9wylQd/Xi6e3ZgWL09LPf86eexNwFiDfq5qnKq4NkmU11
	EamWJxzFBcYJ0bazN67NpumycNQctdwTa0nGE0xg7iyj7Dfk1XQPRoM04ggdlUFKI/cg5d
	qirs+ymRfZtXqvbFsD7sHJGiUhCkRxU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, 
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com, brauner@kernel.org, 
	linux-xfs@vger.kernel.org, gfs2@lists.linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v4 14/16] bcachefs: add pre-content fsnotify hook to fault
Message-ID: <y2734c2a3gfavo737s3vzdj7xxx2atvqsffh6nkdha77bz5kyb@uhgeiwrd75eu>
References: <cover.1723670362.git.josef@toxicpanda.com>
 <9627e80117638745c2f4341eb8ac94f63ea9acee.1723670362.git.josef@toxicpanda.com>
 <20240829111055.hyc4eke7a5e26z7r@quack3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829111055.hyc4eke7a5e26z7r@quack3>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 29, 2024 at 01:10:55PM GMT, Jan Kara wrote:
> On Wed 14-08-24 17:25:32, Josef Bacik wrote:
> > bcachefs has its own locking around filemap_fault, so we have to make
> > sure we do the fsnotify hook before the locking.  Add the check to emit
> > the event before the locking and return VM_FAULT_RETRY to retrigger the
> > fault once the event has been emitted.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Looks good to me. Would be nice to get ack from bcachefs guys. Kent?

btw, happy to give you a CI account as well: just need username and ssh
pubkey

