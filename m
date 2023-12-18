Return-Path: <linux-xfs+bounces-876-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AEF58165A7
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Dec 2023 05:30:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DB361C21392
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Dec 2023 04:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F3C63AA;
	Mon, 18 Dec 2023 04:30:47 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9340563A3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3F5F868BFE; Mon, 18 Dec 2023 05:30:39 +0100 (CET)
Date: Mon, 18 Dec 2023 05:30:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: remove struct xfs_attr_shortform
Message-ID: <20231218043038.GA15579@lst.de>
References: <20231217170350.605812-1-hch@lst.de> <20231217170350.605812-8-hch@lst.de> <ZX9kLBb6vYGsQMhy@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZX9kLBb6vYGsQMhy@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 18, 2023 at 08:12:12AM +1100, Dave Chinner wrote:
> > +struct xfs_attr_sf_hdr {	/* constant-structure header block */
> > +	__be16	totsize;	/* total bytes in shortform list */
> > +	__u8	count;	/* count of active entries */
> > +	__u8	padding;
> > +};
> > +
> > +struct xfs_attr_sf_entry {
> > +	__u8	namelen;	/* actual length of name (no NULL) */
> > +	__u8	valuelen;	/* actual length of value (no NULL) */
> > +	__u8	flags;		/* flags bits (see xfs_attr_leaf.h) */
> 
> May as well correct the comment while you are touching this
> structure; xfs_attr_leaf.h has not existed for a long time. Perhaps
> just "/* XFS_ATTR_* flags */" as they are defined a little further
> down this same file...

Yeah, I'll update it for the next version.

