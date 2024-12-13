Return-Path: <linux-xfs+bounces-16720-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B5EF9F0401
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 06:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AF66283511
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 05:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA6A81632FA;
	Fri, 13 Dec 2024 05:06:22 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F90291E
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734066382; cv=none; b=TVcN/lcEwOEHgxTxDPZ7yUwDEDkhmAxwL4fef6+z60l1j309ZnpnQx+CjELdtsnvRbcVSCV0YOvVAD11OP9A7c9JaFq8gsE/nuDvkvghRLFhBhF6qgXiQQ8/ca47IjbEmVJIUGad38PJk/XCX+bfvoY0cH+49e6z6dH9ehkYqqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734066382; c=relaxed/simple;
	bh=8fb74cEIRHBlD1oDS4lCnvpx9Q1nypsJVQD2wXEgYq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rEpeIHytHMHwX1+rFPM70TXi86yrrW0rk6VK+Vh924mCYFfxaRK7WKJMJRu5hPlAIfqtQdoJOgbEjUKmXD4AUfliUvg35Q/glb5sn4Z5gJpnz/JvlNBtYNVG+/VXUF/TY2CzW+bAzfSF3yL/5PhF7IutHANXQMzGx4MRkMlF1FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6645F68BEB; Fri, 13 Dec 2024 06:06:16 +0100 (CET)
Date: Fri, 13 Dec 2024 06:06:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/43] xfs: don't take m_sb_lock in xfs_fs_statfs
Message-ID: <20241213050615.GC5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-6-hch@lst.de> <20241212214206.GX6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212214206.GX6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 01:42:06PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:54:30AM +0100, Christoph Hellwig wrote:
> > The only non-constant value read under m_sb_lock in xfs_fs_statfs is
> > sb_dblocks, and it could become stale right after dropping the lock
> > anyway.  Remove the thus pointless lock section.
> 
> Is there a stronger reason later for removing the critical section?
> Do we lose much by leaving the protection in place?

It makes a completely mess of xfs_fs_statfs, and as stated in the
commit message about it's not actually useful at all.  I also don't
think taking a global lock from a non-privileged operation is an
old that good idea to start with if we can avoid it.


