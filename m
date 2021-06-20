Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6854C3AE0E6
	for <lists+linux-xfs@lfdr.de>; Mon, 21 Jun 2021 00:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFTW0a (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 20 Jun 2021 18:26:30 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:40538 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229875AbhFTW0a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Jun 2021 18:26:30 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id DA83A4AED;
        Mon, 21 Jun 2021 08:24:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lv5rQ-00F62t-68; Mon, 21 Jun 2021 08:24:12 +1000
Date:   Mon, 21 Jun 2021 08:24:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org, chandanrlinux@gmail.com
Subject: Re: [PATCH 2/3] xfs: print name of function causing fs shutdown
 instead of hex pointer
Message-ID: <20210620222412.GQ664593@dread.disaster.area>
References: <162404243382.2377241.18273624393083430320.stgit@locust>
 <162404244503.2377241.5074228710477395763.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162404244503.2377241.5074228710477395763.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=m2_Svb1A1zpHbGbV_JgA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 11:54:05AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In xfs_do_force_shutdown, print the symbolic name of the function that
> called us to shut down the filesystem instead of a raw hex pointer.
> This makes debugging a lot easier:
> 
> XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
> 	fs/xfs/xfs_log.c. Return address = ffffffffa038bc38
> 
> becomes:
> 
> XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
> 	fs/xfs/xfs_log.c. Return address = xfs_trans_mod_sb+0x25
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
