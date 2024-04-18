Return-Path: <linux-xfs+bounces-7202-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE2C8A8F94
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Apr 2024 01:42:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F33FE1F21AF0
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 23:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076D686158;
	Wed, 17 Apr 2024 23:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="nQ4kWT2c"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E217E58F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 23:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713397361; cv=none; b=XKd833sJTEkOIA9JbiK7MWkZgdnNJpw1qhJ2xKXmm8+LpxXFd8sECdCxJd4YFumXK13lozflQRxxRQ2hkCBtnCgzmXo0RogW9MdnO4IEM8Gk6kD0Mj0Lf1ie5tQ6VzhaZP4nx4JDrocI/UovuxDMWLQMqDOZDEN5uJqP6AWwMQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713397361; c=relaxed/simple;
	bh=QuLPYHHOz9+P2TnYg0nUczvHNM65SSgkjv6IKFjVBoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RS3SfmnxtXRb1qvSa/ToVD+n61h2OVnYOHZ3aeI1sEmMRe4geIw3uMbSvDo9ef8B+nBSAYo+2mqwhS2y0TE3FDKDxKPXjG93kjHQzWmhm8MuZyblDk58TEMrONaMdaUWSP3HiEziYubOJbQhIqsDtvmaAyJDY1z8KIQkVPuT/rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=nQ4kWT2c; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6edb76d83d0so317620b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 16:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1713397360; x=1714002160; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H8PpdhensM7ZVTFq0S18Svxv/4KXaWEIawy5jQm/wKo=;
        b=nQ4kWT2cvS3ml04wZY/Oena1c1WH7gWOJDHxxiGSxzuooDFIc7NqzxINsXwkL44CXS
         j5yYQWVdCumzCXVFmsa8QOdC5RLJ3SnSmxFU5ua2IPcwOjT0wTGzrQpnHcXWKcHtYBj5
         9SwL4iWp/300MjS2M6bY4CGRhbmfoNIYU/Yl4kydv/msU+itADAxgKSMNNw+IhINCn74
         GVzrH+TCK2ZrRe96l6rwkT6SGa61o52jogeIvc1BeR0IeEcEhkCCiqfAYfAdCsOTOZWF
         YLhq+RtkZCSmly8f8msQOKqRA0eJ71XI6uNoRbfi1j8TXbT9BlxpZts82rmMwJU+/rMZ
         Ogkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713397360; x=1714002160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H8PpdhensM7ZVTFq0S18Svxv/4KXaWEIawy5jQm/wKo=;
        b=dcHYigLn/HqXAnnToInFEZRnMnpuZ4BNB3Py8Hb15+V3emsy1N65R0igYySB64Z8NU
         svtrmUSz9dP+NYKHLl/fGUCoWUbJKDyT/p58SHxSELRY6E2ICRw10SM9pDELUhc+Gn5G
         uguoG0siNWcS7vNiZDesaamlQVPOj9VVZ8axEn4brUYuS+3lXTSDhHXiDjuliFAqY1y7
         yE+s8Q2Y+xolCqDe46IpFkFDXR5h/unzOG1fjLJVNJ1mJuzhtaUNr5p7M+o8COekC7p5
         tK1pUD/M6YkAUcwINcZh4H071QofcewoX+pNA7pZgGyVTXZcCqsSHBj/YDStKYPSuz6P
         +SyA==
X-Forwarded-Encrypted: i=1; AJvYcCUR5ueBAeNDaaumkDdLyoQqGriXYZjTHFr5pQeanLEDbl/89qHYcyv/vnzkfqGsp6zMRRYVgwwy4U7ODBEoUqeSo7dO1J4dHFmI
X-Gm-Message-State: AOJu0Yz98xQIlYoktRIJ0ZJrah5ErmtwF7/IAbken7SH5BRAK1ZCK98d
	I0RfT8Vt3/eJYf4JDuBAbD1LwizFEP2ULWC1rFZ5uIwQI4kIOHi/ZO8d5iU2els=
X-Google-Smtp-Source: AGHT+IH8nEcItRdzRInS/eSxQK3uhL9+WikVZcqSuhRn56hzs2gjHLAA6kOwjunZDipiBfNXDYgrHA==
X-Received: by 2002:a05:6a20:da9c:b0:1a3:bfce:ec9e with SMTP id iy28-20020a056a20da9c00b001a3bfceec9emr1570407pzb.18.1713397359601;
        Wed, 17 Apr 2024 16:42:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id x21-20020a17090a531500b002a71f11ddd4sm219146pjh.15.2024.04.17.16.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 16:42:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rxEvD-001hwi-0v;
	Thu, 18 Apr 2024 09:42:35 +1000
Date: Thu, 18 Apr 2024 09:42:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/14] xfs: capture inode generation numbers in the
 ondisk exchmaps log item
Message-ID: <ZiBea9NFJBU3UEE9@dread.disaster.area>
References: <171263348423.2978056.309570547736145336.stgit@frogsfrogsfrogs>
 <20240410000528.GR6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410000528.GR6390@frogsfrogsfrogs>

On Tue, Apr 09, 2024 at 05:05:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Per some very late review comments, capture the generation numbers of
> both inodes involved in a file content exchange operation so that we
> don't accidentally target files with have been reallocated.

<sigh>

That's a really poor commit message, and that's ignoring the fact
the change is actually unnecessary.

The issue raised during review didn't need code to be added - it was
a question about inode lifecycles and interactions with user driven
intent chains.  Instead of discussing and working through the issue
raised to determine if it was a real issue or not, you immediately
assumed everything had to change everywhere and started changing
code. Then it turned into a hot mess and you started ranting and
lecturing people about how you do want critical reviews of this
code, and now we have this completely unexplained, unnecessary patch
in the series.

Yes, I did perform a followup investigation to that was needed
to answer the question I had posed during review. The question was
whether the intent recovery at the end of replay is subject to inode
life-cycle events during the post-intent, pre-done portion of
recovery.

Fundamentally, intent chains run in a context that holds an inode
reference aren't subject to inode life cycle issues and so we don't
need the generation number in the intent to identify the inode. I'd
largely forgotten all this because I haven't looked at BUIs and
intent extent maps for a -long- time and so I forgot all about the
inode numbers they encode and the reasons they don't need generation
numbers.

i.e. because we can't free an inode while there is an open,
unresolved intent chain running, there can't be any life cycle
issues with inode numbers in the journal. In the case of exchange:

- exchange is done with a reference to the inode via open file
  descriptors.
- the ofds cannot be released until the exchange operation returns to
  userspace.
- the last reference to the inode is therefore held until after the
  entire intent chain is committed to the journal.
- therefore, inode freeing can only occur after the exchange returns
  to userspace and so can only occur in the journal -after- the
  intent chain is complete in the journal.

Therefore: if the intent chain in the journal is not complete
we are guaranteed that the inode in the exchange items is live and
valid in the filesytem and the intent chain is acting on the current
lifecycle instance of the inode.

So, yeah, we don't need inode generation numbers in intent items
that are acting on an inode, and we probably should document that
somewhere so we don't forget about it again...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

