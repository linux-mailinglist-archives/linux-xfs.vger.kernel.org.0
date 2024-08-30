Return-Path: <linux-xfs+bounces-12505-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 206E89655D2
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2024 05:43:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B3CDB23502
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2024 03:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE69A139587;
	Fri, 30 Aug 2024 03:42:53 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D192667A0D;
	Fri, 30 Aug 2024 03:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724989373; cv=none; b=Rm8B5I91LjJYpIzHQsm81qrK7pRud95u7cReMF0LcCNFCmuZLvkWtH0HUvDPmtihNVQlb/iZuFClb82KdQjbPK8cWMFp8zQwic008BKGt8TwPvCyFNSBNqO881mDk36PMKj2u6j/ri/wKO5WklgQzz6CP58j9KWW922mTVPNEG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724989373; c=relaxed/simple;
	bh=ehxqUB7kvoK91VInz+QmJlkor1XBmBtzAfDdGaV47pM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sv1xodBe8Oh9R6+1nz81RgeVXGXrnZIJijxVmOJQ5+i5ZlprtJ+IMYHlxROJ1XRDM3xYrwvx8EGU1tzHGWfYBRXO2S4kW2dQXWXhToGNAYaPcv3dftcOBjUYJ5f0LtD3hQM3eU1vPpT7NeMMK9zB7OgoAu47y2fle4YNoLI/yDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9F63B227A88; Fri, 30 Aug 2024 05:42:41 +0200 (CEST)
Date: Fri, 30 Aug 2024 05:42:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/10] iomap: handle a post-direct I/O invalidate race
 in iomap_write_delalloc_release
Message-ID: <20240830034241.GA25633@lst.de>
References: <20240827051028.1751933-1-hch@lst.de> <20240827051028.1751933-2-hch@lst.de> <20240827161416.GV865349@frogsfrogsfrogs> <20240828044848.GA31463@lst.de> <20240828161338.GH1977952@frogsfrogsfrogs> <20240829034626.GB3854@lst.de> <20240829142219.GC6216@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829142219.GC6216@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 29, 2024 at 07:22:19AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 29, 2024 at 05:46:26AM +0200, Christoph Hellwig wrote:
> > On Wed, Aug 28, 2024 at 09:13:38AM -0700, Darrick J. Wong wrote:
> > > Though we might have to revisit this for filesystems that don't take
> > > i_rwsem exclusively when writing -- is that a problem?  I guess if you
> > > had two threads both writing and punching the pagecache they could get
> > > into trouble, but that might be a case of "if it hurts don't do that".
> > 
> > No i_rwsem for buffered writes?  You can't really do that without hell
> > breaking lose.  At least not without another exclusive lock.
> 
> Well, i_rwsem in shared mode.  ISTR ext4 does inode_lock_shared and
> serializes on the folio lock, at least for non extending writes.

ext4 uses plain inode lock/unlock which is an exclusive i_rwsem.
Given that Posix requires the entire write to synchronized vs other
writes applications would break otherwise.


