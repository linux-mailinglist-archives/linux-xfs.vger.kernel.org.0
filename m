Return-Path: <linux-xfs+bounces-16018-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B99E9E3974
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Dec 2024 13:03:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BE52284FE0
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Dec 2024 12:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8CE1B85C0;
	Wed,  4 Dec 2024 12:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L/oh6h9A"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346A61B5EBC
	for <linux-xfs@vger.kernel.org>; Wed,  4 Dec 2024 12:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733313821; cv=none; b=VblGtmvkeSuEb98Kd0KRyZ3yLxYH4h/mnjUgYh4P4ws2joT56phc6lJXW3vS7VJSRYRIFz8QryvHnz4OyfoeI/zC9z0jACtP394FvdKDj/EhSa0FlXxCmaguGkSVV2uZvgqnIYRQENufMjnKNvAYiJxHeGIUeigswFX5IAM6DpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733313821; c=relaxed/simple;
	bh=8ejfWQlP3wC8HLlZ9l1FTdAXoOaWZ/4pkS4zhBys2ZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgldN980nU55FBaBlFmqxJE3BXjs3JGOSUhiMLfp22tBnVsKfH2LBuFiowH59L9m0xmiNPyPC3toIjPGpsqXt/vDR10psaLPGNgsfU+C6vmKaza1PZxtFjPjsy/QL7cf1qLkxrOb06pH5lstSqyH2WC7kD0A205UFX5SfAFBz78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L/oh6h9A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733313818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jA/TrtALI4YFhMGnmAIHZDLngvBNjWPJZXBAWvYqY6g=;
	b=L/oh6h9ArkBJ0pe92VjYjLF2fyX8E6DrOSjyAP/P8h4F8PZPUsHuUv3slq/ZCCZSJndpqs
	YeBg/5xUBKkFXbHS7M6qJzofI9Fk3RcrnVKunkR/D9c43fbqi7s6wQtQFC2KerFjvLanZS
	uipyoxFI99UYjugZjCliLWShRaIpxX8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-127-k2HVIn5gOX2yw1Tbx1cDXA-1; Wed,
 04 Dec 2024 07:03:34 -0500
X-MC-Unique: k2HVIn5gOX2yw1Tbx1cDXA-1
X-Mimecast-MFC-AGG-ID: k2HVIn5gOX2yw1Tbx1cDXA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BB591954126;
	Wed,  4 Dec 2024 12:03:32 +0000 (UTC)
Received: from bfoster (unknown [10.22.90.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E9F03000197;
	Wed,  4 Dec 2024 12:03:30 +0000 (UTC)
Date: Wed, 4 Dec 2024 07:05:16 -0500
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Long Li <leo.lilong@huawei.com>, brauner@kernel.org, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v5 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <Z1BFfIk_iDAh2uwF@bfoster>
References: <20241127063503.2200005-1-leo.lilong@huawei.com>
 <Z0sVkSXzxUDReow7@localhost.localdomain>
 <Z03RlpfdJgsJ_glO@bfoster>
 <Z05oJqT7983ifKqv@dread.disaster.area>
 <Z08bsQ07cilOsUKi@bfoster>
 <Z090Jd06yjgh_Q-y@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z090Jd06yjgh_Q-y@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Dec 04, 2024 at 08:12:05AM +1100, Dave Chinner wrote:
> On Tue, Dec 03, 2024 at 09:54:41AM -0500, Brian Foster wrote:
> > On Tue, Dec 03, 2024 at 01:08:38PM +1100, Dave Chinner wrote:
> > > On Mon, Dec 02, 2024 at 10:26:14AM -0500, Brian Foster wrote:
> > > > On Sat, Nov 30, 2024 at 09:39:29PM +0800, Long Li wrote:
> > > We hold the MMAP_LOCK (filemap_invalidate_lock()) so no new pages
> > > can be instantiated over the range whilst we are running
> > > xfs_itruncate_extents(). hence once truncate_setsize() returns, we
> > > are guaranteed that there will be no IO in progress or can be
> > > started over the range we are removing.
> > > 
> > > Really, the issue is that writeback mappings have to be able to
> > > handle the range being mapped suddenly appear to be beyond EOF.
> > > This behaviour is a longstanding writeback constraint, and is what
> > > iomap_writepage_handle_eof() is attempting to handle.
> > > 
> > > We handle this by only sampling i_size_read() whilst we have the
> > > folio locked and can determine the action we should take with that
> > > folio (i.e. nothing, partial zeroing, or skip altogether). Once
> > > we've made the decision that the folio is within EOF and taken
> > > action on it (i.e. moved the folio to writeback state), we cannot
> > > then resample the inode size because a truncate may have started
> > > and changed the inode size.
> > > 
> > > We have to complete the mapping of the folio to disk blocks - the
> > > disk block mapping is guaranteed to be valid for the life of the IO
> > > because the folio is locked and under writeback - and submit the IO
> > > so that truncate_pagecache() will unblock and invalidate the folio
> > > when the IO completes.
> > > 
> > > Hence writeback vs truncate serialisation is really dependent on
> > > only sampling the inode size -once- whilst the dirty folio we are
> > > writing back is locked.
> > > 
> > 
> > Not sure I see how this is a serialization dependency given that
> > writeback completion also samples i_size.
> 
> Ah, I didn't explain what I meant very clearly, did I?
> 
> What I mean was we can't sample i_size in the IO path without
> specific checking/serialisation against truncate operations. And
> that means once we have partially zeroed the contents of a EOF
> straddling folio, we can't then sample the EOF again to determine
> the length of valid data in the folio as this can race with truncate
> and result in a different size for the data in the folio than we
> prepared it for.
> 

Ok, I think we're just saying the same thing using different words.

> > But no matter, it seems a
> > reasonable implementation to me to make the submission path consistent
> > in handling eof.
> 
> Yes, the IO completion path does sample it again via xfs_new_eof().
> However, as per above, it has specific checking for truncate down
> races and handles them:
> 
> /*
>  * If this I/O goes past the on-disk inode size update it unless it would
>  * be past the current in-core inode size.
>  */
> static inline xfs_fsize_t
> xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
> {
>         xfs_fsize_t i_size = i_size_read(VFS_I(ip));
> 
> >>>>    if (new_size > i_size || new_size < 0)
> >>>>            new_size = i_size;
>         return new_size > ip->i_disk_size ? new_size : 0;
> }
> 
> If we have a truncate_setsize() called for a truncate down whilst
> this IO is in progress, then xfs_new_eof() will see the new, smaller
> inode isize. The clamp on new_size handles this situation, and we
> then only triggers an update if the on-disk size is still smaller
> than the new truncated size (i.e. the IO being completed is still
> partially within the new EOF from the truncate down).
> 
> So I don't think there's an issue here at all at IO completion;
> it handles truncate down races cleanly...
> 

Agree.. this was kind of the point of the submit side trimming. I'm not
sure a second sample of i_size on submission for trimming purposes
affects this in any problematic way either.

Brian

> > I wonder if this could just use end_pos returned from
> > iomap_writepage_handle_eof()?
> 
> Yeah, that was what I was thinking, but I haven't looked at the code
> for long enough to have any real idea of whether that is sufficient
> or not.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 


