Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF6B29D86D
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Oct 2020 23:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388049AbgJ1WcM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Oct 2020 18:32:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388045AbgJ1WcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 18:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603924330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8LtHocyr+jSwxJ2BKL53RZg/0+x8Fujlj2cYEsift+k=;
        b=Wfik5zwSZjn4kKfDnpYaE0Yt85VXDCfBoX2fLNVE9ZX+vsi1HeO/pLTxlHBnMkZqtJWQQe
        e5oIz7E+QwbGVqt9pLFa79quy0FVtpivTYN6pyQZVhBzAco/BhABF2J398JNUoiokyYi/C
        tM1csgjL7XUVIgrGA6m9/ovu0BZSHVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-ASTY3mmgNGmdsiSj6QnlJA-1; Wed, 28 Oct 2020 13:30:11 -0400
X-MC-Unique: ASTY3mmgNGmdsiSj6QnlJA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 253B18049E3;
        Wed, 28 Oct 2020 17:30:10 +0000 (UTC)
Received: from bfoster (ovpn-113-186.rdu2.redhat.com [10.10.113.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5BE460C11;
        Wed, 28 Oct 2020 17:30:09 +0000 (UTC)
Date:   Wed, 28 Oct 2020 13:30:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs_repair: regenerate inode btree block counters in
 AGI
Message-ID: <20201028173007.GF1611922@bfoster>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375523066.880355.14411170857056218197.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375523066.880355.14411170857056218197.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:33:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reset both inode btree block counters in the AGI when rebuilding the
> metadata indexes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/phase5.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 446f7ec0a1db..b97d23809f3c 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -172,6 +172,11 @@ build_agi(
>  				cpu_to_be32(btr_fino->newbt.afake.af_levels);
>  	}
>  
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +		agi->agi_iblocks = cpu_to_be32(btr_ino->newbt.afake.af_blocks);
> +		agi->agi_fblocks = cpu_to_be32(btr_fino->newbt.afake.af_blocks);
> +	}
> +
>  	libxfs_buf_mark_dirty(agi_buf);
>  	libxfs_buf_relse(agi_buf);
>  }
> 

