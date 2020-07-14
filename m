Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DE621E8C1
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jul 2020 09:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgGNHBH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jul 2020 03:01:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24594 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725853AbgGNHBG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 03:01:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594710065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v0o6vS05dMQd9Z186F31LUjw5ChXs8ly1eNOlRWUGXc=;
        b=E6t6RT6qwRcvikuHhccEjpSkwgCipOVx66wbFRG20Cw9V7pG8AIE0xnVESMUbw4zlrHuNB
        Pm/Aly5PDtnglVtHa7sbu8fQyeEqLtrFqQ+3b0fKr0T7VAtLti+63LYuaJTREoLvGb8Awh
        GUBfTU8KlXdUfwab1Qlba07ds1l4jP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-IOq-grENOSCtRE7efr8cHA-1; Tue, 14 Jul 2020 03:01:00 -0400
X-MC-Unique: IOq-grENOSCtRE7efr8cHA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 519241800D42;
        Tue, 14 Jul 2020 07:00:59 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC1E2797EF;
        Tue, 14 Jul 2020 07:00:58 +0000 (UTC)
Date:   Tue, 14 Jul 2020 15:13:46 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/010,030: filter AG header CRC error warnings
Message-ID: <20200714071346.GY1938@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        xfs <linux-xfs@vger.kernel.org>
References: <20200713184930.GK7600@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713184930.GK7600@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 11:49:30AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Filter out the new AG header CRC verification warnings in xfs_repair
> since these tests were built before that existed.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/010 |    6 +++++-
>  tests/xfs/030 |    2 ++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/010 b/tests/xfs/010
> index c341795d..ec23507a 100755
> --- a/tests/xfs/010
> +++ b/tests/xfs/010
> @@ -113,7 +113,11 @@ _check_scratch_fs
>  # nuke the finobt root, repair will have to regenerate from the inobt
>  _corrupt_finobt_root $SCRATCH_DEV
>  
> -_scratch_xfs_repair 2>&1 | sed -e '/^bad finobt block/d' | _filter_repair_lostblocks

I think this patch is based on another patch which hasn't been merged, right?
Due to I can't find the *sed -e '/^bad finobt block/d'* on current xfstests-dev
master branch, which HEAD is:
  aae8fbec  generic/270: wait for fsstress processes to be killed

Thanks,
Zorro

> +filter_finobt_repair() {
> +	sed -e '/^agi has bad CRC/d' -e '/^bad finobt block/d' | _filter_repair_lostblocks
> +}
> +
> +_scratch_xfs_repair 2>&1 | filter_finobt_repair
>  
>  status=0
>  exit
> diff --git a/tests/xfs/030 b/tests/xfs/030
> index 8f95331a..a270e36c 100755
> --- a/tests/xfs/030
> +++ b/tests/xfs/030
> @@ -43,6 +43,8 @@ _check_ag()
>  			    -e '/^bad agbno AGBNO for rmapbt/d' \
>  			    -e '/^bad agbno AGBNO for refcntbt/d' \
>  			    -e '/^bad inobt block count/d' \
> +			    -e '/^agf has bad CRC/d' \
> +			    -e '/^agi has bad CRC/d' \
>  			    -e '/^bad finobt block count/d' \
>  			    -e '/^Missing reverse-mapping record.*/d' \
>  			    -e '/^unknown block state, ag AGNO, block.*/d'
> 

