Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8005E16B0AF
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2020 20:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgBXT5i (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Feb 2020 14:57:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:14001 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgBXT5h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Feb 2020 14:57:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 11:57:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="255695319"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga002.jf.intel.com with ESMTP; 24 Feb 2020 11:57:36 -0800
Date:   Mon, 24 Feb 2020 11:57:36 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V4 09/13] fs/xfs: Add write aops lock to xfs layer
Message-ID: <20200224195735.GA11565@iweiny-DESK2.sc.intel.com>
References: <20200221004134.30599-1-ira.weiny@intel.com>
 <20200221004134.30599-10-ira.weiny@intel.com>
 <20200224003455.GY10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224003455.GY10776@dread.disaster.area>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 11:34:55AM +1100, Dave Chinner wrote:
> On Thu, Feb 20, 2020 at 04:41:30PM -0800, ira.weiny@intel.com wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 

[snip]

> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 35df324875db..5b014c428f0f 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -142,12 +142,12 @@ xfs_ilock_attr_map_shared(
> >   *
> >   * Basic locking order:
> >   *
> > - * i_rwsem -> i_mmap_lock -> page_lock -> i_ilock
> > + * s_dax_sem -> i_rwsem -> i_mmap_lock -> page_lock -> i_ilock
> >   *
> >   * mmap_sem locking order:
> >   *
> >   * i_rwsem -> page lock -> mmap_sem
> > - * mmap_sem -> i_mmap_lock -> page_lock
> > + * s_dax_sem -> mmap_sem -> i_mmap_lock -> page_lock
> >   *
> >   * The difference in mmap_sem locking order mean that we cannot hold the
> >   * i_mmap_lock over syscall based read(2)/write(2) based IO. These IO paths can
> > @@ -182,6 +182,9 @@ xfs_ilock(
> >  	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
> >  	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_SUBCLASS_MASK)) == 0);
> >  
> > +	if (lock_flags & XFS_DAX_EXCL)
> > +		inode_aops_down_write(VFS_I(ip));
> 
> I largely don't see the point of adding this to xfs_ilock/iunlock.
> 
> It's only got one caller, so I don't see much point in adding it to
> an interface that has over a hundred other call sites that don't
> need or use this lock. just open code it where it is needed in the
> ioctl code.

I know it seems overkill but if we don't do this we need to code a flag to be
returned from xfs_ioctl_setattr_dax_invalidate().  This flag is then used in
xfs_ioctl_setattr_get_trans() to create the transaction log item which can then
be properly used to unlock the lock in xfs_inode_item_release()

I don't know of a cleaner way to communicate to xfs_inode_item_release() to
unlock i_aops_sem after the transaction is complete.

Ira

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
