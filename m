Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F4E2447A
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfETXlX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:41:23 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:36836 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfETXlX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:41:23 -0400
Received: by mail-ot1-f49.google.com with SMTP id c3so14678182otr.3
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 16:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vaultcloud-com-au.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qih7PWwGMd108WXsvlyA6Tmx8exMFlmymQYm5li8bis=;
        b=Yzcvq9tTTCOsvKDuDi+4il1oJVoKRxYGygwFMBdJH32yO8i3Uq2xEPoYwUpAEdl/iB
         0DEeVBXtN3htklTnSCMxYRYYUzFr+qVoZDi5orTe4sl5/5xuCZa4ja+QC++nqq3yjyxm
         4yHGdd4zHEzYTcA2O0gR8bM67QXCJfJWegTioTx/HFlg3BbUqYar1lImeXqTWLhvP3lN
         DJjugktW2wg8LNnFw2NR7DirRbZgrNbrER+FDbGFN+p7sOshY5BoXXztLWmlyIdK/EHZ
         c7Ms3dfmv04wYOHleBj4oL24DhOlqF0dPmFhImERmd6fFGAAGXCHSRj/tOKHi9XC6n7f
         SIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qih7PWwGMd108WXsvlyA6Tmx8exMFlmymQYm5li8bis=;
        b=XP4Ib7GkjZdu0+3qHuNUfI6Tj/mR8UL9w80hpUlK8tuL8vsIXGh/ANHTm1284UHc6f
         oaAaPfsPHDt8uk8cAtTKRbTx72ByVqdhBz+aK0P9Kwrre7Lw6+rdsSwlGdBEljCuJWky
         BYU9y5HeLWf/p6f5YfQhCp3Jc8aZ0WrkxB71iwMxtwBApDrnj9+3Shy3k9PexpjXmJzh
         LCqgco6Zv4r6AeJT9atcW+5Wpu1j3cP0XbqQfePsuHNpPeH/NIvN7/PwFEumzDduAWWz
         TAFiOTVhta+ftkqBTls2XfDPObqgTV6e/z/kMZ4W3ZF0UtwdohOvTyJ1Rwk7QfJyC6DT
         OkZw==
X-Gm-Message-State: APjAAAWnD4IOeSzJESi6Q4ShEWMcp3ySEItFmayNNfkIk4ptK+zJmUPT
        6i8tr+pBb9eotGnW80wNdg+ftaRcdaD5yplGMCq1i//relj+fw==
X-Google-Smtp-Source: APXvYqyX1mBANGZMBdjc13/2X+R4ffWX0jWvYqgMAlB4XVqoSxExVAEPqPLb3ZaV/m60kpey7neiW2dti+u86sD7BNM=
X-Received: by 2002:a9d:1b6d:: with SMTP id l100mr25603260otl.15.1558395683013;
 Mon, 20 May 2019 16:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
 <20190513211947.GR29573@dread.disaster.area>
In-Reply-To: <20190513211947.GR29573@dread.disaster.area>
From:   Tim Smith <tim.smith@vaultcloud.com.au>
Date:   Tue, 21 May 2019 09:41:12 +1000
Message-ID: <CAHgs-5Ufzv7NrtL-0pQzGhC3vvDmFVOyeXOW4kRKLsX7xzXf_Q@mail.gmail.com>
Subject: Re: xfs filesystem reports negative usage - reoccurring problem
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 14, 2019 at 7:19 AM Dave Chinner <david@fromorbit.com> wrote:
>   decimal        hex
>  459388955       1b61b7cb
> 4733263928      11a1fdfe8
>                 ^
>                 Single bit is wrong in the free block count.
>
> IOWs, I'd say there's single bit errors happening somewhere in your
> system. Whether it be memory corruption, machines being rowhammered,
> uncorrected storage media errors, etc I have no idea. But it seems
> suspicious that the free block count is almost exactly 0x100000000
> out....

This issue is happening on more than one host, so I'm guessing that it
might not be a RAM issue... however, all the incorrect fdblocks values
do start with a 1:

server2 /dev/sdm
fdblocks = 4674169069 (0x1169A28ED)
server3 /dev/sdad
fdblocks = 4722598181 (0x1197D2125)
server4 /dev/sdad
fdblocks = 4708207408 (0x118A18B30)
