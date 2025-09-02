Return-Path: <linux-xfs+bounces-25208-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6C17B41001
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Sep 2025 00:23:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37B0E1A830A5
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Sep 2025 22:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37305278158;
	Tue,  2 Sep 2025 22:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ObA/JRqx"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A982773D0;
	Tue,  2 Sep 2025 22:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756851776; cv=none; b=G8FDIYh819TGIvg5IUw7LquMUPvuOKymOcQqAqNcc31uJd8KKVfX6HwJqynhXg2/ZuZ4bBLss4PhAgU4i7tHdzot/uskfo4JIwe3B7Z1cbKbmk5X4ESH+7GSdUf1gkrTDwzQkNUpCzVajd4+ozZ+Xa9Zlhn8RogUoPU1bmUTOg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756851776; c=relaxed/simple;
	bh=NCIDcOxJx/19jaVFJTGaNrKrJyqWxUJB41YzSzIf6sQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MKDdH8JGzi/XU+vGHKvDpr8pExfhe8B5LG+h0AFKuC2t+j/sb43dJFAgiIHcx/1P+r9wUL9kKxFV1vSrDmiyi/h5acKQkfXcFEe8iH6j4AkRwB6W4+4nPGrs5YMDv0LJDH8vIH91nmfC/6zkFZLoZdps/14YjzfcMOCXJhr209M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ObA/JRqx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69028C4CEED;
	Tue,  2 Sep 2025 22:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756851775;
	bh=NCIDcOxJx/19jaVFJTGaNrKrJyqWxUJB41YzSzIf6sQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ObA/JRqxPHzwzTtCrHwcrKIf+jjgNEUv15uXGr016aOO4LErLILjS0y00VKB+Vfhw
	 n9vFIicQZI5HlAmKsjFXTTxqPTfoks0txGGk5UBeOd3PfQlcEljzQR+f0hqcrNOvc5
	 WTq3dcEeXlGysb0dcO+d25s3G+H7mLibxvydT5z+o+eBwpFd+olro/fLpBadk1TzEf
	 c2Bijw+58IGjbivasjIbCks2Kckj7X1dJ5b68TsQr5cWBqD+bQ/7oYCclMrfIX3Oaj
	 rcxa4enR+4Y/G2phPBMMEQjKU2eqESBD/HFnYuPQ1RTE43evoHYkbtchTzj5/c2Ih5
	 OxHdJNSwDPyVg==
Date: Tue, 2 Sep 2025 15:22:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: use deferred intent items for reaping
 crosslinked blocks
Message-ID: <20250902222254.GI8096@frogsfrogsfrogs>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
 <175639126502.761138.11864019415667592045.stgit@frogsfrogsfrogs>
 <20250902062545.GC12229@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902062545.GC12229@lst.de>

On Tue, Sep 02, 2025 at 08:25:45AM +0200, Christoph Hellwig wrote:
> On Thu, Aug 28, 2025 at 07:28:38AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When we're removing rmap records for crosslinked blocks, use deferred
> > intent items so that we can try to free/unmap as many of the old data
> > structure's blocks as we can in the same transaction as the commit.
> 
> Shouldn't this be at the start of the series?

Yeah, will move it.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D

