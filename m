Return-Path: <linux-xfs+bounces-19570-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88EFAA3470B
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Feb 2025 16:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86E9C188E57A
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Feb 2025 15:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A129176AA1;
	Thu, 13 Feb 2025 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VBvVs8wb"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DA11714A1
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 15:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460154; cv=none; b=oz/yQLYeF/fONoSPgBtWczl85bycyDgVQIL6D+X8RB2HMx01G1fPgEot5w2DM8WVEJ9y2FBfxpQuAhwOp6PuUeAqcObGTdiwT/Nn9hkTkMoipc3Ot301VPoWzTMkxgzkI9FpS3fl4Vu/PiLosl3BHS8lnJrxGZFbbUukQYkRs04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460154; c=relaxed/simple;
	bh=9j5v/7liqkvTdpUdazBxIEigSFYjI1o0NoVgCGCNEBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=muKlC3aRld6AQWwekMkKwhpeNEZExaFhF/fYVZhvZBnwT1foutFncu6JW8H301e7szNAdRJI6wxpCKUnSNMPsRsEyCCxnzzoCTICdBAXyNfxlbt0qX2+WRlvQ9bS2EiKuP6vRs3diNZ/AfbFH5R6ondjYI6hYnHuBUda5QLDRL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VBvVs8wb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739460150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=juWUE5ymX+ztpL/KJJmTfbv7cT9un3Ru4QHjn9WvQRw=;
	b=VBvVs8wbQMfu740Oc5oLMsBqshJw8zErwGDX/5BFpGPqFtM4gZ153DB46wt0ip+DuB2lhb
	rTKb3BwG5Vdw6Kuyxi4ucDHfXVdCfg/CwJk+UhdJwqqkQP+sR+t12Nv4957llDOBMhXTnW
	QA9EwC+Kqyb5xTlBRol54K/FsLd8qdg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-385-PVyQEsocM_mnM3LUBOWsEw-1; Thu,
 13 Feb 2025 10:22:27 -0500
X-MC-Unique: PVyQEsocM_mnM3LUBOWsEw-1
X-Mimecast-MFC-AGG-ID: PVyQEsocM_mnM3LUBOWsEw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C5AE1903085;
	Thu, 13 Feb 2025 15:22:26 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.88])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4111B1955DCE;
	Thu, 13 Feb 2025 15:22:25 +0000 (UTC)
Date: Thu, 13 Feb 2025 10:24:51 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 01/10] iomap: advance the iter directly on buffered read
Message-ID: <Z64OwyZ18KtnnzPU@bfoster>
References: <20250212135712.506987-1-bfoster@redhat.com>
 <20250212135712.506987-2-bfoster@redhat.com>
 <Z62WJACaaAP2oH1S@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z62WJACaaAP2oH1S@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Wed, Feb 12, 2025 at 10:50:12PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 12, 2025 at 08:57:03AM -0500, Brian Foster wrote:
> > iomap buffered read advances the iter via iter.processed. To
> > continue separating iter advance from return status, update
> > iomap_readpage_iter() to advance the iter instead of returning the
> > number of bytes processed. In turn, drop the offset parameter and
> > sample the updated iter->pos at the start of the function. Update
> > the callers to loop based on remaining length in the current
> > iteration instead of number of bytes processed.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/iomap/buffered-io.c | 44 +++++++++++++++++++-----------------------
> >  1 file changed, 20 insertions(+), 24 deletions(-)
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index ec227b45f3aa..44a366736289 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
...
> > @@ -438,25 +438,22 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
> >  	 * we can skip trailing ones as they will be handled in the next
> >  	 * iteration.
> >  	 */
> > -	return pos - orig_pos + plen;
> > +	length = pos - orig_pos + plen;
> > +	return iomap_iter_advance(iter, &length);
> 
> At this point orig_pos should orig_pos should always be just iter->pos
> and we could trivially drop the variable, right?
> 

Hmm.. good point. I think it should be equivalent. I'll give it a test
and drop orig_pos if all works out.

> > -static loff_t iomap_read_folio_iter(const struct iomap_iter *iter,
> > +static loff_t iomap_read_folio_iter(struct iomap_iter *iter,
> >  		struct iomap_readpage_ctx *ctx)
> >  {
> > -	struct folio *folio = ctx->cur_folio;
> > -	size_t offset = offset_in_folio(folio, iter->pos);
> > -	loff_t length = min_t(loff_t, folio_size(folio) - offset,
> > -			      iomap_length(iter));
> > -	loff_t done, ret;
> > -
> > -	for (done = 0; done < length; done += ret) {
> > -		ret = iomap_readpage_iter(iter, ctx, done);
> > -		if (ret <= 0)
> > +	loff_t ret;
> > +
> > +	while (iomap_length(iter)) {
> > +		ret = iomap_readpage_iter(iter, ctx);
> > +		if (ret)
> >  			return ret;
> 
> This looks so much nicer!
> 
> > -static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
> > +static loff_t iomap_readahead_iter(struct iomap_iter *iter,
> >  		struct iomap_readpage_ctx *ctx)
> >  {
> > -	loff_t length = iomap_length(iter);
> > -	loff_t done, ret;
> > +	loff_t ret;
> >  
> > -	for (done = 0; done < length; done += ret) {
> > +	while (iomap_length(iter) > 0) {
> 
> iomap_length can't really be negative, so we could just drop the "> 0"
> here.  Or if you think it's useful add it in the other loop above to
> be consistent.
> 

Indeed.. no particular reason for this that I recall, probably just a
thinko. Will fix.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks!

Brian


