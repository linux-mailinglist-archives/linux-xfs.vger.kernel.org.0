Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9C42BB17C
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Nov 2020 18:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgKTRbx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Nov 2020 12:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728634AbgKTRbx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Nov 2020 12:31:53 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FB5C0617A7
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 09:31:53 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id l206so11224040oif.12
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 09:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8e4wI0bZkx7vL4ZNjNtbjWVMpWuuSKoV5XC8ZjlhW7s=;
        b=HccBEp+o8ETH4Up44ZRai+3YCDp9ZccG/73PRJf6l8P+2CSniNIKgzDRc27ybuIOvR
         IIsOfywoVBFSGx1Qv7sDxfm4sSmrQlSiigm0wYSweoIK2JSHh+CJnJrDkOciZn38yhj0
         aSga/Z7C/8a9/MwtRVQ0bNGZZBwYGOLWIM6AA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8e4wI0bZkx7vL4ZNjNtbjWVMpWuuSKoV5XC8ZjlhW7s=;
        b=TnI57hIuLARVn/SwKwqbJYPb8glviRbCD5M2ELr5YAaA0tA7uP0SiQsQ1roDtVliDU
         tzLNccGWYmf2Ba/SDQhNGE6YwI0x7ewi5/Yvtd/kmpUSczgSbR5u5CPqb++IDRRZcjcD
         fLUyU6MZBqvYKvvV44ulmOzS88epPvGMHtgvCdu3G4sYDZhnSAv7dJjqSMHwBuBcmoQ0
         GYDBQAapw1YQvPspzzXXiluhS1eA6z7T9Eb1bIBod4qp/1hTyogKXAKhJciaQA3vS5CV
         fttkdSem5SwLtA78Bxl4PhXdQRuI4I62tQC5/4aTJBNce0QwhcbOxAtrI0xEbWUDqY3F
         RKvQ==
X-Gm-Message-State: AOAM530CLt/LWE6c04laZJM05l1jaaRH5qAMOiPiQeS6vzeaAMFfZP35
        Lcyl3+3ZfkRrIUV6+Zs1h1h1n7fKBfqMOqfJpvkfajKyEtg=
X-Google-Smtp-Source: ABdhPJx/L8V6caZCi2etf09pugpqxuriDzOj95Aq3JU3B7KOKGDyXyFPWC3ezSK49DgmKXY+U4gQxivRIffbahFPXew=
X-Received: by 2002:aca:1713:: with SMTP id j19mr6618133oii.101.1605893512499;
 Fri, 20 Nov 2020 09:31:52 -0800 (PST)
MIME-Version: 1.0
References: <20201120095445.1195585-1-daniel.vetter@ffwll.ch>
 <20201120095445.1195585-3-daniel.vetter@ffwll.ch> <bfe3b1a4-9cc0-358f-a62e-b6d9a68e735a@infradead.org>
In-Reply-To: <bfe3b1a4-9cc0-358f-a62e-b6d9a68e735a@infradead.org>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri, 20 Nov 2020 18:31:41 +0100
Message-ID: <CAKMK7uH1NAU1KLNzeYeB=Ri9S8A9UGcHSufh5iCtwUoTChvP2A@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: Extract might_alloc() debug check
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Linux MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        Waiman Long <longman@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 20, 2020 at 6:20 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Hi,
>
> On 11/20/20 1:54 AM, Daniel Vetter wrote:
> > diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> > index d5ece7a9a403..f94405d43fd1 100644
> > --- a/include/linux/sched/mm.h
> > +++ b/include/linux/sched/mm.h
> > @@ -180,6 +180,22 @@ static inline void fs_reclaim_acquire(gfp_t gfp_mask) { }
> >  static inline void fs_reclaim_release(gfp_t gfp_mask) { }
> >  #endif
> >
> > +/**
> > + * might_alloc - Marks possible allocation sites
>
>                     Mark
>
> > + * @gfp_mask: gfp_t flags that would be use to allocate
>
>                                            used
>
> > + *
> > + * Similar to might_sleep() and other annotations this can be used in functions
>
>                                          annotations,
>
> > + * that might allocate, but often dont. Compiles to nothing without
>
>                                      don't.
>
> > + * CONFIG_LOCKDEP. Includes a conditional might_sleep() if @gfp allows blocking.
>
> ?                                            might_sleep_if() if

That's one if too many, I'll do the others for next round. Thanks for
taking a look.
-Daniel

>
> > + */
> > +static inline void might_alloc(gfp_t gfp_mask)
> > +{
> > +     fs_reclaim_acquire(gfp_mask);
> > +     fs_reclaim_release(gfp_mask);
> > +
> > +     might_sleep_if(gfpflags_allow_blocking(gfp_mask));
> > +}
>
>
> --
> ~Randy
>


-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
