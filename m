Return-Path: <linux-xfs+bounces-25778-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37DBBB859EA
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Sep 2025 17:32:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EABF620F57
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Sep 2025 15:29:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C4F521B9D2;
	Thu, 18 Sep 2025 15:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iuG1DJVe"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C642224AF0
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 15:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758209338; cv=none; b=HhCSBE8l20VI7DtuRqVNmWC86Ywgm1vxjmnmCvY8exsW66USe0DSw+RzaHnIJrrg/6mllwxkdP4QjhHUZt/zdU6JceEWpn6Op0btmlas30+mcx2IjQbLEqjX3/krrQeycVZr6ve4J6t1QmELlUBekbM2o/8Y/sug/aZPEjb8QDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758209338; c=relaxed/simple;
	bh=0M2dMHIHd91EeY9Z9Dz9BvhytnQWc7QSWYa1zbdFhbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tS6nbap6R/5O0jV8w2oFmv/pIttlWgj0uj1/3UcbZUWfIsOHQYxQcw0m5vaSPYN7wCCRYOjON+Qjsd/l/sTbndNJisPbeB+6rm031v+DyMzBsa4cqdaK+OyKYSJkCi9uOaMDWXRhtPMp49YYkhlTOvaCmlvSJ/hr0MznzQb8XHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iuG1DJVe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8C6C4CEE7;
	Thu, 18 Sep 2025 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758209337;
	bh=0M2dMHIHd91EeY9Z9Dz9BvhytnQWc7QSWYa1zbdFhbg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iuG1DJVeSvEiwa4jznHnGSbc7Kxtcm/DzU9ZwNs40ULBN4LtmS+yfvnrA/x0yJoLE
	 ywZlxBGqpQC/f1c7nL8x5VEewz2vPOxvL9HEMPxuZ1cPSODM4BMA7uP+J2thoPSl+Q
	 m5ux+cO1fnRzGC8noLgBDwgqNcZtvlj8+xyDIQuYtftQ/bQC0yMOyGkjzKLf3Di3sY
	 4xHPmfVdobbaP38lJOSLEPNoECBu7/iitECbfvV5hZ2N/BCfByIAUEuoSQhrdUm8lD
	 UcccguDjo+aF4bR4yfZEzkqOkO78+Lly9hydqE0plefX0Ehkx1A1Hx5jTHri1tFUIp
	 hMIGPlV6w6MeA==
Date: Thu, 18 Sep 2025 08:28:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/2] Some minor improvements for zoned mode
Message-ID: <20250918152857.GH8096@frogsfrogsfrogs>
References: <20250918130111.324323-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918130111.324323-1-dlemoal@kernel.org>

On Thu, Sep 18, 2025 at 10:01:09PM +0900, Damien Le Moal wrote:
> A couple of patches to improve a mount meaasge and to improve (reduce)
> the default maximum number of open zones for large capacity regular
> devices using the zoned allocatror.

That all looks fine to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> Changes from v1:
>  - Improved XFS_DEFAULT_MAX_OPEN_ZONES description comment.
>  - Removed capitalization from commit titles 
>  - Added review tags
> 
> Damien Le Moal (2):
>   xfs: improve zone statistics message
>   xfs: improve default maximum number of open zones
> 
>  fs/xfs/libxfs/xfs_zones.h | 7 +++++++
>  fs/xfs/xfs_zone_alloc.c   | 4 ++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> -- 
> 2.51.0
> 
> 

