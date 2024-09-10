Return-Path: <linux-xfs+bounces-12829-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6F9973B4B
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Sep 2024 17:17:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DA681C245E4
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Sep 2024 15:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65ED419D07F;
	Tue, 10 Sep 2024 15:17:20 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68EB19ABC6;
	Tue, 10 Sep 2024 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725981440; cv=none; b=Mpn38mA5MB+833IvML+FYclwqryYZSw3DTQl4+/bgMtqbmFiSnKbzikUpUohokjoAkh7DdEWIwiJsg4qjUPfrrxU1/PSPuMOdLjFU3LmsN6qO0aHb7gM3TVvaHpAAhE4Mwf8KyAhk+JPRZ0ZVXwu4BwI2++1FcfBfSm5UmLvx+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725981440; c=relaxed/simple;
	bh=Tl33sND/jY+zAFJyBDLml077offA6Ljf5EtfFkCa/yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDGAit5+q9+dFMDTz7GhSsXnYsOSz7zyuuhvn/XxVbznDBQnJQHRy+jSJSsUBSZMWQLW8qlAAwn53lGghRxQXJptCq+eie3FGH/fXUwTg0Y1B5PPkrz3fFIaFVkZUrBz4XYCvxQwsVLF6fXweC3giGD7T8KJpMVfHBNo7NwhyUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0D4D6227AA8; Tue, 10 Sep 2024 17:17:13 +0200 (CEST)
Date: Tue, 10 Sep 2024 17:17:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: fix stale delalloc punching for COW I/O v2
Message-ID: <20240910151713.GA22893@lst.de>
References: <20240910043949.3481298-1-hch@lst.de> <20240910-deponie-angriff-e9c557fc58bf@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910-deponie-angriff-e9c557fc58bf@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 10, 2024 at 11:21:16AM +0200, Christian Brauner wrote:
> >  - move the already reviewed iomap prep changes to the beginning in case
> >    Christian wants to take them ASAP
> 
> I picked up patches 1-5. It was a bit hairy as I didn't have your merge
> base and I went and looked at https://git.infradead.org/?p=users/hch/xfs.git;a=summary
> but couldn't find the branch this was created from there. It'd be nice
> if you could just point me where to look for any prerequisits next time
> or just base it on some vfs.git branch. Thanks!

This was based on the xfs for-next branch.  For XFS that's kinda obvious,
but for the VFS tree not, sorry.

