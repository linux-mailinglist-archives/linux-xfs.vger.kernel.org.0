Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696A324D8A1
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Aug 2020 17:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgHUPb6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Aug 2020 11:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgHUPb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Aug 2020 11:31:56 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919E0C061573
        for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2020 08:31:56 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 62so1706005qkj.7
        for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2020 08:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0T/kzzZ2hsfqKp5P+lnPiLtuDG14AWPFf2NVSu+GIx4=;
        b=vGul4uPuk+4Ww05pZMg8GP99U/tG8KRg6NVok+qaNaBTH90zLoiHIddVsalEjPR99W
         YO67PkS7M1X6R8/B5VUwDGiKPgA2Pf0UFqUyyMMKf0vpjHzoR/JWGqGr3Pw8dZmVHb4P
         u8QNhEBM9HA8K/dOemGPIg7EjtQ9f/WIeDaJlf5cSLp9f1rMclNfAnfAs+FAkbI40ech
         upnKTc2D1Px+jGfI4KiVZRioAU7Q6Trsh1SEZlvnZZWb4orsjr3tQqUmAaD00L4cwdA+
         PVLoXDqEn88xI7gx7fiu7if/eJHRIXWFwukf0TpuoBF7J1i38O2PvfqvWTondU2MaU1w
         f7Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0T/kzzZ2hsfqKp5P+lnPiLtuDG14AWPFf2NVSu+GIx4=;
        b=elg7wSGNMaEcJFECPo0XARyPo9ULCgBtUus9a+/sfruosYGdiTS+QMHVgMc1pC2GFc
         ltJC/Fn0f6HcYceVmHTeZfEBujCMomJ2uMLj7j4+DqRxLTQPbQ1DkLYKCKZ5pyNWIOf5
         CO3L2ljGFhSCPjvuzJmWviLXXKYbU/wiyKXfXSsLocRU0gl/+SQC0PSHUHOjKfHULPKb
         zPpJAdF546ebBNCBWQkI492rW8HDv6sxtyvDfJI3CCHTsCAlpmMQL9Qf7b+PYzhtrsmG
         zWmIfL+DG56TQFaz4FBZsq0HnJXe0Hzb/PiCwfo7kuROFFORPoAn+eYSePQfEqA0yfgt
         InSA==
X-Gm-Message-State: AOAM531A5Q7cY+L0xqPnSVTyAgfzgEEwCiZHBWyLrNAZ0v2NVavBHHjL
        rBj+iXRW/eL61SMBAWH8ZN+XQ0sEwmNLAWyyPNWWZ7gXLdM=
X-Google-Smtp-Source: ABdhPJzcFpuaa88rcJvNMd3Kc5EpuKC9uxSe+vEGCjPzvuP4lgBpTnt9SSZdmrTmyLI29T/3PVYCq/w/6tKfCXONcOw=
X-Received: by 2002:a05:620a:128e:: with SMTP id w14mr3130381qki.97.1598023915782;
 Fri, 21 Aug 2020 08:31:55 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770505894.3956827.5973810026298120596.stgit@magnolia> <20200818233535.GD21744@dread.disaster.area>
 <20200819214322.GE6096@magnolia> <20200820000102.GF6096@magnolia>
 <CAH3XsHH8i4GY7TcMvLPy6F1Gs-UMaR1Kcx5BJnt=XzR42t+EqA@mail.gmail.com>
 <20200820162049.GI6096@magnolia> <CAH3XsHF=bPBvogcWTRaK8XDFF2zu5Q5Mc++FUJYb8eHY9u_zqQ@mail.gmail.com>
In-Reply-To: <CAH3XsHF=bPBvogcWTRaK8XDFF2zu5Q5Mc++FUJYb8eHY9u_zqQ@mail.gmail.com>
From:   Mike Fleetwood <mike.fleetwood@googlemail.com>
Date:   Fri, 21 Aug 2020 16:31:44 +0100
Message-ID: <CAMU1PDg0JGtJ9ggj1sZXbw8FquQ_RJSOc1otNQ2tqbdfzCt7ZQ@mail.gmail.com>
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038 problem
To:     griffin tucker <xfssxsltislti2490@griffintucker.id.au>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 21 Aug 2020 at 06:02, griffin tucker
<xfssxsltislti2490@griffintucker.id.au> wrote:
>
> thanks for taking the time to respond to my seemingly stupid questions.
>
> what about interplanetary timestamps? and during transit to the
> moon/planets when time slows?


A little bit of searching provides the answers to your questions, which
are heading off topic.

1. SR and GR time dilation effects are very small [1].
   (~0.000027 seconds per day on the ISS [2][3]).
2. It's probably UTC everywhere in the solar system by definition.
   (Fixed offset for longitudinal distribution on the surface of a
   spinning planet is a separate issue [4].  It's UTC on the ISS [5] and
   apparently NASA probes too [6]).
3. Unix time (time_t) works in UTC but with leap seconds ignored [7], so
   is not appropriate for anything important in space.
   (Imagine if every time a leap second was added GPS was off by most of
   the distance to the moon)!

[1] https://en.wikipedia.org/wiki/Time_dilation#Combined_effect_of_velocity_and_gravitational_time_dilation
[2] https://www.businessinsider.com/do-astronauts-age-slower-than-people-on-earth-2015-8?r=US&IR=T
[3] https://spaceflight.nasa.gov/station/crew/exp7/luletters/lu_letter13.html
[4] https://en.wikipedia.org/wiki/Time_zone
[5] https://en.wikipedia.org/wiki/International_Space_Station#Crew_activities
[6] https://solarsystem.nasa.gov/basics/chapter2-3/
[7] https://en.wikipedia.org/wiki/Unix_time
