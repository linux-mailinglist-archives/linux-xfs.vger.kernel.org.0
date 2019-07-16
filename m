Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D04D6AD7B
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Jul 2019 19:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbfGPROF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 16 Jul 2019 13:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728124AbfGPROF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Jul 2019 13:14:05 -0400
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A948206C2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2019 17:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563297244;
        bh=oGXEXU1TbLdGZWmDteG4qGYQzsfwYZ+DxMt1IM0BPHs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=l9bBooi9UqS/1D9Ohu9k1COAFtY7gNvoxmUK/LMGDpkGZwoO/gFat/iAkiIyMmRbQ
         z7PzgsHGwaqEqKFl78301LaTK5TuyAwjbxG29HKKaPdOepo5TPaimOiR9vBkq+LqbX
         ZThiRDs8Hu4ck2tyXR2JzxO8s4FYLzxhVHHWr7wM=
Received: by mail-vs1-f43.google.com with SMTP id h28so14424490vsl.12
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2019 10:14:04 -0700 (PDT)
X-Gm-Message-State: APjAAAWUoGGbeDKuU9rll28SIizZIYwi5KS8q9BJmRY4nOj1I/VHhsNU
        RSQVLEABLUX9f73IB1YOhcqax/g8q9mVM21iU3g=
X-Google-Smtp-Source: APXvYqw/TPyz0KbTfebQewGSwuJTuwlkhH0svHZ6TKUuMZOgXlXb/c4GX32jH4iYSD0iADvfZFwW0xKy6ZW3l3LHOwQ=
X-Received: by 2002:a67:d81b:: with SMTP id e27mr16144310vsj.198.1563297243401;
 Tue, 16 Jul 2019 10:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com>
 <20190627155455.GA30113@42.do-not-panic.com> <CAOQ4uxgqgDAdKZDYwmf0M35M3D6Ctn25-VVj3wu5XSj_4c-WdA@mail.gmail.com>
 <20190627213520.GG19023@42.do-not-panic.com> <CAOQ4uxht-inVEjRWXtkbRPXTA9DvRNTLSPNEZ0Eh=nUhEhNO-A@mail.gmail.com>
 <20190628215051.GE30113@42.do-not-panic.com> <CAOQ4uxgU_Ad50ZJLhmfY0mGHWutNXJU1DhEkA++-Jak2PgkUcA@mail.gmail.com>
 <20190702193449.GQ19023@42.do-not-panic.com>
In-Reply-To: <20190702193449.GQ19023@42.do-not-panic.com>
From:   Luis Chamberlain <mcgrof@kernel.org>
Date:   Tue, 16 Jul 2019 10:13:49 -0700
X-Gmail-Original-Message-ID: <CAB=NE6Vtu0rKx8=ChrHE4W8o42xP5=b7Xz3q=5fmaa1MNAH9=A@mail.gmail.com>
Message-ID: <CAB=NE6Vtu0rKx8=ChrHE4W8o42xP5=b7Xz3q=5fmaa1MNAH9=A@mail.gmail.com>
Subject: Re: [backport request][stable] xfs: xfstests generic/538 failed on xfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alvin Zheng <Alvin@linux.alibaba.com>,
        gregkh <gregkh@linuxfoundation.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        "joseph.qi" <joseph.qi@linux.alibaba.com>,
        caspar <caspar@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 2, 2019 at 12:34 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> On Sat, Jun 29, 2019 at 10:41:35AM +0300, Amir Goldstein wrote:
> that'd be great. How long does your full run take?
>
> Not long, its just I wanted to also add xunit processing support onto
> oscheck as well. I'll start on that now, hopefully it'll all be done
> and tested by end of next week.

I'm now at a point where oscheck .. is looking sharp, and has xunit
processing and even an automatic way to expand our expunge list.... :)

So it will be super easy for me to test this now, in about two days
max I should have results.

  Luis
