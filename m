Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A7524469
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfETXgs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:36:48 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:37941 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfETXgs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:36:48 -0400
Received: by mail-oi1-f169.google.com with SMTP id u199so11372461oie.5
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 16:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vaultcloud-com-au.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lf2QdBG+poykcgyiFRkN94FknG8b4+W3f3kTs9R37uE=;
        b=Ii+RyBlEJdLqjm89QLT6xv+0O09UgwtVwzQ/P2kKfqwadL0nHoJ4v5TtoCGCvqUwy+
         tnTHNHrH3Jxi249bCN8+jFcW1IxhzlF9YToxT8+n/1fY83WdchqVtpovrCj+3BtTl+sL
         OmuC0bCMTa78gpZj+HDMRn4McItCNol+WTxldsa1CjckHCPMCQZ1KQjvsrqgV/FoWOTk
         KI6iR2XjthxNEg+aubwaM+OG9+FmsAuEUooRB+LyMuV0G38hrbwu3TCRrlNA6zwRElRW
         b30KYNG5fYpPRj77vCcEdc+k4Xi1/9Y9ATc3V/JEmbSjqoYECZaiIULLwIeKLs3CdrlP
         liwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lf2QdBG+poykcgyiFRkN94FknG8b4+W3f3kTs9R37uE=;
        b=NLSzUCYXEJao4elvc9WFEH9O597UwmBPDtR/M/wkC1kcROz4j2Rz+JvqZanu3sXuWb
         ah6cd+wN4hins8Vi82GOo/KFaZqPNN3GQL4eN74GlwsjPjjhTErtpf1SZCzuc0vu5UiH
         z1T2+u91kkhokdYsSh5DcyqvYd9iQm5ydx+WvFVdcuJKqU3Vt6cDTX2dFdbAQguJUcjY
         kGfY64AZNdtSqTDpE/Nv9D+I5P++rjgbEZsD2UGdG0E40GUdP5XQO14Dn3kyA0PgZxso
         FuchFij2ZtyphXmJR4m/bEBakXDxT34qWr8TtaGDZTepbdJ+yRRWO3y0/mjQ6FxcsKV6
         dEgw==
X-Gm-Message-State: APjAAAV1MOMtYuCglN5WJ3qZfbsCK0/c+nNsDjsm8zA+cwErwRxoBuoF
        wh5Zyt6PBZ64e9am1gD7kBjRAoBt35+BGADj1/NzoomMa194dg==
X-Google-Smtp-Source: APXvYqx4HUJxKQJ+avBAFU5fIRvAbEvY46XEEoD58nuhf4s4wJzofhLCCrPyuEx+zu+gPWzR5xB329PUEbnT08iMkR8=
X-Received: by 2002:aca:fd45:: with SMTP id b66mr1350883oii.157.1558395407849;
 Mon, 20 May 2019 16:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
 <20190513140943.GC61135@bfoster>
In-Reply-To: <20190513140943.GC61135@bfoster>
From:   Tim Smith <tim.smith@vaultcloud.com.au>
Date:   Tue, 21 May 2019 09:36:37 +1000
Message-ID: <CAHgs-5VCjUhk=ijgUmcMPJ7Gd44yH1yExGZnA5xZv4tfFBQQwQ@mail.gmail.com>
Subject: Re: xfs filesystem reports negative usage - reoccurring problem
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 14, 2019 at 12:09 AM Brian Foster <bfoster@redhat.com> wrote:
> Could you also include xfs_info and mount params of the filesystem(s) in
> question?

$ sudo mount | grep sdad
/dev/sdad on /srv/node/sdad type xfs
(rw,noatime,nodiratime,attr2,inode64,logbufs=8,noquota)

$ sudo xfs_info /srv/node/sdad
meta-data=/dev/sdad              isize=512    agcount=10, agsize=268435455 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0
data     =                       bsize=4096   blocks=2441609216, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

$ sudo xfs_info /srv/node/sdac
meta-data=/dev/sdac              isize=512    agcount=10, agsize=268435455 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0
data     =                       bsize=4096   blocks=2441609216, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

> Also, is this negative blocks used state persistent for any of these
> filesystems? IOW, if you unmount/mount, are you right back into this
> state, or does accounting start off sane and fall into this bogus state
> after a period of runtime or due to some unknown operation?

It's persistent. After umount/remount, it's still in the same state.
It seems to happen after some time...
