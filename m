Return-Path: <linux-xfs+bounces-25054-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADE8B38FBE
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Aug 2025 02:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE7A416547C
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Aug 2025 00:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F78185B67;
	Thu, 28 Aug 2025 00:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="UAfrB0jn"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89D52E63C
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 00:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756340815; cv=none; b=PD09UV/qgRtCCnkUjQ18f+oq94cBqZZ6mVrMC6dWUyhI46N1vSeBSj69jMv4vuCXxL1Di2GywRFoD0wheqGnEDVtsdQRExagDJytKjrymRqdNJwvLp/lOYLGigOeJFT0KsBkAyNQy/gDbBtNfaSD38EjD1gaYcImCM3tkE7i+/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756340815; c=relaxed/simple;
	bh=CiHY/rsMO1JgljnmcpPdzbXavktzcXH6n5jFCBNd7kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uu6aHmtIo/lBBL++VPMVOaVwlDcPnGJK6fqCTzQAkneWLJNhU9xTgnVG4e4u90ek78uN2ayPV/+vBUKX/vTpzhwOxoml/pojRdDyaIlTNxlrDgo2P036oaCO59q/Q8gOAt/MRlPn269fXqsxZ0UNOK31Ykjld293pacJebrNLqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=UAfrB0jn; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b49cfd967b9so271934a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 17:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1756340813; x=1756945613; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AIbrank/pOEZcuqN2pISiixQG0KXR6H+Lj8n+OUb0e8=;
        b=UAfrB0jnykPMfT5vDgDLf+UhS86I0vX7npGjSpoMLC24bKY+GPsuC785SfrJIg3zHn
         vAAnz2KlnMybJ8OfV3k5uMo3CUG5mhfAOTWpUXN4ZvaVd8MjVn0z1RHN0UyJOazODxtG
         z0sH1460cEygNXwgqS/k7qRzJiU15tnTybJuhT4drX5AojwMoTPXMFxJj429Jx/LS6Z1
         o4ualYIadwaYWFjL/pqv00zZLJtROf1KN8vndiPsv4i0sUvnoUUnOTSMRzOcF5sDXzgb
         2sVFV+r1v98KPquB2H2jiLZY1A8/bpmChBTdQcAJCN5UScVPBkfP8g2TWfAIbhL/uBj6
         D9Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756340813; x=1756945613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIbrank/pOEZcuqN2pISiixQG0KXR6H+Lj8n+OUb0e8=;
        b=lm02jkw7LoYhNwJMbSJ2mzV1ueX2iqjoJWH8ECtCwsAk3vJ+ggMADKMuehX6FVjfWd
         So+vAx2D5QG51rfJB0oxDuJN0yAwJy9c/8sbcc05KjqG8UJ6I4+obJayDudcV+05Ifss
         RgrUjlmpXjJ7ZT8mMva9qNvPJmGlWo5E1/Ef3pu+AuE4LXmCeBQ5EDFJEyutdONQDtdL
         x4yatNkr7Mh5Q4FOhpaHTMCt1adg0lH99dJdbd6o2HxJgcmL2gGs7/T0q+9d3ILLQLbp
         DCkKRXdE95sCsSL1hiTpHt9HQal2gV934mgDpGoubZWSYu8EgEFYj+JnQgfk0o0UM7U4
         huWA==
X-Forwarded-Encrypted: i=1; AJvYcCVRrxU+zRGkvtWTi+2PpymjkeIuOmtT9UEhWuDkxgRgv+Q406gEcheobez3Q2qhfzS036x4f6jKGCw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKSma4kwEGOMgatCeUGASJ43hqAtPFncKt7SbZ/xBgT8b1Rsz2
	e0Hyff+PnMlUUxZ/AiL3Q+KJPypA5dpKaY+CATPJJzLCgOtXnh1H3zSmRcIXFINJ0xI=
X-Gm-Gg: ASbGnctYK2ZMbAM2QJQDU8fT6nyRZaB4toS2f/Wd1UhPhZPh0YawAGA6Jko4uCnKuTR
	XJ7YOKhg+9swd6qo3KuCKav7S5sYMyM39t3QSPA6qqbhNtBt/iqKIgA5TRy86E6mD6Mx3x9FfG6
	dZ4VsbL7jLi0QI99D6og/W7pUpptgc7FKXi06TpBr36+ILJpB58iqt5q+yS1DsrMYU0T0jj1gdA
	zRAzohQ6ganYt765bKE1Aa4LQ02sfQbOGaGdleKz5cyIsNeYTbPysuuphKsDN4x21jK5nLbhhOD
	geCOOW75vLgaqZej0NXI9qmZgwj3KNqHwweqLFbvuZgltH0RU6R8IcyQ8M5Q0eHWfHYgBjpNvtT
	cCyMh009nGiC79dc6t/jCyM2f+UuOx64+G8QdaSWvI2diXhkDX6NPRRin29+9D5Rh86+naHfpau
	/7rCvxkcOV
X-Google-Smtp-Source: AGHT+IFK5hxc7bYLtaOFxGe9ricq7ACFEmb4qM2KiH4E4yFcbUWB7uOpNMCQ2mvzULlcuE6v1Dn+5Q==
X-Received: by 2002:a17:903:acc:b0:248:b8e0:5e1d with SMTP id d9443c01a7336-248b8e06116mr39556925ad.49.1756340813131;
        Wed, 27 Aug 2025 17:26:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24875471811sm49697605ad.37.2025.08.27.17.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 17:26:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1urQTa-0000000ByQW-0gL8;
	Thu, 28 Aug 2025 10:26:50 +1000
Date: Thu, 28 Aug 2025 10:26:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, amir73il@gmail.com
Subject: Re: [PATCH v2 53/54] fs: remove I_LRU_ISOLATING flag
Message-ID: <aK-iSiXtuaDj_fyW@dread.disaster.area>
References: <cover.1756222464.git.josef@toxicpanda.com>
 <3b1965d56a463604b5a0a003d32fe6983bc297ba.1756222465.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b1965d56a463604b5a0a003d32fe6983bc297ba.1756222465.git.josef@toxicpanda.com>

On Tue, Aug 26, 2025 at 11:39:53AM -0400, Josef Bacik wrote:
> If the inode is on the LRU it has a full reference and thus no longer
> needs to be pinned while it is being isolated.
> 
> Remove the I_LRU_ISOLATING flag and associated helper functions
> (inode_pin_lru_isolating, inode_unpin_lru_isolating, and
> inode_wait_for_lru_isolating) as they are no longer needed.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

....
> @@ -745,34 +742,32 @@ is_uncached_acl(struct posix_acl *acl)
>   * I_CACHED_LRU		Inode is cached because it is dirty or isn't shrinkable,
>   *			and thus is on the s_cached_inode_lru list.
>   *
> - * __I_{SYNC,NEW,LRU_ISOLATING} are used to derive unique addresses to wait
> - * upon. There's one free address left.
> + * __I_{SYNC,NEW} are used to derive unique addresses to wait upon. There are
> + * two free address left.
>   */
>  
>  enum inode_state_bits {
>  	__I_NEW			= 0U,
> -	__I_SYNC		= 1U,
> -	__I_LRU_ISOLATING	= 2U
> +	__I_SYNC		= 1U
>  };
>  
>  enum inode_state_flags_t {
>  	I_NEW			= (1U << __I_NEW),
>  	I_SYNC			= (1U << __I_SYNC),
> -	I_LRU_ISOLATING         = (1U << __I_LRU_ISOLATING),
> -	I_DIRTY_SYNC		= (1U << 3),
> -	I_DIRTY_DATASYNC	= (1U << 4),
> -	I_DIRTY_PAGES		= (1U << 5),
> -	I_CLEAR			= (1U << 6),
> -	I_LINKABLE		= (1U << 7),
> -	I_DIRTY_TIME		= (1U << 8),
> -	I_WB_SWITCH		= (1U << 9),
> -	I_OVL_INUSE		= (1U << 10),
> -	I_CREATING		= (1U << 11),
> -	I_DONTCACHE		= (1U << 12),
> -	I_SYNC_QUEUED		= (1U << 13),
> -	I_PINNING_NETFS_WB	= (1U << 14),
> -	I_LRU			= (1U << 15),
> -	I_CACHED_LRU		= (1U << 16)
> +	I_DIRTY_SYNC		= (1U << 2),
> +	I_DIRTY_DATASYNC	= (1U << 3),
> +	I_DIRTY_PAGES		= (1U << 4),
> +	I_CLEAR			= (1U << 5),
> +	I_LINKABLE		= (1U << 6),
> +	I_DIRTY_TIME		= (1U << 7),
> +	I_WB_SWITCH		= (1U << 8),
> +	I_OVL_INUSE		= (1U << 9),
> +	I_CREATING		= (1U << 10),
> +	I_DONTCACHE		= (1U << 11),
> +	I_SYNC_QUEUED		= (1U << 12),
> +	I_PINNING_NETFS_WB	= (1U << 13),
> +	I_LRU			= (1U << 14),
> +	I_CACHED_LRU		= (1U << 15)
>  };

This is a bit of a mess - we should reserve the first 4 bits for the
waitable inode_state_bits right from the start and not renumber the
other flag bits into that range. i.e. start the first non-waitable
bit at bit 4. That way every time we add/remove a waitable bit, we
don't have to rewrite the entire set of flags. i.e: something like:

enum inode_state_flags_t {
	I_NEW			= (1U << __I_NEW),
	I_SYNC			= (1U << __I_SYNC),
	// waitable bit 2 unused
	// waitable bit 3 unused
	I_DIRTY_SYNC		= (1U << 4),
....

This will be much more blame friendly if we do it this way from the
start of this patch set.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

