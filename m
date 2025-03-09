Return-Path: <linux-xfs+bounces-20595-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A8DCA5889E
	for <lists+linux-xfs@lfdr.de>; Sun,  9 Mar 2025 22:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A37E8169C29
	for <lists+linux-xfs@lfdr.de>; Sun,  9 Mar 2025 21:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE62521ABA2;
	Sun,  9 Mar 2025 21:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="mZJxB7us"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311AE1A9B34
	for <linux-xfs@vger.kernel.org>; Sun,  9 Mar 2025 21:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741557074; cv=none; b=RO7Xubd9ELOYNEHNzNwI10YhBa24JrMm/5bSLRNPK+u1/UmnIvU0IIU8BDqyrvorusxrFQT3ishsTEv+dLriJLyNiekoZCOvsFgHU8bsYupM6lRPiD6W++8yO+kuPJuHyc5FZw6eiOkur+zg0ENxnrTL57lXCp/iU9uYTOOK6bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741557074; c=relaxed/simple;
	bh=F1FrAhqe1gDWi8xlo4HpXF2wBOUM+KcW2zALRt2drk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pok1pSDMGougSVJUVM2RLLDlP0zBHjpOEo5h6mfXytTB5OlcMaSUGj90LlJ6Ce8bfhxN/nQY65tqQ1XaDr+V4MZrna78D5yiWDgsdMxt2XOGFimHwfrzWegrDAwEJSG9utqnxP7m0lNbvX6XXnb8oG60e8ThpdTakGvVEm1QVzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=mZJxB7us; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2240b4de12bso51000205ad.2
        for <linux-xfs@vger.kernel.org>; Sun, 09 Mar 2025 14:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741557072; x=1742161872; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wtQlZm6zttB+fiTHsUvomrcaKMWy8CxBSny2Xz7D1/k=;
        b=mZJxB7usCFOpdhMxPogYwsPajD+HSuIwxBZZ264YG/qFwEE4TDPUEDhCO0A6O8g6uC
         b8Nv/cmIOLpi5rs6ASLdBg/ZxEkcNZ75+NwIB5cltgpCgtco1X7VJR2u0rfSi8G48Baj
         S/SYev6baCCr2KQz9WsNsa9U5I61qijAKqyMXLfbYm+FW8PEBPlj8gzgj1WbF/cI0S3E
         Kk88vPHJUehFKpNANCYW2Xznb8IB3eBAT4S62UYoTSCETVAqYQYWFR2vPpLDpdFkd8Mw
         obz/4PxFBRptgHlVgngNgyt9VntWKnsq8iD12ixEyvlGUyuaWzV5vcwr7ABhhiJPyNC5
         xVkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741557072; x=1742161872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wtQlZm6zttB+fiTHsUvomrcaKMWy8CxBSny2Xz7D1/k=;
        b=Ty71QA6lBq7v0H5GKA6vQIPQ+WTRJqhDsAYwRtD3P/w6tYOc/Vx4CWN74km7IV6k+z
         sKHtRtL1nen2l4FSyGTK2Vl0A2tyysKiKPwyqEBT82gUV6gjPSsD+X0KccuIIXoNV0u+
         0b+CspSMJxe0pOV39o4vmIVYEjm6X6wPWNG904Z5Dqnr1Y17SbLi91/m+HrZYp9sEERG
         zwALDktaKKnrMsd+Mzit5preAA85rTGrJPkmdmgnRnEBveIho6LfdOdjikIDwBLn8n7v
         kd57vvXBFgWmYZj64fLdEkzPuIy2cYNzsb0lqsB4XQmivkNBCSaBxRA59yFb7Cv8wC4W
         m2QA==
X-Forwarded-Encrypted: i=1; AJvYcCXqOWfftpr02Fdg/2KODd7tqXP5Id0mem4mnwLO983+IuoNcP8pZ7z0orMVq3jfqkclkE8XG57Qbm4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw48ZewuLGkfbpNd+kZib0xnbdbB3V3nN4ZqWp12DJdldHvz+xV
	09kDlpTeBj0gXLk5WDg08dgycIw/V+f46SogPmc3j7QDnOP5ZkDpcfkvw0OJa0o=
X-Gm-Gg: ASbGncsrc+wMeRx4Lq6CVTjIB1QkdaAcrK0vmPp6iQj9dCsUpzExZ0rJs86JB7zLhrI
	QnPaAwsgP4GLzCYCpXHN2sEdw3cRrr8TskTEebvFGTUpSrf6gjg3IKZkniDecgX5GDaqvcxNzy3
	xMnf7FN+NKeXGytMxUr+VxbFVKORF9fAXhjuK6eqBHR2U3Kz3b9gQho9zzOXaFEvWgfuJddGgXm
	k5W3VlGylCyi5dId9Uw3WnNvhqfM977dcCmL6zyIrBUcL7XWaJVCya6Z7MspV27EaTrWpy2fFuj
	wTGMSyqKDXIXMSMDOaLyloXOBDIe4oMN340Rs7zMDqfG48bzu6EybXOSa3ro45ZJDXbaQ0411k2
	mr1TlyB//AuXOzMOTjSX9
X-Google-Smtp-Source: AGHT+IFmE/y2ukJ1h6orczK3sejJrk1ZhdcmorRtk38tGOzGDUfVjo6i5W3u8DPicjhnFh7GQsAsuA==
X-Received: by 2002:a05:6a20:4393:b0:1f5:7873:304b with SMTP id adf61e73a8af0-1f57873325amr2358526637.26.1741557072470;
        Sun, 09 Mar 2025 14:51:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af50b2d4c9fsm4345121a12.76.2025.03.09.14.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 14:51:11 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1trOY8-0000000B2Ns-3N8c;
	Mon, 10 Mar 2025 08:51:08 +1100
Date: Mon, 10 Mar 2025 08:51:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com, martin.petersen@oracle.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v4 05/12] iomap: Support SW-based atomic writes
Message-ID: <Z84NTP5tyHEVLNbA@dread.disaster.area>
References: <20250303171120.2837067-1-john.g.garry@oracle.com>
 <20250303171120.2837067-6-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303171120.2837067-6-john.g.garry@oracle.com>

On Mon, Mar 03, 2025 at 05:11:13PM +0000, John Garry wrote:
> Currently atomic write support requires dedicated HW support. This imposes
> a restriction on the filesystem that disk blocks need to be aligned and
> contiguously mapped to FS blocks to issue atomic writes.
> 
> XFS has no method to guarantee FS block alignment for regular,
> non-RT files. As such, atomic writes are currently limited to 1x FS block
> there.
> 
> To deal with the scenario that we are issuing an atomic write over
> misaligned or discontiguous data blocks - and raise the atomic write size
> limit - support a SW-based software emulated atomic write mode. For XFS,
> this SW-based atomic writes would use CoW support to issue emulated untorn
> writes.
> 
> It is the responsibility of the FS to detect discontiguous atomic writes
> and switch to IOMAP_DIO_ATOMIC_SW mode and retry the write. Indeed,
> SW-based atomic writes could be used always when the mounted bdev does
> not support HW offload, but this strategy is not initially expected to be
> used.

So now seeing how these are are to be used, these aren't "hardware"
and "software" atomic IOs. They are block layer vs filesystem atomic
IOs.

We can do atomic IOs in software in the block layer drivers (think
loop or dm-thinp) rather than off-loading to storage hardware.

Hence I think these really need to be named after the layer that
will provide the atomic IO guarantees, because "hw" and "sw" as they
are currently used are not correct. e.g something like
IOMAP_FS_ATOMIC and IOMAP_BDEV_ATOMIC which indicates which layer
should be providing the atomic IO constraints and guarantees.

-Dave.

-- 
Dave Chinner
david@fromorbit.com

