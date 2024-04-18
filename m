Return-Path: <linux-xfs+bounces-7190-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90CD98A8EDA
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Apr 2024 00:30:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08FAE1F22413
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 22:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC5D7640D;
	Wed, 17 Apr 2024 22:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zUAVvX3f"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2E57D3E2
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713393033; cv=none; b=hPkbinM4z2wKhiwbBrYOw+s5Um+RNtHUTJUDkvFfz6vXoIVPj35yx2tHET1vPs7Tr3iwLEYZCx5NpUmMEOleXy+NCgvRcBvNoFN0VKsSoIeqMnikj7xd+Agf/wqEldmfbsVqEp0WtMt0Q/tudlK0Ee7rVkfRc+0FgZpnvO/WLIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713393033; c=relaxed/simple;
	bh=XCO2q1PeG2NL7Zmt2Y2OV5VIN5TxMnKAPpjzPbktuVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCHq2KFadQbULdOCr9RhLAVu92Y3AGVtXBbD4x63gCMo8x5kWhAqzelT56vBdZJHrhvz1GAmLEwwUg62dgN0ih7rAIRUDIFAqZUbxqjSdZZy7jqHm0BEcMyIDk2rdW5s5jzMqYuYg7qA7x5Kqqw7YBJZZ2Wq/ODexbsiesMDIcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=zUAVvX3f; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5cedfc32250so140412a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1713393031; x=1713997831; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ves4N4OM0bniaoZiWtYhs/KsccMz0/SZxy7XPz7z/s0=;
        b=zUAVvX3fSRksBqwS1aQNFCEaYfRLalatd3OtA8I6gL7H4hJcI+vzLo4P/Cxjel5WuR
         7AI/6HS5A1stHutwhxxNMfuDtzRdHU5R/rWACB4HftmX9wkz1tP6r007CBIyE9Uw3K+t
         6rW/ETfAnVYlsYH9/9kbxXwi+8Z/EYIwTWdC+P+MNMqI1KjpSJxgWHVkwJ1Gcfws7r3y
         +ezCVRpsf0yw1q1DoK+z+CVQ84K5clw9hVcms1t526fZfljVrHION6Vf5VMkUl/Q+6OX
         aiWdQlciFXyib4Ca+9TR8bicS8fyhlucIgDFuDivGNcH5/GVI5RV/LIOM4aSZVDFX2aD
         OeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713393031; x=1713997831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ves4N4OM0bniaoZiWtYhs/KsccMz0/SZxy7XPz7z/s0=;
        b=p3K9bF6f7DfnU/h85uTEwDSp9TcXtFG8R3jWegbs3mj0SnvBW5x3isPnk24e3GqiqW
         h5utfBsPV50k8gLj66U0XCIMNeaLUsfzlJfVSjRtM0iSaBR1OE52gvpwXswSYNQYxfSj
         SCZVETd+tHapzMziuzN8eYoBAeosN/6g6TlLI+E+CSf8SeVf33aDCHkiQ2PwnWU2iQnU
         GVHvNEfHePXkD75eLXRaEeh7Uv1Z/mcie9/mt6RBOjbxeRLhHzTjNsEF4JkVvOrRNYN1
         /KhBWVFIMHqDzJq8dFuUQqEmyalwQ5/IVnKXW+a2wM1uEhbvhIzwunR08OSBwjv07/9e
         hB+w==
X-Forwarded-Encrypted: i=1; AJvYcCUZpdRdQclPkmvuGySd7GBJ0w6AOnPcAX1pNEWwhRq1sWVqv5oEQaSlpnqUeVswK7cVfFXtmuw6SHRZuufBxkGCFWjNXQvw71MC
X-Gm-Message-State: AOJu0Yy2X9a5atobr9vLpglXEZzR4C/aHhZNXnGX9xoSJ8bg4wuG8fCN
	otHORyXpcT4jofru7IczImtyMhJSf8qT9v66EdZsKgQdxZO87gLcIQXywYU8Xxc=
X-Google-Smtp-Source: AGHT+IGV2WCNnNO9clrLYBB6qqnqF0Eg604PhN4TGFZJ291wNriw7Oml8Bv1gYhOaQOgW2BzmpRuqQ==
X-Received: by 2002:a05:6a20:1585:b0:1a7:7b92:e0ed with SMTP id h5-20020a056a20158500b001a77b92e0edmr1282322pzj.51.1713393030872;
        Wed, 17 Apr 2024 15:30:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id km18-20020a056a003c5200b006efbc365de9sm173267pfb.121.2024.04.17.15.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 15:30:30 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rxDnP-001eRo-0B;
	Thu, 18 Apr 2024 08:30:27 +1000
Date: Thu, 18 Apr 2024 08:30:27 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: djwong@kernel.org, alexjlzheng@tencent.com, chandan.babu@oracle.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 RESEND] xfs: remove redundant batch variables for
 serialization
Message-ID: <ZiBNg28NUqCC4/wG@dread.disaster.area>
References: <20240417152713.GX11948@frogsfrogsfrogs>
 <20240417155438.1060996-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417155438.1060996-1-alexjlzheng@tencent.com>

On Wed, Apr 17, 2024 at 11:54:38PM +0800, Jinliang Zheng wrote:
> On Wed, 17 Apr 2024 08:27:13 -0700, djwong@kernel.org wrote:
> > On Wed, Apr 17, 2024 at 08:07:35PM +0800, alexjlzheng@gmail.com wrote:
> > > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > > 
> > > Historically, when generic percpu counters were introduced in xfs for
> > > free block counters by commit 0d485ada404b ("xfs: use generic percpu
> > > counters for free block counter"), the counters used a custom batch
> > > size. In xfs_mod_freecounter(), originally named xfs_mod_fdblocks(),
> > > this patch attempted to serialize the program using a smaller batch size
> > > as parameter to the addition function as the counter approaches 0.
> > > 
> > > Commit 8c1903d3081a ("xfs: inode and free block counters need to use
> > > __percpu_counter_compare") pointed out the error in commit 0d485ada404b
> > > ("xfs: use generic percpu counters for free block counter") mentioned
> > > above and said that "Because the counters use a custom batch size, the
> > > comparison functions need to be aware of that batch size otherwise the
> > > comparison does not work correctly". Then percpu_counter_compare() was
> > > replaced with __percpu_counter_compare() with parameter
> > > XFS_FDBLOCKS_BATCH.
> > > 
> > > After commit 8c1903d3081a ("xfs: inode and free block counters need to
> > > use __percpu_counter_compare"), the existence of the batch variable is
> > > no longer necessary, so this patch is proposed to simplify the code by
> > > removing it.
> > > 
> > > Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> > > ---
> > > Changelog:
> > > 
> > > v3: Resend for the second time 
> > > 
> > > v2: https://lore.kernel.org/linux-xfs/20230918043344.890817-1-alexjlzheng@tencent.com/
> > > 
> > > v1: https://lore.kernel.org/linux-xfs/20230908235713.GP28202@frogsfrogsfrogs/T/#t
> > 
> > ...you still haven't answered my question from V1: What problem are you
> > solving with this patch?
> 
> Hi, thank you for your reply. :)
> 
> I'm trying to simplify the code. When percpu_counter_add_batch() and
> __percpu_counter_compare() use the same batch size, percpu_counter can count
> correctly, so there is no need to reduce the batch size to 1, which will cause
> unnecessary serialization.

One of the reasons the batch size gets set to 1 when we are really
near to enospc is so that anyone else reading the counter will see
the update immediately via percpu_counter_read*(). i.e. this forces
the global count to be updated immediately rather than use the
percpu accumulators.

This behaviour helps external, unsynchronised visibility be more
accurate (e.g. in speculative preallocation) as we get very close to
ENOSPC. We don't care if we serialise near ENOSPC - we're going to
be going through allocation slow paths anyway, so there's no benefit
to be gained by maintaining wide concurrency when we are this close
to ENOSPC.

There is, however, benefit to near-ENOSPC allocation behaviour by
being more accurate, hence the batch size change when we near the
zero threshold.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

