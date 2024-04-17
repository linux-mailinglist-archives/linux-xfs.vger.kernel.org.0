Return-Path: <linux-xfs+bounces-7042-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6172F8A87BA
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 17:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B2F1282E75
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 15:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35411482F3;
	Wed, 17 Apr 2024 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gu8caGMp"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A275C147C8D
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713368097; cv=none; b=k1tmf1P4GW7yU0aVTEKhWAdx0nALXrOdOqiaWfuYoF4bALs76zBzKEkcYMgPEhaNlZUbc86LtNVKQpv2gwt6tgNOggfYGPkO2eu50lT7IDuMxIv7NbHUHXTa6G299uMMER8OjQ99Sb7L0lWhhpU7JtOEa0yq0aK4ExJBdTIBmuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713368097; c=relaxed/simple;
	bh=uYmKEqNFeNwzPhOnYA8IhDQe8hEbZ3Nubus5XA+UmpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmzCMT9FVjOOoviX4Xn9/keigTx0qJuq2NOxl3keR7QFhchkGKld8DE3VXJlXjJCi8CMIDYFRYqR2DF7p04J7cJhq2tgsdc+IxH1yfqtQNQEEyPgSAv/ZXtr1xOXgxfSgM9YwlUg0RY5hoDTV1WxESGo4Pap123sDF9bt61csO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gu8caGMp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D68C072AA;
	Wed, 17 Apr 2024 15:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713368097;
	bh=uYmKEqNFeNwzPhOnYA8IhDQe8hEbZ3Nubus5XA+UmpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gu8caGMpWgcoT9k64YAn7tyb9lQICtzya991IKINrUwfPqCEASYyXvkhVP0CPPROZ
	 ru3KBDyW+T8PIApTGeTKOdwEHkHUBlc6YbKDFgVE1S9LGXbofffU0CEGVTlfMM9Ke3
	 E35S5ixDQ/2Qza1ZqNeBZqpgofKJJZqjWGWhPhgkp01aVR+iTSFgXNpItFgttEWyqG
	 WeQblrOuCPhu/kDe8Mskc/ckrezTUWSfJAOEPZggb050MzZoN8zoVbeOEpFOK895FZ
	 aMdfjgHch3FiR72sX1Mo0BzZopM4ybDYjo2pzOOYyT5ZRfJRi8L2BP9AxKI0phTgJq
	 beW6HMXvXcI9A==
Date: Wed, 17 Apr 2024 08:34:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs v6.7.0 released
Message-ID: <20240417153456.GZ11948@frogsfrogsfrogs>
References: <fcm36zohx5vbvsd2houwjsmln4kc4grkazbgn6qlsjjglyozep@knvfxshr2bmy>
 <mMHk0yaj9LgGgzujpBfn8GpG3uZmXbQHUrGp5m_ZJWUAwpcEcZWzMa0KUUcZ8_oQ5T6lDTu0CcOl-hYmW7z-MA==@protonmail.internalid>
 <20240417151834.GR11948@frogsfrogsfrogs>
 <pvsrakeforclh6cg576qn4u3ifgtzl6iwebzyjvxtvxqh2ph55@muhndh3a536k>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pvsrakeforclh6cg576qn4u3ifgtzl6iwebzyjvxtvxqh2ph55@muhndh3a536k>

On Wed, Apr 17, 2024 at 05:32:15PM +0200, Carlos Maiolino wrote:
> On Wed, Apr 17, 2024 at 08:18:34AM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 17, 2024 at 10:13:52AM +0200, Carlos Maiolino wrote:
> > > Hi folks,
> > >
> > > The xfsprogs repository at:
> > >
> > > 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > >
> > > has just been updated.
> > >
> > > Patches often get missed, so if your outstanding patches are properly reviewed
> > > on the list and not included in this update, please let me know.
> > 
> > Ah well, I was hoping to get
> > https://lore.kernel.org/linux-xfs/171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs/
> > and
> > https://lore.kernel.org/linux-xfs/20240326192448.GI6414@frogsfrogsfrogs/
> > in for 6.7.
> 
> To be honest, one of the reasons I decided to release 6.7 today, was because these patches were
> cooking for too long on the list, and I wanted to pull them this week, but not delay 6.7 because of
> them as I want to also not delay 6.8 for too long, mostly libxfs-sync and what we already have on
> the list. The debian one I totally missed it btw
> 
> Also, I was assuming you were going to send PRs for these series according to our previous talks,
> will you still submit PRs or shall I pull them from the list?
> 
> I'll try to pull those patches you meant asap.
> 
> I could do a 6.7.1 release with the debian patch if this is really required, but I don't think it
> will change anything if I simply postpone it for 6.8.

Well if we get a 6.8 release out fairly fast then it might not matter --
Debian are busy rebuilding the world with 64-bit time_t and altered
package names.

--D

> 
> > 
> > --D
> > 
> > >
> > > The for-next branch has also been updated to match the state of master.
> > >
> > > The new head of the master branch is commit:
> > >
> > > 09ba6420a1ee2ca4bfc763e498b4ee6be415b131
> > >
> > > --
> > > Carlos
> > >
> > 
> 

