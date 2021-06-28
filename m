Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99AE3B67FB
	for <lists+linux-xfs@lfdr.de>; Mon, 28 Jun 2021 19:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhF1R5p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 28 Jun 2021 13:57:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47476 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234044AbhF1R5o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jun 2021 13:57:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624902918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9xx3aix+D5Tr8zE04rXkig/bU4Pi+06/8LbOmmRbtrw=;
        b=Aiv/B/NHPkLakcHA4+e5eODxZ2+tDbylAQ7YohCgj9IxTwZT1pE9edw/tuo2l9BqokBOKh
        wdn0ADh1jmyax2eqPKsE7CTW7B2RPm8UQm8cR8C0fRd/dEG+SUDgQOmjVol8XVFCQB9qcd
        26bJ77lAibCggKwHTaUoJyuKCR/iEkA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-ZFqoFZI2MruBjiHc6sgcvQ-1; Mon, 28 Jun 2021 13:55:16 -0400
X-MC-Unique: ZFqoFZI2MruBjiHc6sgcvQ-1
Received: by mail-wr1-f70.google.com with SMTP id t10-20020a5d49ca0000b029011a61d5c96bso4875843wrs.11
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jun 2021 10:55:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9xx3aix+D5Tr8zE04rXkig/bU4Pi+06/8LbOmmRbtrw=;
        b=eJ3EfH0WwMsk/Fvz/9N0KdD+1kw2gU6J5yAEOuuCRSXpXCVA96myA+yeCmRLcSMOFN
         WoEMqvA23siM9nuGNHwsEeMWB1ryO6clNWKtN6gjfRiIGuDBcF4zk+5ZmHXDtKaf7tm1
         ylPc0Td1QqRWwZA0RYBfmB1m9W4fa5mC5u3oQQ7o2EePxc7BIWmzwAp9A6G9mJSpmcvW
         PXxCe1LvjCOrWLtyn2OR1eC3SIxPZx0yg3uLKQVrq5cXw6AlysHHpBNDoDnf6RpX9Ypb
         vnQD7vr8v0Xx8Il6UZzB8n/Z0MGgKF9f1JmnLYm+Q8H6KODprAJYsc6FV1pjbh5CCMvD
         NcsA==
X-Gm-Message-State: AOAM531Kc28Fln8cekjhz7ReY5Kivb1s7MC9n6qBjOs8kBNrp+6Ku9FN
        8UMgEMmlil3pDI/eM2gum8OlzkhIFa/tofJCm9jun0ag7/IDWjYwB4TMCzt0WNBN41cziurwoNh
        Og7B1uzrZG/GHB8q3Phm2f3ihZy09z89fBgui
X-Received: by 2002:a5d:5745:: with SMTP id q5mr1987548wrw.329.1624902915374;
        Mon, 28 Jun 2021 10:55:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxM0AJBi5M/RdX9OijjwR4Wd6ZMMoGR51dlTSusBJc5+SZh1Ir838Q0/HWfs3XJf/JcDJ92e03R7DtCTSUSI7c=
X-Received: by 2002:a5d:5745:: with SMTP id q5mr1987533wrw.329.1624902915263;
 Mon, 28 Jun 2021 10:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210628172727.1894503-1-agruenba@redhat.com> <YNoJPZ4NWiqok/by@casper.infradead.org>
In-Reply-To: <YNoJPZ4NWiqok/by@casper.infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 28 Jun 2021 19:55:04 +0200
Message-ID: <CAHc6FU5tkvH5WNFuiwRZKNhYZdj2z+Q2bXzp31xBP8mbnnYhzw@mail.gmail.com>
Subject: Re: [PATCH 0/2] iomap: small block problems
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 28, 2021 at 7:40 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Mon, Jun 28, 2021 at 07:27:25PM +0200, Andreas Gruenbacher wrote:
> > (1) In iomap_readpage_actor, an iomap_page is attached to the page even
> > for inline inodes.  This is unnecessary because inline inodes don't need
> > iomap_page objects.  That alone wouldn't cause any real issues, but when
> > iomap_read_inline_data copies the inline data into the page, it sets the
> > PageUptodate flag without setting iop->uptodate, causing an
> > inconsistency between the two.  This will trigger a WARN_ON in
> > iomap_page_release.  The fix should be not to allocate iomap_page
> > objects when reading from inline inodes (patch 1).
>
> I don't have a problem with this patch.
>
> > (2) When un-inlining an inode, we must allocate a page with an attached
> > iomap_page object (iomap_page_create) and initialize the iop->uptodate
> > bitmap (iomap_set_range_uptodate).  We can't currently do that because
> > iomap_page_create and iomap_set_range_uptodate are not exported.  That
> > could be fixed by exporting those functions, or by implementing an
> > additional helper as in patch 2.  Which of the two would you prefer?
>
> Not hugely happy with either of these options, tbh.  I'd rather we apply
> a patch akin to this one (plucked from the folio tree), so won't apply:
>
> @@ -1305,7 +1311,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>                 struct writeback_control *wbc, struct inode *inode,
>                 struct folio *folio, loff_t end_pos)
>  {
> -       struct iomap_page *iop = to_iomap_page(folio);
> +       struct iomap_page *iop = iomap_page_create(inode, folio);
>         struct iomap_ioend *ioend, *next;
>         unsigned len = i_blocksize(inode);
>         unsigned nblocks = i_blocks_per_folio(inode, folio);
> @@ -1313,7 +1319,6 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>         int error = 0, count = 0, i;
>         LIST_HEAD(submit_list);
>
> -       WARN_ON_ONCE(nblocks > 1 && !iop);
>         WARN_ON_ONCE(iop && atomic_read(&iop->write_bytes_pending) != 0);
>
>         /*
>
> so permit pages without an iop to enter writeback and create an iop
> *then*.  Would that solve your problem?

It probably would. Let me do some testing based on that.

> > (3) We're not yet using iomap_page_mkwrite, so iomap_page objects don't
> > get created on .page_mkwrite, either.  Part of the reason is that
> > iomap_page_mkwrite locks the page and then calls into the filesystem for
> > uninlining and for allocating backing blocks.  This conflicts with the
> > gfs2 locking order: on gfs2, transactions must be started before locking
> > any pages.  We can fix that by calling iomap_page_create from
> > gfs2_page_mkwrite, or by doing the uninlining and allocations before
> > calling iomap_page_mkwrite.  I've implemented option 2 for now; see
> > here:
>
> I think this might also solve this problem?

Probably yes.

Thanks,
Andreas

