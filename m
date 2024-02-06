Return-Path: <linux-xfs+bounces-3532-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2ACD84AB75
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Feb 2024 02:15:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 231581C23B2D
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Feb 2024 01:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6587B15A7;
	Tue,  6 Feb 2024 01:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="woK79TxY"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8051373
	for <linux-xfs@vger.kernel.org>; Tue,  6 Feb 2024 01:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707182148; cv=none; b=eHjnmeo010YDHawqBuVaPkrdaVH01NEbmhDTGV2i9/OluOb9mqjQh2RY5jlrDi/TUyNnUmH0xDC7GpJGeSqxquEvP6hr1SnkSAxUci2IN+LDdi2S24ujJmvUf+Z4O9E77HkmVuMQC/mN9bQKqWMYuXbv3Wp1zqMe/Bn11zXaDkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707182148; c=relaxed/simple;
	bh=M6bMxtBYUTNQzAPCE9SXwB3+1J8pM4V9rwYYjVrY6rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YH8urWjBfXIYEAvUduONR4F0rVRG8GEdWdXMxH6Uya5tGtiLjjWWnZ71mDiP47QGS3gX2Vya/gyzG6xIcPolMAVaytMJChuiOVHAKMWN+to+oYqiZhv98gOLTE/yBJSwiHkPwo39qtxLGNofi1Hz+1tncP+snkJWHbU6M+kDtGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=woK79TxY; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6da9c834646so4064827b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 17:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707182146; x=1707786946; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=abZROUiS5HfPGfxSfOXxk9xMII3VljT9ZrpiGO2Q9Sg=;
        b=woK79TxY/gB/sDEm51e8MLusRcIM2l9uqpwEXo6E9yreA06gFLcfAyzRYAeWi8LkAp
         Ke590dZn7UEh8vj6UcJGA/Xf0RpHLwdauPZ0xrUqtVXFt790x51VLAQAoTR7CudKeYYy
         LPWNpVRf93ZqO4wz26B5ocy+lA0a64lnJKgdAniQP9Z3AsbT403rHCheY1Gglmv6lic1
         jeylsvwtyIi1Zm3gbNOlSfRDvkjSzRAtzt6/RAes8kiWXO7XRjE7g7x0aTOdT62XT4E2
         e/oSNUIImG1hCtUxcgh5Lp7sXaCUmfdPSKz44/e66LHto8iuMcSBlfpo5M1g9tT6Bx1z
         mmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707182146; x=1707786946;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=abZROUiS5HfPGfxSfOXxk9xMII3VljT9ZrpiGO2Q9Sg=;
        b=HeJJR+MxTQ10+ENPdzTjpCOOA5XF2bt8AoP7baVrU3eq84nzauF/gO3rF4WVDTIBfp
         vqc3/Rm7rvpQQF/699lr8MGJE3heGorXNcCH8slmxjUp5xRefn+nByFwKNp6ghphA5hP
         4TSGh2D5//lTRGZ11NmqKY7llyqXR0y7iSatUOKw0W2HfBgrpgWO0NDAMPurLGtj7YJP
         qmoxKn47PIVs7FhqPkoRQzMqNmMabmv2+2ml5WS4u8IB7h9NGud1L3qzan85KjUTqq/E
         L/GNRhQySryntnslNlfvnk06UTB9PBXd2uUyxtG8Bv2zMi1DsAHI46MM6EBBKYRDFF5k
         B4ug==
X-Gm-Message-State: AOJu0YxLeyicStjzfXcar0TkGz6VlamPNw9ntlvwSmircaTeQbnDOhEw
	uzeCaoHvyuDgLQxPMGnR9YoD7Io/YDdp4GXYIocpQeOjSRFvhaI81dAtOAxqhcU=
X-Google-Smtp-Source: AGHT+IGr96vb75ghoHuo2nxwcsq/KpIfXgfqhzHECuOhcjZyvVOWZIpNmpzN4t3j+olVGfeJ8/iEcQ==
X-Received: by 2002:a05:6a00:80c:b0:6dd:c43e:fb5e with SMTP id m12-20020a056a00080c00b006ddc43efb5emr1331580pfk.8.1707182145710;
        Mon, 05 Feb 2024 17:15:45 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXGN7hRM7vfDA3eju+s9+PnCNEx9dgUXK52BE0vquXZRqLWpw/WZriRFEp/RR05kBTScm6YezwUjmlEzlqE+f5TezyGQfpq6xnSkQ911IIJCC4KQnAteZnA2cuqr4eJTKW9pr4pmrD6h9GO+d+45GHPzZjPTHxWe0OE3iC08Y8fqbb+ZDRw2nYZBrFrHlzHBAvJ6G4TQzyWRX3RYD93MdkpCx8LmG3ver1T9ZTixjYTQJECo3iFXjPrIz1TmfGqvMHjIKNgUcMawCc/0koX6aUQZu9gUUwaLE98VxtQPcy/D8Dyi9xXbEWI3mInNNwegBkNrj/VK2RwILFXR6CuBfc21eqqJWQcLTWPK3LKQEBMsvC+1PkPhMPcTYh2U2TpKGBfPT3FAm7eOLXt+6uVUMcPVkw6EiSYQ6Xr1vZQbIW+eICuVY7jNvpQwZvgA1JzLQCT
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id x4-20020a056a00188400b006d9b35b2602sm541964pfh.3.2024.02.05.17.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 17:15:45 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rXA3q-002cWD-1H;
	Tue, 06 Feb 2024 12:15:42 +1100
Date: Tue, 6 Feb 2024 12:15:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, hch@lst.de,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, chandan.babu@oracle.com, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH RFC 5/6] fs: xfs: iomap atomic write support
Message-ID: <ZcGIPlNCkL6EDx3Z@dread.disaster.area>
References: <20240124142645.9334-1-john.g.garry@oracle.com>
 <20240124142645.9334-6-john.g.garry@oracle.com>
 <20240202184758.GA6226@frogsfrogsfrogs>
 <e61cf382-66bd-4091-b49c-afbb5ce67d8f@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e61cf382-66bd-4091-b49c-afbb5ce67d8f@oracle.com>

On Mon, Feb 05, 2024 at 01:36:03PM +0000, John Garry wrote:
> On 02/02/2024 18:47, Darrick J. Wong wrote:
> > On Wed, Jan 24, 2024 at 02:26:44PM +0000, John Garry wrote:
> > > Ensure that when creating a mapping that we adhere to all the atomic
> > > write rules.
> > > 
> > > We check that the mapping covers the complete range of the write to ensure
> > > that we'll be just creating a single mapping.
> > > 
> > > Currently minimum granularity is the FS block size, but it should be
> > > possibly to support lower in future.
> > > 
> > > Signed-off-by: John Garry <john.g.garry@oracle.com>
> > > ---
> > > I am setting this as an RFC as I am not sure on the change in
> > > xfs_iomap_write_direct() - it gives the desired result AFAICS.
> > > 
> > >   fs/xfs/xfs_iomap.c | 41 +++++++++++++++++++++++++++++++++++++++++
> > >   1 file changed, 41 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > index 18c8f168b153..758dc1c90a42 100644
> > > --- a/fs/xfs/xfs_iomap.c
> > > +++ b/fs/xfs/xfs_iomap.c
> > > @@ -289,6 +289,9 @@ xfs_iomap_write_direct(
> > >   		}
> > >   	}
> > > +	if (xfs_inode_atomicwrites(ip))
> > > +		bmapi_flags = XFS_BMAPI_ZERO;

We really, really don't want to be doing this during allocation
unless we can avoid it. If the filesystem block size is 64kB, we
could be allocating up to 96GB per extent, and that becomes an
uninterruptable write stream inside a transaction context that holds
inode metadata locked.

IOWs, if the inode is already dirty, this data zeroing effectively
pins the tail of the journal until the data writes complete, and
hence can potentially stall the entire filesystem for that length of
time.

Historical note: XFS_BMAPI_ZERO was introduced for DAX where
unwritten extents are not used for initial allocation because the
direct zeroing overhead is typically much lower than unwritten
extent conversion overhead.  It was not intended as a general
purpose "zero data at allocation time" solution primarily because of
how easy it would be to DOS the storage with a single, unkillable
fallocate() call on slow storage.

> > Why do we want to write zeroes to the disk if we're allocating space
> > even if we're not sending an atomic write?
> > 
> > (This might want an explanation for why we're doing this at all -- it's
> > to avoid unwritten extent conversion, which defeats hardware untorn
> > writes.)
> 
> It's to handle the scenario where we have a partially written extent, and
> then try to issue an atomic write which covers the complete extent.

When/how would that ever happen with the forcealign bits being set
preventing unaligned allocation and writes?

> In this
> scenario, the iomap code will issue 2x IOs, which is unacceptable. So we
> ensure that the extent is completely written whenever we allocate it. At
> least that is my idea.

So return an unaligned extent, and then the IOMAP_ATOMIC checks you
add below say "no" and then the application has to do things the
slow, safe way....

> > I think we should support IOCB_ATOMIC when the mapping is unwritten --
> > the data will land on disk in an untorn fashion, the unwritten extent
> > conversion on IO completion is itself atomic, and callers still have to
> > set O_DSYNC to persist anything.
> 
> But does this work for the scenario above?

Probably not, but if we want the mapping to return a single
contiguous extent mapping that spans both unwritten and written
states, then we should directly code that behaviour for atomic
IO and not try to hack around it via XFS_BMAPI_ZERO.

Unwritten extent conversion will already do the right thing in that
it will only convert unwritten regions to written in the larger
range that is passed to it, but if there are multiple regions that
need conversion then the conversion won't be atomic.

> > Then we can avoid the cost of
> > BMAPI_ZERO, because double-writes aren't free.
> 
> About double-writes not being free, I thought that this was acceptable to
> just have this write zero when initially allocating the extent as it should
> not add too much overhead in practice, i.e. it's one off.

The whole point about atomic writes is they are a performance
optimisation. If the cost of enabling atomic writes is that we
double the amount of IO we are doing, then we've lost more
performance than we gained by using atomic writes. That doesn't
seem desirable....

> 
> > 
> > > +
> > >   	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
> > >   			rblocks, force, &tp);
> > >   	if (error)
> > > @@ -812,6 +815,44 @@ xfs_direct_write_iomap_begin(
> > >   	if (error)
> > >   		goto out_unlock;
> > > +	if (flags & IOMAP_ATOMIC) {
> > > +		xfs_filblks_t unit_min_fsb, unit_max_fsb;
> > > +		unsigned int unit_min, unit_max;
> > > +
> > > +		xfs_get_atomic_write_attr(ip, &unit_min, &unit_max);
> > > +		unit_min_fsb = XFS_B_TO_FSBT(mp, unit_min);
> > > +		unit_max_fsb = XFS_B_TO_FSBT(mp, unit_max);
> > > +
> > > +		if (!imap_spans_range(&imap, offset_fsb, end_fsb)) {
> > > +			error = -EINVAL;
> > > +			goto out_unlock;
> > > +		}
> > > +
> > > +		if ((offset & mp->m_blockmask) ||
> > > +		    (length & mp->m_blockmask)) {
> > > +			error = -EINVAL;
> > > +			goto out_unlock;
> > > +		}

That belongs in the iomap DIO setup code, not here. It's also only
checking the data offset/length is filesystem block aligned, not
atomic IO aligned, too.

> > > +
> > > +		if (imap.br_blockcount == unit_min_fsb ||
> > > +		    imap.br_blockcount == unit_max_fsb) {
> > > +			/* ok if exactly min or max */

Why? Exact sizing doesn't imply alignment is correct.

> > > +		} else if (imap.br_blockcount < unit_min_fsb ||
> > > +			   imap.br_blockcount > unit_max_fsb) {
> > > +			error = -EINVAL;
> > > +			goto out_unlock;

Why do this after an exact check?

> > > +		} else if (!is_power_of_2(imap.br_blockcount)) {
> > > +			error = -EINVAL;
> > > +			goto out_unlock;

Why does this matter? If the extent mapping spans a range larger
than was asked for, who cares what size it is as the infrastructure
is only going to do IO for the sub-range in the mapping the user
asked for....

> > > +		}
> > > +
> > > +		if (imap.br_startoff &&
> > > +		    imap.br_startoff & (imap.br_blockcount - 1)) {
> > 
> > Not sure why we care about the file position, it's br_startblock that
> > gets passed into the bio, not br_startoff.
> 
> We just want to ensure that the length of the write is valid w.r.t. to the
> offset within the extent, and br_startoff would be the offset within the
> aligned extent.

I'm not sure why the filesystem extent mapping code needs to care
about IOMAP_ATOMIC like this - the extent allocation behaviour is
determined by the inode forcealign flag, not IOMAP_ATOMIC.
Everything else we have to do is just mapping the offset/len that
was passed to it from the iomap DIO layer. As long as we allocate
with correct alignment and return a mapping that spans the start
offset of the requested range, we've done our job here.

Actually determining if the mapping returned for IO is suitable for
the type of IO we are doing (i.e. IOMAP_ATOMIC) is the
responsibility of the iomap infrastructure. The same checks will
have to be done for every filesystem that implements atomic writes,
so these checks belong in the generic code, not the filesystem
mapping callouts.

-Dave
-- 
Dave Chinner
david@fromorbit.com

