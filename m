Return-Path: <linux-xfs+bounces-19895-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D3C5A3B17E
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 07:14:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BF7E3AFE88
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 06:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1691B425A;
	Wed, 19 Feb 2025 06:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afowCAde"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FA9192B66;
	Wed, 19 Feb 2025 06:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945638; cv=none; b=U2RmEzLLf0O9ExJGtXtxyxxO8i+1kJzAO7czl9l2mTiu3cHZzoqXjKv6HK4JZj/AKziREq5JdGWfHAv0rXOyxUl7iX3xXTOkGcDxUS5onVsD4RwJmLyrck9wZmXrenbgliglj95sLvvflcddWCZdmIm3V06tG9AUoCo4pewB9Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945638; c=relaxed/simple;
	bh=NpS9F+CA9dQmH5LWQkUTEymLfUpa82STLRUn09XGFm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/ccef3X8vXvP9RpIXW29vzhWqHmj28GpDcvJ7SxUQ+vHt9WVMErSa9IXsSvIiREEqIc27FL14C9dBXE7hDBh0HCBk5uLTjksevnalzmXByoFT2SqkEEWyKFtSFA01AmIAGvC/vyVkKCO8s6JXw3EsSGpCwjcC6aGgGMxCB/mNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afowCAde; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91469C4CED1;
	Wed, 19 Feb 2025 06:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739945637;
	bh=NpS9F+CA9dQmH5LWQkUTEymLfUpa82STLRUn09XGFm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=afowCAdevGbnS3WDWv0URXySk3RpCYHrnvf1vWf+4XOHiF4xl2WEqQXqwU2VzMw/P
	 x9Dr5liLA22xyF3VHxOYiHGK8AWnU3t05VdH1rjRULjokTuvPQnQ6XrkptYV8dKbJ+
	 LF1FXXBfXQNtTKA6HaBH4oSFyM9RVvqHqGJkX/BFpSHc8xwyq2NvFZFf8N8aJrz4xA
	 guSPjuIdw+w499QU6xwbuOgvUzq3YZBm0bJd1YQda6CGwZ0qLYh1/Td3T6pGp6uhMK
	 ptSADDqqm9gFYT7gaxKJS3rbml4u/H2+iz8Fiv1yY9bwzNbhivJ2uEN0MOhs2ayVxu
	 FITat+QwNgLhg==
Date: Tue, 18 Feb 2025 22:13:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs/28[56],xfs/56[56]: add to the auto group
Message-ID: <20250219061357.GX3028674@frogsfrogsfrogs>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587607.4078254.10572528213509901449.stgit@frogsfrogsfrogs>
 <Z7VzmdxUtQcNcgzS@infradead.org>
 <20250219060504.GW3028674@frogsfrogsfrogs>
 <Z7V1Ru-05o2iFgzw@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7V1Ru-05o2iFgzw@infradead.org>

On Tue, Feb 18, 2025 at 10:08:06PM -0800, Christoph Hellwig wrote:
> On Tue, Feb 18, 2025 at 10:05:04PM -0800, Darrick J. Wong wrote:
> > > Can you explain why only these four?
> > 
> > The rest of the stress tests pick /one/ metadata type and race
> > scrub/repair of it against fsstress by invoking xfs_io repeatedly.
> > xfs/28[56] runs the whole xfs_scrub program repeatedly so we get to
> > exercise all of them in a single test.
> > 
> > (The more specific ones make it a lot easier to debug problems.)
> 
> Can you add this to the commit log?  With that:

Will do!

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D

