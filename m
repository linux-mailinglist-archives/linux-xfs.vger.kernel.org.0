Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F9E6F363B
	for <lists+linux-xfs@lfdr.de>; Mon,  1 May 2023 20:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjEASuT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 May 2023 14:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbjEASuS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 May 2023 14:50:18 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06FF170B
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 11:50:16 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-95f4c5cb755so570657366b.0
        for <linux-xfs@vger.kernel.org>; Mon, 01 May 2023 11:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1682967015; x=1685559015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJsDytAkzpo1N72CvaRaEHpBmg/KeBVFFxmvg3mMNXA=;
        b=RG31kh6Cuw6wynQJXlRZdlHS6Sy38NOCv2IPwyN2RVan1ucfixhr/eeq6GYiC6Tb6Q
         T9mEelkOfkQK5rfL+FpivpcFRBjlw7CV7K6gIVv3qPHycIxkYQBO4lClPb3ScOzMYmtH
         4n9Ry/dlC8wf1wzePrd5W77gn70GyRXY4iU5c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682967015; x=1685559015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QJsDytAkzpo1N72CvaRaEHpBmg/KeBVFFxmvg3mMNXA=;
        b=RcMviUxeFz7OO5fciHWQdXQLa0Li52D4w7QeqZk9h82Yb4UmoxbD5sQg0I1oDhWcDV
         s8K2YMnY+ygPc6m5MZUP4NUC6wrkShZnbOvV6sl58BHvDImdn3r+FZxhYv0QWCuqUw4U
         mZhg4R99Qr2cAXLvPUBoyqujWhbPJxvnKZxtUgdmngJ/fv6ZVQCCSxPB8DK+o1+hpw2d
         2fND6/wwY5Ienc+TCK0Lfz5APBhWSb86SHSKSO1q0eBS5H/DunP6lpAyNbkgemqtRjh6
         53JjIX3ROjMIpu0C004MT8019P7/R8Cxm1EtzSPvFmW4/oVqByQ5Cc10J/b6AkzzNkSK
         rLcA==
X-Gm-Message-State: AC+VfDzSBEIz3VNoYSVg42NC5Uc7Q/kMgmiYLgBJt+G9wOlTKusvEhHa
        RwPzXb8Qp4cme7JEO/Yo14b8SSIyWsuhT8b3k28ZPA==
X-Google-Smtp-Source: ACHHUZ6RBZXIMWwJN0lLyMfekUiJ/Ws1IJ4uy0X6K0aTD9nM2cYWwE23pNi6d8C6uIqdoCks5ttkZA==
X-Received: by 2002:a17:907:368d:b0:92b:e1ff:be30 with SMTP id bi13-20020a170907368d00b0092be1ffbe30mr13039774ejc.4.1682967014729;
        Mon, 01 May 2023 11:50:14 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id tl18-20020a170907c31200b0095ed3befbedsm8080972ejc.54.2023.05.01.11.50.12
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 11:50:13 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-50bceaf07b8so393336a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 01 May 2023 11:50:12 -0700 (PDT)
X-Received: by 2002:aa7:d8cb:0:b0:50b:cff8:ff1f with SMTP id
 k11-20020aa7d8cb000000b0050bcff8ff1fmr310706eds.42.1682967012421; Mon, 01 May
 2023 11:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000de34bd05f3c6fe19@google.com> <0000000000001ec6ce05fa9a4bf7@google.com>
In-Reply-To: <0000000000001ec6ce05fa9a4bf7@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 1 May 2023 11:49:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=whWUZyiFvHpkC35DXo713GKFjqCWwY1uCs3tbMJ6QXeWg@mail.gmail.com>
Message-ID: <CAHk-=whWUZyiFvHpkC35DXo713GKFjqCWwY1uCs3tbMJ6QXeWg@mail.gmail.com>
Subject: Re: [syzbot] [xfs?] BUG: unable to handle kernel paging request in clear_user_rep_good
To:     syzbot <syzbot+401145a9a237779feb26@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@suse.de>, stable <stable@vger.kernel.org>
Cc:     almaz.alexandrovich@paragon-software.com, clm@fb.com,
        djwong@kernel.org, dsterba@suse.com, hch@infradead.org,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        ntfs3@lists.linux.dev, syzkaller-bugs@googlegroups.com,
        willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[ Added Borislav and stable people ]

On Sun, Apr 30, 2023 at 9:31=E2=80=AFPM syzbot
<syzbot+401145a9a237779feb26@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:

Indeed.

My initial reaction was "no, that didn't fix anything, it just cleaned
stuff up", but it turns out that yes, it did in fact fix a real bug in
the process.

The fix was not intentional, but the cleanup actually got rid of buggy code=
.

So here's the automatic marker for syzbot:

#syz fix: x86: don't use REP_GOOD or ERMS for user memory clearing

and the reason for the bug - in case people care - is that the old
clear_user_rep_good (which no longer exists after that commit) had the
exception entry pointing to the wrong instruction.

The buggy code did:

    .Lrep_good_bytes:
            mov %edx, %ecx
            rep stosb

and the exception entry weas

        _ASM_EXTABLE_UA(.Lrep_good_bytes, .Lrep_good_exit)

so the exception entry pointed at the register move instruction, not
at the actual "rep stosb" that does the user space store.

End result: if you had a situation where you *should* return -EFAULT,
and you triggered that "last final bytes" case, instead of the
exception handling dealing with it properly and fixing it up, you got
that kernel oops.

The bug goes back to commit 0db7058e8e23 ("x86/clear_user: Make it
faster") from about a year ago, which made it into v6.1.

It only affects old hardware that doesn't have the ERMS capability
flag, which *probably* means that it's mostly only triggerable in
virtualization (since pretty much any CPU from the last decade has
ERMS, afaik).

Borislav - opinions? This needs fixing for v6.1..v6.3, and the options are:

 (1) just fix up the exception entry. I think this is literally this
one-liner, but somebody should double-check me. I did *not* actually
test this:

    --- a/arch/x86/lib/clear_page_64.S
    +++ b/arch/x86/lib/clear_page_64.S
    @@ -142,8 +142,8 @@ SYM_FUNC_START(clear_user_rep_good)
            and $7, %edx
            jz .Lrep_good_exit

    -.Lrep_good_bytes:
            mov %edx, %ecx
    +.Lrep_good_bytes:
            rep stosb

     .Lrep_good_exit:

   because the only use of '.Lrep_good_bytes' is that exception table entry=
.

 (2) backport just that one commit for clear_user

     In this case we should probably do commit e046fe5a36a9 ("x86: set
FSRS automatically on AMD CPUs that have FSRM") too, since that commit
changes the decision to use 'rep stosb' to check FSRS.

 (3) backport the entire series of commits:

        git log --oneline v6.3..034ff37d3407

Or we could even revert that commit 0db7058e8e23, but it seems silly
to revert when we have so many ways to fix it, including a one-line
code movement.

Borislav / stable people? Opinions?

                         Linus
