Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307A21E03F4
	for <lists+linux-xfs@lfdr.de>; Mon, 25 May 2020 01:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388202AbgEXXlp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 24 May 2020 19:41:45 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:43965 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388104AbgEXXlp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 19:41:45 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 3F0C2D58E48;
        Mon, 25 May 2020 09:41:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jd0FR-00017R-Fj; Mon, 25 May 2020 09:41:41 +1000
Date:   Mon, 25 May 2020 09:41:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/24] xfs: mark inode buffers in cache
Message-ID: <20200524234141.GR2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-4-david@fromorbit.com>
 <20200522213517.GG8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522213517.GG8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=pbw9mNaNS2h3AII9DEMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 02:35:17PM -0700, Darrick J. Wong wrote:
> On Fri, May 22, 2020 at 01:50:08PM +1000, Dave Chinner wrote:
> >  #define XFS_BUF_FLAGS \
> > @@ -50,12 +54,13 @@ typedef unsigned int xfs_buf_flags_t;
> >  	{ XBF_DONE,		"DONE" }, \
> >  	{ XBF_STALE,		"STALE" }, \
> >  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
> > -	{ XBF_TRYLOCK,		"TRYLOCK" },	/* should never be set */\
> > -	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
> > +	{ _XBF_INODES,		"INODES" }, \
> 
> This a toughie.  On the one hand if you're going to go introducing what
> amounts to two-bit buffer io completion type in the middle of b_flags
> then (like Amir says) this ideally would have a mask and switch
> statements and whatnot.

I didn't really want a mask, because these are not unconditional
"buffer type" flags. They are only set on buffers with inodes
attached for IO completion and used that way in this patchset.
Everywhere else that uses them only checks for a single type...

> I also wonder if we could tell the buffer type given all the
> xfs_trans_buf_set_type calls, but I think the answer is that not every
> buffer is guaranteed to have a buffer log item attached and a type code
> set correctly?

Correct - that's what I looked at first, but inode cluster buffers
that have not just been created or have an unlinked inode logged
against them don't have buffer log items. Similarly dquot buffers
may not have a log item, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
