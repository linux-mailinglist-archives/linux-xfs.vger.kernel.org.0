Return-Path: <linux-xfs+bounces-8827-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A368D792A
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 01:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C548C281964
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Jun 2024 23:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7ABA7D06E;
	Sun,  2 Jun 2024 23:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="mrQ3e4hE"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB2F40C03
	for <linux-xfs@vger.kernel.org>; Sun,  2 Jun 2024 23:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717371440; cv=none; b=IFEr+BEn0hzVlQa/EMekR91uo0Nuoc6gerUEFSLdpGTWb2huRFD2G64z5FrO9rfUCh74nBL2SpAb+MVX6vwnjA8ugVvNnnZIZU78CQO24/WbdmYu9clqCgiLqgOr1FbCr5XF6RV290fj9UAs0T7hoFMEHZWfwSwBfkQbNAVKVkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717371440; c=relaxed/simple;
	bh=adM5UqbLZsUsSMDE6CRVvcIOUpORHYPuRZBuNyEkHMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lw5JN5Xb78dhFZYkddX3oDIU9IMJDofAXSaVxNOSnDmoRvEKZi+mRVvy2nqJPYAGpyGYvOO/qUjXNXE0wCT1nVmQj+6xXVrs1rK0xfSYFSM/1p+Z21GhcGsAAVAJi4V2zd0e40SfDuCes7b9jaiGgCDvqNDXncoYIRLtGauPkow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=mrQ3e4hE; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7025e7a42dcso667401b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 02 Jun 2024 16:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1717371438; x=1717976238; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yIyy6V/HgjngZpZdcQcFHRoQXU8swvm21+8SP0nEENo=;
        b=mrQ3e4hEw4K83fKAxT8xGWI4vG0T2VuORBDisXJVQ2cD9Mig8tJnCmPLvTWeGvS826
         n3M9X7C3dNqNi4dBSHXvSEs6DENIiHLtZKkCNbcGBv7cXG1GEfnhTr4zxLxivf0yQNcx
         fZi8VseiSQUafDu1ZNZCCd0KdkAOwArH3eKrVFmsbEUAex7bOOrFVp32xRYa+4clQoOT
         a+fADBXwN3FuSvndESMt8CTYsKCbRX06p/CklDeF74pXNfjeWUVMGoY8rM4PXxXwluKZ
         4sY/FQeDyMOUoTk6ui8y+yaofVhh6xVGVz+96BpQxWGrQp3uqe24oQqcgxJzq4/JTdLa
         8UnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717371438; x=1717976238;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yIyy6V/HgjngZpZdcQcFHRoQXU8swvm21+8SP0nEENo=;
        b=ak1Q+xnWkyQXtT5P1EMv7R2t9Y50S/VyQZ6G//ZNcfSCe48oYPj4czf9rsH82mLuKr
         ROJTByhKeaaA2tfGo0nwWkE/c53BuXVaLxenPtFCm55tRBEGB/V0dxwefhIxZiNscQ3A
         Da0uic0o0kOQaB4q461tYr3k5tia9SgR2grYWmcD4FefIomVSIFlDihGGAaZjXZrkhs1
         BT+nst+udEuBKTVHVzMYVuGLAQzymkeVcQZsq+ATpJKPLkqTXDqiudhOI0pv9LftrSTo
         /YGbX3sa0Eo2aubh5+tjNmE7P1/nGapyjQm/geBHeN0dYcRhtIUu+1vz4i1NgwVt5mml
         Jy5A==
X-Gm-Message-State: AOJu0YzwxTAwvZsJYu0ALxjzeK/40W8v4delChfo5buVj87wBPDtfvhX
	5aEkncAmpSTmSc1KP7RQ+WALiR2JULLYu51LNB52V8iSsspY+ekV6R2f8tqo9cIQ2iYDlkIKREo
	7
X-Google-Smtp-Source: AGHT+IF2uElQpbK/FduWWGNKOmwVu50ouO12T2hnh7OvwVFDDTHqOMn2aZ3IgIHA1LmeWs5eXpfepw==
X-Received: by 2002:a05:6a00:2343:b0:702:2f19:659c with SMTP id d2e1a72fcca58-702478c7cc2mr7795453b3a.31.1717371437955;
        Sun, 02 Jun 2024 16:37:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702423cb2e4sm4548137b3a.19.2024.06.02.16.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 16:37:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sDulG-002E4j-1x;
	Mon, 03 Jun 2024 09:37:14 +1000
Date: Mon, 3 Jun 2024 09:37:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: make sure sb_fdblocks is non-negative
Message-ID: <Zl0CKi9d34ci0fEh@dread.disaster.area>
References: <20240511003426.13858-1-wen.gang.wang@oracle.com>
 <Zj7HLZ5Mp5SjhvrH@dread.disaster.area>
 <AEBF87C7-89D5-47B7-A01E-B5C165D56D8C@oracle.com>
 <A9F20047-4AD8-419F-9386-26C4ED281E29@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A9F20047-4AD8-419F-9386-26C4ED281E29@oracle.com>

On Fri, May 31, 2024 at 03:44:56PM +0000, Wengang Wang wrote:
> Hi Dave,
> 
> Do you have further comments and/or suggestions? Or give a RB pls :D

Sorry, LSFMM intervened and I didn't notice your comment until now.

> > On May 13, 2024, at 10:06 AM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> > 
> > Things is that we have a metadump, looking at the fdblocks from super block 0, it is good.
> > 
> > $ xfs_db -c "sb 0" -c "p" cust.img |egrep "dblocks|ifree|icount"
> > dblocks = 26214400
> > icount = 512
> > ifree = 337
> > fdblocks = 25997100
> > 
> > And when looking at the log, we have the following:
> > 
> > $ egrep -a "fdblocks|icount|ifree" cust.log |tail
> > sb_fdblocks 37
> > sb_icount 1056
> > sb_ifree 87
> > sb_fdblocks 37
> > sb_icount 1056
> > sb_ifree 87
> > sb_fdblocks 37
> > sb_icount 1056
> > sb_ifree 87
> > sb_fdblocks 18446744073709551604
> > 
> > # cust.log is output of my script which tries to parse the log buffer.
> > 
> > 18446744073709551604ULL == 0xfffffffffffffff4 or -12LL 
> > 
> > With upstream kernel (6.7.0-rc3), when I tried to mount (log recover) the metadump,
> > I got the following in dmesg:
> > 
> > [   52.927796] XFS (loop0): SB summary counter sanity check failed
> > [   52.928889] XFS (loop0): Metadata corruption detected at xfs_sb_write_verify+0x60/0x110 [xfs], xfs_sb block 0x0
> > [   52.930890] XFS (loop0): Unmount and run xfs_repair
> > [   52.931797] XFS (loop0): First 128 bytes of corrupted metadata buffer:
> > [   52.932954] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 01 90 00 00  XFSB............
> > [   52.934333] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [   52.935733] 00000020: c9 c1 ed ae 84 ed 46 b9 a1 f0 09 57 4a a9 98 42  ......F....WJ..B
> > [   52.937120] 00000030: 00 00 00 00 01 00 00 06 00 00 00 00 00 00 00 80  ................
> > [   52.938515] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> > [   52.939919] 00000050: 00 00 00 01 00 64 00 00 00 00 00 04 00 00 00 00  .....d..........
> > [   52.941293] 00000060: 00 00 64 00 b4 a5 02 00 02 00 00 08 00 00 00 00  ..d.............
> > [   52.942661] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 17 00 00 19  ................
> > [   52.944046] XFS (loop0): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply+0x38b/0x3a0 [xfs] (fs/xfs/xfs_buf.c:1559).  Shutting down filesystem.
> > [   52.946710] XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> > [   52.948099] XFS (loop0): log mount/recovery failed: error -117
> > [   52.949810] XFS (loop0): log mount failed

And that's what should be in the commit message, as it explains
exactly how the problem occurred, the symptom that was seen, and
why the change is necessary. It also means that anyone else who sees
a similar problem and is grepping the commit history will see this
and recognise it, thereby knowing that this is the fix they need...

> > Looking at corresponding code:
> > 231 xfs_validate_sb_write(
> > 232         struct xfs_mount        *mp,
> > 233         struct xfs_buf          *bp,
> > 234         struct xfs_sb           *sbp)
> > 235 {
> > 236         /*
> > 237          * Carry out additional sb summary counter sanity checks when we write
> > 238          * the superblock.  We skip this in the read validator because there
> > 239          * could be newer superblocks in the log and if the values are garbage
> > 240          * even after replay we'll recalculate them at the end of log mount.
> > 241          *
> > 242          * mkfs has traditionally written zeroed counters to inprogress and
> > 243          * secondary superblocks, so allow this usage to continue because
> > 244          * we never read counters from such superblocks.
> > 245          */
> > 246         if (xfs_buf_daddr(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
> > 247             (sbp->sb_fdblocks > sbp->sb_dblocks ||
> > 248              !xfs_verify_icount(mp, sbp->sb_icount) ||
> > 249              sbp->sb_ifree > sbp->sb_icount)) {
> > 250                 xfs_warn(mp, "SB summary counter sanity check failed");
> > 251                 return -EFSCORRUPTED;
> > 252         }
> > 
> > From dmesg and code, we know the check failure was due to bad sb_ifree vs sb_icount or bad sb_fdblocks vs sb_dblocks.
> > 
> > Looking at the super block dump and log dump,
> > We know ifree and icount are good, what’s bad is sb_fdblocks. And that sb_fdblocks is from log.
> > # I verified that sb_fdblocks is 0xfffffffffffffff4 with a UEK debug kernel (though not 6.7.0-rc3)
> > 
> > So the sb_fdblocks is updated from log to incore at xfs_log_sb() -> xfs_validate_sb_write() path though
> > Should be may re-calculated from AGs.
> > 
> > The fix aims to make xfs_validate_sb_write() happy.

What about the sb_icount and sb_ifree counters? They are also percpu
counters, and they can return transient negative numbers, too,
right? If they end up in the log, the same as this transient
negative sb_fdblocks count, won't that also cause exactly the same
issue?

i.e. if we need to fix the sb_fdblocks sum to always be positive,
then we need to do the same thing with the other lazy superblock
per-cpu counters so they don't trip the over the same transient
underflow issue...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

