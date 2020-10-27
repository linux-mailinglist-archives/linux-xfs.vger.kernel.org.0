Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF86E29C818
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Oct 2020 20:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829223AbgJ0TBa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Oct 2020 15:01:30 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41940 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371435AbgJ0TB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:01:28 -0400
Received: by mail-oi1-f194.google.com with SMTP id k65so2389165oih.8
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2020 12:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M/ppSbcOSIkyb0WLxSLtuLH+l8WQbDgVdPBCEGLhzkg=;
        b=ITgfknbVMZfp35lpmLI31j4Nz1iCLqIjRADmmwWUK5/lEwTGJCtZuIg7KxFWy7ItTQ
         hfI9rUKmuyCzK+NN6zramPdeJQr3T/y85wtC502Wh1aA+EVeb5zEhSA9pSEyllBQ0ubV
         93+c6QQRkdWNThoyRK6g0NvSsnUYPyNsOg5A0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M/ppSbcOSIkyb0WLxSLtuLH+l8WQbDgVdPBCEGLhzkg=;
        b=pf8MCVJkT9t0xCRxgqm7SoL/UMpBmcbLiS7PGM//Qd2mFqYFbDZorYYqFq1HZDqH+t
         OOPZpxGdsGyfI9AGksWhk8nOR5caBOe9jftjd5zKk50xVCUjOHZpoU7QxujEtUa6lKx9
         UcN0qoyuTcNlXOO7VPCV4oWgk3aepXOwTeax1HRj+K/gEUCNz8wczYke3bIJJowc+MKo
         6iTMgjoC9qbl0LNi3q77iYqCH1SXgeZfS/1nW7u6fWNLUmpS5uLZ8B13FqiAE4MdvmU9
         41QLYAph+7jvH1Epg2aHUpRnz9TgPBomYO17KfLHbE92h18f+IFW6EP1boHG8BxEYmvn
         9DVQ==
X-Gm-Message-State: AOAM530aQ68HHapVSqEka+gE4sHVZBGZnr/Pr29gM8prHU+y7ILWumeo
        ENLLrL/KLUfvKI3x++5Qep/rV2XX53/8z4JTrQ0TTA==
X-Google-Smtp-Source: ABdhPJwHcWbTJCbJ7AAyjVib0AGCCVAs4xDrwxrSwOfpPtT8albuTTgqSli8X5JVplvyhTsqPY2DxlaYLA/ZcsBiLvA=
X-Received: by 2002:aca:39d6:: with SMTP id g205mr2530848oia.14.1603825286633;
 Tue, 27 Oct 2020 12:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201021163242.1458885-1-daniel.vetter@ffwll.ch>
 <20201023122216.2373294-1-daniel.vetter@ffwll.ch> <20201023122216.2373294-3-daniel.vetter@ffwll.ch>
 <20201027185100.GD12824@infradead.org>
In-Reply-To: <20201027185100.GD12824@infradead.org>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 27 Oct 2020 20:01:15 +0100
Message-ID: <CAKMK7uERSRmJ+E03SWsXcjVEbg24pzbVcXf7dpCvcR1JvnTcnA@mail.gmail.com>
Subject: Re: [PATCH 03/65] mm: Track mmu notifiers in fs_reclaim_acquire/release
To:     Christoph Hellwig <hch@infradead.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Qian Cai <cai@lca.pw>, linux-xfs@vger.kernel.org,
        "Thomas Hellstr??m" <thomas_os@shipmail.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Linux MM <linux-mm@kvack.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        "Christian K??nig" <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 7:51 PM Christoph Hellwig <hch@infradead.org> wrote:
> Is there a list that has the cover letter and the whole series?
> I've only found fragments (and mostly the same fragments) while
> wading through my backlog in various list folders..

Typoed git send-email command that I only caught half-way through. I
tried to reply with apologies in a few spots, I guess I didn't cover
all the lists this spams :-/

The patch itself is still somewhere on my todo to respin, I want to
pep it up with some testcases since previous version was kinda badly
broken. Just didn't get around to that yet.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
