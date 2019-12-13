Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEE211E56E
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2019 15:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfLMOQF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Dec 2019 09:16:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34212 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727444AbfLMOQF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 09:16:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576246564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WV3+I+Ngmdeg3kOKFWBW9UAJnnMXgSs+vuoDc75+tTc=;
        b=FlL6+eGJhIzYUzwspM2R7fqxD/D2MHBRQBMgWJ60S60SMKjoE2wgiQK9UVJwGdB3sMA+ne
        5P0iWRJ4nnTuKr9f4Qi2VMd6rzdQ6JrlLOerVITRKbN8sUG99oyEUz3FPUHGjHu9E1ttwi
        LyeBucTJhCPua7gjheiBLGdGYh+uWcE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-ev5PrglwOkeAPbW3xlzjaA-1; Fri, 13 Dec 2019 09:16:03 -0500
X-MC-Unique: ev5PrglwOkeAPbW3xlzjaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A300800D4C;
        Fri, 13 Dec 2019 14:16:02 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D57DA10013A1;
        Fri, 13 Dec 2019 14:16:01 +0000 (UTC)
Date:   Fri, 13 Dec 2019 09:16:01 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 12/14] xfs: Check for -ENOATTR or -EEXIST
Message-ID: <20191213141601.GF43376@bfoster>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-13-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 09:15:11PM -0700, Allison Collins wrote:
> Delayed operations cannot return error codes.  So we must check for
> these conditions first before starting set or remove operations
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a3dd620..b5a5c84 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -446,6 +446,18 @@ xfs_attr_set(
>  		goto out_trans_cancel;
>  
>  	xfs_trans_ijoin(args.trans, dp, 0);
> +
> +	error = xfs_has_attr(&args);
> +	if (error == -EEXIST) {
> +		if (name->type & ATTR_CREATE)
> +			goto out_trans_cancel;
> +		else
> +			name->type |= ATTR_REPLACE;

Hmm.. this bit looks funny to me. Shouldn't this already be set by
userspace? What's the reason for setting it here?

Brian

> +	}
> +
> +	if (error == -ENOATTR && (name->type & ATTR_REPLACE))
> +		goto out_trans_cancel;
> +
>  	error = xfs_attr_set_args(&args);
>  	if (error)
>  		goto out_trans_cancel;
> @@ -534,6 +546,10 @@ xfs_attr_remove(
>  	 */
>  	xfs_trans_ijoin(args.trans, dp, 0);
>  
> +	error = xfs_has_attr(&args);
> +	if (error != -EEXIST)
> +		goto out;
> +
>  	error = xfs_attr_remove_args(&args);
>  	if (error)
>  		goto out;
> -- 
> 2.7.4
> 

