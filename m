Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C933AF11E
	for <lists+linux-xfs@lfdr.de>; Mon, 21 Jun 2021 18:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhFURAQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 21 Jun 2021 13:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233271AbhFUQ7q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 12:59:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C93E60C3F;
        Mon, 21 Jun 2021 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624294652;
        bh=SYNdbbqd8hbPZCLmFz7xPj8bzpG3YVpkSkp67e+IHe4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ebLpD3SYV+UD8P1cSPaJEnQTwXGDhd5OjwtNxVegmTPHfYUmM9neOlyXCqfMn/2nt
         zO2x9L59wEpIwN1JFS8IxSV8sz7cc9OzfaDC/+JJqlcNi/lNnxMDEjwmcenxv5HhpK
         9NfkHRkbgd0AvtRfV2VJETrAiiAS+TYwy3SDkliCBAp7Y5DODLycU33J12h/VXt9Dl
         +3ZQcJerSOMgagQVuIALJgmj5QvMTuixVgqskf3GmIAdyBb3xOa+YFpLteoh67MUEw
         onzy9j7qgtOkx2pkg25RWcPmzQkejJ2BelPYi6WxazK8hUNjSaUo10CaOATwU0oNuT
         fvI2NNBQT81KQ==
Date:   Mon, 21 Jun 2021 09:57:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] xfs: fix buffer use after free on unpin abort
Message-ID: <20210621165732.GB3619569@locust>
References: <20210621131644.128177-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621131644.128177-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 21, 2021 at 09:16:42AM -0400, Brian Foster wrote:
> v2:
> - Split assert in patch 2.
> v1: https://lore.kernel.org/linux-xfs/20210511135257.878743-1-bfoster@redhat.com/
> - Rework patch 1 to hold conditionally in the abort case and document
>   the underlying design flaw.
> - Add patch 2 to remove some unused code.
> rfc: https://lore.kernel.org/linux-xfs/20210503121816.561340-1-bfoster@redhat.com/
> 
> Brian Foster (2):
>   xfs: hold buffer across unpin and potential shutdown processing
>   xfs: remove dead stale buf unpin handling code

Doh, this totally fell off my radar.  Thanks for resubmitting it, I'll
put it in the test queue.

--D

> 
>  fs/xfs/xfs_buf_item.c | 58 +++++++++++++++++--------------------------
>  1 file changed, 23 insertions(+), 35 deletions(-)
> 
> -- 
> 2.26.3
> 
