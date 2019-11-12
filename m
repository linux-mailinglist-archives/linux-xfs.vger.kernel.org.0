Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0697F9DC8
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Nov 2019 00:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKLXJY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Nov 2019 18:09:24 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48115 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726973AbfKLXJX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 18:09:23 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A72097E9F3D;
        Wed, 13 Nov 2019 10:09:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iUfHj-0007q7-N7; Wed, 13 Nov 2019 10:09:19 +1100
Date:   Wed, 13 Nov 2019 10:09:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the unused m_chsize field
Message-ID: <20191112230919.GR4614@dread.disaster.area>
References: <20191111180957.23443-1-hch@lst.de>
 <20191112013810.GV6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112013810.GV6219@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 11, 2019 at 05:38:10PM -0800, Darrick J. Wong wrote:
> On Mon, Nov 11, 2019 at 07:09:57PM +0100, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Heh, what was that even used for?

> > -	uint			m_chsize;	/* size of next field */

Inode cluster hash size.

We used to keep a linked list of all the inodes in a cluster in a
separate structure, so that we could easily iterate them when needed
(writeback/cluster freeing). They were kept in a separate hash table
so that they could be used as a quick reference inode cluster buffer
cache as well (IIRC it was to speed up things like xfs_imap_to_bp())
without having the overhead of a full buffer cache lookup...

The need for all this went away with the radix tree indexing and
gang lookups - I guess I missed removing this last fragment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
