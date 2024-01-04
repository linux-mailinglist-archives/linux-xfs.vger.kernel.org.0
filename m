Return-Path: <linux-xfs+bounces-2543-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D33823C37
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jan 2024 07:24:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18A36B2181E
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jan 2024 06:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AA51CAA2;
	Thu,  4 Jan 2024 06:24:35 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50F91C6A1
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8921368B05; Thu,  4 Jan 2024 07:24:30 +0100 (CET)
Date: Thu, 4 Jan 2024 07:24:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 09/15] xfs: don't allow highmem pages in xfile mappings
Message-ID: <20240104062428.GC29215@lst.de>
References: <20240103084126.513354-1-hch@lst.de> <20240103084126.513354-10-hch@lst.de> <20240104000324.GC361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104000324.GC361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 04:03:24PM -0800, Darrick J. Wong wrote:
> > +	/*
> > +	 * We don't want to bother with kmapping data during repair, so don't
> > +	 * allow highmem pages to back this mapping.
> > +	 */
> > +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> 
> Gonna be fun to see what happens on 32-bit. ;)

32-bit with highmem, yes.  I suspect we should just not allow online
repair and scrub on that.  I've in fact been tempted to see who would
scream if we'd disallow XFS on 32-bit entirel, as that would simplify
a lot of things.


