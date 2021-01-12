Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFAE2F3FC8
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Jan 2021 01:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394675AbhALWgk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Jan 2021 17:36:40 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:52441 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726960AbhALWgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 17:36:39 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id C3F8410F6FB;
        Wed, 13 Jan 2021 09:35:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kzS6w-005pdL-JB; Wed, 13 Jan 2021 09:25:58 +1100
Date:   Wed, 13 Jan 2021 09:25:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Bastien Traverse <bastien@esrevart.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] xfs_corruption_error after creating a swap file
Message-ID: <20210112222558.GV331610@dread.disaster.area>
References: <TMAUMQ.RILVCKL2FQ501@esrevart.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TMAUMQ.RILVCKL2FQ501@esrevart.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=RqOyhilZ9Ju7JBSqp90A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 12, 2021 at 10:06:29PM +0100, Bastien Traverse wrote:
> Hello everyone,
> 
> A couple of weeks back I got an xfs_corruption_error stack trace on my
> rootfs on Arch Linux, a few minutes after creating a swap file an enabling
> it. Here is the process I followed to do so:
> 
>    fallocate -l 4G /swapfile
>    chmod 600 /swapfile
>    mkswap /swapfile
>    swapon /swapfile
>    echo "/swapfile none swap defaults 0 0" >> /etc/fstab
> 
> And the trace appeared a few minutes later, without me doing much at that
> moment:

Sounds like:

commit 41663430588c737dd735bad5a0d1ba325dcabd59
Author: Gao Xiang <hsiangkao@redhat.com>
Date:   Fri Sep 25 21:19:01 2020 -0700

    mm, THP, swap: fix allocating cluster for swapfile by mistake
    
    SWP_FS is used to make swap_{read,write}page() go through the
    filesystem, and it's only used for swap files over NFS.  So, !SWP_FS
    means non NFS for now, it could be either file backed or device backed.
    Something similar goes with legacy SWP_FILE.
    
    So in order to achieve the goal of the original patch, SWP_BLKDEV should
    be used instead.
    
    FS corruption can be observed with SSD device + XFS + fragmented
    swapfile due to CONFIG_THP_SWAP=y.
.....

But I thought that was fixed in 5.9-rc7 so should be in your kernel.
Can you confirm that your kernel has this fix?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
