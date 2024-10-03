Return-Path: <linux-xfs+bounces-13571-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D3A198ED19
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Oct 2024 12:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BA861C215E4
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Oct 2024 10:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8335F14D2A6;
	Thu,  3 Oct 2024 10:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="tBT6MHGK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6008378289
	for <linux-xfs@vger.kernel.org>; Thu,  3 Oct 2024 10:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727951766; cv=none; b=XIHIQX0o+sFrxCxhYqsMo2/RColjq4gZQcdgENLcdZuWZt+0PCezLxwHKLNRNnOwOABxq8tfhROa8sisP1QlR7H0BQeBuT2ddSof5UE15tmT1s6qUnik6z0rMwIEGAlyzLRWYBYimr9xDHT/nFYnjR9uRw/x/7tUo7YMkV7eJcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727951766; c=relaxed/simple;
	bh=8oK4I+JBIU/DL1qfcLk0wLwR/KnTVzyuzZnecZa4deU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=smkYD/UVYP2fNif6FsPj39+drfhr3sn3dnvbJuyVB4jhXSSMrTxlztTZp4Nfl/OxzHtobECcsz4OcKd0GAXzrrp1QddReyiCNQxCr7OC5oVbOtSAE14yl1weBpDMXI5d/M8s+u5zwAfu/UqN/SnzLyPq/OfZPlGl//HF+Wa6/YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=tBT6MHGK; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20bb39d97d1so6105055ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 03 Oct 2024 03:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727951764; x=1728556564; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=meBlkFYSu8tQQG8fzuHlW0Llugrqw0c4D3dP4w0sd0k=;
        b=tBT6MHGKDoVN6TKilxvrhHMf7tMu/9GjUI4PWr7im5rMk0zLW4UlNJrW+jSCGXKZts
         rdeprrrtJMFXrOMbKIwFdcTJE/W6ihpZdbq19h3ZAqJNpALTWR1Fim6/8i2JOYD6/x7+
         fgL5KHJFVKRH798UKo9r1KTlkc1ggz0Quw7kD3wKhel+IcdaeamNrsLA675i7hGq32rW
         jbmOAoPavdiyq808JBj4Ft3cx2HwpKtXCb+DVr2GdMa/nOiygJHDcCvjXqXYzUvbY4RX
         uYwaSZv0cwZfWrin/onvdeT5iOS4+xV7IY/VMxtil+UWy1A9XownGQKDfx8yf1PBX8QQ
         1+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727951764; x=1728556564;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=meBlkFYSu8tQQG8fzuHlW0Llugrqw0c4D3dP4w0sd0k=;
        b=XdKrRICsWLEQyGtfNaNIsw3vg7k742Fz5MZXm+sFyfr9MPwrqVUnH4dr+XgVN7WrYm
         rY0KlHM1Adr/GrM8GSR03/q5Lzwl/0Vql6TpHcRX43I3l9tGGO9lIDLK0BDtu30wq6KD
         AzFLJT/cG5C+g/MbCHJWtB/I/R+BbSKaG1iv/EvZxMTOOI4ap7pteRTMwqRGumPWBCYV
         eHzVsfV/Ug4ZSA3uf8f+J/ozDXDcs/ULavG9SQLzimxnYH956XUJ8HwuwhTGG/qigVMK
         pZthqdMH0TymdijAcuac/63OcmswkIsPrR/DXH/v4cHYP5KX30faFz9gJ4rRNw4iRyTd
         y00w==
X-Forwarded-Encrypted: i=1; AJvYcCWvzFNtqlEi37USLM2AB3Y7XGpHNlfo/wjzxXvaNDIGAwehvWD5X1gx7ZaImdWR631GcPnGBAFV7JA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQprYXy+WDpeCKbEukuk/TXBFqQr/TFuLuSf0QGgqpZOIDsv0I
	uSTZ+uyu0xfwg2ngFsZjnLdmiCkh/NNZmRlqAlE9SPZk45aun0B1+DMoIXH8/rM=
X-Google-Smtp-Source: AGHT+IHAbmLCjTe9ucPXUjhaOkLLAkmHqYr94XYuHe2VWk7hgIGyvqHOxEgqNzNISkYi8RQMpJxqkg==
X-Received: by 2002:a17:902:f68d:b0:206:8acc:8871 with SMTP id d9443c01a7336-20bc5a13640mr66308755ad.31.1727951763533;
        Thu, 03 Oct 2024 03:36:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20beeca2256sm6720985ad.91.2024.10.03.03.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 03:36:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1swJBf-00DLiE-2H;
	Thu, 03 Oct 2024 20:35:59 +1000
Date: Thu, 3 Oct 2024 20:35:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, kent.overstreet@linux.dev,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 2/7] vfs: add inode iteration superblock method
Message-ID: <Zv5zj2k8X3ZasfYB@dread.disaster.area>
References: <20241002014017.3801899-1-david@fromorbit.com>
 <20241002014017.3801899-3-david@fromorbit.com>
 <Zv5D3ag3HlYFsCAX@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv5D3ag3HlYFsCAX@infradead.org>

On Thu, Oct 03, 2024 at 12:12:29AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 02, 2024 at 11:33:19AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add a new superblock method for iterating all cached inodes in the
> > inode cache.
> 
> The method is added later, this just adds an abstraction.

Ah, I forgot to remove that from the commit message when I split the
patch up....

> > +/**
> > + * super_iter_inodes - iterate all the cached inodes on a superblock
> > + * @sb: superblock to iterate
> > + * @iter_fn: callback to run on every inode found.
> > + *
> > + * This function iterates all cached inodes on a superblock that are not in
> > + * the process of being initialised or torn down. It will run @iter_fn() with
> > + * a valid, referenced inode, so it is safe for the caller to do anything
> > + * it wants with the inode except drop the reference the iterator holds.
> > + *
> > + */
> 
> Spurious empty comment line above.
> 
> > +void super_iter_inodes_unsafe(struct super_block *sb, ino_iter_fn iter_fn,
> > +		void *private_data)
> > +{
> > +	struct inode *inode;
> > +	int ret;
> > +
> > +	rcu_read_lock();
> > +	spin_lock(&sb->s_inode_list_lock);
> > +	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> > +		ret = iter_fn(inode, private_data);
> > +		if (ret == INO_ITER_ABORT)
> > +			break;
> > +	}
> 
> Looking at the entire series, splitting the helpers for the unsafe
> vs safe iteration feels a bit of an odd API design given that the
> INO_ITER_REFERENCED can be passed to super_iter_inodes, but is an
> internal flag pass here to the file system method.

The INO_ITER_REFERENCED flag is a hack to support the whacky
fsnotify and landlock iterators that are run after evict_inodes()
(which you already noticed...).  i.e.  there should not be any
unreferenced inodes at this point, so if any are found they should
be skipped.

I think it might be better to remove that flag and replace the
iterator implementation with some kind of SB flag and
WARN_ON_ONCE that fires if a referenced inode is found. With that,
the flags field for super_iter_inodes() can go away...

> Not sure what
> the best way to do it, but maybe just make super_iter_inodes
> a wrapper that calls into the method if available, or
> a generic_iter_inodes_unsafe if the unsafe flag is set, else
> a plain generic_iter_inodes?

Perhaps. I'll look into it.

> > +/* Inode iteration callback return values */
> > +#define INO_ITER_DONE		0
> > +#define INO_ITER_ABORT		1
> > +
> > +/* Inode iteration control flags */
> > +#define INO_ITER_REFERENCED	(1U << 0)
> > +#define INO_ITER_UNSAFE		(1U << 1)
> 
> Please adjust the naming a bit to make clear these are different
> namespaces, e.g. INO_ITER_RET_ and INO_ITER_F_.

Will do.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

