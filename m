Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1727B26D0FC
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 04:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgIQCNC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Sep 2020 22:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIQCNA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 22:13:00 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F3EC061788
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 19:05:16 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id z1so191800ooj.3
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 19:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=FvBdfI3/8JYEzHDwTJchNGznx9TCTfOWN6nMTk+cWRg=;
        b=SxAIwAWl1MqxQGVya1/LLGYLyQUf80qPgV3UgTzda0zs4xtGvK+4t42qChTNnUsQp2
         iidBl3RcjWjxLEf3TZErhnJNVVQbN7kfMfUmVvIATlXjukaBN+biw4DGFEtwxso0eFH3
         U57Zvvxg6m/kE5XelTs1/4GU+7H9JXM071r8m/4ZtDTvnHENVfGtnySAZv4kOHTr0OEO
         nGgEa2imdIkbWGjE4w2eJKI3i7opSAcSjM4lAf/eWxB03Q2LwB/TXuLJwne9YkNYXg0u
         /h/dWj2zkQOOZ9HHYhSHhoHJtjkFEXp5gat/GmMoyC4Tw0RZhLUvTdQyQRkgrx/gGf3i
         dp5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=FvBdfI3/8JYEzHDwTJchNGznx9TCTfOWN6nMTk+cWRg=;
        b=sRvGOCVgAA6Tqx4FP68e/D6EB8qFOH9MrwX/XhhYHHxJ/yIeyeRefNlt5WoT0UrTh/
         Lfq2LBOWgBF308hO8Yy9ZydKDPUgMNaYC0YSmt+LDUd4e4wlN82PneLyGnCNj2rBZsQO
         CNYspjh9Jzj1+xymGtWGRLTCbpm7VroFz5Y7ldIafE8bHG1CPOwXiokeW4SV9lPUcyPQ
         hEWVnKSGUsjomCt+gqylTR2PSIn6GteGJsBXifmOmd+himFW3dBT26lTGd1ZvRiKsiV9
         j17EvW1VjALTl2SiJFqpaNx4oflBMsMT+f0rdrH5U34ovI1TlkN+6kK4yKn2qKVplpVE
         cChQ==
X-Gm-Message-State: AOAM533A+Ri3O3n/VhWNr7kw5mCzACBHwHBNMC/LRyWi1N4gExUZPh2X
        LvMLjcADM5xFBDs2ZoMR5bo9mg==
X-Google-Smtp-Source: ABdhPJwlHAL814Qbgr+EScHD+loUynWF6I3FcBxRyuexwIjAE/FXXv9TKSXjo79ezbsysUHb+aAFHw==
X-Received: by 2002:a4a:c541:: with SMTP id j1mr19671594ooq.13.1600308314725;
        Wed, 16 Sep 2020 19:05:14 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id a4sm8527275oif.3.2020.09.16.19.05.09
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 16 Sep 2020 19:05:11 -0700 (PDT)
Date:   Wed, 16 Sep 2020 19:04:46 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Dave Chinner <david@fromorbit.com>
cc:     Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Theodore Tso <tytso@mit.edu>,
        Martin Brandenburg <martin@omnibond.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Qiuyang Sun <sunqiuyang@huawei.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, nborisov@suse.de
Subject: Re: More filesystem need this fix (xfs: use MMAPLOCK around
 filemap_map_pages())
In-Reply-To: <20200917014454.GZ12131@dread.disaster.area>
Message-ID: <alpine.LSU.2.11.2009161853220.2087@eggly.anvils>
References: <20200623052059.1893966-1-david@fromorbit.com> <CAOQ4uxh0dnVXJ9g+5jb3q72RQYYqTLPW_uBqHPKn6AJZ2DNPOQ@mail.gmail.com> <20200916155851.GA1572@quack2.suse.cz> <20200917014454.GZ12131@dread.disaster.area>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 17 Sep 2020, Dave Chinner wrote:
> 
> So....
> 
> P0					p1
> 
> hole punch starts
>   takes XFS_MMAPLOCK_EXCL
>   truncate_pagecache_range()
>     unmap_mapping_range(start, end)
>       <clears ptes>
> 					<read fault>
> 					do_fault_around()
> 					  ->map_pages
> 					    filemap_map_pages()
> 					      page mapping valid,
> 					      page is up to date
> 					      maps PTEs
> 					<fault done>
>     truncate_inode_pages_range()
>       truncate_cleanup_page(page)
>         invalidates page
>       delete_from_page_cache_batch(page)
>         frees page
> 					<pte now points to a freed page>

No.  filemap_map_pages() checks page->mapping after trylock_page(),
before setting up the pte; and truncate_cleanup_page() does a one-page
unmap_mapping_range() if page_mapped(), while holding page lock.

(Of course, there's a different thread, in which less reliance on
page lock is being discussed, but that would be a future thing.)

Hugh
