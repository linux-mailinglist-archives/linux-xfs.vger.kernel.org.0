Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA1D28C50
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 23:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387725AbfEWV0E (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 17:26:04 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45167 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387521AbfEWV0E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 17:26:04 -0400
Received: by mail-lj1-f196.google.com with SMTP id r76so1355151lja.12
        for <linux-xfs@vger.kernel.org>; Thu, 23 May 2019 14:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zDS3Ns71UvqAxo/Ziy/UlngEZ1rvpeIhNyX6PGvAAp8=;
        b=H4gjzqmptwunXRqYKn250eOT7ZJCydxukVmu4abj4LD8/gbMEVOPhuM7deCH1oNhln
         IhAnoulFRb3ISTB2HVOGL4lwyjS9ysrUvrNhplgIj/dCVrMGGG7bNKPjDw5bsLNtt6oh
         ZXbn+4T7bsuWw2xhN1jJiH7ToSUE6NWp3vTNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zDS3Ns71UvqAxo/Ziy/UlngEZ1rvpeIhNyX6PGvAAp8=;
        b=nIhu7Nm4a6SE+vZF3ZsfnUVOPER6EppeAISZZYy4EsY/zFflIplt3rBjeG9ArniEG5
         HA1EEZSWllpAsxPrXIEYPFq18/aPMFEZrSf9n3KWe8kezDBDeDGCwC102B27GVLnqgDA
         +Vkrzj8MFFGIa3CinKYa8DP3ZiX4ILa2Xi/ItA/kmaHet80Ps6tbluTV9WgD2pCo+EYI
         VnbsrrxQtIc34xmG9OSCBU6G3zaolUBz/ncV7L10tPmBzvVnapUAGhVVgRl3QoHQj5ST
         Mg5+MKKWVIdeH8QYmIhD9V1Ucutfh9MDXopmpvgRp2iStRTBLa2PF4aUhdB5tGk5QuRT
         +Fig==
X-Gm-Message-State: APjAAAUCAbEXdjEUpyYbGTJpsS4R28z+99MqQIf28VlafNhcAW6aE1wZ
        hdT0p45tFJwNpjvlV8tBN5HAYp80Nhg=
X-Google-Smtp-Source: APXvYqzVw2dWXcmp11JvFrUMIDFPeHPmiXyxhvIpgPGygMKqEZz+rLw/Rae5i1nNEWmPMRbWYep7TA==
X-Received: by 2002:a2e:90d1:: with SMTP id o17mr36743830ljg.187.1558646761779;
        Thu, 23 May 2019 14:26:01 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id g14sm146482lfb.20.2019.05.23.14.26.01
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 14:26:01 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id h11so6852216ljb.2
        for <linux-xfs@vger.kernel.org>; Thu, 23 May 2019 14:26:01 -0700 (PDT)
X-Received: by 2002:a2e:9f41:: with SMTP id v1mr12462152ljk.66.1558646380884;
 Thu, 23 May 2019 14:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190523100013.52a8d2a6@gandalf.local.home> <CAHk-=wg5HqJ2Kfgpub+tCWQ2_FiFwEW9H1Rm+an-BLGaGvDDXw@mail.gmail.com>
 <20190523112740.7167aba4@gandalf.local.home> <CAHk-=whFJqTOk0mSxJGeh38ZxDksgRaMrNV8hqTngiuokyJzew@mail.gmail.com>
 <20190523133648.591f9e78@gandalf.local.home>
In-Reply-To: <20190523133648.591f9e78@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 23 May 2019 14:19:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=whATjcpjVmTtM-MJw=XWY9kxq2xc67wA4_UkmVgF1mf2Q@mail.gmail.com>
Message-ID: <CAHk-=whATjcpjVmTtM-MJw=XWY9kxq2xc67wA4_UkmVgF1mf2Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] kernel.h: Add generic roundup_64() macro
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        nouveau@lists.freedesktop.org,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 10:36 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> >
> > Of course, you probably want the usual "at least use 'int'" semantics,
> > in which case the "type" should be "(x)+0":
> >
> >      #define round_up(x, y) size_fn((x)+0, round_up_size, x, y)
> >
> >  and the 8-bit and 16-bit cases will never be used.
>
> I'm curious to what the advantage of that is?

Let's say that you have a structure with a 'unsigned char' member,
because the value range is 0-255.

What happens if you do

   x = round_up(p->member, 4);

and the value is 255?

Now, if you stay in 'unsigned char' the end result is 0. If you follow
the usual C integer promotion rules ("all arithmetic promotes to at
least 'int'"), you get 256.

Most people probably expect 256, and that implies that even if you
pass an 'unsigned char' to an arithmetic function like this, you
expect any math to be done in 'int'. Doing the "(x)+0" forces that,
because the "+0" changes the type of the expression from "unsigned
char" to "int" due to C integer promotion.

Yes. The C integer type rules are subtle and sometimes surprising. One
of the things I've wanted is to have some way to limit silent
promotion (and silent truncation!), and cause warnings. 'sparse' does
some of that with some special-case types (ie __bitwise), but it's
pretty limited.

              Linus
