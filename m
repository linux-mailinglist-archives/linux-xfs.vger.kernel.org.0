Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4211072B5D1
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Jun 2023 05:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjFLDPZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 11 Jun 2023 23:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbjFLDO7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Jun 2023 23:14:59 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAAFE74
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 20:14:46 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-97460240863so640245166b.0
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 20:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1686539684; x=1689131684;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gGHjfKWs/8J2QTgYgScVsY4FNyh0rb7YtJFbRyvfLSg=;
        b=Ar5p683T7l0KXRGWfSmBW3jdgDtXI4LveJyfhgWfaVMN+nqNydPbWfq5tQchPRy/Dk
         x2Hw/9xG0wsfivJWIQVtBDWl4KQN2CljKDoc9KQCjwGM/RGPYwR+lDlBaPnzbcjK2uhe
         sOnqWcNQ8Fh4ZLbaXdJP775EJ1SJG7hO/eFB8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686539684; x=1689131684;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gGHjfKWs/8J2QTgYgScVsY4FNyh0rb7YtJFbRyvfLSg=;
        b=Evu1UMZUxTWbT/BqUwUa0lG5uUHrYapansooRpGK+nAXPDWUXtTGXfD2lDWfEA6I4u
         zxnCJc1tjMUCW91AO+BNCO6fG/HBLr2FP9Y9RLV59QEbxY2YHS6DYedcW90AL9KryYM5
         9aXoveMnuxpxbZXwdzV1bflWn3nWXq4x7NbCBSqfjr2+wAO1BlTm/Qg8PtHtANapsU8U
         efgxVHJzhUv/BRsYtPKiRwcaEnIufoiZMur0aW10d9PB1qJK0zcibMTWCOqJOln+h3vK
         o+ntzisMt0ykYG6jbS5jYo/TjQ/N34fsDEnltkqnLp+kgyVdlnizsfBTmTvTO3Zy8N6l
         e6Mg==
X-Gm-Message-State: AC+VfDyef/hjLUeNcy/SJY1TC1t33I4LO18bA3UUbYJM2N6ZezXu18Nh
        N7MavaM/an7864xeKR+rMRePtXGte01fHp3eoZ1L9g==
X-Google-Smtp-Source: ACHHUZ6TrotU6LyiIQK/wdVaBfDghxr+2/U5iLnDoQl+IOuTJzwi8HYBEaMNyCWN+QQcF3QkPLAwFA==
X-Received: by 2002:a17:907:162a:b0:97e:ab93:b248 with SMTP id hb42-20020a170907162a00b0097eab93b248mr3975102ejc.47.1686539684421;
        Sun, 11 Jun 2023 20:14:44 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id w12-20020a17090633cc00b00965f31ff894sm4493887eja.137.2023.06.11.20.14.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jun 2023 20:14:42 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-97467e06511so637435766b.2
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 20:14:42 -0700 (PDT)
X-Received: by 2002:a17:907:1c05:b0:973:daa0:2f6 with SMTP id
 nc5-20020a1709071c0500b00973daa002f6mr8779707ejc.3.1686539681866; Sun, 11 Jun
 2023 20:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
 <ZIZSPyzReZkGBEFy@dread.disaster.area> <20230612015145.GA11441@frogsfrogsfrogs>
 <ZIaBQnCKJ6NsqGhd@dread.disaster.area>
In-Reply-To: <ZIaBQnCKJ6NsqGhd@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 11 Jun 2023 20:14:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
Message-ID: <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000a3907605fde61ee1"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--000000000000a3907605fde61ee1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 11, 2023 at 7:22=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> I guess the regression fix needs a regression fix....

Yup.

From the description of the problem, it sounds like this happens on
real hardware, no vhost anywhere?

Or maybe Darrick (who doesn't see the issue) is running on raw
hardware, and you and Zorro are running in a virtual environment?

It sounds like zap_other_threads() and coredump_task_exit() do not
agree about the core_state->nr_threads counting, which is part of what
changed there.

[ Goes off to look ]

Hmm. Both seem to be using the same test for

    (t->flags & (PF_IO_WORKER | PF_USER_WORKER)) !=3D PF_USER_WORKER

which I don't love - I don't think io_uring threads should participate
in core dumping either, so I think the test could just be

    (t->flags & PF_IO_WORKER)

but that shouldn't be the issue here.

But according to

  https://lore.kernel.org/all/20230611124836.whfktwaumnefm5z5@zlang-mailbox=
/

it's clearly hanging in wait_for_completion_state() in
coredump_wait(), so it really looks like some confusion about that
core_waiters (aka core_state->nr_threads) count.

Oh. Humm. Mike changed that initial rough patch of mine, and I had
moved the "if you don't participate in c ore dumps" test up also past
the "do_coredump()" logic.

And I think it's horribly *wrong* for a thread that doesn't get
counted for core-dumping to go into do_coredump(), because then it
will set the "core_state" to possibly be the core-state of the vhost
thread that isn't even counted.

So *maybe* this attached patch might fix it? I haven't thought very
deeply about this, but vhost workers most definitely shouldn't call
do_coredump(), since they are then not counted.

(And again, I think we should just check that PF_IO_WORKER bit, not
use this more complex test, but that's a separate and bigger change).

              Linus

--000000000000a3907605fde61ee1
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_lisa5jh60>
X-Attachment-Id: f_lisa5jh60

IGtlcm5lbC9zaWduYWwuYyB8IDQgKysrKwogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygr
KQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9zaWduYWwuYyBiL2tlcm5lbC9zaWduYWwuYwppbmRleCAy
NTQ3ZmE3M2JkZTUuLmExZTExZWU4NTM3YyAxMDA2NDQKLS0tIGEva2VybmVsL3NpZ25hbC5jCisr
KyBiL2tlcm5lbC9zaWduYWwuYwpAQCAtMjg0Nyw2ICsyODQ3LDEwIEBAIGJvb2wgZ2V0X3NpZ25h
bChzdHJ1Y3Qga3NpZ25hbCAqa3NpZykKIAkJICovCiAJCWN1cnJlbnQtPmZsYWdzIHw9IFBGX1NJ
R05BTEVEOwogCisJCS8qIHZob3N0IHdvcmtlcnMgZG9uJ3QgcGFydGljaXBhdGUgaW4gY29yZSBk
dXBzICovCisJCWlmICgoY3VycmVudC0+ZmxhZ3MgJiAoUEZfSU9fV09SS0VSIHwgUEZfVVNFUl9X
T1JLRVIpKSAhPSBQRl9VU0VSX1dPUktFUikKKwkJCWdvdG8gb3V0OworCiAJCWlmIChzaWdfa2Vy
bmVsX2NvcmVkdW1wKHNpZ25yKSkgewogCQkJaWYgKHByaW50X2ZhdGFsX3NpZ25hbHMpCiAJCQkJ
cHJpbnRfZmF0YWxfc2lnbmFsKGtzaWctPmluZm8uc2lfc2lnbm8pOwo=
--000000000000a3907605fde61ee1--
