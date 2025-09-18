Return-Path: <linux-xfs+bounces-25749-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21387B806AF
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Sep 2025 17:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F25523A92F7
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Sep 2025 15:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B06032BC17;
	Wed, 17 Sep 2025 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="js+hj204";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O1eBm2ng";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="js+hj204";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O1eBm2ng"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E20B32E741
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 15:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758121523; cv=none; b=q86RRTE+zyj7jol4AFDMHOSltUI4s/WxsHQkX9ZvJ/RKJJqb1oSzo6qmWJF5TIR2QkPB7bmE3bIKl/FFeMxAhYW/Hseki7GH7aI8l9nJH0OUbmf3cysIZswBCAYF7lcoguuzrGmP8InHE0lTJu1pnZVSccg/a7+t59FHP6Ep18k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758121523; c=relaxed/simple;
	bh=z3gbz86SLmg/jIpuO926rco4j7e3WhlfSZWrwcFkEcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6YAK/BTTyDVTKJ+P7U2e97pe91793/a7MzDgGE6vr2Fd+79wZxOMqnEwK3pJpCYyry2vTts43ib7QFnyL8QKQP6dgzd1udzKf3lLD68EnHWShJefAVANjo3qI5TzEQedvbZHxLnV/KiG9uMfVi3oshIhFBZIzDuUv81aDF0Z6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=js+hj204; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O1eBm2ng; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=js+hj204; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O1eBm2ng; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 16A383388D;
	Wed, 17 Sep 2025 15:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758121519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kzouW0g2e7EIS3g55lkyVqTLbysLm3lGNAmhUO0nag4=;
	b=js+hj204cm8EO3NTMTVbWxOBWJfkb1gEOD10VJm6yuBIrXywiS1Qf/38A2Z+9sC1kROF8z
	jip3q/63P7SLMiFjVgctp/P2vkofzERDWmiCleZH/y+biFnsYrq2PDC0qBC5iwo2scUht/
	7cN7qDl2Lu0gjSxSY/qAIxp5NXOEO6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758121519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kzouW0g2e7EIS3g55lkyVqTLbysLm3lGNAmhUO0nag4=;
	b=O1eBm2ngIY37wAqLMkHQ+IoERqcDOpKqBG/uZ92OvzT+ru3Us6UgfAd8HDnP461+d73lBO
	SOkRacqb+qea3+Dw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=js+hj204;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O1eBm2ng
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758121519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kzouW0g2e7EIS3g55lkyVqTLbysLm3lGNAmhUO0nag4=;
	b=js+hj204cm8EO3NTMTVbWxOBWJfkb1gEOD10VJm6yuBIrXywiS1Qf/38A2Z+9sC1kROF8z
	jip3q/63P7SLMiFjVgctp/P2vkofzERDWmiCleZH/y+biFnsYrq2PDC0qBC5iwo2scUht/
	7cN7qDl2Lu0gjSxSY/qAIxp5NXOEO6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758121519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kzouW0g2e7EIS3g55lkyVqTLbysLm3lGNAmhUO0nag4=;
	b=O1eBm2ngIY37wAqLMkHQ+IoERqcDOpKqBG/uZ92OvzT+ru3Us6UgfAd8HDnP461+d73lBO
	SOkRacqb+qea3+Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B8A71368D;
	Wed, 17 Sep 2025 15:05:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +zzLAi/OymgWFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Sep 2025 15:05:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C374EA077E; Wed, 17 Sep 2025 17:05:18 +0200 (CEST)
Date: Wed, 17 Sep 2025 17:05:18 +0200
From: Jan Kara <jack@suse.cz>
To: Lukas Herbolt <lherbolt@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: Don't hold XFS_ILOCK_SHARED over log force
 during fsync
Message-ID: <xnmqfaxsl234r32xs625y5dgox7ewtv3n36pymbl3mo5ep3oey@g4f4yth4q5jp>
References: <20250908151248.1290-2-jack@suse.cz>
 <aL9yc4WJLdqtCFOK@dread.disaster.area>
 <hzjznua7gqp32yc36b5uef6acy4nssfdy42jtlpaxcdzfi5ddy@kcveowwcwltb>
 <aMIe43ZYUtcQ9cZv@dread.disaster.area>
 <aMkAhMrKO8bE8Eba@dread.disaster.area>
 <vpsyvzbupclvb76axyzytms5rh5yzubcyj5l5h2iwpk3d7xf6a@dw6pemmdfcka>
 <aMnXW_sEk_wTPnvB@dread.disaster.area>
 <hgk4f5iatzmdmrueuqww56nzc6cdev2mjbkcxxcytkaukzby34@5cwqi3j7pdie>
 <CAM4Jq_5kSfwPRiVsGD67n3ftoNPsdXOwMx0jxxQ4f8T9kcqgcw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM4Jq_5kSfwPRiVsGD67n3ftoNPsdXOwMx0jxxQ4f8T9kcqgcw@mail.gmail.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 16A383388D
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01

On Wed 17-09-25 12:22:46, Lukas Herbolt wrote:
> >> I was actually trying hard to come up with a fio recipe to reproduce
> this
> >> but I've failed.
> I have a similar issue with DB2 observed during index reorg/rebuild. The db
> opens
> the files with O_DSYNC|O_DIRECT and writes with libaio 256 x 4k writes
> (mostly
> sequential)  I believe that with the 256 and 4K depends on DB2
> internal page size
> and extent size. Anyway with bellow I am getting around ~18MB/s without the
> patch
> and around ~75MB/s with your patch. Need to test Dave's as well.
> 
> The fio file looks like this
> ---
> [global]
> name=fio-seq-write
> filename_format=/mnt/test/$jobname/$jobnum/fio.$filenum.$jobnum
> rw=write
> bs=4k
> direct=1
> numjobs=10
> time_based
> runtime=20
> nrfiles=1
> size=4G
> ioengine=libaio
> iodepth=16
> iodepth_batch_submit=16
> iodepth_batch_complete_min=16
> iodepth_batch_complete_max=16
> group_reporting=1
> gtod_reduce=1
> sync=dsync
> fadvise_hint=1
> 
> [posix]
> fallocate=posix
> stonewall
> ---

Thanks for sharing this! The results of this fio job vary significantly on
my test machine (even if I increase the runtime to several minutes) but
indeed average throughput seems to be about 30% better with the patch
applied so I think it's good enough smoke test.

								Honza

> 
> On Wed, Sep 17, 2025 at 12:07 PM Jan Kara <jack@suse.cz> wrote:
> 
> > On Wed 17-09-25 07:32:11, Dave Chinner wrote:
> > > On Tue, Sep 16, 2025 at 03:32:42PM +0200, Jan Kara wrote:
> > > > On Tue 16-09-25 16:15:32, Dave Chinner wrote:
> > > > > On Thu, Sep 11, 2025 at 10:59:15AM +1000, Dave Chinner wrote:
> > > > > > i.e. if we clear the commit sequences on last unpin (i.e. in
> > > > > > xfs_inode_item_unpin) then an item that is not in the CIL (and so
> > > > > > doesn't have dirty metadata) will have no associated commit
> > > > > > sequence number set.
> > > > > >
> > > > > > Hence if ili_datasync_commit_seq is non-zero, then by definition
> > the
> > > > > > inode must be pinned and has been dirtied for datasync purposes.
> > > > > > That means we can simply query ili_datasync_commit_seq in
> > > > > > xfs_bmbt_to_iomap() to set IOMAP_F_DIRTY.
> > > > > >
> > > > > > I suspect that the above fsync code can then become:
> > > > > >
> > > > > >         spin_lock(&iip->ili_lock);
> > > > > >         if (datasync)
> > > > > >                 seq = iip->ili_datasync_commit_seq;
> > > > > >         else
> > > > > >                 seq = iip->ili_commit_seq;
> > > > > >         spin_unlock(&iip->ili_lock);
> > > > > >
> > > > > >         if (!seq)
> > > > > >                 return 0;
> > > > > >         return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
> > log_flushed);
> > > > > >
> > > > > > For the same reason. i.e. a non-zero sequence number implies the
> > > > > > inode log item is dirty in the CIL and pinned.
> > > > > >
> > > > > > At this point, we really don't care about races with transaction
> > > > > > commits. f(data)sync should only wait for modifications that have
> > > > > > been fully completed. If they haven't set the commit sequence in
> > the
> > > > > > log item, they haven't fully completed. If the commit sequence is
> > > > > > already set, the the CIL push will co-ordinate appropriately with
> > > > > > commits to ensure correct data integrity behaviour occurs.
> > > > > >
> > > > > > Hence I think that if we tie the sequence number clearing to the
> > > > > > inode being removed from the CIL (i.e. last unpin) we can drop all
> > > > > > the pin checks and use the commit sequence numbers directly to
> > > > > > determine what the correct behaviour should be...
> > > > >
> > > > > Here's a patch that implements this. It appears to pass fstests
> > > > > without any regressions on my test VMs. Can you test it and check
> > > > > that it retains the expected performance improvement for
> > > > > O_DSYNC+DIO on fallocate()d space?
> > > >
> > > > Heh, I just wanted to send my version of the patch after all the tests
> > > > passed :). Anyway, I've given your patch a spin with the test I have
> > and
> > > > its performance looks good. So feel free to add:
> > > >
> > > > Tested-by: Jan Kara <jack@suse.cz>
> > >
> > > Thanks!
> > >
> > > > BTW I don't have customer setup with DB2 available where the huge
> > > > difference is visible (I'll send them backport of the patch to their
> > SUSE
> > > > kernel once we settle on it) but I have written a tool that replays the
> > > > same set of pwrites from same set of threads I've captured from syscall
> > > > trace. It reproduces only about 20% difference between good & bad
> > kernels
> > > > on my test machine but it was good enough for the bisection and
> > analysis
> > > > and the customer confirmed that the revert of what I've bisected to
> > > > actually fixes their issue (rwsem reader lockstealing logic).
> > >
> > > It was also recently bisected on RHEL 8.x to the introduction of
> > > rwsem spin-on-owner changes from back in 2019. Might be the same
> > > commit you are talking about, but either way it's an indication of
> > > rwsem lock contention rather than a problem with the rwsems
> > > themselves.
> >
> > Right. I've also come to a conclusion that the real problem is the too
> > heavy use of ILOCK and not the rwsem behavior itself. Hence this patch :).
> >
> > > > So I'm
> > > > reasonably confident I'm really reproducing their issue.
> > >
> > > Ok, that's good to know. I was thinking that maybe a fio recipe
> > > might show it up, too, but I'm not sure about that nor do I have the
> > > time to investigate it...
> >
> > I was actually trying hard to come up with a fio recipe to reproduce this
> > but I've failed. As you are noting in your changelog, this workload is
> > bound by log throughput and one of the obvious differences between fast and
> > slow kernels is that fast kernels do less larger log forces while slow
> > kernels do many tiny log forces (with obvious consequences for throughput,
> > in particular because we tend to relog the same blocks over and over again
> > - the slow kernels end up logging about 3x as much data in total).  Now
> > with fio the jobs were always managing to cram enough changes in one log
> > force for the difference to not be visible. Somehow the distribution of
> > writes among threads (and possibly their location determining how the btree
> > gets fragmented and which blocks get logged) DB2 creates is pretty peculiar
> > so that it makes such a big difference.
> >
> > > > So I just wanted to suggest that as a possible optimization (my patch
> > > > attached for reference). But regardless of whether you do the change
> > or not
> > > > I think the patch is good to go.
> > >
> > > I was on the fence about using READ_ONCE/WRITE_ONCE.
> > >
> > > However, xfs_csn_t is 64 bit and READ_ONCE/WRITE_ONCE doesn't
> > > prevent torn reads of 64 bit variables on 32 bit platforms. A torn
> > > read of a commit sequence number will result in a transient data
> > > integrity guarantee failure, and so I decided to err on the side of
> > > caution....
> >
> > Hum, right. I didn't think of 32-bits.
> >
> > > > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > > > index 829675700fcd..2a90e156b072 100644
> > > > --- a/fs/xfs/xfs_inode_item.c
> > > > +++ b/fs/xfs/xfs_inode_item.c
> > > > @@ -145,18 +145,7 @@ xfs_inode_item_precommit(
> > > >             flags |= XFS_ILOG_CORE;
> > > >     }
> > > >
> > > > -   /*
> > > > -    * Record the specific change for fdatasync optimisation. This
> > allows
> > > > -    * fdatasync to skip log forces for inodes that are only timestamp
> > > > -    * dirty. Once we've processed the XFS_ILOG_IVERSION flag, convert
> > it
> > > > -    * to XFS_ILOG_CORE so that the actual on-disk dirty tracking
> > > > -    * (ili_fields) correctly tracks that the version has changed.
> > > > -    */
> > > >     spin_lock(&iip->ili_lock);
> > > > -   iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
> > > > -   if (flags & XFS_ILOG_IVERSION)
> > > > -           flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
> > > > -
> > > >     /*
> > > >      * Inode verifiers do not check that the CoW extent size hint is an
> > > >      * integer multiple of the rt extent size on a directory with both
> > > > @@ -204,6 +193,23 @@ xfs_inode_item_precommit(
> > > >             xfs_trans_brelse(tp, bp);
> > > >     }
> > > >
> > > > +   /*
> > > > +    * Set the transaction dirty state we've created back in inode item
> > > > +    * before mangling flags for storing on disk. We use the value
> > later in
> > > > +    * xfs_inode_item_committing() to determine whether the
> > transaction is
> > > > +    * relevant for fdatasync or not. ili_dirty_flags gets cleared in
> > > > +    * xfs_trans_ijoin() before adding inode to the next transaction.
> > > > +    */
> > > > +   iip->ili_dirty_flags = flags;
> > > > +
> > > > +   /*
> > > > +    * Now convert XFS_ILOG_IVERSION flag to XFS_ILOG_CORE so that the
> > > > +    * actual on-disk dirty tracking (ili_fields) correctly tracks
> > that the
> > > > +    * version has changed.
> > > > +    */
> > > > +   if (flags & XFS_ILOG_IVERSION)
> > > > +           flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
> > > > +
> > >
> > > OK, I think I might have missed this. I'll check/fix it, and send an
> > > updated version for inclusion.
> >
> > Yeah, your version may miss we've set XFS_ILOG_CORE in flags in
> > xfs_inode_item_precommit(). Frankly, I wasn't sure whether fdatasync() not
> > flushing the log in these cases it fine or not so I've just preserved the
> > existing behavior in my patch.
> >
> >                                                                 Honza
> >
> > --
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
> >
> >
> 
> -- 
> Lukas Herbolt
> SSME
> Red Hat
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

