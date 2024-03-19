Return-Path: <linux-xfs+bounces-5403-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8756788643D
	for <lists+linux-xfs@lfdr.de>; Fri, 22 Mar 2024 01:07:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C167B220B9
	for <lists+linux-xfs@lfdr.de>; Fri, 22 Mar 2024 00:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F940633;
	Fri, 22 Mar 2024 00:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="OuUNKfpP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CE1383
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 00:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711066034; cv=none; b=qXQuoCPg5uPyoK7wwoeBUSjGf/mlBXcOmS7Z4eMdC3Nn21QNCR8Xv4yfwRT/WqD3Hfu2IJwB95hvb4v0xh5dvf0/VpyAaOqoFHpeDS5vomvqz2O7maE+v7nVHcMCs3N7xsmkkbMPErjdFt9o5nKch61xveGk+WsDfCrSK0M8mYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711066034; c=relaxed/simple;
	bh=6+G1sjHqFPVArExQiyfW7MUfRkLiQCAT4ozOgZwjtwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NbRS+DSkmYkYfu+MKNMtyBBvOMrlcoW8y9XvI9dfoiRcp97r7mj2rR4eEMaMU69sqNcvEFNdY5uCDixrPB3LqpwfVX304VtiT14BcaXUGZbXisQ+yb+m0KSoC6T+QMSIlMDKs5QkEe5wtm2MI/Wf657erX53LopJ6hF5UZ9eqCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=OuUNKfpP; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3684bee9ddfso7135395ab.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 17:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711066031; x=1711670831; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :resent-to:resent-message-id:resent-date:resent-from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UjGog3ZvffaVpb6rTr/ObLpWPMullTEcsb0ecf3K6VE=;
        b=OuUNKfpPbm9sBPDy558IS3zxu4ka+hW5XlLyPPZlSuVyi4HQ2XPdP2bMYRfULQtlSK
         f18vtAJmIlbiGQLAH2+hpRNCEgytzQRilLbODbgrhPQifCl6wKG9/cYQzQA1+Uz//XqL
         tckO3VkqDC1hxEK30wvN6xBD6R+36P0Xt3jkVWM6vvdx0MYEMaXl4dgDi4GSd3gCWej2
         tTk4ACM7cTnZGC9t0/iN6SVecO1mMgfkMzaOeZNYwj2Oon9rqJsI6HEU+frIhwQ4mqOu
         zm+5I6DYM5WNkiiEKOTerobdFODYxFIcH8llyNAeUpk4Xdb/lhZJHtVNQHwmpwNTQmXy
         HLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711066031; x=1711670831;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :resent-to:resent-message-id:resent-date:resent-from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UjGog3ZvffaVpb6rTr/ObLpWPMullTEcsb0ecf3K6VE=;
        b=T1H/P2iVP0W1DX4bvE6KLk4Y01xw6t18SQA/X6TqaYheKvECn3vgSbLqRlXuPghKKw
         NSezk7bjJts4XzTtaJzWxtC/C5h5ZjBPzv1Jaaj23QBVBnoV8Go/92pXgjHxq19qejxL
         /94n4AAGnteNcorD/T4Et6Y/OwGuRhBgA5vOfT9iBlJFLTP5lwjaT19JYFXVCknvUBDn
         tqcLUEJ+BYGLWiLuQsUQEZI8jIUXsvlUOKj9V4yq0ev5Pje0YsMAWAcWkJR2dwAJV5Z+
         c4rFUPJ6OHa21cTaKv5T+tV4mfsMaNXxu3Zwgh5mjMCKQihatpWLs9u8sBM+Tn4tpJkP
         j0Jw==
X-Gm-Message-State: AOJu0YxOFTcGkxmMhNpK14OC5uS9WqHCzwQbSGLuQ9AOjoIqPLBr2xGW
	xRGIZMBC3X7YMdgXqTtMGJ8zisJxoPYUAEMLWGx1okRAj0jbe0iI4zdqsMByhT4B+9GsYFLjvld
	L
X-Google-Smtp-Source: AGHT+IGrQKASXjXw42Td3Sylm4F7pbntFEMt/ZG5Oa0Q5UrU7xw4L4QL1almfJR9EMBFQ+Yq1wapPQ==
X-Received: by 2002:a05:6358:48c3:b0:17b:759:65c2 with SMTP id pf3-20020a05635848c300b0017b075965c2mr1053022rwc.10.1711065549780;
        Thu, 21 Mar 2024 16:59:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id s66-20020a632c45000000b005d6b5934deesm427841pgs.48.2024.03.21.16.59.09
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 16:59:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rnSJP-005JCO-0S
	for linux-xfs@vger.kernel.org;
	Fri, 22 Mar 2024 10:59:07 +1100
Resent-From: Dave Chinner <david@fromorbit.com>
Resent-Date: Fri, 22 Mar 2024 10:59:07 +1100
Resent-Message-ID: <ZfzJyw3h4iHpzNNr@dread.disaster.area>
Resent-To: linux-xfs@vger.kernel.org
Date: Wed, 20 Mar 2024 08:42:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: use folios in the buffer cache
Message-ID: <ZfoGzbDXQsrtlc4i@dread.disaster.area>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-3-david@fromorbit.com>
 <Zfk2hhhXU78WSo18@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zfk2hhhXU78WSo18@infradead.org>

On Mon, Mar 18, 2024 at 11:53:58PM -0700, Christoph Hellwig wrote:
> So while this looks good to me,
> 
> > +	for (i = 0; i < bp->b_folio_count; i++) {
> > +		if (bp->b_folios[i])
> > +			__folio_put(bp->b_folios[i]);
> 
> The __folio_put here really needs to be folio_put or page alloc
> debugging gets very unhappy.

*nod*

I can't remember why I used that in the first place...

> But even with that fixed on top of this patch the first mount just hangs
> without a useful kernel backtrace in /proc/*/stack, although running
> with the entire ѕeries applied it does pass the basic sanity checking
> so far.

Huh. It worked before I folded in your patches to clean everything
up; I don't tend to test individual patches if the whole series
works. I guess I screwed something up somewhere and then fixed it
later - I'll sort that out.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

