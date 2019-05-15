Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60161F806
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 17:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfEOP5f (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 11:57:35 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:40529 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEOP5f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 11:57:35 -0400
Received: by mail-lj1-f172.google.com with SMTP id d15so257828ljc.7
        for <linux-xfs@vger.kernel.org>; Wed, 15 May 2019 08:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=79A4BTL8ExzweRzFS8quFeHLFVif5As3EVU1vOW0R6k=;
        b=SajgcHYELnxAc2JODlKl8LZJMaDj+/oc88LJomoaTJerkFcXmqEPoo0wRKQuKXKWu6
         4NFuNyVmUaA8NXBn8O6y8IQCU0BXi4fr5u93dVNcyBed4KHBS6DvK/78ffWwB/7+r9UM
         SB0ON5AEW2Z5C03GN65JRU8LyU3UvFwMNBzwNpT4sjB4l5K55xe2G/DSn2/rU9RGsjE6
         uxfX61nAn9W40/qGGjEZ0iP/rMwO06QBn6HVNnua6wrfeER3yvxQeGckSDr6UPJbbFjq
         MmyfE8OhOwTK8JcG7WEmu30SWDHql8rCBQ7ivnPM3bdU8Xxo3vTB/5Yy7WB+NbUwDKLE
         oSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=79A4BTL8ExzweRzFS8quFeHLFVif5As3EVU1vOW0R6k=;
        b=Gya3WRGuaYifrlhQ/KydDEZYn4H0uVWeBzedaS6mEpFJkSvuMR2XuiMJWAteyqGlgR
         +JQfLygv8g9//UlDYU7+6HH0JuI04DRXG635du8gAASXlsFKUgoZp4GmVN/1kZNLdMQd
         flZnpE5DnujcoD25jRAy0pa4UnJgzvfYkKAQiOhOJG+42na0vZefkjGi1yx4RIgYXRb3
         nrrdIb2OJsqNtxfb2Tzggy0O4kP0AMqZpipg2VCJ6IDAwkjuhSgEozzg9w7iX87OeOBe
         +S/WJ12jSt/OJw63hyMp5XvgWKkjKHhoZqNn+9WFQkGi2my3iIGf78wE6Q1+0N4DZcsj
         RDQA==
X-Gm-Message-State: APjAAAWPcaKy1/Dcm8dokoJkwMLYlXYKs+3pQeJHcoqcs3fJ4aSzGC5a
        is94YZEQvAHyxkQ6Lp7gN/W5mNhwOwb0GDr1Y4I=
X-Google-Smtp-Source: APXvYqy0TplImBZ62UxNmSkrXqe6PLaBPdBFiMMwxx6zMGiBYyy/dzZkydd6HZy3xAQMN2wZKKvNODWQZ/gI5gYX15Q=
X-Received: by 2002:a2e:206:: with SMTP id 6mr18817543ljc.59.1557935852585;
 Wed, 15 May 2019 08:57:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190514185026.73788-1-jorgeguerra@gmail.com> <4a47cdc4-4a96-cf78-9e48-83d6cd0fe65f@sandeen.net>
In-Reply-To: <4a47cdc4-4a96-cf78-9e48-83d6cd0fe65f@sandeen.net>
From:   Jorge Guerra <jorge.guerra@gmail.com>
Date:   Wed, 15 May 2019 08:57:21 -0700
Message-ID: <CAEFkGAx1A3-XXqWSssa3QQsTZW-8BuVU_D+Dq2sYfKAKs0+t_w@mail.gmail.com>
Subject: Re: [PATCH] xfs_db: add extent count and file size histograms
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>,
        Jorge Guerra <jorgeguerra@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thanks Eric,

I'm addressing these comments.  Will send an update once we have an
agreement with Dave into how and where to implement this.

On Tue, May 14, 2019 at 1:02 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 5/14/19 1:50 PM, Jorge Guerra wrote:
> > +             dbprintf(_("capacity used (bytes): %llu (%.3f %cB)\n"),
> > +             extstats.logicalused, answer, iec_prefixes[i]);
>
> I think I missed this instance of "indent please" and probably others...
>
> (I'm kind of wondering about carrying 'used' in bytes, but I suppose we're
> ok until we really get zettabyte filesytems in the wild) ;)
>
> -Eric



-- 
Jorge E Guerra D
