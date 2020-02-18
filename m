Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC857162747
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Feb 2020 14:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgBRNmb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Feb 2020 08:42:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49330 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgBRNmb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 08:42:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=sRRfkuIro3UJgk7ronBRbu9Qpl4FSkPX98/JT02cIzQ=; b=WiqMBzR3mGIQcEq161KXuYNNqn
        oGEGsCAD1sh6ZxDHFnwWKQ2UwAbxLDKaVUSstZlvvZi3x4yIlHuLp2u6l7YrszKdgcpLhi972Q0/M
        v2lPX/oCVktUYRubwI/oT4ULqsPrfYeqx1ppvykbJky0SIGyrQDEEKC6qeiOAZIZLEEa8fGbwzymS
        SKIhK0eTvDnycS/K6GjH9DoFUk9lT4+Bh4Q7le4HVT8wkpD+696fuAoTeI+nAElAF/93gchu8m6kq
        3yyLRS2ZUp2AAlJpuu2kf3UYi/qoxOxEhYzdrtFmaDyvoJBUAzp1grGpHZPuH40DCWRoboP4begWK
        g4B3syeQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j438w-0002EE-C5; Tue, 18 Feb 2020 13:42:30 +0000
Date:   Tue, 18 Feb 2020 05:42:30 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 00/19] Change readahead API
Message-ID: <20200218134230.GN7778@bombadil.infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
 <20200218045633.GH10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200218045633.GH10776@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 03:56:33PM +1100, Dave Chinner wrote:
> Latest version in your git tree:
> 
> $ ▶ glo -n 5 willy/readahead
> 4be497096c04 mm: Use memalloc_nofs_save in readahead path
> ff63497fcb98 iomap: Convert from readpages to readahead
> 26aee60e89b5 iomap: Restructure iomap_readpages_actor
> 8115bcca7312 fuse: Convert from readpages to readahead
> 3db3d10d9ea1 f2fs: Convert from readpages to readahead
> $
> 
> merged into a 5.6-rc2 tree fails at boot on my test vm:
> 
> [    2.423116] ------------[ cut here ]------------
> [    2.424957] list_add double add: new=ffffea000efff4c8, prev=ffff8883bfffee60, next=ffffea000efff4c8.
> [    2.428259] WARNING: CPU: 4 PID: 1 at lib/list_debug.c:29 __list_add_valid+0x67/0x70
> [    2.457484] Call Trace:
> [    2.458171]  __pagevec_lru_add_fn+0x15f/0x2c0
> [    2.459376]  pagevec_lru_move_fn+0x87/0xd0
> [    2.460500]  ? pagevec_move_tail_fn+0x2d0/0x2d0
> [    2.461712]  lru_add_drain_cpu+0x8d/0x160
> [    2.462787]  lru_add_drain+0x18/0x20

Are you sure that was 4be497096c04 ?  I ask because there was a
version pushed to that git tree that did contain a list double-add
(due to a mismerge when shuffling patches).  I noticed it and fixed
it, and 4be497096c04 doesn't have that problem.  I also test with
CONFIG_DEBUG_LIST turned on, but this problem you hit is going to be
probabilistic because it'll depend on the timing between whatever other
list is being used and the page actually being added to the LRU.

