Return-Path: <linux-xfs+bounces-7633-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7249E8B2D30
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Apr 2024 00:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02994283EA2
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Apr 2024 22:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC7E84D0D;
	Thu, 25 Apr 2024 22:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JrN+gwGB"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815792599;
	Thu, 25 Apr 2024 22:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714084837; cv=none; b=i9A/SDT5YQ5u0WTJ4NKvBb4oQoLxKG30QiQVnjEGP6aFd0DHCFgo52LKDN2xaa9kcoC6k1OvyXek8mSqsp7Z1B2W9FPWp7HSKi/AZcGA3H06azeDvfEo4iAymb7TynhMPARkqtzxKGBZzSSs6n+79eEVo63cbG/rTN6xcfkRL2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714084837; c=relaxed/simple;
	bh=isimwcOHdDK7dQ5J/GY/2fBT8r4/NY8PJ8OszygoMX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4aMOEyj39BtUTL457CtifU6Ma1pb6AEd8+zw6MryGIcgQlH+CYJ+ZMOItEI4YSFIYjgY9FwMr5iI/ttUXvg/kHIoZtdGOrnC4XWC1hhvt0OD/CjmZoFeONRBneS+rQiChWE1cE8+q6UZbg5lB/s3ZRvPnnqUDvkwcPIb2pgomY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JrN+gwGB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=Pv6DAoPFFNrD4sYIPF/agyqOANkVbxxZ+lZCZEZ+GiM=; b=JrN+gwGBiCeml7wT9b6Ytx+8zr
	E199uP12fHkIKlQBzuWwF3kTvVpMlFuwd5s25SPo+4NkOMRvOr2Imy6xxJJF+njOuGptf8Zew0Ibq
	KPjc39y8562tf4ByOhadWH7GuD1gVuM/dqzfYIrpG8Tk/3SOHdFDjAWP4tRmTTZFIb06BzcWIbp/4
	tlRQRwmmabiIUYsZgpe6gtzHLjpAP7MLAxo2DDaJ65Ar8XiM7nHR40HOtJ4/3WYmDY6H/L9DPs1rC
	Bl93lsDBs8NkuMqNge2MOiiMM7JSM+k1VTdlNjlGa+C+rM/tCKK6kFFrOAuAXEFAaCT73kRxIkhzH
	dSMCCz5w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s07lY-0000000AV5t-1zP9;
	Thu, 25 Apr 2024 22:40:32 +0000
Date: Thu, 25 Apr 2024 15:40:32 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	willy@infradead.org, hare@suse.de, john.g.garry@oracle.com,
	p.raghav@samsung.com, da.gomez@samsung.com
Subject: Re: [PATCH 1/2] mm/huge_memory: skip invalid debugfs file entry for
 folio split
Message-ID: <Zirb4GNjubOJzdoR@bombadil.infradead.org>
References: <20240424225449.1498244-1-mcgrof@kernel.org>
 <20240424225449.1498244-2-mcgrof@kernel.org>
 <17447911-9578-45B2-A601-28CD0C5036D4@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <17447911-9578-45B2-A601-28CD0C5036D4@nvidia.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, Apr 24, 2024 at 09:03:51PM -0400, Zi Yan wrote:
> On 24 Apr 2024, at 18:54, Luis Chamberlain wrote:
>=20
> > If the file entry is too long we may easily end up going out of bounds
> > and crash after strsep() on sscanf(). To avoid this ensure we bound the
> > string to an expected length before we use sscanf() on it.
> >
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  mm/huge_memory.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 9e9879d2f501..8386d24a163e 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3623,6 +3623,7 @@ static ssize_t split_huge_pages_write(struct file=
 *file, const char __user *buf,
> >  		char file_path[MAX_INPUT_BUF_SZ];
> >  		pgoff_t off_start =3D 0, off_end =3D 0;
> >  		size_t input_len =3D strlen(input_buf);
> > +		size_t max_left_over;
> >
> >  		tok =3D strsep(&buf, ",");
> >  		if (tok) {
> > @@ -3632,6 +3633,14 @@ static ssize_t split_huge_pages_write(struct fil=
e *file, const char __user *buf,
> >  			goto out;
> >  		}
> >
> > +		max_left_over =3D MAX_INPUT_BUF_SZ - strlen(file_path);
> > +		if (!buf ||
> > +		    strnlen(buf, max_left_over) < 7 ||
>=20
> What is this magic number 7? strlen("0xN,0xN") as the minimal input strin=
g size?
> Maybe use sizeof("0xN,0xN") - 1 instead?

Sure and I forgot the fixes tag, will send a v2.

  Luis

