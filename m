Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06484DCA02
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Mar 2022 16:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiCQPdW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Mar 2022 11:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbiCQPdV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 11:33:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E19E2208C2F
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 08:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647531124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FxOX+RAN4v4Lf/VXH38aBDUMX82mgpHDsamZJ2eKXbI=;
        b=jNaDbKmAjwoS9tf4otvnXvKowDaZ+XJ/2a/8n6JYuQHpXYa4PfE+S8i0ds64V2rg5CTI1u
        ptm+rHuDEBgecHi2VUKybcOxHVsx+DR9hZ8mHMGgYGgNf4x/CRrIrr14+PJe0zrcbXnhpa
        11Y7QtM2HG0BAqZ6YY11oXn8LEKjSzs=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-hb-rsx_9OdyuvCvGpZJFSA-1; Thu, 17 Mar 2022 11:32:02 -0400
X-MC-Unique: hb-rsx_9OdyuvCvGpZJFSA-1
Received: by mail-qt1-f200.google.com with SMTP id q24-20020ac87358000000b002e063c3d15aso3778111qtp.2
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 08:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FxOX+RAN4v4Lf/VXH38aBDUMX82mgpHDsamZJ2eKXbI=;
        b=dUdMQkDNDHF5rsPIEQbVMWEbmttBRrnJ2dNc9lPW21JbLzqsidMv6gthyfi56c0B7N
         2FTjiUJ5Zaf2jyjVl8UfJeO1EH4aqSLwjfwtD4Lns3oU6krZovOCA+p1V0zZXIOkxvQp
         u/tHaTDpu+xFSI27HTlPsbi56xHIHC8XTjHfigaZ/Qb5XIhQFfwTSHwILvU/x43679Dv
         0uVooIibOIQmaBib8nHkHwiatKA4P2zKOA1U1DIN55aOXFlQh4VGA5SRh/hf49VPlLTN
         f9ke1EckUdoAG1GNZ68vP24sTAMoOkDnlS5/FpMsB4FmCcL0FCZITYb0Ha8ci2+B7rcG
         rTEg==
X-Gm-Message-State: AOAM532YNgoIWUfJH6q4GI3S89M/z1S+0q7r5v0FCUle8wLMYoU4moTj
        hMYZmcvxzaclF+Y7bpqE7P4xYSCokmLYmATj0esbGXZHPbqTsJiU3t4SpnstLL+VHrrGmKH0OUK
        TGKdWFXiFYaX7GAqOat86
X-Received: by 2002:ac8:5a4f:0:b0:2e1:a7be:2d13 with SMTP id o15-20020ac85a4f000000b002e1a7be2d13mr4151323qta.598.1647531121897;
        Thu, 17 Mar 2022 08:32:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHBjIab8EPVWX036RD6/D6zYUhmHxCkiYYMe9+aHBCL5A94LdRhl0wHn0trVhn0vS+XUvhGA==
X-Received: by 2002:ac8:5a4f:0:b0:2e1:a7be:2d13 with SMTP id o15-20020ac85a4f000000b002e1a7be2d13mr4151286qta.598.1647531121500;
        Thu, 17 Mar 2022 08:32:01 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id x6-20020ac86b46000000b002e02be9c0easm3432036qts.69.2022.03.17.08.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 08:32:01 -0700 (PDT)
Date:   Thu, 17 Mar 2022 11:31:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: writeback completion soft lockup BUG in folio_wake_bit()
Message-ID: <YjNUb1tk3YVg3GNy@bfoster>
References: <YjDj3lvlNJK/IPiU@bfoster>
 <YjJPu/3tYnuKK888@casper.infradead.org>
 <CAHk-=wgPTWoXCa=JembExs8Y7fw7YUi9XR0zn1xaxWLSXBN_vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgPTWoXCa=JembExs8Y7fw7YUi9XR0zn1xaxWLSXBN_vg@mail.gmail.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 04:35:10PM -0700, Linus Torvalds wrote:
> On Wed, Mar 16, 2022 at 1:59 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > As I recall, the bookmark hack was introduced in order to handle
> > lock_page() problems.  It wasn't really supposed to handle writeback,
> > but nobody thought it would cause any harm (and indeed, it didn't at the
> > time).  So how about we only use bookmarks for lock_page(), since
> > lock_page() usually doesn't have the multiple-waker semantics that
> > writeback has?
> 
> I was hoping that some of the page lock problems are gone and we could
> maybe try to get rid of the bookmarks entirely.
> 
> But the page lock issues only ever showed up on some private
> proprietary load and machine, so we never really got confirmation that
> they are fixed. There were lots of strong signs to them being related
> to the migration page locking, and it may be that the bookmark code is
> only hurting these days.
> 
> See for example commit 9a1ea439b16b ("mm:
> put_and_wait_on_page_locked() while page is migrated") which doesn't
> actually change the *locking* side, but drops the page reference when
> waiting for the locked page to be unlocked, which in turn removes a
> "loop and try again when migration". And that may have been the real
> _fix_ for the problem.
> 
> Because while the bookmark thing avoids the NMI lockup detector firing
> due to excessive hold times, the bookmarking also _causes_ that "we
> now will see the same page multiple times because we dropped the lock
> and somebody re-added it at the end of the queue" issue. Which seems
> to be the problem here.
> 
> Ugh. I wish we had some way to test "could we just remove the bookmark
> code entirely again".
> 
> Of course, the PG_lock case also works fairly hard to not actually
> remove and re-add the lock waiter to the queue, but having an actual
> "wait for and get the lock" operation. The writeback bit isn't done
> that way.
> 
> I do hate how we had to make folio_wait_writeback{_killable}() use
> "while" rather than an "if". It *almost* works with just a "wait for
> current writeback", but not quite. See commit c2407cf7d22d ("mm: make
> wait_on_page_writeback() wait for multiple pending writebacks") for
> why we have to loop. Ugly, ugly.
> 

Right.. In case you missed it in my too long of a description (sorry), I
pointed out that this problem seems to manifest most recently as of that
commit. In fact looking through the past discussion for that patch, it
wouldn't surprise me a ton of this problem is some pathological
manifestation of the perf issue that you described here [1].

Indeed most of the waiters in this case come from fsync() -> ... ->
__filemap_fdatawait_range(), and your test patch in that email performs
a similar sort of trick to skip out of the wake up side (I'm curious if
that was ever determined to help?) to things that I was playing with to
try and narrow this down.

> Because I do think that "while" in the writeback waiting is a problem.
> Maybe _the_ problem.
> 

FWIW, Matthew's patch does seem to address this problem. My current test
of that patch is past the point where I usually expect to see the soft
lockup warning, but I'm going to let it continue to run (and then run it
through some xfs regression if the approach is agreeable).

Getting back to the loop thing (and seeing Matthew's latest reply wrt to
wait_and_set())...

If we wanted to go back to non-looping in folio_wait_writeback() to
avoid the unserialized wait queue build up or whatever, would it make
any sense to lift the looping writeback check to write_cache_pages()? We
hold the page lock and have checked PageDirty() by that point, so ISTM
that would address the BUG_ON(PageWriteback()) race caused by the
delayed/unserialized wakeup without producing the excess wait queue
buildup caused by waiters in the __filemap_fdatawait_range() path.

Then presumably that "wait for writeback to clear" loop in
write_cache_pages() is eventually replaced by the "wait and set
writeback" thing when the rest of the fs code is fixed up appropriately.
Hm? Of course I haven't tested that so it could be completely bogus, but
I can if it makes any sort of sense as an incremental step..

Brian

[1] https://lore.kernel.org/linux-mm/CAHk-=wgD9GK5CeHopYmRHoYS9cNuCmDMsc=+MbM_KgJ0KB+=ng@mail.gmail.com/

>                         Linus
> 

