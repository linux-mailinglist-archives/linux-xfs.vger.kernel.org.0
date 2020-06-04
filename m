Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807D11EEA16
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jun 2020 20:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbgFDSHD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Jun 2020 14:07:03 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57792 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730008AbgFDSHD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 14:07:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591294021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RoneP3PWIkcKg8e6X9KoU8mL7DeaoohaY8AUHsn6OSc=;
        b=hKmvgKB5tXfHUwO6y0tCgLIs4nGZAf3uBWHHxw5gbYlW/9LgmPsj227ys7upQevZGUp56r
        3o9T9qnd+pFRI8+L9jUqx8ypYB9GgD0rQI4M2ska0XkgNy4QANJALqSAuVoQVmMINj7y3g
        iYwakuSPuz+8fod9J+AvodRde8bvgpc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-jtO7gOqpMWKUmT772NNaVQ-1; Thu, 04 Jun 2020 14:06:58 -0400
X-MC-Unique: jtO7gOqpMWKUmT772NNaVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8332510954DF;
        Thu,  4 Jun 2020 18:06:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CAC57CCC4;
        Thu,  4 Jun 2020 18:06:46 +0000 (UTC)
Date:   Thu, 4 Jun 2020 14:06:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/30] xfs: make inode reclaim almost non-blocking
Message-ID: <20200604180644.GF17815@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-18-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-18-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:45:53PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that dirty inode writeback doesn't cause read-modify-write
> cycles on the inode cluster buffer under memory pressure, the need
> to throttle memory reclaim to the rate at which we can clean dirty
> inodes goes away. That is due to the fact that we no longer thrash
> inode cluster buffers under memory pressure to clean dirty inodes.
> 
> This means inode writeback no longer stalls on memory allocation
> or read IO, and hence can be done asynchronously without generating
> memory pressure. As a result, blocking inode writeback in reclaim is
> no longer necessary to prevent reclaim priority windup as cleaning
> dirty inodes is no longer dependent on having memory reserves
> available for the filesystem to make progress reclaiming inodes.
> 
> Hence we can convert inode reclaim to be non-blocking for shrinker
> callouts, both for direct reclaim and kswapd.
> 
> On a vanilla kernel, running a 16-way fsmark create workload on a
> 4 node/16p/16GB RAM machine, I can reliably pin 14.75GB of RAM via
> userspace mlock(). The OOM killer gets invoked at 15GB of
> pinned RAM.
> 
> With this patch alone, pinning memory triggers premature OOM
> killer invocation, sometimes with as much as 45% of RAM being free.
> It's trivially easy to trigger the OOM killer when reclaim does not
> block.
> 

Nit, but I had to reread this a couple times to grok what "With this
patch alone ..." meant. I think it means "With non-blocking inode
reclaim without cluster buffer pinning ...," based on the next
paragraph. If so, I think the explicit wording is a little more clear.

> With pinning inode clusters in RAM and then adding this patch, I can
> reliably pin 14.5GB of RAM and still have the fsmark workload run to
> completion. The OOM killer gets invoked 14.75GB of pinned RAM, which
> is only a small amount of memory less than the vanilla kernel. It is
> much more reliable than just with async reclaim alone.
> 
> simoops shows that allocation stalls go away when async reclaim is
> used. Vanilla kernel:
> 
> Run time: 1924 seconds
> Read latency (p50: 3,305,472) (p95: 3,723,264) (p99: 4,001,792)
> Write latency (p50: 184,064) (p95: 553,984) (p99: 807,936)
> Allocation latency (p50: 2,641,920) (p95: 3,911,680) (p99: 4,464,640)
> work rate = 13.45/sec (avg 13.44/sec) (p50: 13.46) (p95: 13.58) (p99: 13.70)
> alloc stall rate = 3.80/sec (avg: 2.59) (p50: 2.54) (p95: 2.96) (p99: 3.02)
> 
> With inode cluster pinning and async reclaim:
> 
> Run time: 1924 seconds
> Read latency (p50: 3,305,472) (p95: 3,715,072) (p99: 3,977,216)
> Write latency (p50: 187,648) (p95: 553,984) (p99: 789,504)
> Allocation latency (p50: 2,748,416) (p95: 3,919,872) (p99: 4,448,256)
> work rate = 13.28/sec (avg 13.32/sec) (p50: 13.26) (p95: 13.34) (p99: 13.34)
> alloc stall rate = 0.02/sec (avg: 0.02) (p50: 0.01) (p95: 0.03) (p99: 0.03)
> 
> Latencies don't really change much, nor does the work rate. However,
> allocation almost never stalls with these changes, whilst the
> vanilla kernel is sometimes reporting 20 stalls/s over a 60s sample
> period. This difference is due to inode reclaim being largely
> non-blocking now.
> 
> IOWs, once we have pinned inode cluster buffers, we can make inode
> reclaim non-blocking without a major risk of premature and/or
> spurious OOM killer invocation, and without any changes to memory
> reclaim infrastructure.
> 

Very interesting result:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_icache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index dbba4c1946386..a6780942034fc 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1402,7 +1402,7 @@ xfs_reclaim_inodes_nr(
>  	xfs_reclaim_work_queue(mp);
>  	xfs_ail_push_all(mp->m_ail);
>  
> -	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT, &nr_to_scan);
> +	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
>  }
>  
>  /*
> -- 
> 2.26.2.761.g0e0b3e54be
> 

