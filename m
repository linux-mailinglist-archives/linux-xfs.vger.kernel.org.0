Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9AD267C98
	for <lists+linux-xfs@lfdr.de>; Sun, 14 Jul 2019 03:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbfGNBRv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 13 Jul 2019 21:17:51 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:43340 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbfGNBRu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Jul 2019 21:17:50 -0400
Received: by mail-lf1-f54.google.com with SMTP id c19so8736104lfm.10
        for <linux-xfs@vger.kernel.org>; Sat, 13 Jul 2019 18:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f/ZbMKpaeDfR0c6CluIR2RGEThcJc265Nfb8zCnn6MQ=;
        b=JFAS9tE4paeCtL/HDO7+w783I/1T0SiLhmNcOpTVr2Heh5JE7iPzUXsY4VP8KwcaKM
         vJSrnpHsO4JGdgNhGCw7jHJlrdrLuxe4RT9O3WBDvxWv1nJ1lG1Jl8Vaz51tC0c8rjCR
         ewi9P8bFkO1yo+gtxWxrpgluzYMFNaW7/h1r8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f/ZbMKpaeDfR0c6CluIR2RGEThcJc265Nfb8zCnn6MQ=;
        b=mMofd7dekA0AfEzvV8Nn1rT0jl81ittx59u2K0FR/0d584742nie6NvfF0CKGiJ8D1
         JZX9LPAr3jmPuL6Kbe/eSC1rHPw5V8ix/DcH1NlX0mOKu7HpXUjMkqqMIr4fyaJd/Szm
         rYufuB5ISeKBukroIyjvTHSG9RUIlz7t+N6UWlsMk2NsYqr3WUs2bi0MwrQxEQlWFPhL
         A1luPEY0miYB4B+SeS5NRYafrSV1DNyeVZqYVjHF3gq9tAFQm8u1gDxb91r2GQIt2W4v
         GcegGrQBauWYgVpi+hk5yOnbJHlynFsv+M5HnltHJgT7zUiQpIvfrrvCEXj5osMIfM3K
         iYLA==
X-Gm-Message-State: APjAAAUf8FtqJoJAbVn3i/jxwN38HX+XTTP73AA7NHKTL0C4B8a+pPlw
        zf/0iSp9zbZemzJDOpTyquaGLHPI4Oc=
X-Google-Smtp-Source: APXvYqz5JWTlBc94hIHDqrqxbxriaTRXX3qPl0Hy//k7IDOoW0vKKYl5/P/bxaYEOgxo9oky86C0BQ==
X-Received: by 2002:a19:6b0e:: with SMTP id d14mr7888584lfa.174.1563067067396;
        Sat, 13 Jul 2019 18:17:47 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id q1sm2253003ljb.87.2019.07.13.18.17.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 18:17:46 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id v24so12777962ljg.13
        for <linux-xfs@vger.kernel.org>; Sat, 13 Jul 2019 18:17:46 -0700 (PDT)
X-Received: by 2002:a2e:9ec9:: with SMTP id h9mr9461591ljk.90.1563067065731;
 Sat, 13 Jul 2019 18:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190712180205.GA5347@magnolia> <CAHk-=wiK8_nYEM2B8uvPELdUziFhp_+DqPN=cNSharQqpBZ6qg@mail.gmail.com>
 <20190713040728.GB5347@magnolia>
In-Reply-To: <20190713040728.GB5347@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 13 Jul 2019 18:17:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgEsUC1uLdYCX6rxGxRcgzKS64e3Y8h5HVLvnpGSj5pJA@mail.gmail.com>
Message-ID: <CAHk-=wgEsUC1uLdYCX6rxGxRcgzKS64e3Y8h5HVLvnpGSj5pJA@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new features for 5.3
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 12, 2019 at 9:07 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> Doh, it turns out I was merging against the same HEAD as my last two
> pull requests because I forgot to re-pull.  Sorry about that.  It's been
> too long of a week. :/

Heh, no problem, I was just surprised when my merge result didn't
match expectations.

As mentioned, it wasn't like the conflict was complicated, only unexpected.

                     Linus
