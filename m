Return-Path: <linux-xfs+bounces-12140-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA1B95D4CB
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2024 20:00:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D79D1C228EB
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2024 18:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB7F819149E;
	Fri, 23 Aug 2024 18:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s8Dd+gwH"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA4A18DF62
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 18:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724436002; cv=none; b=Uz0oZNZt0vLOLZTrh/Jclqu8HeeCTJ/oj2MotvXOoHAvroekgYvn4XD7u2eBUigwmIg72UUdRRmYylGAqeLjtigs9H78cJLWJskXX3qNqhLLff3Lh3aHffel0sfBZh5ZztPmUR3PjPa2Ye9Nh2mBa4DuWrvxmcKhzwU15CYnaUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724436002; c=relaxed/simple;
	bh=8/dt3A3D7QifUOSsUMfZ8weR8+8l1DVfj7N5iRa5nyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JKK2vQ3AupC1Ux0buieHs04XWlZFnoP3dzwwit1sRVp6BwIDMbd7OM94BqDNMBxqWUy74H4rmMNnTpMCPH38A3psqPtp0GGjTox3Kpp1sNMYfuB22k0omwTRcc611nhzvu2C6J6W/6T480a3LcnI9lcoIc6kDj6wfMf/9/qFIok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s8Dd+gwH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF17C4AF09;
	Fri, 23 Aug 2024 18:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724436002;
	bh=8/dt3A3D7QifUOSsUMfZ8weR8+8l1DVfj7N5iRa5nyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s8Dd+gwHEKdSJVGQevYcQC9tPDjHhC6xQ+LwbW+ef/lr3nigxmVWtYnE0D9lgN1ap
	 DpECvjEBZIg2ssNX6WAeQyB0sdpvl8FJxSYGs5mHR6Wm9I+V4J5i8yruqdMjGm6FUg
	 pIca/7QE8cqCNnYxjlI6Rc0CPQmLrYmyk8WgzOw0AeNdszgZJxkHADmdKWkoa45q/z
	 947GxpIZ2erK4AmzGTxUPX1lLTmCBIcrfP8n2vYGMoFjmj9U5vQCHPtsJhv2rLideM
	 F55cf9C/CaEuefZbB8OjFMQg48msAQMMb1z6vHQ5XUk0Okllre3OIqiW4gwSW9pNrr
	 gBya2sKR1C59A==
Date: Fri, 23 Aug 2024 11:00:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/26] xfs: metadata files can have xattrs if metadir is
 enabled
Message-ID: <20240823180001.GN865349@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085484.57482.17914105316962083187.stgit@frogsfrogsfrogs>
 <ZsgVCOsDBJ1HQviI@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsgVCOsDBJ1HQviI@infradead.org>

On Thu, Aug 22, 2024 at 09:50:16PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 22, 2024 at 05:06:50PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If metadata directory trees are enabled, it's possible that some future
> > metadata file might want to store information in extended attributes.
> > Or, if parent pointers are enabled, then children of the metadir tree
> > need parent pointers.  Either way, we start allowing xattr data when
> > metadir is enabled, so we now need check and repair to examine attr
> > forks for metadata files on metadir filesystems.
> 
> I think the parent pointer case is the relevant here, so maybe state
> that more clearly?

I'll change this to:

"If parent pointers are enabled, then metadata files will store parent
pointers in xattrs, just like files in the user visible directory tree.
Therefore, scrub and repair need to handle attr forks for metadata files
on metadir filesystems."

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D

