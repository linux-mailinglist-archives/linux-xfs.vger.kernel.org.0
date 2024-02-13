Return-Path: <linux-xfs+bounces-3780-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D847585393A
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Feb 2024 18:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62C6D1F2411B
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Feb 2024 17:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C6160B8F;
	Tue, 13 Feb 2024 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBVWRNkt"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B1C60B86;
	Tue, 13 Feb 2024 17:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846950; cv=none; b=k42jZgOCiwYXCgsmiYiyvNeFJ0wYpFGHzLdOG7GL33WjXAKM1SCugkFPog7GLp/SmtR+wY0dLwkK41dq1ncBBEbp8Kef3UF5MMGW1YhOgIcU9sxdR3IlVz4MUdP1r6PM46/SkdvOPXI/oQTcAykLA+sjMWukDptWml2nmplYtow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846950; c=relaxed/simple;
	bh=FCSg3u/T4vpEvkECtTnEyCSbmHI+EtLfUbeUYTkp5d4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MNa4IRM7EAmD6gY5NQWhp9skanH3RQNdTRAgK8KTF03c9HxUuUS5/IIMDPxqDfsWua0rpb5/5bW+2hlPihnHq/eSlT1fcFJ0IZD+Xqp86qptPrlapeVQ96i/TXxaoddGDUfZSh3j22Mqd+HfZcy6eo4VG9/PatLc+k53uY10R7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBVWRNkt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB9AC43390;
	Tue, 13 Feb 2024 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707846950;
	bh=FCSg3u/T4vpEvkECtTnEyCSbmHI+EtLfUbeUYTkp5d4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XBVWRNkt4dhFG0yoAZzqL10a5MqbXgP1hjhuSm65ex+0+ALP5DepLFhOc7ICgyLlb
	 EjB4g1j761TjdNu/vRr5O3cKNoMb4Olpk2qTkHmO5NoZKMnEKW9eyvO2mmRnIuQn9q
	 gv3XOArfsdIQa2nJcn9l2QWAmWRjYAXRW0cu7fNiXXZ20T4wm/tdwck+f0RpA1axOm
	 mtaxouGN6ZUy2nxLHfRF5oEoeJTV0dThUzYhpKMR0wRgxGG0SfHUmjlw1aoBF/ZEQa
	 Un/do5rR9vg1I9IB8qV2k+06ctvOSiZZzXklhbEwZJ/+d7wTNKhxDWw6mKz16Zmmni
	 IUtQepT93v0HQ==
Date: Tue, 13 Feb 2024 09:55:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: John Garry <john.g.garry@oracle.com>, viro@zeniv.linux.org.uk,
	brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
	chandan.babu@oracle.com, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH 0/6] block atomic writes for XFS
Message-ID: <20240213175549.GU616564@frogsfrogsfrogs>
References: <20240124142645.9334-1-john.g.garry@oracle.com>
 <20240213072237.GA24218@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213072237.GA24218@lst.de>

On Tue, Feb 13, 2024 at 08:22:37AM +0100, Christoph Hellwig wrote:
> From reading the series and the discussions with Darrick and Dave
> I'm coming more and more back to my initial position that tying this
> user visible feature to hardware limits is wrong and will just keep
> on creating ever more painpoints in the future.
> 
> Based on that I suspect that doing proper software only atomic writes
> using the swapext log item and selective always COW mode

Er, what are you thinking w.r.t. swapext and sometimescow?  swapext
doesn't currently handle COW forks at all, and it can only exchange
between two of the same type of fork (e.g. both data forks or both attr
forks, no mixing).

Or will that be your next suggestion whenever I get back to fiddling
with the online fsck patches? ;)

> and making that
> work should be the first step.  We can then avoid that overhead for
> properly aligned writs if the hardware supports it.  For your Oracle
> DB loads you'll set the alignment hints and maybe even check with
> fiemap that everything is fine and will get the offload, but we also
> provide a nice and useful API for less performance critical applications
> that don't have to care about all these details.

I suspect they might want to fail-fast (back to standard WAL mode or
whatever) if the hardware support isn't available.

--D

