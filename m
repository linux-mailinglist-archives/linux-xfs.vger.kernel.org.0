Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB4FA64863
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 16:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfGJOav (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 10:30:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38847 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfGJOau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 10:30:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so2719771wrr.5
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 07:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y9ttaUmI/Ctg3mKNGy0nWZg73phGny9cfT86VkYH83E=;
        b=oW6GUD6i/KfNZXXugTKW+QyabIXwnbQ8Qgck2yy8z+X7kO/UXw6GdgZz2HNORcisRw
         yRf9oOSOqPLzPM987kHo53fy35sJ/UVYbdpnX8MRczofNHySV6JplRN1vfIkAJducCu2
         MxAmYzF8aC5BXj9EckPrCmXAs+oBJKra2p+RWf4UDYvyxA3eZvcVgqhXextA63TC+jid
         7s4mvMZRj5h5CpLeQPNhQZt3+MRqVJc2egSfBlg6Fa+ZKHgo+7X4DDvLyYCkA1K70LEI
         t671scUUidMa6l8GXJdgIf9pBD/vwD4UJ4yfRN42gTXWBMha0HHLGzpP5nSixGTPyec8
         VQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y9ttaUmI/Ctg3mKNGy0nWZg73phGny9cfT86VkYH83E=;
        b=H3mUm49LGFRTjN99IYv9TYAJxd/pM0Cqo2v3ZwcaNGy9fQmhTaiNHSJfN6Vfic5+tQ
         W9g5G8wedPmWH9ICoGy595UFkShPHbI/5EtJPcsjW5UU0kMoU3PtxsBKkWznlbBIYw66
         4IAHof5Efu+M+DYWCgLQ9ZMmq+r6qdm3R4RxGbVuvMFmOuKgznVmRlLUJ3JwBRXcpnkZ
         wup60Em45iO2LXQpE63N7BlKa0TWY9V3bK2TUIPat1MExhAYpjnzkxYeseNagGlpI1nO
         4TJH+fEEcrprYofqd5DBNVp+7CKmdrNXp0DZQqT6R+O/wZ5ezvdb7ltz2fa3aFIso35e
         nbAw==
X-Gm-Message-State: APjAAAUwPiRzBqdT57CfDrWlXVa2ObciXBsNB/YO5Czf5CqtldesxibL
        +u32GBcV6ZOw78JgjwSfkmV3TQws70HlvgwnZFBneHtBpmw=
X-Google-Smtp-Source: APXvYqwgXqVGvpE9ps5yg2Bz7aUKd2Rgq4ob9Pq50au9Auw/znPOuUXXDkYQXcwVYq4mHCr8CgTH8N8XL7r9MmfhHW4=
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr30686591wrx.82.1562769048537;
 Wed, 10 Jul 2019 07:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <958316946.20190710124710@a-j.ru>
In-Reply-To: <958316946.20190710124710@a-j.ru>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 10 Jul 2019 08:30:37 -0600
Message-ID: <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
Subject: Re: Need help to recover root filesystem after a power supply issue
To:     Andrey Zhunev <a-j@a-j.ru>
Cc:     xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 10, 2019 at 3:52 AM Andrey Zhunev <a-j@a-j.ru> wrote:
>
> [root@tftp ~]# xfs_repair /dev/centos/root
> Phase 1 - find and verify superblock...
> superblock read failed, offset 53057945600, size 131072, ag 2, rval -1
>
> fatal error -- Input/output error
> [root@tftp ~]#

# smartctl -l scterc /dev/

Point it to the physical device. If it's a consumer drive, it might
support a configurable SCT ERC. Also need to see the kernel messages
at the time of the i/o error. There's some chance if a deep recover
read is possible, it'll recover the data. But I don't see how this is
related to power supply failure.


-- 
Chris Murphy
