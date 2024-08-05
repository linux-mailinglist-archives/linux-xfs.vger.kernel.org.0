Return-Path: <linux-xfs+bounces-11281-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 142B8947BC1
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2024 15:25:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD950281333
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2024 13:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F03D15ADB8;
	Mon,  5 Aug 2024 13:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="PuXcxE1d"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1830F156C74;
	Mon,  5 Aug 2024 13:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722864319; cv=none; b=n7lYyp444lVQ+CodF3DGFAODBOE7wbZKMAq73VOGn+xv2U7gRNAWj6z7yEI/6MnRlbp5fKKUNxwPaCD5cvAi6sC2SSmDdQSgG7VXhpgaqYPoPYb9F2UB8YXbE6xnY5hQ98wjYUabdDrS05aCsW1s6v8WVxspUCpi0zUJFrIOwXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722864319; c=relaxed/simple;
	bh=pXFTp+Ee7+WWm9m5TpcqGTAtumc11aH2jFAKLrErjRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKLWMykdJ/zIW1mRlGZe0VTA0tfbnvB7XQXmJ4CsKbdYUDoHeUeeUvynvC59/J6ze1x2ifqWwF4z04FzCD/tf4EWTxTK6Gl4cCYruZgh7zgfLWAFJYe6HF7HkQvQ5Mar+l+9l/D2IjhXeuFxogYcgRFEnLVAmAJ2EgCCVPQlYqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=PuXcxE1d; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Wcxxt44PXz9sWy;
	Mon,  5 Aug 2024 15:25:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1722864306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c+Xw23u08D/qoRPrvrK6+9KGcUXgv/XFJgZyXn7SUuQ=;
	b=PuXcxE1dPjN42JkFy2i6KyJEKozsovshl4jgV9XlY5Wpc1H7CMEL9M28kkmAMTimTW3zxn
	yE/1xXBpOpVmZqxpGjl/udnHQnIMmKkb9JRz6V0tfYnbIsg6KH2IpAmTFRlERKmpselwAP
	UnWn53EBJZEIm1rJPRDZ+KeDizjWhU5qC7UyqqtY7+yH5BC93IjRJISEF7QeAv4U/ZqNxv
	bcwFJE+PUEHTpVKPRn36w7NstmW0l4q06NDM5HjNxC8XTnaI7DD+kDJ9RwOOyL0UGi6ZDJ
	tTWgDhR1UVzTj7nGMVTYBhjKB5IAzRixhQxn+SFzPoY8HrHw3BLKS6hAKf59uw==
Date: Mon, 5 Aug 2024 13:24:59 +0000
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: willy@infradead.org
Cc: yang@os.amperecomputing.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, john.g.garry@oracle.com,
	linux-fsdevel@vger.kernel.org, hare@suse.de, p.raghav@samsung.com,
	mcgrof@kernel.org, gost.dev@samsung.com, cl@os.amperecomputing.com,
	linux-xfs@vger.kernel.org, ryan.roberts@arm.com, hch@lst.de,
	Zi Yan <ziy@nvidia.com>, david@fromorbit.com,
	chandan.babu@oracle.com, djwong@kernel.org, brauner@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH v11 00/10] enable bs > ps in XFS
Message-ID: <20240805132459.ndyofuoyyojqctgt@quentin>
References: <20240726115956.643538-1-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726115956.643538-1-kernel@pankajraghav.com>
X-Rspamd-Queue-Id: 4Wcxxt44PXz9sWy

@willy

The following patches that relevant to you but are missing your RVB. 
Do you think you can take a look when you have time?

readahead: allocate folios with mapping_min_order in readahead
mm: split a folio in minimum folio order chunks

--
Pankaj

> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> This is the 11th version of the series that enables block size > page size
> (Large Block Size) in XFS.
> The context and motivation can be seen in cover letter of the RFC v1 [0].
> We also recorded a talk about this effort at LPC [1], if someone would
> like more context on this effort.
> 
> A lot of emphasis has been put on testing using kdevops, starting with an XFS
> baseline [3]. The testing has been split into regression and progression.
> 
> Regression testing:
> In regression testing, we ran the whole test suite to check for regressions on
> existing profiles due to the page cache changes.
> 
> I also ran split_huge_page_test selftest on XFS filesystem to check for
> huge page splits in min order chunks is done correctly.
> 
> No regressions were found with these patches added on top.
> 
> Progression testing:
> For progression testing, we tested for 8k, 16k, 32k and 64k block sizes.  To
> compare it with existing support, an ARM VM with 64k base page system (without
> our patches) was used as a reference to check for actual failures due to LBS
> support in a 4k base page size system.
> 
> There are some tests that assumes block size < page size that needs to be fixed.
> We have a tree with fixes for xfstests [4], most of the changes have been posted
> already, and only a few minor changes need to be posted. Already part of these
> changes has been upstreamed to fstests, and new tests have also been written and
> are out for review, namely for mmap zeroing-around corner cases, compaction
> and fsstress races on mm, and stress testing folio truncation on file mapped
> folios.
> 
> No new failures were found with the LBS support.
> 
> We've done some preliminary performance tests with fio on XFS on 4k block size
> against pmem and NVMe with buffered IO and Direct IO on vanilla Vs + these
> patches applied, and detected no regressions.
> 
> We also wrote an eBPF tool called blkalgn [5] to see if IO sent to the device
> is aligned and at least filesystem block size in length.
> 
> For those who want this in a git tree we have this up on a kdevops
> large-block-minorder-for-next-v11 tag [6].
> 
> [0] https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/
> [1] https://www.youtube.com/watch?v=ar72r5Xf7x4
> [2] https://lkml.kernel.org/r/20240501153120.4094530-1-willy@infradead.org
> [3] https://github.com/linux-kdevops/kdevops/blob/master/docs/xfs-bugs.md
> 489 non-critical issues and 55 critical issues. We've determined and reported
> that the 55 critical issues have all fall into 5 common  XFS asserts or hung
> tasks  and 2 memory management asserts.
> [4] https://github.com/linux-kdevops/fstests/tree/lbs-fixes
> [5] https://github.com/iovisor/bcc/pull/4813
> [6] https://github.com/linux-kdevops/linux/
> [7] https://lore.kernel.org/linux-kernel/Zl20pc-YlIWCSy6Z@casper.infradead.org/#t
> 
> Changes since v10:
> - Revert back to silent clamping in mapping_set_folio_range().
> - Moved mapping_max_folio_size_supported() to patch 10.
> - Collected RVB from Darrick.
> 
> Dave Chinner (1):
>   xfs: use kvmalloc for xattr buffers
> 
> Luis Chamberlain (1):
>   mm: split a folio in minimum folio order chunks
> 
> Matthew Wilcox (Oracle) (1):
>   fs: Allow fine-grained control of folio sizes
> 
> Pankaj Raghav (7):
>   filemap: allocate mapping_min_order folios in the page cache
>   readahead: allocate folios with mapping_min_order in readahead
>   filemap: cap PTE range to be created to allowed zero fill in
>     folio_map_range()
>   iomap: fix iomap_dio_zero() for fs bs > system page size
>   xfs: expose block size in stat
>   xfs: make the calculation generic in xfs_sb_validate_fsb_count()
>   xfs: enable block size larger than page size support
> 
>  fs/iomap/buffered-io.c        |   4 +-
>  fs/iomap/direct-io.c          |  45 +++++++++++--
>  fs/xfs/libxfs/xfs_attr_leaf.c |  15 ++---
>  fs/xfs/libxfs/xfs_ialloc.c    |   5 ++
>  fs/xfs/libxfs/xfs_shared.h    |   3 +
>  fs/xfs/xfs_icache.c           |   6 +-
>  fs/xfs/xfs_iops.c             |   2 +-
>  fs/xfs/xfs_mount.c            |   8 ++-
>  fs/xfs/xfs_super.c            |  28 +++++---
>  include/linux/huge_mm.h       |  14 ++--
>  include/linux/pagemap.h       | 122 ++++++++++++++++++++++++++++++----
>  mm/filemap.c                  |  36 ++++++----
>  mm/huge_memory.c              |  59 ++++++++++++++--
>  mm/readahead.c                |  83 +++++++++++++++++------
>  14 files changed, 345 insertions(+), 85 deletions(-)
> 
> 
> base-commit: 2347b4c79f5e6cd3f4996e80c2d3c15f53006bf5
> -- 
> 2.44.1
> 

