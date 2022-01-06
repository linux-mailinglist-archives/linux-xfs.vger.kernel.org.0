Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7FB485E38
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Jan 2022 02:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344440AbiAFBrQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jan 2022 20:47:16 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48887 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344427AbiAFBrO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 20:47:14 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 701B462C1D0;
        Thu,  6 Jan 2022 12:47:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n5Hs0-00Br06-97; Thu, 06 Jan 2022 12:47:12 +1100
Date:   Thu, 6 Jan 2022 12:47:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: take the ILOCK when accessing the inode core
Message-ID: <20220106014712.GS945095@dread.disaster.area>
References: <20220105195226.GL656707@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105195226.GL656707@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=61d64a21
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=2vh1AmWuAvyLDwjQFqQA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 05, 2022 at 11:52:26AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I was poking around in the directory code while diagnosing online fsck
> bugs, and noticed that xfs_readdir doesn't actually take the directory
> ILOCK when it calls xfs_dir2_isblock.  xfs_dir_open most probably loaded
> the data fork mappings and the VFS took i_rwsem (aka IOLOCK_SHARED) so
> we're protected against writer threads, but we really need to follow the
> locking model like we do in other places.
> 
> To avoid unnecessarily cycling the ILOCK for fairly small directories,
> change the block/leaf _getdents functions to consume the ILOCK hold that
> the parent readdir function took to decide on a _getdents implementation.
> 
> It is ok to cycle the ILOCK in readdir because the VFS takes the IOLOCK
> in the appropriate mode during lookups and writes, and we don't want to
> be holding the ILOCK when we copy directory entries to userspace in case
> there's a page fault.  We really only need it to protect against data
> fork lookups, like we do for other files.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: reduce the scope of the locked region, and reduce lock cycling

Looks good, one minor thing: can you add a comment to xfs_readdir()
that callers/VFS needs to hold the i_rwsem to ensure that the
directory is not being concurrently modified? Maybe even add a
ASSERT(rwsem_is_locked(VFS_I(ip)->i_rwsem)) to catch cases where
this gets broken?

Other than than it looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
