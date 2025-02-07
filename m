Return-Path: <linux-xfs+bounces-19266-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90240A2BA12
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Feb 2025 05:15:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0D8E1888D16
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Feb 2025 04:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B013517995E;
	Fri,  7 Feb 2025 04:15:49 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750282417CA
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738901749; cv=none; b=SJ7x8yHeysvrS5QbiRMZK2exDFLp0FnPPU9IZAJk8vpkuezJ/4/XEkv2mCrfZ/bL3xs2Hcp64ubzd7/PM9ueA9wwBDNoXTqT+u9nve5W1RGfyx9voCzAneskKCKlYN0GqIz+WDEV4HWYEDyTB8ljSdiDq4YquqcFeyK5z7fzKcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738901749; c=relaxed/simple;
	bh=FSNVZdIozYUxza9DqMiGC+i4tg+puSBV81Hc/c/IlCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EgeiPjI7tFIkSSYu+L8tXYaiB5+GFzIqDRWT1IL9VBim9BG1BGg5kD+t73MDfrpr4t10bfC9cRgEx1f1531op8HpNUOxEIMs8JuLQ58OIts0D47ReUy0oF3DVyIE0Dp+K1n6ivGHOPHrC1o7M4EbnUKj6c2eJ7FiH0Uru63+6es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C28DC68C4E; Fri,  7 Feb 2025 05:15:42 +0100 (CET)
Date: Fri, 7 Feb 2025 05:15:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/43] xfs: skip always_cow inodes in
 xfs_reflink_trim_around_shared
Message-ID: <20250207041542.GA5467@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-5-hch@lst.de> <20250206201351.GH21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206201351.GH21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 06, 2025 at 12:13:51PM -0800, Darrick J. Wong wrote:
> Hmm.  So this is to support doing COW on non-reflink zoned filesystems?

Yes.

> How then do we protect the refcount intent log items from being replayed
> on an oler kernel?

There are no refcount intent log items for this case.


