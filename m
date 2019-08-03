Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2F0803E1
	for <lists+linux-xfs@lfdr.de>; Sat,  3 Aug 2019 03:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387864AbfHCBxZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Aug 2019 21:53:25 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34404 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387606AbfHCBxZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 21:53:25 -0400
Received: by mail-qk1-f196.google.com with SMTP id t8so56273470qkt.1
        for <linux-xfs@vger.kernel.org>; Fri, 02 Aug 2019 18:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1nRDQWcGKZ6UNcc5VMBTx5rRmeK37YySnprFdXg1Zyo=;
        b=SKtKXjnAQpGWImqXqaKt0QNEdFrN3PyWoKvI1uWwgL7ZMMFyBMHDKbSAwn1SIKGJoa
         Y/oySydLL0apwjKx59c1HoA3CSq6lkUC4zk3+YthKyBrHL/xAr0QO0/Y5wgd+Dn7ON3c
         VBHDdToJ0hpZ4uuIFIwpxy2BsKybkczBlrW1+Q1h/NzMPAqG7Yc0pZWYEU527JrUWIS7
         9rAh32y4NIG8wrtdhHtRA5E70LeT2qVii4v+NcO2w56ye1Z/6Fj6kHmI6fdpdwnJ9I6U
         RngTBWbbANiQEObnfvvbh/v/gHi0P9DKAYt1Z1pZIWUST3tqK6/sZBS1xN6meCvXBTMS
         zHGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1nRDQWcGKZ6UNcc5VMBTx5rRmeK37YySnprFdXg1Zyo=;
        b=atiuAEH0/ey5s2hATPvpbhqJVQVFG7Xs+ssOS92ghmRi0sAR8pTUPFbrOnm05G6MW1
         xcjTMj/uBAqxk2GDZfj6O5NDdWjPQQi+VQnBf5+qjAZ3L0xo3gBM7w2bCzaLuI6OJw6P
         pT064zY3C/S1p4mnyn7YLN8q1s5GK50oo/oZV9hgw/QtazAm6aWvNzTAKwgyKA6f7Vmn
         ggwYnxJHJR9qLpXfrsF+RIo6UF9vb/hreBGwKi9Ka1W0KPGldLG0D6sH0hnmK51RiVZ6
         +vC31P7FPiLlkRRSi4uddfnQddDl3i+HhcfX1K0VJAMA9BngV+fmWoVKiOz1bU40mf69
         aafQ==
X-Gm-Message-State: APjAAAVXi9m867a67/iiRt2cO5YGPc3vickkqlIXgVRSbwpFVhZfMJf8
        RPqyHpU0my5pbNRefL5y2rNEsIg=
X-Google-Smtp-Source: APXvYqwrGQLxyVOL3/FrfLpmT3gSVXoS4MfJR3ViBd3rxFn8gb6wy8oYRZ0ma8ndaoHfSA/CPqtDHQ==
X-Received: by 2002:a05:620a:11b2:: with SMTP id c18mr93537705qkk.174.1564797204235;
        Fri, 02 Aug 2019 18:53:24 -0700 (PDT)
Received: from lud1.home ([177.17.22.67])
        by smtp.gmail.com with ESMTPSA id q73sm19458155qke.90.2019.08.02.18.53.22
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 02 Aug 2019 18:53:23 -0700 (PDT)
Date:   Fri, 2 Aug 2019 22:53:20 -0300
From:   Luciano ES <lucmove@gmail.com>
To:     XFS mailing list <linux-xfs@vger.kernel.org>
Subject: Re: XFS file system corruption, refuses to mount
Message-ID: <20190802225320.77b4b3c2@lud1.home>
In-Reply-To: <20190803011106.GJ7138@magnolia>
References: <20181211183203.7fdbca0f@lud1.home>
        <20190803011106.GJ7138@magnolia>
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2 Aug 2019 18:11:06 -0700, Darrick J. Wong wrote:

> On Fri, Aug 02, 2019 at 09:53:56PM -0300, Luciano ES wrote:
> > I've had this internal disk running for a long time. I had to 
> > disconnect it from the SATA and power plugs for two days. 
> > Now it won't mount. 
> > 
> > mount: wrong fs type, bad option, bad superblock
> > on /dev/mapper/cab3, missing codepage or helper program, or other
> > error In some cases useful info is found in syslog - try
> >        dmesg | tail or so.
> > 
> > I get this in dmesg:
> > 
> > [   30.301450] XFS (dm-1): Mounting V5 Filesystem
> > [   30.426206] XFS (dm-1): Corruption warning: Metadata has LSN
> > (16:367696) ahead of current LSN (16:367520). Please unmount and run
> > xfs_repair (>= v4.3) to resolve.  
> 
> Hm, I think this means the superblock LSN is behind the log LSN, which
> could mean that... software is buggy?  The disk didn't flush its cache
> before it was unplugged?  Something else?
> 
> What kernel & xfsprogs?

Debian 4.9.0-3-amd64, xfsprogs 4.9.0.


> And how did you disconnect it from the power plugs?

I shut down the machine, opened the box's cover and disconnected the 
data and power cables. I used them on the CD/DVD drive, which I never 
use but this time I had to. The hard disk drive remained quiet in its 
bay. Then I shut down the machine and reconnected the cables to the 
hard disk and this problem came up. I also tried another cable and 
another SATA port, to no avail.


> > [   30.426209] XFS (dm-1): log mount/recovery failed: error -22
> > [   30.426310] XFS (dm-1): log mount failed
> > 
> > Note that the entire disk is encrypted with cryptsetup/LUKS, 
> > which is working fine. Wrong passwords fail. The right password 
> > opens it. But then it refuses to mount.
> > 
> > This has been happening a lot to me with XFS file systems. 
> > Why is this happening?
> > 
> > Is there something I can do to recover the data?  
> 
> Try xfs_repair -n to see what it would do if you ran repair?

I tried and got this output:


Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...


and it's been printing an endless stream of dots for a very long 
time. I'm about to go to bed and let this running overnight. 
It looks like it has a long way to go.

-- 
Luciano ES
>>
