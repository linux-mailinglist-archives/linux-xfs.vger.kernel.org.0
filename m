Return-Path: <linux-xfs+bounces-914-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB6C8816ADE
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Dec 2023 11:23:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92A57282836
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Dec 2023 10:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69CC13AF1;
	Mon, 18 Dec 2023 10:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BW2ktF+R"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F1612B92
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 10:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d3a9b9634dso179965ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 02:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702894973; x=1703499773; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XsINoeBkWViAuliJrhdixz1X42eDrzcqlZbekSi8rJY=;
        b=BW2ktF+RhkMCGlIuBQLTd/LiJaSuxIl8Q0zpgQiks81azmkKjY+E1oCtrJKJdA8Jko
         nZpSwgFn9JwZzW89IFiBCMMIO2cGBczNwSZuf/kh3B0GKYdNOqvPNOZ+2dUos+wXEGEx
         cR+qL3zhEGUS6CQyS7xnspVNCZN0jDsTlgkJxzzUO7pXQcftHhZTg4EafpDJ+4qCthrk
         ZfccHFHYuL8V7WTXScyuQHVdmJsYnDbBX4cyeT2KwehKLUS4egn9wmoq6DwyYBXuWtvk
         k/XLDQN3+mqbq0IhgC9hVCKDwKkAyZww4+k39YF2zwCYQrxJrSrEgmdcjjurx0Dw4Jl+
         N3lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702894973; x=1703499773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XsINoeBkWViAuliJrhdixz1X42eDrzcqlZbekSi8rJY=;
        b=PEjag8NcuFUm38azdaq4yfmLWwNMji98QTuyqDk68beWP9p/MIGTvQ85eJ+G8FvcX6
         njtzZD/qjeTyARRDWo+vcuSaKF+GXZQ4OvHjlPZv4hHde4y0hmvcMMBBHQu399LvZSM5
         Ix+rccL2QEH5rYpsqqJn7qNa4jW8l7DfgYsYv2b/SVjhPLEgYDA/ddIRZ2/4lA/1lX8c
         Ta+EBKjspYZSdB+XCexjliujrw9BvB7FqQ+X7jA7Ms6phh1L2QxQU8BrWCdJJxg0LHH2
         A3WynnnF5W8G/a1tYz5tk5Nxr9yz6nQPVlSD9q4Yk/xBq0pedLaOp+cFwr45Vb1eaMxT
         DMdw==
X-Gm-Message-State: AOJu0YxUlFJIGwwHyCzo8WlAgfIufsUA2DJhQfLRG9LNkqlhubW9mJ88
	uTsvxuLqxgyrh33TubcVZ9Ql2cScNqCKvU42Dos1MjzeCEUR
X-Google-Smtp-Source: AGHT+IEqgTaLWJs/H23ic01NPxJ+nUivzssnIVroJq03aHwX6HoLLFRcwMEG/fmsAFGsJJ6GUIMZ+dK8dx8RfQ1NgxY=
X-Received: by 2002:a17:902:ea0e:b0:1d3:b941:6b7 with SMTP id
 s14-20020a170902ea0e00b001d3b94106b7mr108364plg.23.1702894972479; Mon, 18 Dec
 2023 02:22:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000f66a3005fa578223@google.com> <20231213104950.1587730-1-glider@google.com>
 <ZXofF2lXuIUvKi/c@rh> <ZXopGGh/YqNIdtMJ@dread.disaster.area>
 <CAG_fn=UukAf5sPrwqQtmL7-_dyUs3neBpa75JAaeACUzXsHwOA@mail.gmail.com>
 <ZXt2BklghFSmDbhg@dread.disaster.area> <CAG_fn=VqSEyt+vwZ7viviiJtipPPYyzEhkuDjdnmRcW-UXZkYg@mail.gmail.com>
 <ZXzMU9DQ7JqeYwvb@dread.disaster.area>
In-Reply-To: <ZXzMU9DQ7JqeYwvb@dread.disaster.area>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 18 Dec 2023 11:22:40 +0100
Message-ID: <CANp29Y5XPoH3tdZ_ZEJK3oUZnFf5awQn1w3E95YJFJ-wPxQQ4g@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in __crc32c_le_base (3)
To: Dave Chinner <david@fromorbit.com>
Cc: Alexander Potapenko <glider@google.com>, Dave Chinner <dchinner@redhat.com>, 
	syzbot+a6d6b8fffa294705dbd8@syzkaller.appspotmail.com, hch@lst.de, 
	davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dave,

> KMSAN has been used for quite a long time with syzbot, however,
> and it's supposed to find these problems, too. Yet it's only been
> finding this for 6 months?

As Alex already mentioned, there were big fs fuzzing improvements in
2022, and that's exactly when we started seeing "KMSAN: uninit-value
in __crc32c_le_base" (I've just checked crash history). Before that
moment the code was likely just not exercised on syzbot.

On Fri, Dec 15, 2023 at 10:59=E2=80=AFPM 'Dave Chinner' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> On Fri, Dec 15, 2023 at 03:41:49PM +0100, Alexander Potapenko wrote:
> >
> > You are right, syzbot used to mount XFS way before 2022.
> > On the other hand, last fall there were some major changes to the way
> > syz_mount_image() works, so I am attributing the newly detected bugs
> > to those changes.
>
> Oh, so that's when syzbot first turned on XFS V5 format testing?
>
> Or was that done in April, when this issue was first reported?
>
> > Unfortunately we don't have much insight into reasons behind syzkaller
> > being able to trigger one bug or another: once a bug is found for the
> > first time, the likelihood to trigger it again increases, but finding
> > it initially might be tricky.
> >
> > I don't understand much how trivial is the repro at
> > https://gist.github.com/xrivendell7/c7bb6ddde87a892818ed1ce206a429c4,
>
> I just looked at it - all it does is create a new file. It's
> effectively "mount; touch", which is exactly what I said earlier
> in the thread should reproduce this issue every single time.
>
> > but overall we are not drilling deep enough into XFS.
> > https://storage.googleapis.com/syzbot-assets/8547e3dd1cca/ci-upstream-k=
msan-gce-c7402612.html
> > (ouch, 230Mb!) shows very limited coverage.
>
> *sigh*
>
> Did you think to look at the coverage results to check why the
> numbers for XFS, ext4 and btrfs are all at 1%?

Hmmm, thanks for pointing it out!

Our ci-upstream-kmsan-gce instance is configured in such a way that
the fuzzer program is quite restricted in what it can do. Apparently,
it also lacks capabilities to do mounts, so we get almost no coverage
in fs/*/**. I'll check whether the lack of permissions to mount() was
intended.

On the other hand, the ci-upstream-kmsan-gce-386 instance does not
have such restrictions at all and we do see fs/ coverage there:
https://storage.googleapis.com/syzbot-assets/609dc759f08b/ci-upstream-kmsan=
-gce-386-0e389834.html

It's still quite low for fs/xfs, which is explainable -- we almost
immediately hit "KMSAN: uninit-value in __crc32c_le_base". For the
same reason, it's also somewhat lower than could be elsewhere as well
-- we spend too much time restarting VMs after crashes. Once the fix
patch reaches the fuzzed kernel tree, ci-upstream-kmsan-gce-386 should
be back to normal.

If we want to see how deep syzbot can go into the fs/ code in general,
it's better to look at the KASAN instance coverage:
https://storage.googleapis.com/syzbot-assets/12b7d6ca74e6/ci-upstream-kasan=
-gce-root-0e389834.html
 (*)

Here e.g. fs/ext4 is already 63% and fs/xfs is 16%.

(*) Be careful, the file is very big.

--=20
Aleksandr

> Why didn't the low
> number make you dig a bit deeper to see if the number was real or
> whether there was a test execution problem during measurement?
>
> I just spent a minute doing exactly that, and the answer is
> pretty obvious. Both ext4 and XFS had a mount attempts
> rejected at mount option parsing, and btrfs rejected a device scan
> ioctl. That's it. Nothing else was exercised in those three
> filesystems.
>
> Put simply: the filesystems *weren't tested during coverage
> measurement*.
>
> If you are going to do coverage testing, please measure coverage
> over *thousands* of different tests performed on a single filesystem
> type. It needs to be thousands, because syzbot tests are so shallow
> and narrow that actually covering any significant amount of
> filesystem code is quite difficult....
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> --

