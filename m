Return-Path: <linux-xfs+bounces-20397-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CE0FA4B507
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Mar 2025 22:49:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AC9F188A9BB
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Mar 2025 21:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D52B1E9B0B;
	Sun,  2 Mar 2025 21:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.b="sKRHcC9p"
X-Original-To: linux-xfs@vger.kernel.org
Received: from pannekake.samfundet.no (pannekake.samfundet.no [193.35.52.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A564E1CAA87
	for <linux-xfs@vger.kernel.org>; Sun,  2 Mar 2025 21:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.35.52.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740952181; cv=none; b=I7+nlVs8S2JFjq5sxjQcEprDVJi3oF676ZgnH8im6d+qPycApKs48WmiWRiTiwSmB0GDiY8bMQspVPjwU8p+uQmrwGSi5NotcrGNTs7dRwxiwRwbvwYwyuTcHBWAs+lF9QN6Ot16RHJpde4LzlbYSt1kIm5hbaq9YswYGfqt31A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740952181; c=relaxed/simple;
	bh=ltjihaonSNa+3FpAWBo03Rig9hlI4b+/P9mbl283Axk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JgVyXVvmwd8gQ2L36KlljcSZOisV2U4tIQX6AG/jXbmxUHUBZ+LICS226pmeez92cxzB/8gYoerHrxKnRBxkHNU+1tvSrYFXzr5P9ekP23Hdi0gJObXNlFDzfCPBR1jgfSfYcowGw2Pu7FISTO5XJsDWxMiKTSlyF8iEaSSgHSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no; spf=pass smtp.mailfrom=gunderson.no; dkim=pass (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.b=sKRHcC9p; arc=none smtp.client-ip=193.35.52.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gunderson.no
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gunderson.no; s=legacy; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NbXt1iuImHsZkTQJ63BbBZAQQ3XgvZb0aoD3IjQEPrs=; b=sKRHcC9pU7zP5mJZutzkBmktuN
	8PiDEp1IJbClMn+Yno50rvV7HL3vHGMr+cJchGyORzwGwW21QC5svI7TiDHK3ydeUi66ccCzxE9rQ
	UE5AUsSsVWSHCjpmXKcjZEExLjSjdgL299YieL/tc3vo4Jdzj6Gb7ZpaFfbhF8ondZl8NM7jBgPIW
	HYShyaHxgW2SnZ4aYPB7y6IoohoKzQkHG3i5yHi/YYqJYGuz7RPcEEW9ln+CtRqOun835D9FrHmH3
	tJgJ13N5G2Ot92Smhnjw4QWcYr1G7TO1tOiR39P/C+3Cmda1lzPMzmkfB8GAP4xhCc00vZQ1iBnJt
	KGOaI69w==;
Received: from sesse by pannekake.samfundet.no with local (Exim 4.96)
	(envelope-from <steinar+bounces@gunderson.no>)
	id 1torBl-007kbI-0I;
	Sun, 02 Mar 2025 22:49:36 +0100
Date: Sun, 2 Mar 2025 22:49:33 +0100
From: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Slow deduplication
Message-ID: <20250302214933.dkp743wxlo624aj7@sesse.net>
X-Operating-System: Linux 6.13.0-rc4 on a x86_64
References: <20250302084710.3g5ipnj46xxhd33r@sesse.net>
 <Z8TPPX3g9rA5XND_@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z8TPPX3g9rA5XND_@dread.disaster.area>

On Mon, Mar 03, 2025 at 08:35:57AM +1100, Dave Chinner wrote:
> This does comparison one folio at a time and does no readahead.
> Hence if the data isn't already in cache, it is doing synchronous
> small reads and waiting for every single one of them. This really
> should use an internal interface that is capable of issuing
> readahead...

Yes, I noticed that if I do dummy read() of each extent first,
it becomes _massively_ faster. I'm not sure if I trust posix_fadvise()
to just to MADV_WILLNEED given the manpage; would it work (and give
roughly the same readahead that read() seems to be doing)?

After 12 hours or so of this massive I/O, seemingly the page cache fragments
really hard and I'm left using 99% in xas_* functions (on read()) until I do
drop_caches and it clears up again. I'm not sure if this is deduplication-related
or not. :-)

/* Steinar */
-- 
Homepage: https://www.sesse.net/

