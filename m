Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE748D0B1
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Aug 2019 12:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfHNKZF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Aug 2019 06:25:05 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35938 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbfHNKZE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 06:25:04 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B82C82AD206;
        Wed, 14 Aug 2019 20:25:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hxqRf-0001eN-Jr; Wed, 14 Aug 2019 20:23:55 +1000
Date:   Wed, 14 Aug 2019 20:23:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH 3/3] xfs: Opencode and remove DEFINE_SINGLE_BUF_MAP
Message-ID: <20190814102355.GM6129@dread.disaster.area>
References: <20190813090306.31278-1-nborisov@suse.com>
 <20190813090306.31278-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813090306.31278-4-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=iox4zFpeAAAA:8 a=7-415B0cAAAA:8 a=mOsgxCDldrQDDwu2L0QA:9
        a=CjuIK1q_8ugA:10 a=WzC6qhA0u3u7Ye7llzcV:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 12:03:06PM +0300, Nikolay Borisov wrote:
> This macro encodes a trivial struct initializations, just open code it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Hmmmm.

We have defines for this sort of structure definition and
initialisation all over the kernel. e.g. LIST_HEAD(),
DEFINE_PER_CPU(), DEFINE_HASHTABLE(), DEFINE_SPINLOCK(), etc...

And really, the intent of the define was to make it easy to get
rid of all the callers of the non-map buffer interfaces by moving
the map definition into the callers of xfs_buf_get, _read, etc
and then enabling use to remove the non-map interfaces
altogether.

Hence I'd much prefer to see the xfs_buf_{get,read,readahead} and
xfs_trans_buf_{get,read} wrapper functions go away than removing the
define.

> ---
>  fs/xfs/xfs_buf.c   | 4 ++--
>  fs/xfs/xfs_buf.h   | 9 +++------
>  fs/xfs/xfs_trans.h | 6 ++++--
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 99c66f80d7cc..389c5b590f11 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -658,7 +658,7 @@ xfs_buf_incore(
>  {
>  	struct xfs_buf		*bp;
>  	int			error;
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };

FWIW, I'm not a fan of single line definitions like this because
they are really hard to read. If you are converting to this form, it
should be like this:

	struct xfs_buf_map map = {
		.bm_bn = blkno,
		.bm_len = numblks,
	};

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
