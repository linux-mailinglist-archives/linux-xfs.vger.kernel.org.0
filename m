Return-Path: <linux-xfs+bounces-951-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C4B981806F
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Dec 2023 05:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5D1B1F24A2B
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Dec 2023 04:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7F65393;
	Tue, 19 Dec 2023 04:21:44 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECC05380
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 04:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7715B68AFE; Tue, 19 Dec 2023 05:21:39 +0100 (CET)
Date: Tue, 19 Dec 2023 05:21:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move the xfs_attr_sf_lookup tracepoint
Message-ID: <20231219042139.GB30534@lst.de>
References: <20231217170350.605812-1-hch@lst.de> <20231217170350.605812-4-hch@lst.de> <20231218223902.GC361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218223902.GC361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 18, 2023 at 02:39:02PM -0800, Darrick J. Wong wrote:
> > -	trace_xfs_attr_sf_lookup(args);
> > -
> >  	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
> >  	sfe = &sf->list[0];
> >  	for (i = 0; i < sf->hdr.count;
> > @@ -905,6 +903,9 @@ xfs_attr_shortform_getvalue(
> >  	int				i;
> >  
> >  	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
> > +
> > +	trace_xfs_attr_sf_lookup(args);
> 
> Shouldn't this get renamed to trace_xfs_attr_shortform_getvalue to match
> the function?  Especially since xfs_attr_shortform_lookup disappears
> later, AFAICT.

If we value accurate naming over being able to use a historical
trace point: yes.  Although in that case I'd probably structure it
as a patch adding the new xfs_attr_shortform_getvalue tracepoint only,
and removing the xfs_attr_sf_lookup one with the function.


