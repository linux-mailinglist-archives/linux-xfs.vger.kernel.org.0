Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E19930FACE
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Feb 2021 19:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbhBDSJu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Feb 2021 13:09:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238466AbhBDSJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 13:09:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612462069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2uqBOHayoK9VQ4lj587O369rpP5nIS/wiQsdo323rcY=;
        b=dGW0YRNsIkH+PnIJlBQfpq85jRjdsR+ZRrdi234dSe3w8zjBXgtmL9gt9C+2O57HxnVdnR
        JgloQAFVozuNmkrWe/oJc6259jdGKh7S1oMUlmm3+Q3I2rCaUuXMfal5D4DFez7l9wtwPU
        Bp85CI5kBYP/HHpn3LACXT0F2hfIHBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-J5Es6aY6Pd6KUIxbGUP8_w-1; Thu, 04 Feb 2021 13:07:47 -0500
X-MC-Unique: J5Es6aY6Pd6KUIxbGUP8_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1AE7801960;
        Thu,  4 Feb 2021 18:07:45 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3394760C05;
        Thu,  4 Feb 2021 18:07:42 +0000 (UTC)
Date:   Thu, 4 Feb 2021 13:07:39 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Allison Henderson <allison.henderson@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix unused variable warning
Message-ID: <20210204180739.GD3721376@bfoster>
References: <20210204160427.2303504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204160427.2303504-1-arnd@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 04, 2021 at 05:03:44PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When debugging is disabled, the ASSERT() is left out and
> the 'log' variable becomes unused:
> 
> fs/xfs/xfs_log.c:1111:16: error: unused variable 'log' [-Werror,-Wunused-variable]
> 
> Remove the variable declaration and open-code it inside
> of the assertion.
> 
> Fixes: 303591a0a947 ("xfs: cover the log during log quiesce")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

I sent basically the same patch[1] about a week ago, but either one is
fine with me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

[1] https://lore.kernel.org/linux-xfs/20210125132616.GB2047559@bfoster/

>  fs/xfs/xfs_log.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 58699881c100..d8b814227734 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1108,12 +1108,11 @@ static int
>  xfs_log_cover(
>  	struct xfs_mount	*mp)
>  {
> -	struct xlog		*log = mp->m_log;
>  	int			error = 0;
>  	bool			need_covered;
>  
> -	ASSERT((xlog_cil_empty(log) && xlog_iclogs_empty(log) &&
> -	        !xfs_ail_min_lsn(log->l_ailp)) ||
> +	ASSERT((xlog_cil_empty(mp->m_log) && xlog_iclogs_empty(mp->m_log) &&
> +	        !xfs_ail_min_lsn(mp->m_log->l_ailp)) ||
>  	       XFS_FORCED_SHUTDOWN(mp));
>  
>  	if (!xfs_log_writable(mp))
> -- 
> 2.29.2
> 

