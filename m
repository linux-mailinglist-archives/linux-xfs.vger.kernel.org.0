Return-Path: <linux-xfs+bounces-4507-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D66386D031
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Feb 2024 18:10:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37B5C28278F
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Feb 2024 17:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469BB3839D;
	Thu, 29 Feb 2024 17:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t/ACR1VR"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF914383BB
	for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 17:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709226645; cv=none; b=bVvGO5JdFj466V6FbBWTYfgTdBCaReON/H78ha4DruAYdQeZsIC1OocxyMfWBW78aCUSz79AZqzv8Vo5AZyeBaVbROGfbDSRChCM2WEJ4VGKkC6KbR6L1iiDBUqwSUi+FWujSitv++qEV2whao1eNsG4iKvmUpZKWJwCW92m8n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709226645; c=relaxed/simple;
	bh=ChhtmMibOmTZUcDhTGdzCFyRQ8St/iVQNvu3TdmkOI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bR58fF7A5SdDxSBE2GcCAQeTF96p50+O7+Bma2eqT0rtHe0MSl20BJvI19FSs3In8KxEd3PIvlIn5GbBBVkntDtnGoyGcr4bBS3YzpZTIpKdqcS7Zqy2FyODkytRYh158oEsT3ECSBc8mn+SW5yHtujcLgifZOmhtXDv6QtVknw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t/ACR1VR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61406C43390;
	Thu, 29 Feb 2024 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709226644;
	bh=ChhtmMibOmTZUcDhTGdzCFyRQ8St/iVQNvu3TdmkOI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t/ACR1VRvxzmrYMfDPEhz106hDTOVGIndaG/Y8MI2K8qtdsz1vGg5oiUlhv+YrPOC
	 Fw+pWxLHmZUp+BjoDc3Nu5SmDNr2xJ0C1ffRNcr4p6zZ1uzVfBpVx5rqFOK1esHoVW
	 Sj5jX/AmEOuDE82S+nq4y+FwL1ywpu+YCKkTGrPUfxqm1rMF2hvh8vVEqnJsnCOQgS
	 11wD5xkkaa30GJUIGGR7hrcu+v0PRQ5ht4Pb74+NUPbrBDfKhLfCF82iunZZc59Cfx
	 xNch4gw4bBOrqELFZyKgQhILs9LlJu/CC9jQ4uaTyvu63n8u7civ41PyFH6AnTsQcp
	 xtkM7gsyBgm6g==
Date: Thu, 29 Feb 2024 09:10:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/14] xfs: introduce new file range exchange ioctls
Message-ID: <20240229171043.GZ1927156@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011673.938268.12940080187778287002.stgit@frogsfrogsfrogs>
 <Zd9U4GAYxqw7zpXe@infradead.org>
 <20240228193547.GQ1927156@frogsfrogsfrogs>
 <Zd-LdqtoruWBSVc6@infradead.org>
 <20240228230057.GU1927156@frogsfrogsfrogs>
 <ZeCFBZVX2yjAw-5n@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeCFBZVX2yjAw-5n@infradead.org>

On Thu, Feb 29, 2024 at 05:22:13AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 28, 2024 at 03:00:57PM -0800, Darrick J. Wong wrote:
> > The offsets and lengths for FICLONERANGE are unsigned, so I think
> > xfs_exchange_range ought to follow that.
> 
> Yes.  I though I had actually brought that up before, but I might have
> wanted to and not actually sent the comments out..

You mentioned it in passing, but I misinterpreted what you'd said and
took the signedness in the wrong direction.  Here's what I went with in
the end:

struct xfs_exchange_range {
	__s32		file1_fd;
	__u32		pad;		/* must be zeroes */
	__u64		file1_offset;	/* file1 offset, bytes */
	__u64		file2_offset;	/* file2 offset, bytes */
	__u64		length;		/* bytes to exchange */

	__u64		flags;		/* see XFS_EXCHANGE_RANGE_* below */
};

--D

