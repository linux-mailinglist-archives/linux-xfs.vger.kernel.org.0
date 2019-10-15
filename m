Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713D4D7CEF
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Oct 2019 19:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfJORJQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Oct 2019 13:09:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfJORJQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Oct 2019 13:09:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B00713082E42;
        Tue, 15 Oct 2019 17:09:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5525E6062A;
        Tue, 15 Oct 2019 17:09:16 +0000 (UTC)
Date:   Tue, 15 Oct 2019 13:09:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: remove dead ifdef XFSERRORDEBUG code
Message-ID: <20191015170914.GG36108@bfoster>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-6-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 15 Oct 2019 17:09:16 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:45PM +0200, Christoph Hellwig wrote:
> XFSERRORDEBUG is never set and the code isn't all that useful, so remove
> it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 67a767d90ebf..7a429e5dc27c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3996,19 +3996,6 @@ xfs_log_force_umount(
>  	spin_unlock(&log->l_cilp->xc_push_lock);
>  	xlog_state_do_callback(log, true, NULL);
>  
> -#ifdef XFSERRORDEBUG
> -	{
> -		xlog_in_core_t	*iclog;
> -
> -		spin_lock(&log->l_icloglock);
> -		iclog = log->l_iclog;
> -		do {
> -			ASSERT(iclog->ic_callback == 0);
> -			iclog = iclog->ic_next;
> -		} while (iclog != log->l_iclog);
> -		spin_unlock(&log->l_icloglock);
> -	}
> -#endif
>  	/* return non-zero if log IOERROR transition had already happened */
>  	return retval;
>  }
> -- 
> 2.20.1
> 
