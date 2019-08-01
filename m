Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314BD7E50C
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 23:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732521AbfHAV4T (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 17:56:19 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53362 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730419AbfHAV4T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 17:56:19 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5C624361499;
        Fri,  2 Aug 2019 07:56:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1htJ2S-0002iC-Gt; Fri, 02 Aug 2019 07:55:08 +1000
Date:   Fri, 2 Aug 2019 07:55:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] fs: xfs: xfs_log: Don't use KM_MAYFAIL at
 xfs_log_reserve().
Message-ID: <20190801215508.GN7777@dread.disaster.area>
References: <20190729215657.GI7777@dread.disaster.area>
 <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801185057.GT30113@42.do-not-panic.com>
 <e901d22d-18b5-abde-15d1-777a6417f6c8@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e901d22d-18b5-abde-15d1-777a6417f6c8@i-love.sakura.ne.jp>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=PrpOhyjp6lNxhopi8ZoA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 02, 2019 at 06:13:12AM +0900, Tetsuo Handa wrote:
> On 2019/08/02 3:50, Luis Chamberlain wrote:
> > That's quite an opaque commit log for what started off as a severe email
> > thread of potential leak of information. As such, can you expand on this
> > commit log considerably to explain the situation a bit better? Your
> > initial thread here provided much clearer evidence of the issue. As-is
> > this commit log tells the reader *nothing* about the potential harm in
> > not applying this patch.
> > 
> > You had mentioned you identified this issue present on at least
> > 4.18 till 5.3-rc1. So, I'm at least inclined to consider this for
> > stable for at least v4.19.
> > 
> > However, what about older kernels? Now that you have identified
> > a fix, were the flag changed in prior commits, is it a regression
> > that perhaps added KM_MAYFAIL at some point?
> 
> I only checked 4.18+ so that RHEL8 will backport this patch. According to
> Brian Foster, commit eb01c9cd87 ("[XFS] Remove the xlog_ticket allocator")
> ( https://git.kernel.org/linus/eb01c9cd87 ) which dates back to April 2008
> added KM_MAYFAIL flag for this allocation
> 
> -	buf = (xfs_caddr_t) kmem_zalloc(PAGE_SIZE, KM_SLEEP);
> +	tic = kmem_zone_zalloc(xfs_log_ticket_zone, KM_SLEEP|KM_MAYFAIL);
> 
> though Dave Chinner thinks that the log ticket rework is irrelevant.
> Do we need to find which commit made this problem visible?

No.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
