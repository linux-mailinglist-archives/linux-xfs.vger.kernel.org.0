Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067821B002F
	for <lists+linux-xfs@lfdr.de>; Mon, 20 Apr 2020 05:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgDTDUF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 19 Apr 2020 23:20:05 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51431 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725896AbgDTDUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Apr 2020 23:20:05 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CD0F07EADED;
        Mon, 20 Apr 2020 13:20:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jQMyV-0007zr-IJ; Mon, 20 Apr 2020 13:19:59 +1000
Date:   Mon, 20 Apr 2020 13:19:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: ratelimit unmount time per-buffer I/O error
 warning
Message-ID: <20200420031959.GH9800@dread.disaster.area>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417150859.14734-6-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=cmkG0EOEte6Ke3cZuDsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 17, 2020 at 11:08:52AM -0400, Brian Foster wrote:
> At unmount time, XFS emits a warning for every in-core buffer that
> might have undergone a write error. In practice this behavior is
> probably reasonable given that the filesystem is likely short lived
> once I/O errors begin to occur consistently. Under certain test or
> otherwise expected error conditions, this can spam the logs and slow
> down the unmount. Ratelimit the warning to prevent this problem
> while still informing the user that errors have occurred.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 93942d8e35dd..5120fed06075 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1685,11 +1685,10 @@ xfs_wait_buftarg(
>  			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
>  			list_del_init(&bp->b_lru);
>  			if (bp->b_flags & XBF_WRITE_FAIL) {
> -				xfs_alert(btp->bt_mount,
> -"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
> +				xfs_alert_ratelimited(btp->bt_mount,
> +"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!\n"
> +"Please run xfs_repair to determine the extent of the problem.",
>  					(long long)bp->b_bn);

Hmmmm. I was under the impression that multiple line log messages
were frowned upon because they prevent every output line in the log
being tagged correctly. That's where KERN_CONT came from (i.e. it's
a continuation of a previous log message), but we don't use that
with the XFS logging and hence multi-line log messages are split
into multiple logging calls.

IOWs, this might be better handled just using a static ratelimit
variable here....

Actually, we already have one for xfs_buf_item_push() to limit
warnings about retrying XBF_WRITE_FAIL buffers:

static DEFINE_RATELIMIT_STATE(xfs_buf_write_fail_rl_state, 30 * HZ, 10);

Perhaps we should be using the same ratelimit variable here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
