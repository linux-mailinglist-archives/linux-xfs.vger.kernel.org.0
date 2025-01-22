Return-Path: <linux-xfs+bounces-18515-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F7E8A18C3B
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Jan 2025 07:43:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B4BA188B631
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Jan 2025 06:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E1291A4F22;
	Wed, 22 Jan 2025 06:42:57 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0912F9FE;
	Wed, 22 Jan 2025 06:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737528177; cv=none; b=oicRH1ARHphbleje4/OmbGmNe35DX1PPGApWxHcHyXfYLWpw+67HNOGZUBpgyYRTTs6l3FvgG/NP5bJ5krdVZQicJF6Lw10OEh9Trd1Jujik+mE9vFumD8gvhWazy4YHdetUWF3WzVjGDJYLS/FjQDd3+SrFPXxAAmgtDIgrc60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737528177; c=relaxed/simple;
	bh=hX70D7WdNRS7aPubcE9xEUk9h8mRyAgO857Km96gTig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SeB8QvAkLdBXbl6K7r8qDP55UaonqIOgFVgZ3BiuqQcYyoLfUCEjCYgwtyXIu9mYFTSBsERHTfwsrm7eUqo1qwf1t55fuPyRugT9slESQ0sH4fBFFHMa37PCVzChaD7ZhVqxSvehPwPFTfCnLpU1GTmqZFHTBKNUUYFMziNxkuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 45E0068D45; Wed, 22 Jan 2025 07:42:48 +0100 (CET)
Date: Wed, 22 Jan 2025 07:42:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	John Garry <john.g.garry@oracle.com>, brauner@kernel.org,
	cem@kernel.org, dchinner@redhat.com, ritesh.list@gmail.com,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 1/4] iomap: Lift blocksize restriction on atomic writes
Message-ID: <20250122064247.GA31374@lst.de>
References: <20241204154344.3034362-1-john.g.garry@oracle.com> <20241204154344.3034362-2-john.g.garry@oracle.com> <Z1C9IfLgB_jDCF18@dread.disaster.area> <3ab6000e-030d-435a-88c3-9026171ae9f1@oracle.com> <Z1IX2dFida3coOxe@dread.disaster.area> <20241212013433.GC6678@frogsfrogsfrogs> <Z4Xq6WuQpVOU7BmS@dread.disaster.area> <20250114235726.GA3566461@frogsfrogsfrogs> <20250116065225.GA25695@lst.de> <20250117184934.GI1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117184934.GI1611770@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 17, 2025 at 10:49:34AM -0800, Darrick J. Wong wrote:
> The trouble is that the br_startoff attribute of cow staging mappings
> aren't persisted on disk anywhere, which is why exchange-range can't
> handle the cow fork.  You could open an O_TMPFILE and swap between the
> two files, though that gets expensive per-io unless you're willing to
> stash that temp file somewhere.

Needing another inode is better than trying to steal ranges from the
actual inode we're operating on.  But we might just need a different
kind of COW staging for that.

> 
> At this point I think we should slap the usual EXPERIMENTAL warning on
> atomic writes through xfs and let John land the simplest multi-fsblock
> untorn write support, which only handles the corner case where all the
> stars are <cough> aligned; and then make an exchange-range prototype
> and/or all the other forcealign stuff.

That is the worst of all possible outcomes.  Combing up with an
atomic API that fails for random reasons only on aged file systems
is literally the worst thing we can do.  NAK.


