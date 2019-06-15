Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012BF46E0B
	for <lists+linux-xfs@lfdr.de>; Sat, 15 Jun 2019 06:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbfFOEB0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 15 Jun 2019 00:01:26 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:35623 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfFOEB0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Jun 2019 00:01:26 -0400
Received: by mail-lf1-f43.google.com with SMTP id a25so3021553lfg.2
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2019 21:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LNCCQDzXq6yRFhVLoEUQSeznUefXALf/b6AvjDf5zbk=;
        b=K+NlbgNmc77iE+WvrjEBgMNlZucBcKdO/O5/nk7OZOBx6QGiPLKgW6xHqeUKR/z1/9
         zyhhdNgrB4+1BFo6Zu6tRLbi1YgVBxzcym14Fw3e1Cvu/GabpqLG0GbD6xnKbRNydIPE
         3038hUhYpnFUOgY2FK0lkFrB+J3deHeUX1FtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LNCCQDzXq6yRFhVLoEUQSeznUefXALf/b6AvjDf5zbk=;
        b=ZkwqQ1A9J2UjH8CNrPtL2GIpADpFvSLL5JRSLE0iGfMgz+py0DgyrSjwAgmXQz59oj
         DB6ihwt4Hqs9CJG2fHAAnhS867DzERGa9steKNfI7pr1xdrgGROiSGt8muDG9WHtCzcD
         sxX1kb5wqrVJsGof80ni+LSDRu9DYIEK6qZxjWiol1K4t428cRA/VGrJN+X53OQc5/J2
         qZc+9/8lNOGc2DWeFu8wfOi43w3kZrcWbXlU7JRf9Wslzldw7+j1bXblYZh3l+6d1yY4
         kf0Zuwk6ISTr+vSRumeWMHZia/GkB8DJQ2br87JLq1/kGUrUhHVgYJ99t212rgaXzrWt
         zo/A==
X-Gm-Message-State: APjAAAVKtJDxsY07L/JrKfwoMhCjvtojAhhXeDmZm/ipfVc310SNDEqe
        dVDltyx+c6cAYDA1hFr5yF1Ubg2KCwQ=
X-Google-Smtp-Source: APXvYqwZpJiY3AKZp7+E3VYzYJaOt2rCoG1s58hH/2xZhgZRbag6pQFE9BOIDLaiwq83oxA+88e2jw==
X-Received: by 2002:ac2:4ac5:: with SMTP id m5mr25533638lfp.95.1560571284440;
        Fri, 14 Jun 2019 21:01:24 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id 25sm890527ljo.38.2019.06.14.21.01.23
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 21:01:24 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id k18so4250297ljc.11
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2019 21:01:23 -0700 (PDT)
X-Received: by 2002:a2e:b003:: with SMTP id y3mr18772815ljk.72.1560571283486;
 Fri, 14 Jun 2019 21:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel> <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel> <20190612230224.GJ14308@dread.disaster.area>
 <20190613183625.GA28171@kmo-pixel> <20190613235524.GK14363@dread.disaster.area>
 <CAHk-=whMHtg62J2KDKnyOTaoLs9GxcNz1hN9QKqpxoO=0bJqdQ@mail.gmail.com>
In-Reply-To: <CAHk-=whMHtg62J2KDKnyOTaoLs9GxcNz1hN9QKqpxoO=0bJqdQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 14 Jun 2019 18:01:07 -1000
X-Gmail-Original-Message-ID: <CAHk-=wgz+7O0pdn8Wfxc5EQKNy44FTtf4LAPO1WgCidNjxbWzg@mail.gmail.com>
Message-ID: <CAHk-=wgz+7O0pdn8Wfxc5EQKNy44FTtf4LAPO1WgCidNjxbWzg@mail.gmail.com>
Subject: Re: pagecache locking (was: bcachefs status update) merged)
To:     Dave Chinner <david@fromorbit.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 5:08 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I do not believe that posix itself actually requires that at all,
> although extended standards may.

So I tried to see if I could find what this perhaps alludes to.

And I suspect it's not in the read/write thing, but the pthreads side
talks about atomicity.

Interesting, but I doubt if that's actually really intentional, since
the non-thread read/write behavior specifically seems to avoid the
whole concurrency issue.

The pthreads atomicity thing seems to be about not splitting up IO and
doing it in chunks when you have m:n threading models, but can be
(mis-)construed to have threads given higher atomicity guarantees than
processes.

               Linus
