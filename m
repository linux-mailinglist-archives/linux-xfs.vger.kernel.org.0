Return-Path: <linux-xfs+bounces-23816-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 890E2AFDB76
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Jul 2025 00:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF7C7564BE3
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Jul 2025 22:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D93C22A4D8;
	Tue,  8 Jul 2025 22:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="eKQVDhYv"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377FB229B2A
	for <linux-xfs@vger.kernel.org>; Tue,  8 Jul 2025 22:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752015587; cv=none; b=es0vuHCgefseYnUWK574YnpwIK0ombPoBTFL9DzETnWkEPqv0l7hY10n6X73jwiRfFunihorMgc2DQQAhDgW3sqyH1m6vyS9g06W29zJoJ9mfjjkvGbKwNgbVH8dH9oM2A796Lm16IeQGJxmpuQLdRnPb3/hg3VNccba6GnvrTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752015587; c=relaxed/simple;
	bh=M3mbuCdHP5nRK/r1JDT5y/NZEwpCM+rOZ/k+iVnc3Xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TAbJSellJuIe7nZq3dIQI/wIUQvjeQHSbHucLUX0FQyAEW2abbkIa8goOOsZE83GDkdXGMLCulD+7tehpR5lLT+g+s8+WHB4iBoUvCXZArm71WZQH8FlO1maXEZyQZZLw7mZd8sz07mzQWZ5sT+awY+betJ3a4jAR0AW0krbbTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=eKQVDhYv; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-23c8a5053c2so37424995ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 08 Jul 2025 15:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1752015585; x=1752620385; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s3l35aQqAnevtjyZ/VyVsw6OhRX5o5OHMyl6xIvwp38=;
        b=eKQVDhYv8LiyC3jnf97jJV+MCpCDdKLYjMCKYT/G+AufJrdbxHtRtUyi+h8gJiCucb
         HFChlxOXpK3jTnXjwi1Tt+EdTgcEBbliTIIcJMcrcNcZX1ZyJ/owzAwkWja1hDUPIi+Y
         FIeyyrTP1Th89WluUkqtdh6oPxJezFDGK4YG8NOaTH/cnJ8dQ3Ch68PHdVSbVvjndUu9
         N2WYcZAi5ObhNh8JfUULFpqux138ZohIXe2lmswRq96jQVBT8KUJv1CUb6HJJdCNYcps
         A0HxH1Byuk9pC6kRqjWSsBWSPTWMy6AtUOdr9NRml5aFUJqmHLLKTyiIpwGwDzNiOPcp
         Wh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752015585; x=1752620385;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s3l35aQqAnevtjyZ/VyVsw6OhRX5o5OHMyl6xIvwp38=;
        b=T8D0eEiTXKtLHdtKzPdPell47T2mCxwWkAISe8Th22umSNiWtJ+lutENcfpj0nwtnD
         Zwvq4sWF3S5mNt3lwAfro9CRwyU7q4kcb/A3t20MRLySQBVQ1B4/eQZhxGBcOv9IWRt5
         yGh8LHtrNDIhm6NUj2pjtoDcApSjdy1iFizxkoJe7nDIjSc83hPlCwoAegUZa9GG+8Nw
         KQXf73VXgkozG9pDKhkuL4m/3DOw9CL6j5Syr919iII4YAPI/HaItxsu4lbzz2avGREG
         I3MEcYq5LEDvFIKGNkS/Lj8oBmUUv9RjrvAPuTZx7c9IH+LrcV508RVpzifqvoXwIy37
         5g/g==
X-Forwarded-Encrypted: i=1; AJvYcCVtrq4pjwPPSWFNWihVnPwbeMm/gVVJoCtBX29ai/ZrUHMkXBFSugULhzARSzSubnv1uCrGW1ydUrM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9eFsJBy15w5rQ6q2t0lunCC8hDq8/GT2q0U1xjS7lNHKD13T1
	2LPJi4jQEkDQbOvZgxCuTEVGCqztoM3cGlpMjWCDPIh9N6eUTtonXWsJTlnFJZ8xHEQ=
X-Gm-Gg: ASbGncsXP4WRtRByL3/DJIN1eqRh1pdqc8MlP4aJTQQWLN7cGO3/PQReNqKP/2ZpEzc
	AKcwdg+JEKnkF4tMnmEe9geNOhysxrtH3A2FAM0TJwSKB49NXdSWeJ5qQk8t+Hu4dYSMQt4NGyq
	MKORDozGc7+ElsP1E1ArIJD+dj0S0ISb/zrJccX3IPexu4cfFO4xy0WiL6XY5kqTy+bzhmRkEhy
	r91+pDCvdCkEQ2scH2PamZkol2LiD1CUZ4GWufjxoyqz9mCH5FTrrhU6ngV3lysf4cR2/O4QbsJ
	tQywpK3VdAsPl6/gO8YEgYoMS4FFVKTXsInkCnSWpUaf3eoI3xEX1oGMnWG13Uls9q5FnokcFJA
	f/fWgMf+HDXeUHp6pCF4mlTwSR1cpcbdoNAkoRA==
X-Google-Smtp-Source: AGHT+IHgAio6dtY7YujZnCX74Dqj6rWXG+QIi1+TToEKN6tFwVYNcRTRFvNMZWDi8G3LmTON1cFJ/Q==
X-Received: by 2002:a17:903:2411:b0:223:7006:4db2 with SMTP id d9443c01a7336-23ddb2e62cfmr4398715ad.31.1752015585353;
        Tue, 08 Jul 2025 15:59:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8455eea0sm121499985ad.137.2025.07.08.15.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 15:59:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uZHHq-00000008cJE-0C8v;
	Wed, 09 Jul 2025 08:59:42 +1000
Date: Wed, 9 Jul 2025 08:59:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 1/6] fs: enhance and rename shutdown() callback to
 remove_bdev()
Message-ID: <aG2i3qP01m-vmFVE@dread.disaster.area>
References: <cover.1751589725.git.wqu@suse.com>
 <de25bbdb572c75df38b1002d3779bf19e3ad0ff6.1751589725.git.wqu@suse.com>
 <aGxSHKeyldrR1Q0T@dread.disaster.area>
 <dbd955f7-b9b4-402f-97bf-6b38f0c3237e@gmx.com>
 <20250708004532.GA2672018@frogsfrogsfrogs>
 <20250708-geahndet-rohmaterial-0419fd6a76b3@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250708-geahndet-rohmaterial-0419fd6a76b3@brauner>

On Tue, Jul 08, 2025 at 09:55:14AM +0200, Christian Brauner wrote:
> On Mon, Jul 07, 2025 at 05:45:32PM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 08, 2025 at 08:52:47AM +0930, Qu Wenruo wrote:
> > > 
> > > 
> > > 在 2025/7/8 08:32, Dave Chinner 写道:
> > > > On Fri, Jul 04, 2025 at 10:12:29AM +0930, Qu Wenruo wrote:
> > > > > Currently all the filesystems implementing the
> > > > > super_opearations::shutdown() callback can not afford losing a device.
> > > > > 
> > > > > Thus fs_bdev_mark_dead() will just call the shutdown() callback for the
> > > > > involved filesystem.
> > > > > 
> > > > > But it will no longer be the case, with multi-device filesystems like
> > > > > btrfs and bcachefs the filesystem can handle certain device loss without
> > > > > shutting down the whole filesystem.
> > > > > 
> > > > > To allow those multi-device filesystems to be integrated to use
> > > > > fs_holder_ops:
> > > > > 
> > > > > - Replace super_opearation::shutdown() with
> > > > >    super_opearations::remove_bdev()
> > > > >    To better describe when the callback is called.
> > > > 
> > > > This conflates cause with action.
> > > > 
> > > > The shutdown callout is an action that the filesystem must execute,
> > > > whilst "remove bdev" is a cause notification that might require an
> > > > action to be take.
> > > > 
> > > > Yes, the cause could be someone doing hot-unplug of the block
> > > > device, but it could also be something going wrong in software
> > > > layers below the filesystem. e.g. dm-thinp having an unrecoverable
> > > > corruption or ENOSPC errors.
> > > > 
> > > > We already have a "cause" notification: blk_holder_ops->mark_dead().
> > > > 
> > > > The generic fs action that is taken by this notification is
> > > > fs_bdev_mark_dead().  That action is to invalidate caches and shut
> > > > down the filesystem.
> > > > 
> > > > btrfs needs to do something different to a blk_holder_ops->mark_dead
> > > > notification. i.e. it needs an action that is different to
> > > > fs_bdev_mark_dead().
> > > > 
> > > > Indeed, this is how bcachefs already handles "single device
> > > > died" events for multi-device filesystems - see
> > > > bch2_fs_bdev_mark_dead().
> > > 
> > > I do not think it's the correct way to go, especially when there is already
> > > fs_holder_ops.
> > > 
> > > We're always going towards a more generic solution, other than letting the
> > > individual fs to do the same thing slightly differently.
> > 
> > On second thought -- it's weird that you'd flush the filesystem and
> > shrink the inode/dentry caches in a "your device went away" handler.
> > Fancy filesystems like bcachefs and btrfs would likely just shift IO to
> > a different bdev, right?  And there's no good reason to run shrinkers on
> > either of those fses, right?
> > 
> > > Yes, the naming is not perfect and mixing cause and action, but the end
> > > result is still a more generic and less duplicated code base.
> > 
> > I think dchinner makes a good point that if your filesystem can do
> > something clever on device removal, it should provide its own block
> > device holder ops instead of using fs_holder_ops.  I don't understand
> > why you need a "generic" solution for btrfs when it's not going to do
> > what the others do anyway.
> 
> I think letting filesystems implement their own holder ops should be
> avoided if we can. Christoph may chime in here. I have no appettite for
> exporting stuff like get_bdev_super() unless absolutely necessary. We
> tried to move all that handling into the VFS to eliminate a slew of
> deadlocks we detected and fixed. I have no appetite to repeat that
> cycle.

Except it isn't actually necessary.

Everyone here seems to be assuming that the filesystem *must* take
an active superblock reference to process a device removal event,
and that is *simply not true*.

bcachefs does not use get_bdev_super() or an active superblock
reference to process ->mark_dead events.

It has it's own internal reference counting on the struct bch_fs
attached to the bdev that ensures the filesystem structures can't go
away whilst ->mark_dead is being processed.  i.e. bcachefs is only
dependent on the bdev->bd_holder_lock() being held when
->mark_dead() is called and does not rely on the VFS for anything.

This means that device removal processing can be performed
without global filesystem/VFS locks needing to be held. Hence issues
like re-entrancy deadlocks when there are concurrent/cascading
device failures (e.g. a HBA dies, taking out multiple devices
simultaneously) are completely avoided...

It also avoids the problem of ->mark_dead events being generated
from a context that holds filesystem/vfs locks and then deadlocking
waiting for those locks to be released.

IOWs, a multi-device filesystem should really be implementing
->mark_dead itself, and should not be depending on being able to
lock the superblock to take an active reference to it.

It should be pretty clear that these are not issues that the generic
filesystem ->mark_dead implementation should be trying to
handle.....

> The shutdown method is implemented only by block-based filesystems and
> arguably shutdown was always a misnomer because it assumed that the
> filesystem needs to actually shut down when it is called.

Shutdown was not -assumed- as the operation that needed to be
performed. That was the feature that was *required* to fix
filesystem level problems that occur when the device underneath it
disappears.

->mark_dead() is the abstract filesystem notification from the block
device, fs_bdfev_mark_dead() is the -generic implementation- of the
functionality required by single block device filesystems. Part of
that functionality is shutting down the filesystem because it can
*no longer function without a backing device*.

multi-block device filesystems require compeltely different
implementations, and we already have one that -does not use active
superblock references-. IOWs, even if we add ->remove_bdev(sb)
callout, bcachefs will continue to use ->mark_dead() because low
level filesystem device management isn't (and shouldn't be!)
dependent on high level VFS structure reference counting....

> IOW, we made
> it so that it is a call to action but that doesn't have to be the case.
> Calling it ->remove_bdev() is imo the correct thing because it gives
> block based filesystem the ability to handle device events how they see
> fit.

And that's exactly what ->mark_dead already provides. 

And, as I've pointed out above, multi-device filesystems don't
actually need actively referenced superblocks to process device
removal notifications. Hence ->mark_dead is the correct interface
for them to use.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

