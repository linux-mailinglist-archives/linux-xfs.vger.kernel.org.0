Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D770C277449
	for <lists+linux-xfs@lfdr.de>; Thu, 24 Sep 2020 16:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgIXOsQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 24 Sep 2020 10:48:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728147AbgIXOsP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 10:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600958894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5AR+Qj5i+6LX9old+y3hUJoCWXTMX4G+tk5PXfWTv+Y=;
        b=CUYuZw/C4rT0j9M9cH9DkCUu1c4uVgAZ1PRiibC0mbr3WocOBAEQFpte64wrgT8ZuOLEy4
        MCeWnHoGjxgSlWFQPKfpsh1DpehJl4teYoHhmwOxA3N7ooEHPoqXPhdRu2U/oqlKt3C1eg
        YOLW+kbWU7EhS5y2C+BY+P5ZqZvtYC0=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-LRLTPRxnMLu8u1tLYqkldA-1; Thu, 24 Sep 2020 10:48:12 -0400
X-MC-Unique: LRLTPRxnMLu8u1tLYqkldA-1
Received: by mail-pg1-f200.google.com with SMTP id j6so689779pgi.22
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2020 07:48:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5AR+Qj5i+6LX9old+y3hUJoCWXTMX4G+tk5PXfWTv+Y=;
        b=LhTUINCbuKUa3ZIlHRdlYn3bGv+HJtgmdgUJxkBd8w5c9f+/7PS1nWoQOs5hTGjBem
         qkZX2QcBfDoqXgJ0oATZXgm09r4MxW2EqWMnCeENVNrvMTn8aFVF9pqo3uUW9UHrzEZh
         NkG+RNzMkPTQQjaB4z5qJLHivx8h8qIDAS6ZPocMotCeFj66zfxFa9MW4/FOtGXfunF8
         cm69amOk9329+7tSlaBeArguEKi3ZoICwr6QA+7MgCrV6OQA/J3ey6dwPQj+hLx17341
         UqEJmIF87mL4eWCinUmnTSEiY8KhW/rETJLFxhuFCvmawpaDygaR97CCQZwZ6FTj4C4C
         oQkA==
X-Gm-Message-State: AOAM530CXyCMyezT0saCnJsOL0WjUGrimMqRIH8w8d7lWl1InNfyQpUE
        g2Tv5QTuN4fGCulPBJe4sRqccEm6nCPNcOJV34MVdKgwQRy8eCAw2zVMxY7e5oEBqf5htoChI/4
        qy0K0V1u8B1Y6/jDfbmBm
X-Received: by 2002:a17:90a:15d6:: with SMTP id w22mr4344222pjd.148.1600958891012;
        Thu, 24 Sep 2020 07:48:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrqlv5H4wHGAQvUaT3idV8BV3Y27+4cju9CJ8wy0kDgM0Qx/2d1uIDfzhuqmXFxttUDJnLSA==
X-Received: by 2002:a17:90a:15d6:: with SMTP id w22mr4344196pjd.148.1600958890694;
        Thu, 24 Sep 2020 07:48:10 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x20sm3212407pfr.190.2020.09.24.07.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 07:48:10 -0700 (PDT)
Date:   Thu, 24 Sep 2020 22:47:59 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Qian Cai <cai@redhat.com>
Subject: Re: [PATCH] iomap: Set all uptodate bits for an Uptodate page
Message-ID: <20200924144759.GB28205@xiangao.remote.csb>
References: <20200924125608.31231-1-willy@infradead.org>
 <20200924131235.GA2603692@bfoster>
 <20200924135900.GV32101@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924135900.GV32101@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 24, 2020 at 02:59:00PM +0100, Matthew Wilcox wrote:
> On Thu, Sep 24, 2020 at 09:12:35AM -0400, Brian Foster wrote:
> > On Thu, Sep 24, 2020 at 01:56:08PM +0100, Matthew Wilcox (Oracle) wrote:
> > > For filesystems with block size < page size, we need to set all the
> > > per-block uptodate bits if the page was already uptodate at the time
> > > we create the per-block metadata.  This can happen if the page is
> > > invalidated (eg by a write to drop_caches) but ultimately not removed
> > > from the page cache.
> > > 
> > > This is a data corruption issue as page writeback skips blocks which
> > > are marked !uptodate.
> > 
> > Thanks. Based on my testing of clearing PageUptodate here I suspect this
> > will similarly prevent the problem, but I'll give this a test
> > nonetheless. 
> > 
> > I am a little curious why we'd prefer to fill the iop here rather than
> > just clear the page state if the iop data has been released. If the page
> > is partially uptodate, then we end up having to re-read the page
> > anyways, right? OTOH, I guess this behavior is more consistent with page
> > size == block size filesystems where iop wouldn't exist and we just go
> > by page state, so perhaps that makes more sense.
> 
> Well, it's _true_ ... the PageUptodate bit means that every byte in this
> page is at least as new as every byte on storage.  There's no need to
> re-read it, which is what we'll do if we ClearPageUptodate.
> 

Agreed, Pagetodate(page) means the whole page content is available now,
see create_page_buffers() -> create_empty_buffers() and try_to_free_buffers()
(much like .releasepage()) in buffer head approach.

Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

