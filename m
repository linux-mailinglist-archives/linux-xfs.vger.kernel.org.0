Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276CE2BB284
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Nov 2020 19:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgKTSXT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Nov 2020 13:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgKTSXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Nov 2020 13:23:18 -0500
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEC4C0613CF
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 10:23:18 -0800 (PST)
Received: by mail-qv1-xf44.google.com with SMTP id p12so2927220qvj.13
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 10:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=UCRF1tW/AZBL2cTgUwVNxqtk7LoMkUYo1UAbEj+RJjA=;
        b=B4hybK4yzaLM2Npm1+7g6r63APKMgeTYmtc+xA4iVzmdUpm8/fc6u8PaaYBUCEqsTa
         DQGtD0B85sfZ6AQDUGUUQC5pVjZlDUujNTP78g/UuI8FK4lpcR30mtecsvkVf7DRgiuW
         MlO955aCtgx98+WPuV3NTYdOklNjuBLotWjSZU4ObiQWcAx2srZjTgQUtz+nDfdm6w6W
         DZqPXoE1QXdh/pboRXeD4ejJgfX5GK2Q1BTBAtJtZmFj9fTPLr6v/mkTDWfR54U03nWV
         iXOwhBmbqACTOvfxkYtC+csJIypzFC+zmDe+YDbqWg3tSfxHioKaKSUTa24FTqD2nFIt
         rECQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UCRF1tW/AZBL2cTgUwVNxqtk7LoMkUYo1UAbEj+RJjA=;
        b=Bv94D2brsPZLZkqCXuaxW5j418hMmyuO7KcgMWCFkfRfRl3qaQCKipxVCUs8lfEoZK
         RYePq5aZsf5NrQmKtbAs5EwJRfUgEhvubHnPhWg5OXMLs1O1uNvcIv7NOX37K7M7tb/R
         LPLn/h2aFZdYgdtF9HaKwOOp3tAbpu4PZjTUYrKYvT4FVrn/st23wWZljdmoYYEuS2O2
         6iQ+2pPFCda9RyOcgIjyLdIVSYsIEJpzTWTzBOUjpGQGlT+z2CO8Q9yybhoFSXinjZ/W
         1CrXoch1YLPORpzOKJpRymIpNJjDqlHtVdr2F5S33WEEgYmAuf1spefM6qS45VLL4skL
         eDoA==
X-Gm-Message-State: AOAM5336zo8IsPKBuSfW/3jz5or9S426PbaqVGnx6Ngq+mz+l04J0zhq
        LY+Dp8wQ/PBt1/l5/jqjV22qxg==
X-Google-Smtp-Source: ABdhPJyYHlJdtw+Gau+17nV3WJLVIt14si/LWrTbl0K59MDQ0saInzPp33g3U6H6OWsC2O3yX2B0AQ==
X-Received: by 2002:a0c:b18a:: with SMTP id v10mr16583162qvd.46.1605896597938;
        Fri, 20 Nov 2020 10:23:17 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id v9sm2453624qkv.34.2020.11.20.10.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 10:23:17 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kgB40-008ub6-IN; Fri, 20 Nov 2020 14:23:16 -0400
Date:   Fri, 20 Nov 2020 14:23:16 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas_os@shipmail.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-rdma@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH 1/3] mm: Track mmu notifiers in fs_reclaim_acquire/release
Message-ID: <20201120182316.GP244516@ziepe.ca>
References: <20201120095445.1195585-1-daniel.vetter@ffwll.ch>
 <20201120095445.1195585-2-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201120095445.1195585-2-daniel.vetter@ffwll.ch>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 20, 2020 at 10:54:42AM +0100, Daniel Vetter wrote:
> fs_reclaim_acquire/release nicely catch recursion issues when
> allocating GFP_KERNEL memory against shrinkers (which gpu drivers tend
> to use to keep the excessive caches in check). For mmu notifier
> recursions we do have lockdep annotations since 23b68395c7c7
> ("mm/mmu_notifiers: add a lockdep map for invalidate_range_start/end").
> 
> But these only fire if a path actually results in some pte
> invalidation - for most small allocations that's very rarely the case.
> The other trouble is that pte invalidation can happen any time when
> __GFP_RECLAIM is set. Which means only really GFP_ATOMIC is a safe
> choice, GFP_NOIO isn't good enough to avoid potential mmu notifier
> recursion.
> 
> I was pondering whether we should just do the general annotation, but
> there's always the risk for false positives. Plus I'm assuming that
> the core fs and io code is a lot better reviewed and tested than
> random mmu notifier code in drivers. Hence why I decide to only
> annotate for that specific case.
> 
> Furthermore even if we'd create a lockdep map for direct reclaim, we'd
> still need to explicit pull in the mmu notifier map - there's a lot
> more places that do pte invalidation than just direct reclaim, these
> two contexts arent the same.
> 
> Note that the mmu notifiers needing their own independent lockdep map
> is also the reason we can't hold them from fs_reclaim_acquire to
> fs_reclaim_release - it would nest with the acquistion in the pte
> invalidation code, causing a lockdep splat. And we can't remove the
> annotations from pte invalidation and all the other places since
> they're called from many other places than page reclaim. Hence we can
> only do the equivalent of might_lock, but on the raw lockdep map.
> 
> With this we can also remove the lockdep priming added in 66204f1d2d1b
> ("mm/mmu_notifiers: prime lockdep") since the new annotations are
> strictly more powerful.
> 
> v2: Review from Thomas Hellstrom:
> - unbotch the fs_reclaim context check, I accidentally inverted it,
>   but it didn't blow up because I inverted it immediately
> - fix compiling for !CONFIG_MMU_NOTIFIER
> 
> v3: Unbreak the PF_MEMALLOC_ context flags. Thanks to Qian for the
> report and Dave for explaining what I failed to see.
> 
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Qian Cai <cai@lca.pw>
> Cc: linux-xfs@vger.kernel.org
> Cc: Thomas Hellström (Intel) <thomas_os@shipmail.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: linux-mm@kvack.org
> Cc: linux-rdma@vger.kernel.org
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  mm/mmu_notifier.c |  7 -------
>  mm/page_alloc.c   | 31 ++++++++++++++++++++-----------
>  2 files changed, 20 insertions(+), 18 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
