Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C219E26CC79
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Sep 2020 22:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgIPUnp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Sep 2020 16:43:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726611AbgIPRD1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 13:03:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600275793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3Y7DIUnPz/azd2Y2xGdlV0zmqjkbnUfaVhO/F8QGZoM=;
        b=I0C4BuihXKI8201SjAiZ+w+2sqrtwKfHGupB1gSbGP7IXG/TvOIO6egwX6XtLNgMSfXBUv
        5ebK5RCTOifJ95FQgfdyEWlT/LQT69cL92XFLF78JG5FkjKGSIaCDzK5Fiygc6bOQYyiBc
        NvHZ+nH057cxkkdv/VGM3DZHbWhijHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-_xcp5liHPMKFA-IVUk_HXg-1; Wed, 16 Sep 2020 07:20:02 -0400
X-MC-Unique: _xcp5liHPMKFA-IVUk_HXg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F275104D3E6;
        Wed, 16 Sep 2020 11:20:01 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D80E55DE4A;
        Wed, 16 Sep 2020 11:20:00 +0000 (UTC)
Date:   Wed, 16 Sep 2020 19:34:00 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 15/24] xfs/194: actually check if we got 512-byte blocks
 before proceeding
Message-ID: <20200916113400.GF2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013427110.2923511.12673259176007024613.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013427110.2923511.12673259176007024613.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:44:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This test has specific fs block size requirements, so make sure that's
> what we got before we proceed with the test.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/194 |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/tests/xfs/194 b/tests/xfs/194
> index 9001a146..90b74c8f 100755
> --- a/tests/xfs/194
> +++ b/tests/xfs/194
> @@ -84,6 +84,9 @@ unset XFS_MKFS_OPTIONS
>  # we need 512 byte block size, so crc's are turned off
>  _scratch_mkfs_xfs -m crc=0 -b size=$blksize >/dev/null 2>&1
>  _scratch_mount
> +test "$(_get_block_size $SCRATCH_MNT)" = 512 || \
> +	_notrun "Could not get 512-byte blocks"
> +

If this case is only for 512 byte blocksize, the "blksize=`expr $pgsize / 8`"
and all things with the "$blksize" looks redundant, right?

Thanks,
Zorro

>  
>  # 512b block / 4k page example:
>  #
> 

