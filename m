Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCCA8CC2A
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Aug 2019 09:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfHNHAy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Aug 2019 03:00:54 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3939 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726373AbfHNHAy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Aug 2019 03:00:54 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id E48AC89D4D0CCF1AD9C5;
        Wed, 14 Aug 2019 15:00:50 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 14 Aug 2019 15:00:48 +0800
Received: from 138 (10.175.124.28) by dggeme762-chm.china.huawei.com
 (10.3.19.108) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Wed, 14
 Aug 2019 15:00:47 +0800
Date:   Wed, 14 Aug 2019 15:17:54 +0800
From:   Gao Xiang <gaoxiang25@huawei.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3] vfs: fix page locking deadlocks when deduping files
Message-ID: <20190814071754.GC28602@138>
References: <20190813151434.GQ7138@magnolia>
 <20190813154010.GD5307@bombadil.infradead.org>
 <20190814070321.GB28602@138>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190814070321.GB28602@138>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Originating-IP: [10.175.124.28]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 14, 2019 at 03:03:21PM +0800, Gao Xiang wrote:
> On Tue, Aug 13, 2019 at 08:40:10AM -0700, Matthew Wilcox wrote:
> > On Tue, Aug 13, 2019 at 08:14:34AM -0700, Darrick J. Wong wrote:
> > > +		/*
> > > +		 * Now that we've locked both pages, make sure they still
> > > +		 * represent the data we're interested in.  If not, someone
> > > +		 * is invalidating pages on us and we lose.
> > > +		 */
> > > +		if (src_page->mapping != src->i_mapping ||
> > > +		    src_page->index != srcoff >> PAGE_SHIFT ||
> > > +		    dest_page->mapping != dest->i_mapping ||
> > > +		    dest_page->index != destoff >> PAGE_SHIFT) {
> > > +			same = false;
> > > +			goto unlock;
> > > +		}
> > 
> > It is my understanding that you don't need to check the ->index here.
> > If I'm wrong about that, I'd really appreciate being corrected, because
> > the page cache locking is subtle.
> > 
> > You call read_mapping_page() which returns the page with an elevated
> > refcount.  That means the page can't go back to the page allocator and
> > be allocated again.  It can, because it's unlocked, still be truncated,
> > so the check for ->mapping after locking it is needed.  But the check
> > for ->index being correct was done by find_get_entry().
> > 
> > See pagecache_get_page() -- if we specify FGP_LOCK, then it will lock
> > the page, check the ->mapping but not check ->index.  OK, it does check
> > ->index, but in a VM_BUG_ON(), so it's not something that ought to be
> > able to be wrong.
> 
> That is my understanding as well. In details...
> 
> The page data get ready after read_mapping_page() is successfully
> returned. However, if someone needs to get a stable untruncated page,
> lock_page() and recheck page->mapping are needed as well.
> 
> I have no idea how page->index can be changed safely without reallocating
> the page, even some paths could keep using some truncated page temporarily
> with some refcounts held but I think those paths cannot add these pages

Such a case is like that even if the page can be truncated
at the same time without locking, some paths only needs to
get its page data unstrictly (and note that these pages
should be Uptodated before). Therefore those paths can
only take a refcount without PG_lock... But such refcounts
should be used temporarily, those pages cannot be added to
page cache again without reallocating...

Thanks,
Gao Xiang

> directly to some page cache again without freeing since it seems really
> unsafe.....
> 
> Thanks,
> Gao Xiang
> 
> > 
