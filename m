Return-Path: <linux-xfs+bounces-19572-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A19A347D1
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Feb 2025 16:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C5EE3B2B62
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Feb 2025 15:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB63A156F3C;
	Thu, 13 Feb 2025 15:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BKbX8PFl"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E41146588
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 15:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460278; cv=none; b=b32cVZi5LJerjvFigOjrBAOSU8DP4mtw4GQbqc7FtzMXNNAYT7UG8uJa3n08yeuXXLlLiHri8tR/2GCFIrkKIW46UEzgJKlVGF1JBCdUCy9IBOrIr22xBUAu2VWR7u1KX6Xkm4qA+1N+j8ZRDDaQvlh36gmuKPEEt6EwWWqWrpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460278; c=relaxed/simple;
	bh=qlhV2OVZUqN0wvTT/IHjRE39/69E/A+9kUxu48pgAC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLbu0SCiYDPWSj6K3j3Stkzwiy8/b8qpnKNfEZUt2UJsRAEFhYEBrutDZySKHxbrpczmbstCZ6p3CqzJL7bhy8mkQmqCPlzbrTV12rkNsey1t8WiBihCR5CnDT0eOnRNRhuakRuq1AOw4si2o2e3Jb7KipMjxwGjJY7NdFLJGBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BKbX8PFl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739460275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZMmO0gPhrk16JOo+K3wbkjEwACwQemqFykGoQjvkKJ8=;
	b=BKbX8PFl3BLZ896t25/PE8USUJTooB6ePPn5psWOPo0TKIvKHUrSHhk8xOJcAu1fLaiic4
	XVsn7aDk/xUc2jrvqbcGyWxtO9pSNb66SA2i8DhkJold1Mfp8ALuX6ulYNya22E2fcjng3
	gItwsSunT8ohUh7biMaExHniltHYw2s=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-tChZd1FLOIqcmEteey9ltA-1; Thu,
 13 Feb 2025 10:24:34 -0500
X-MC-Unique: tChZd1FLOIqcmEteey9ltA-1
X-Mimecast-MFC-AGG-ID: tChZd1FLOIqcmEteey9ltA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C5D319560AF;
	Thu, 13 Feb 2025 15:24:33 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.88])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CEDF1800360;
	Thu, 13 Feb 2025 15:24:32 +0000 (UTC)
Date: Thu, 13 Feb 2025 10:26:57 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 03/10] iomap: convert misc simple ops to incremental
 advance
Message-ID: <Z64PQasyLmDeze5n@bfoster>
References: <20250212135712.506987-1-bfoster@redhat.com>
 <20250212135712.506987-4-bfoster@redhat.com>
 <Z62XMuDSLOhF2DD7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z62XMuDSLOhF2DD7@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Feb 12, 2025 at 10:54:42PM -0800, Christoph Hellwig wrote:
> > +	u64 length = iomap_length(iter);
> > +
> >  	switch (iomap->type) {
> >  	case IOMAP_MAPPED:
> >  	case IOMAP_UNWRITTEN:
> > @@ -132,7 +134,8 @@ static loff_t iomap_swapfile_iter(const struct iomap_iter *iter,
> >  			return error;
> >  		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
> >  	}
> > -	return iomap_length(iter);
> > +
> > +	return iomap_iter_advance(iter, &length);
> 
> I notice that for many of these callers passing in the length as in/out
> argument isn't all that great.  Not sure that's worth changing now (or
> adding another helper?).  The conversion itself looks good.
> 

Yes, I noticed the same when I changed it to an in/out param in the
previous series. Several callers end up needing a dummy local to
represent iomap_length(). I left it as is because I think this is the
lesser of two evils compared to the overloaded return situation, at
least for now, but I could also tack on a patch to introduce an
iomap_iter_advance_full(iter) (name?) or some such inline helper to
clean up these cases..

Brian


