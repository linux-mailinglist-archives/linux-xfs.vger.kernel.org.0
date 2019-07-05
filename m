Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3566060870
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 16:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfGEOws (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 10:52:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726978AbfGEOws (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 10:52:48 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6672C83F42;
        Fri,  5 Jul 2019 14:52:48 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 10BE76960B;
        Fri,  5 Jul 2019 14:52:47 +0000 (UTC)
Date:   Fri, 5 Jul 2019 10:52:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: online scrub needn't bother zeroing its
 temporary buffer
Message-ID: <20190705145246.GH37448@bfoster>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158203074.495944.13142136337107091755.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158203074.495944.13142136337107091755.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 05 Jul 2019 14:52:48 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 01:47:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The xattr scrubber functions use the temporary memory buffer either for
> storing bitmaps or for testing if attribute value extraction works.  The
> bitmap code always zeroes what it needs and the value extraction merely
> sets the buffer contents (we never read the contents, we just look for
> return codes), so it's not necessary to waste CPU time zeroing on
> allocation.
> 

If we don't need to zero the buffer because we never look at the result,
that suggests we don't need to populate it in the first place right?

> A flame graph analysis showed that we were spending 7% of a xfs_scrub
> run (the whole program, not just the attr scrubber itself) allocating
> and zeroing 64k segments needlessly.
> 

How much does this patch help?

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/attr.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 09081d8ab34b..d3a6f3dacf0d 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -64,7 +64,12 @@ xchk_setup_xattr_buf(
>  		sc->buf = NULL;
>  	}
>  
> -	ab = kmem_zalloc_large(sizeof(*ab) + sz, flags);
> +	/*
> +	 * Allocate the big buffer.  We skip zeroing it because that added 7%
> +	 * to the scrub runtime and all the users were careful never to read
> +	 * uninitialized contents.
> +	 */

Ok, that suggests the 7% hit was due to zeroing (where the commit log
says "allocating and zeroing"). Either way, we probably don't need such
details in the code. Can we tweak the comment to something like:

/*
 * Don't zero the buffer on allocation to avoid runtime overhead. All
 * users must be careful never to read uninitialized contents.
 */ 

With that:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	ab = kmem_alloc_large(sizeof(*ab) + sz, flags);
>  	if (!ab)
>  		return -ENOMEM;
>  
> 
