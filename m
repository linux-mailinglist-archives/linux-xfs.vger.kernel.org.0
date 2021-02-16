Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331E431D0C6
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Feb 2021 20:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhBPTQI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 16 Feb 2021 14:16:08 -0500
Received: from sandeen.net ([63.231.237.45]:39028 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229761AbhBPTQH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Feb 2021 14:16:07 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9F7124872E4;
        Tue, 16 Feb 2021 13:15:19 -0600 (CST)
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     nathans@redhat.com
References: <20200930063532.142256-1-david@fromorbit.com>
 <20200930063532.142256-2-david@fromorbit.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/2] xfs: stats expose padding value at end of qm line
Message-ID: <8cc99c4b-df46-046a-b4a7-57654f3fb5d4@sandeen.net>
Date:   Tue, 16 Feb 2021 13:15:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20200930063532.142256-2-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/30/20 1:35 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are 8 quota stats exposed, but:
> 
> $ grep qm /proc/fs/xfs/stat
> qm 0 0 0 1889 308893 0 0 0 0
> $
> 
> There are 9 values exposed. Code inspection reveals that the struct
> xfsstats has a hole in the structure where the values change from 32
> bit counters to 64 bit counters. pahole output:
> 
> ....
> uint32_t                   xs_qm_dquot;          /*   748     4 */
> uint32_t                   xs_qm_dquot_unused;   /*   752     4 */
> 
> /* XXX 4 bytes hole, try to pack */
> 
> uint64_t                   xs_xstrat_bytes;      /*   760     8 */
> ....
> 
> Fix this by defining an "end of 32 bit variables" variable that
> we then use to define the end of the quota line. This will then
> ensure that we print the correct number of values regardless of
> structure layout.
> 
> However, ABI requirements for userspace parsers mean we cannot
> remove the output that results from this hole, so we also need to
> explicitly define this unused value until such time that we actually
> add a new stat that makes the output meaningful.
> 
> And now we have a defined end of 32bit variables, update the  stats
> union to be sized to match all the 32 bit variables correctly.
> 
> Output with this patch:
> 
> $ grep qm /proc/fs/xfs/stat
> qm 0 0 0 326 1802 0 6 3 0
> $
> 
> Reported-by: Nathan Scott <nathans@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This makes sense, and fixes a real bug, so seems like it could
get merged:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


Now, I could bikeshed by suggesting that we avoid holes by doing something like:


        static const struct xstats_entry {
                char    *desc;
                int     last;
        } xstats[] = {
                { "extent_alloc",       xfsstats_last(xs_freeb)  },
                { "abt",                xfsstats_last(xs_abt_insrec)    },
...

#define xfsstats_last(f)      ((offsetof(struct __xfsstats, f)+sizeof(f))/sizeof(uint32_t))

etc, so that we point to the last group item, instead of pointing to the next
group's first item, possibly exposing a hole in between.

but maybe that's just rearranging deck chairs, and I don't have a very strong
opinion on this.

-Eric


> ---
>  fs/xfs/xfs_stats.c |  2 +-
>  fs/xfs/xfs_stats.h | 15 +++++++++++++--
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index f70f1255220b..3409b273f00a 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -51,7 +51,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		{ "rmapbt",		xfsstats_offset(xs_refcbt_2)	},
>  		{ "refcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
>  		/* we print both series of quota information together */
> -		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
> +		{ "qm",			xfsstats_offset(xs_end_of_32bit_counts)},
>  	};
>  
>  	/* Loop over all stats groups */
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 34d704f703d2..861acf84cb3c 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -133,6 +133,17 @@ struct __xfsstats {
>  	uint32_t		xs_qm_dqwants;
>  	uint32_t		xs_qm_dquot;
>  	uint32_t		xs_qm_dquot_unused;
> +	uint32_t		xs_qm_zero_until_next_stat_is_added;
> +
> +/*
> + * Define the end of 32 bit counters as a 32 bit variable so that we don't
> + * end up exposing an implicit structure padding hole due to the next counters
> + * being 64bit values. If the number of coutners is odd, this fills the hole. If
> + * the number of coutners is even the hole is after this variable and the stats
> + * line will terminate printing at this offset and not print the hole.
> + */
> +	uint32_t		xs_end_of_32bit_counts;
> +
>  /* Extra precision counters */
>  	uint64_t		xs_xstrat_bytes;
>  	uint64_t		xs_write_bytes;
> @@ -143,8 +154,8 @@ struct __xfsstats {
>  
>  struct xfsstats {
>  	union {
> -		struct __xfsstats	s;
> -		uint32_t		a[xfsstats_offset(xs_qm_dquot)];
> +		struct __xfsstats s;
> +		uint32_t	a[xfsstats_offset(xs_end_of_32bit_counts)];
>  	};
>  };
>  
> 
