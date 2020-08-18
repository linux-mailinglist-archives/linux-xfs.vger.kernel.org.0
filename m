Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D672487EB
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Aug 2020 16:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgHROkw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Aug 2020 10:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbgHROkv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:40:51 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5F9C061342
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:40:51 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id z3so17818125ilh.3
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6MYPfJCpyvGDvlQrubm3ry1QQ8GwjeDHIF5TE20zLYo=;
        b=c8sXilVNcMhS0Nn6S2ifgkGljWC5FyZzXB5OIkqDBbSE/zhQFhgOySNJ23xzLw8D9Z
         XXVk15KGKOkTrVG5Dnczz49WXPv8VfSaskgFwvKKkL+pucq8jHvpEZl5sOxY6o6YMSmw
         lFqLF3hfYQ6b+YxdRQvRweQSsaAoUS4YQFyPEzw4vXcDzeeABwNkOLH+bYOaqHOVTLjJ
         k3iKRvkxjOctFInsjmjnPHyfaQB96FE/F4R9F4bZsclqzf9su3M5IDYuM9D/U42V+hbg
         Lpc1gR3JK5C0khs9sK5WbctGS76L50ZDL1yt9hEl3hPwpN4/a5GuDlXpIY/6PCvlwvqA
         cCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6MYPfJCpyvGDvlQrubm3ry1QQ8GwjeDHIF5TE20zLYo=;
        b=Azoum9Grj8AE6h4crgEvVPF7wvx2ppoufJRywqxA1wpOXrc2SI+KNdb0KQ7Bc1gOxi
         K33NoyWsco3sDjr5VMZVAp9BGJ1435oVZWNhpfTuBurounuzmu+vg1/xqGpvawTbx501
         18VpEi41JrwfEDCCAVCe/PW/cFwKpxCwnNc6vr1yxr3b8/Csjv4BYzvWHazw5QpesDpI
         V7SBscV/9pfpmnOymRg+7Uk4bfzzHOhodZAq2dumO18S5mf/e+puitD0v1qj34eGe5t1
         4QUUlKx0dv4zUPrXH2SW4gQKanoiOc2kmdXHakx815QmBhxhkEW3m6j8dfR8Tig6ywWb
         dKCg==
X-Gm-Message-State: AOAM531TUp0Vu3hQLeG9gCUhHaO4lmnnkP0bp7TmYku6ONj9wMkHL3RI
        54MMRvm/HixBmr+0KRN89pEcJG8Rly2bgxfoWjA=
X-Google-Smtp-Source: ABdhPJwQTJhaRDPJp0Zun+ZqPNzf8q8AJABRM5qVNwqF/t/6XMc7W7Zr3YeuD6uZBycgQOI+U5PDCKVot6dR4rtcWWw=
X-Received: by 2002:a92:da0a:: with SMTP id z10mr17957049ilm.275.1597761650608;
 Tue, 18 Aug 2020 07:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770519622.3958786.16858432845716831168.stgit@magnolia>
In-Reply-To: <159770519622.3958786.16858432845716831168.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:40:39 +0300
Message-ID: <CAOQ4uxiDBY22-H+jr6mYCNTDUqvcBD42T-V9GfRunS=ZU_7Eqg@mail.gmail.com>
Subject: Re: [PATCH 10/18] xfs: widen ondisk timestamps to deal with y2038 problem
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 2:24 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
> nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
> time epoch).  This enables us to handle dates up to 2486, which solves
> the y2038 problem.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Changes look ok. Cannot say myself if other changes are missing.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
