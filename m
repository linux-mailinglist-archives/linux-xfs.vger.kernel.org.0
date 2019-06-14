Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371084525C
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jun 2019 05:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfFNDIh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 23:08:37 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45879 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfFNDIh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 23:08:37 -0400
Received: by mail-lj1-f193.google.com with SMTP id m23so766738lje.12
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 20:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CJD5Oc6zmvXaVn3uGPjjPCtVx39KdSpYi2Iir9oJ4pE=;
        b=c8Dd9yVuZrGwyOECEiNIFNBaiENJ8KvhuUkTobdjyjxFioQm9x+srYpCxXeYqUlYAD
         uTex+sHSyhpFTOwrn9/TaRkbBKGIWujgB4MwCYBbZyXMUhQwCbFSkjXCppR6gW+P4o4I
         KGyDDzVlQn4xshfEF5ZvoJKHSfyRCHHZmFIHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CJD5Oc6zmvXaVn3uGPjjPCtVx39KdSpYi2Iir9oJ4pE=;
        b=tviMdyykxm79OLtpiNIqKu+m0hHFiJk/ZG4C5pdYePEwhHUCOqWDu7rrJRWgUV/FQL
         ukumqhoIA+S9u59bVumvaZhPbtthLmf5EAvvqJKC5QQBuVOGwHDo0giG25B5DZLvy1xm
         8ogCkfYtOogPqi80csFMoLHbalDep7m0MfDrzo5z6zje7KNmzue+RBjH5WEFDyzoHCUT
         oQrRjwYxVlzSRRbrDFIVrSMDgizG5rOMlvlb5uJl9mokoKWXhbYVD4W+Zq2Q7VEr/hPy
         brxiTio8Aj3cU/cN9E+rMss8/Dolc8jJgCcW+17OgkVS6XRt5u2lKKtMiLQG8O8rkTWb
         Bf5A==
X-Gm-Message-State: APjAAAVQRrE0eKNqSP89fpzChWhTedDYc+Pted76NMLglPceUMCVYvCJ
        pHbE8aG6Tt8iUXwIVRQPZTEamfLsIyc=
X-Google-Smtp-Source: APXvYqy4YhFKmptc1YNCUAtNyP7DGlRnrk7rxCV2QFr3ACCvRph3fg/bKlx3M3MADAJrBPv9uvuuTw==
X-Received: by 2002:a2e:8696:: with SMTP id l22mr25803702lji.201.1560481714862;
        Thu, 13 Jun 2019 20:08:34 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id g15sm313603ljk.83.2019.06.13.20.08.33
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:08:33 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id 131so809673ljf.4
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 20:08:33 -0700 (PDT)
X-Received: by 2002:a2e:9a58:: with SMTP id k24mr3378542ljj.165.1560481713174;
 Thu, 13 Jun 2019 20:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel> <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel> <20190612230224.GJ14308@dread.disaster.area>
 <20190613183625.GA28171@kmo-pixel> <20190613235524.GK14363@dread.disaster.area>
In-Reply-To: <20190613235524.GK14363@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 13 Jun 2019 17:08:16 -1000
X-Gmail-Original-Message-ID: <CAHk-=whMHtg62J2KDKnyOTaoLs9GxcNz1hN9QKqpxoO=0bJqdQ@mail.gmail.com>
Message-ID: <CAHk-=whMHtg62J2KDKnyOTaoLs9GxcNz1hN9QKqpxoO=0bJqdQ@mail.gmail.com>
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

On Thu, Jun 13, 2019 at 1:56 PM Dave Chinner <david@fromorbit.com> wrote:
>
> - buffered read and buffered write can run concurrently if they
> don't overlap, but right now they are serialised because that's the
> only way to provide POSIX atomic write vs read semantics (only XFS
> provides userspace with that guarantee).

I do not believe that posix itself actually requires that at all,
although extended standards may.

That said, from a quality of implementation standpoint, it's obviously
a good thing to do, so it might be worth looking at if something
reasonable can be done. The XFS atomicity guarantees are better than
what other filesystems give, but they might also not be exactly
required.

But POSIX actually ends up being pretty lax, and says

  "Writes can be serialized with respect to other reads and writes. If
a read() of file data can be proven (by any means) to occur after a
write() of the data, it must reflect that write(), even if the calls
are made by different processes. A similar requirement applies to
multiple write operations to the same file position. This is needed to
guarantee the propagation of data from write() calls to subsequent
read() calls. This requirement is particularly significant for
networked file systems, where some caching schemes violate these
semantics."

Note the "can" in "can be serialized", not "must". Also note that
whole language about how the read file data must match the written
data only if the read can be proven to have occurred after a write of
that data.  Concurrency is very much left in the air, only provably
serial operations matter.

(There is also language that talks about "after the write has
successfully returned" etc - again, it's about reads that occur
_after_ the write, not concurrently with the write).

The only atomicity guarantees are about the usual pipe writes and
PIPE_BUF. Those are very explicit.

Of course, there are lots of standards outside of just the POSIX
read/write thing, so you may be thinking of some other stricter
standard. POSIX itself has always been pretty permissive.

And as mentioned, I do agree from a QoI standpoint that atomicity is
nice, and that the XFS behavior is better. However, it does seem that
nobody really cares, because I'm not sure we've ever done it in
general (although we do have that i_rwsem, but I think it's mainly
used to give the proper lseek behavior). And so the XFS behavior may
not necessarily be *worth* it, although I presume you have some test
for this as part of xfstests.

                Linus
