Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EB226D60D
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 10:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgIQIMM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 04:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgIQIBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:01:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5606CC061756;
        Thu, 17 Sep 2020 01:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/x454jVjCrKFEZFxYpIYOU/qhvr8ZH7kQEIhvbRO4d4=; b=BROgyWcdaIlvJjww2Nl1U6a1wm
        m4ugjc63k1O6QMiWGztFBfedUykP+0+OBMlKjZQcW7WfTtfp3fqxkOo1medjAU1Vme0XpYkF9nHU+
        LDpZrjibs6r3ylFpuaJLDtek7zKyy1YNQsL9mMHXVylXhq6gWkVtZgliZREF3TnfiC+j/1aHn2ihu
        KZuzXa6yf/u/a+IJv5yOu7b2rfGPDPvicdjY/hd3KJkM9wh6njnGgkdyonXegiFClyduVR95iZGab
        oL9lkhi21rBzUqBILT6usGMN5/CRsejpWtNL6unoVnbAvUnde6uGE8i/YAyVdnQkacNp3gdIjGdQR
        JPAZyrJQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIoqc-0007jD-4R; Thu, 17 Sep 2020 08:00:54 +0000
Date:   Thu, 17 Sep 2020 09:00:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 21/24] common/rc: teach _scratch_mkfs_sized to set a size
 on an xfs realtime volume
Message-ID: <20200917080054.GQ26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013430895.2923511.7033338053997588353.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013430895.2923511.7033338053997588353.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:45:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Generally speaking, tests that call _scratch_mkfs_sized are trying to
> constrain a test's run time by formatting a filesystem that's smaller
> than the device.  The current helper does this for the scratch device,
> but it doesn't do this for the xfs realtime volume.
> 
> If fstests has been configured to create files on the realtime device by
> default ("-d rtinherit=1) then those tests that want to run with a small
> volume size will instead be running with a huge realtime device.  This
> makes certain tests take forever to run, so apply the same sizing to the
> rt volume if one exists.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/rc |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index f78b1cfc..b2d45fa2 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -976,14 +976,20 @@ _scratch_mkfs_sized()
>  	[ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
>      fi
>  
> +    if [ "$HOSTOS" == "Linux" ] && [ "$FSTYP" = "xfs" ] && [ -b "$SCRATCH_RTDEV" ]; then
> +	local rtdevsize=`blockdev --getsize64 $SCRATCH_RTDEV`
> +	[ "$fssize" -gt "$rtdevsize" ] && _notrun "Scratch rt device too small"
> +	rt_ops="-r size=$fssize"
> +    fi

The indentation here looks rather weird.  I also don't think we need
the HOSTOS check.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
