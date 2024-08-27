Return-Path: <linux-xfs+bounces-12203-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCBB095FE1C
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2024 02:59:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8577D283411
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2024 00:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D7C2564;
	Tue, 27 Aug 2024 00:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="eCqHMtqp"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1674046B5
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 00:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724720344; cv=none; b=RdgtVIhDRL0IVdoYMevQ21EMnrOb0NNfpkf3HnNfDlMoDM0+T5K7WC6X0OSi5T7YiRv8jo2q58Gn7RtJEkuu6gGXbC9Gj1m6IHaOmmpU/ce2pbi4htHec3ZQialnXJKmdd7RYN6/O8OTFPlnChdxgbbkD411RHyA5eyO6zmZOj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724720344; c=relaxed/simple;
	bh=WFHofCR3c2rFd1nYI0X2oy+Mrl9h3CEaknkRHYpSkp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GMrvPFVv4z83TNTX6qq65dyEIv5Iem/P/ObnIuxalBDziybSzctYZclW4HoH1IGK5IdBGjASCUVe8drf91ce8M/GITT0BEu+g4WRgCugwHRXSBqnKyc/ibQ+afIfM/TpzW4vsTMVxtSqwMZKnf2exsjIGsAI2T645j9SBX3X9Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=eCqHMtqp; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2d3d662631aso3818451a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 17:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724720342; x=1725325142; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aYtUiv7YLgzcs/x00HAAym+Jp1p1bF1Lz9JpmR0QCw0=;
        b=eCqHMtqp6UcBHuO1rdAtPxK7ELwLcEcH26YWNi/0hXcWODDM/ZLk38OG5tQHiPEUWz
         5ED4tOU5Q/3fLu1zr6b8v+yVlm3iMyR7PAQWJPLqyjnY/hK4t9lWSG1pBwfTUwdhqQur
         YFbxNy3s3irBOtMF6SRdz1t42c3osWV7Xdmr2FIqwUo+btiQSOKywM9RRPlZZH4Q0PXR
         09NFxzegkauL2YENH+pHpuf4J8X2rseFoQ1cDgCO5Ql8UOsI55stwmR0OkdynSTxCOPR
         7bcmfCItNdB65ZjxcPmw9OKOPzYfJJMudxMxDB8WYYWfTa0lJjddNnXmbeN1jGxAUj0r
         b1AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724720342; x=1725325142;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aYtUiv7YLgzcs/x00HAAym+Jp1p1bF1Lz9JpmR0QCw0=;
        b=uLDkqVIJXLQdkubwnRiFagC4Y06KibqW8DtrVdWXzA2zlxC59TaMTGnxDzkRbY7ypB
         OBfMReOT/97lT9+I1ihmp6qZYZ/tc1Ds4JgGkY8smW2ausKABH4LQ0XTqMS6YG+t7A0a
         Ss6wuKZuWJP4NwO5eH38JPIFy/c1cm3uHwopmn6cTl/zb96iWgrA2TatEGzwHdZs4cZw
         NSSsf8+FB6vmfT/nq662ct6ie5QO29c8RP9OOinq9wYM2/8C8ksLCzTb35ljp9WY5jcl
         LvpYhC91p28F3KYbzP2UOrbLRoMZF6YJ/yUqAkXZUXa/Ky68eGaBdGrEIzHEQ1FxW6GU
         Io6A==
X-Forwarded-Encrypted: i=1; AJvYcCXVUw/Rcw9dQArsUbg5rKRq0jL6qal1C+WpCgnlyw2D52YXyfWsRCbbtbipMzMDryTAN3H99eszXb4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4jpW1ZjF3qXlmuGshlfEU4rizj6hWGEQGn/XLwTj63DqZzqFx
	K1aZguVV3JH4DHj228Fi7cr92jvCwNRycATz5TsBLNXt7Xw6NToVbyrqFd69smA=
X-Google-Smtp-Source: AGHT+IHPnpHk2EpjjWw1otv7xTPc95uvPO0x6jIsp7QMrozb+wB9C2aGXaJVe61SncElhCVO15mC4A==
X-Received: by 2002:a17:90a:5d0c:b0:2d3:d95a:36d1 with SMTP id 98e67ed59e1d1-2d646bf604fmr12574815a91.12.1724720342218;
        Mon, 26 Aug 2024 17:59:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d6139201ecsm10703542a91.18.2024.08.26.17.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 17:59:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sikXz-00DyeH-1O;
	Tue, 27 Aug 2024 10:58:59 +1000
Date: Tue, 27 Aug 2024 10:58:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/24] xfs: add a lockdep class key for rtgroup inodes
Message-ID: <Zs0k0y1euPWgWMie@dread.disaster.area>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087470.59588.4171434021531099837.stgit@frogsfrogsfrogs>
 <ZsvFDesdVVdUhI8T@dread.disaster.area>
 <20240826213827.GG865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826213827.GG865349@frogsfrogsfrogs>

On Mon, Aug 26, 2024 at 02:38:27PM -0700, Darrick J. Wong wrote:
> On Mon, Aug 26, 2024 at 09:58:05AM +1000, Dave Chinner wrote:
> > On Thu, Aug 22, 2024 at 05:18:02PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Add a dynamic lockdep class key for rtgroup inodes.  This will enable
> > > lockdep to deduce inconsistencies in the rtgroup metadata ILOCK locking
> > > order.  Each class can have 8 subclasses, and for now we will only have
> > > 2 inodes per group.  This enables rtgroup order and inode order checks
> > > when nesting ILOCKs.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_rtgroup.c |   52 +++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 52 insertions(+)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> > > index 51f04cad5227c..ae6d67c673b1a 100644
> > > --- a/fs/xfs/libxfs/xfs_rtgroup.c
> > > +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> > > @@ -243,3 +243,55 @@ xfs_rtgroup_trans_join(
> > >  	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
> > >  		xfs_rtbitmap_trans_join(tp);
> > >  }
> > > +
> > > +#ifdef CONFIG_PROVE_LOCKING
> > > +static struct lock_class_key xfs_rtginode_lock_class;
> > > +
> > > +static int
> > > +xfs_rtginode_ilock_cmp_fn(
> > > +	const struct lockdep_map	*m1,
> > > +	const struct lockdep_map	*m2)
> > > +{
> > > +	const struct xfs_inode *ip1 =
> > > +		container_of(m1, struct xfs_inode, i_lock.dep_map);
> > > +	const struct xfs_inode *ip2 =
> > > +		container_of(m2, struct xfs_inode, i_lock.dep_map);
> > > +
> > > +	if (ip1->i_projid < ip2->i_projid)
> > > +		return -1;
> > > +	if (ip1->i_projid > ip2->i_projid)
> > > +		return 1;
> > > +	return 0;
> > > +}
> > 
> > What's the project ID of the inode got to do with realtime groups?
> 
> Each rtgroup metadata file stores its group number in i_projid so that
> mount can detect if there's a corruption in /rtgroup and we just opened
> the bitmap from the wrong group.
> 
> We can also use lockdep to detect code that locks rtgroup metadata in
> the wrong order.  Potentially we could use this _cmp_fn to enforce that
> we always ILOCK in the order bitmap -> summary -> rmap -> refcount based
> on i_metatype.

Ok, can we union the i_projid field (both in memory and in the
on-disk structure) so that dual use of the field is well documented
by the code?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

