Return-Path: <linux-xfs+bounces-12391-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1072D96272A
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Aug 2024 14:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 684D5B233A8
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Aug 2024 12:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E231F16C6AD;
	Wed, 28 Aug 2024 12:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ikx+qhBr"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373E216D4C1
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 12:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724848501; cv=none; b=tsMFJXi99RiIdyxC2OwieZDKK3FnzrHlAgDTCy3hTbNvoyldt2v4nlFCPUK7m8MITfURHTGiTJP1aGLRhP2jc7Fj3H1qQRXuNU0doCuxwDZud/gO0aM70cM3DiDDQBZYSOaXnghU84T4eOzdW3MVmEutpRP62IxMg8mf6PSNMdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724848501; c=relaxed/simple;
	bh=KqgDH1ZnHQ/z69qaNmvd4e9mQU4Q722O1wXDs8Wawwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9+GSOnNW9Ij5l/hU/b/RLGsVQZPL8iO0lsm8fT4Q/hnm1JCb2XNHrbNKS1Hq21W0keUfYtSV/Cj1cSD1wahOikglKCPZ640e8aN8fRwcJbI29nDf+HP9FqGitvRWCCTSCibs5R5wR552VX1LoEr44tQ7AGWqSBDMm/ono5hQoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ikx+qhBr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724848499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EAigvyxuhqeoYg4Y0eYmizGDEVtW+d60BU6GHWqWla4=;
	b=Ikx+qhBrSrMcY9iIoQAT4mOCobshbMXAN9khc74ANsjuiga4gIy9ivrYB4SPmvcThLASrw
	SuvAN5rRWAUAm2snB/YfMlTEs3mRIr3S/fi+EToisuGT1e+0jdw9Vba8lCvLZARvguJhzG
	fUzSSPjNtSdcNL+yrUwc9hb2tuApKDE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-442-VTkI9Sh1NoScDTFyoE5nUg-1; Wed,
 28 Aug 2024 08:34:53 -0400
X-MC-Unique: VTkI9Sh1NoScDTFyoE5nUg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 790BE1955D4A;
	Wed, 28 Aug 2024 12:34:49 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.95])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBE1119560A3;
	Wed, 28 Aug 2024 12:34:47 +0000 (UTC)
Date: Wed, 28 Aug 2024 08:35:47 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	djwong@kernel.org, josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH 2/2] iomap: make zero range flush conditional on
 unwritten mappings
Message-ID: <Zs8Zo3V1G3NAQEnK@bfoster>
References: <20240822145910.188974-1-bfoster@redhat.com>
 <20240822145910.188974-3-bfoster@redhat.com>
 <Zs1uHoemE7jHQ2bw@infradead.org>
 <Zs3hTiXLtuwXkYgU@bfoster>
 <Zs6oY91eFfaFVrMw@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs6oY91eFfaFVrMw@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Aug 27, 2024 at 09:32:35PM -0700, Christoph Hellwig wrote:
> On Tue, Aug 27, 2024 at 10:23:10AM -0400, Brian Foster wrote:
> > Yeah, I agree with that. That was one of the minor appeals (to me) of the
> > prototype I posted a while back that customizes iomap_truncate_page() to
> > do unconditional zeroing instead of being an almost pointless wrapper
> > for iomap_zero_range().
> 
> I only very vaguely remember that, you don't happen to have a pointer
> to that?
> 
> 

Yeah, it was buried in a separate review around potentially killing off
iomap_truncate_page():

https://lore.kernel.org/linux-fsdevel/ZlxUpYvb9dlOHFR3@bfoster/

The idea is pretty simple.. use the same kind of check this patch does
for doing a flush, but instead open code and isolate it to
iomap_truncate_page() so we can just default to doing the buffered write
instead.

Note that I don't think this replaces the need for patch 1, but it might
arguably make further optimization of the flush kind of pointless
because I'm not sure zero range would ever be called from somewhere that
doesn't flush already.

The tradeoffs I can think of are this might introduce some false
positives where an EOF folio might be dirty but a sub-folio size block
backing EOF might be clean, and again that callers like truncate and
write extension would need to both truncate the eof page and zero the
broader post-eof range. Neither of those seem all that significant to
me, but just my .02.

Brian


