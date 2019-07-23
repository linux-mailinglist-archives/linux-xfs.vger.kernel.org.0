Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6B671BA2
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jul 2019 17:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbfGWPbi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Jul 2019 11:31:38 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46708 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731633AbfGWPbi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 11:31:38 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so43634005wru.13
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2019 08:31:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=vvoeRmFxu4dwFaH9ZikW/aWAd+3zIvMziG8rZ0CdYV0=;
        b=hJqKX72vtUgX5/T8FWY7VtavIKtwNC7r0BDEH/4rO5YeUmWYYVLRWp563QusQu1xiP
         4A1vscX/EmL1C9pjg3EZ9eJJsQbC++cjOrT5qocDlK2Jy5cYs6rfOzneJx2zjyyat5h3
         M0oae+qVaUgUfQgH5pkocMewCyCD1XdOmSDhZoy9L4hnlqXaettbGZlPkuxLyGwXwm/q
         TOqWuxKrIq2vIGiwnfhFvRwNa9zrUEGI7aWY1W5j0BHkQbv2r/yflRdEhZEgfHJWfoSu
         NfyzVusDE5WS+eGMd8YQXvtf9C37Rwo0Ac7c+CQnExqwVDj4Z+ULiLo/Ztp0Td7S9Dm0
         cbgQ==
X-Gm-Message-State: APjAAAURa40AeY3w6fY7fwEulHtFYvTZc4keyQir1Tz7jqdzGOiwosZP
        2MLTMPuDyD8JJYhC7zMkRlMrXg==
X-Google-Smtp-Source: APXvYqwaCdgb8eu9Am1caa4M2y+wqIqY9REfCbtCEZzaZ1jIb6FyhqTCtJvokw9mC25yz2jrZkQBjw==
X-Received: by 2002:adf:cf0d:: with SMTP id o13mr35293776wrj.291.1563895896688;
        Tue, 23 Jul 2019 08:31:36 -0700 (PDT)
Received: from orion.maiolino.org (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id r11sm53511047wre.14.2019.07.23.08.31.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 08:31:35 -0700 (PDT)
Date:   Tue, 23 Jul 2019 17:31:33 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, jlayton@kernel.org
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
Message-ID: <20190723153133.wqt3p3dqaghxbkpr@orion.maiolino.org>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, jlayton@kernel.org
References: <20190723150017.31891-1-cmaiolino@redhat.com>
 <20190723151102.GA1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723151102.GA1561054@magnolia>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 08:11:02AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 23, 2019 at 05:00:17PM +0200, Carlos Maiolino wrote:
> > xfs_extent_busy_clear_one() calls kmem_free() with the pag spinlock
> > locked.
> 

CC'ing Jeff so he can maybe chime in too.


> Er, what problem does this solve?  Does holding on to the pag spinlock
> too long while memory freeing causes everything else to stall?  When is
> memory freeing slow enough to cause a noticeable impact?

Jeff detected it when using this patch:

https://marc.info/?l=linux-mm&m=156388753722881&w=2

At first I don't see any specific problem, but I don't think we are supposed to
use kmem_free() inside interrupt context anyway. So, even though there is no
visible side effect, it should be fixed IMHO. With the patch above, the side
effect is a bunch of warnings :P

> 
> > Fix this by adding a new temporary list, and, make
> > xfs_extent_busy_clear_one() to move the extent_busy items to this new
> > list, instead of freeing them.
> > 
> > Free the objects in the temporary list after we drop the pagb_lock
> > 
> > Reported-by: Jeff Layton <jlayton@kernel.org>
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/xfs_extent_busy.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > index 0ed68379e551..0a7dcf03340b 100644
> > --- a/fs/xfs/xfs_extent_busy.c
> > +++ b/fs/xfs/xfs_extent_busy.c
> > @@ -523,7 +523,8 @@ STATIC void
> >  xfs_extent_busy_clear_one(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_perag	*pag,
> > -	struct xfs_extent_busy	*busyp)
> > +	struct xfs_extent_busy	*busyp,
> > +	struct list_head	*list)
> >  {
> >  	if (busyp->length) {
> >  		trace_xfs_extent_busy_clear(mp, busyp->agno, busyp->bno,
> > @@ -531,8 +532,7 @@ xfs_extent_busy_clear_one(
> >  		rb_erase(&busyp->rb_node, &pag->pagb_tree);
> >  	}
> >  
> > -	list_del_init(&busyp->list);
> > -	kmem_free(busyp);
> > +	list_move(&busyp->list, list);
> >  }
> >  
> >  static void
> > @@ -565,6 +565,7 @@ xfs_extent_busy_clear(
> >  	struct xfs_perag	*pag = NULL;
> >  	xfs_agnumber_t		agno = NULLAGNUMBER;
> >  	bool			wakeup = false;
> > +	LIST_HEAD(busy_list);
> >  
> >  	list_for_each_entry_safe(busyp, n, list, list) {
> >  		if (busyp->agno != agno) {
> > @@ -580,13 +581,18 @@ xfs_extent_busy_clear(
> >  		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
> >  			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
> >  		} else {
> > -			xfs_extent_busy_clear_one(mp, pag, busyp);
> > +			xfs_extent_busy_clear_one(mp, pag, busyp, &busy_list);
> 
> ...and why not just put the busyp on the busy_list here so you don't
> have to pass the list_head pointer around?

Just left it inside _clear_one to keep manipulation of busyp in a single place.
We already remove it from the rb tree there, so, remove it from the extent
busy list also there, just looked clear to do all the cleanup in the same place.

> 
> --D
> 
> >  			wakeup = true;
> >  		}
> >  	}
> >  
> >  	if (pag)
> >  		xfs_extent_busy_put_pag(pag, wakeup);
> > +
> > +	list_for_each_entry_safe(busyp, n, &busy_list, list) {
> > +		list_del_init(&busyp->list);
> > +		kmem_free(busyp);
> > +	}
> >  }
> >  
> >  /*
> > -- 
> > 2.20.1
> > 

-- 
Carlos
