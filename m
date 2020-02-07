Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9012154FBC
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Feb 2020 01:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgBGA3y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Feb 2020 19:29:54 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47705 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgBGA3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 19:29:54 -0500
Received: from dread.disaster.area (pa49-181-161-120.pa.nsw.optusnet.com.au [49.181.161.120])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CECD43A497D;
        Fri,  7 Feb 2020 11:29:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1izrWm-0006xk-Tc; Fri, 07 Feb 2020 11:29:48 +1100
Date:   Fri, 7 Feb 2020 11:29:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Thumshirn <jth@kernel.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v12 1/2] fs: New zonefs file system
Message-ID: <20200207002948.GC21953@dread.disaster.area>
References: <20200206052631.111586-1-damien.lemoal@wdc.com>
 <20200206052631.111586-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206052631.111586-2-damien.lemoal@wdc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=SkgQWeG3jiSQFIjTo4+liA==:117 a=SkgQWeG3jiSQFIjTo4+liA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=NXwXW5gbVE1O_1ho6owA:9 a=NUhwtb2oAqvidNHn:21
        a=lSNHsdPPTDXGtUOn:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 06, 2020 at 02:26:30PM +0900, Damien Le Moal wrote:
> zonefs is a very simple file system exposing each zone of a zoned block
> device as a file. Unlike a regular file system with zoned block device
> support (e.g. f2fs), zonefs does not hide the sequential write
> constraint of zoned block devices to the user. Files representing
> sequential write zones of the device must be written sequentially
> starting from the end of the file (append only writes).

....
> +	if (flags & IOMAP_WRITE)
> +		length = zi->i_max_size - offset;
> +	else
> +		length = min(length, isize - offset);
> +	mutex_unlock(&zi->i_truncate_mutex);
> +
> +	iomap->offset = offset & (~sbi->s_blocksize_mask);
> +	iomap->length = ((offset + length + sbi->s_blocksize_mask) &
> +			 (~sbi->s_blocksize_mask)) - iomap->offset;

	iomap->length = __ALIGN_MASK(offset + length, sbi->s_blocksize_mask) -
			iomap->offset;

or it could just use ALIGN(..., sb->s_blocksize) and not need
pre-calculation of the mask value...


> +static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
> +{
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +	struct zonefs_sb_info *sbi = ZONEFS_SB(inode->i_sb);
> +	struct zonefs_inode_info *zi = ZONEFS_I(inode);
> +	size_t count;
> +	ssize_t ret;
> +
> +	/*
> +	 * For async direct IOs to sequential zone files, ignore IOCB_NOWAIT
> +	 * as this can cause write reordering (e.g. the first aio gets EAGAIN
> +	 * on the inode lock but the second goes through but is now unaligned).
> +	 */
> +	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ && !is_sync_kiocb(iocb)
> +	    && (iocb->ki_flags & IOCB_NOWAIT))
> +		iocb->ki_flags &= ~IOCB_NOWAIT;

Hmmm. I'm wondering if it would be better to return -EOPNOTSUPP here
so that the application knows it can't do non-blocking write AIO to
this file.

Everything else looks OK to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
