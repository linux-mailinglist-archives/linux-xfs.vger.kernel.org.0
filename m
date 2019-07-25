Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7681A74DD5
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 14:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfGYML7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jul 2019 08:11:59 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:33801 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbfGYML7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 08:11:59 -0400
Received: by mail-wm1-f44.google.com with SMTP id w9so35631189wmd.1
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 05:11:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=vAtGZk4VYs5rW03d4XJ/51oxI92v+vKMZ1DEv55Wy+E=;
        b=fpOi8A4WqhJ03uKHdUHGdSfLc6DlOZ3h3iAUOhOm/gGgToJw1raj7t+vC+AHHaCssl
         Yer0+D2MYu58VwPDxJ6OosZAbN7uCTjj9vBQ93KOMU3JIi6MlTvdYBa8DNzXoN9fI6Py
         /CQyTXicFIippNKvvL7ZiYBLGXUbx43F3FmvkT9z+e+atPb74JCiOw1hwARVGnLQVeFw
         aM68nWbV9p0uw6nW6+IrCrZGc7jgTqmcjQX3TZ7p1Y5ijWcNdUfjmkVhkdJVxLk0vk2X
         F9BY0eeHeg8EEsWxdMABQmkg12+m5+HdZGEkm5nndn550IFUK1cnfOQq4w2rDrIz4zr4
         kZ4Q==
X-Gm-Message-State: APjAAAU8nPcSAG0wE+36U4iTdTFevLLTWBaitULcVW3gD/jze1U2qvll
        O/knN5wnAVPWPFEPZpoSilxtNPy4tTU=
X-Google-Smtp-Source: APXvYqyPNRjTdqmIDQnBOR0eE1KmaBJFEJt+6pFwLr2Hr3lY/2Ux+Gmr487Q7df1nqITcjkm16uepg==
X-Received: by 2002:a1c:3b02:: with SMTP id i2mr76244417wma.23.1564056717162;
        Thu, 25 Jul 2019 05:11:57 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id r123sm45510268wme.7.2019.07.25.05.11.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 05:11:56 -0700 (PDT)
Date:   Thu, 25 Jul 2019 14:11:54 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Carlos E. R." <robin.listas@telefonica.net>
Cc:     Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Subject: Re: Sanity check - need a second pair of eyes ;-)
Message-ID: <20190725121154.pewwwdpgejcrgdi7@pegasus.maiolino.io>
Mail-Followup-To: "Carlos E. R." <robin.listas@telefonica.net>,
        Linux-XFS mailing list <linux-xfs@vger.kernel.org>
References: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
 <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
 <900147aa-12a9-bb30-6af3-1cc63cd9f05a@telefonica.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <900147aa-12a9-bb30-6af3-1cc63cd9f05a@telefonica.net>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> 
> Thanks. 
> 
> (Yes, I looked at the manual but did not /see/ aka understand what I really needed).
> 
> My page is a little bit different:
> 
>        -s sector_size_options
>               This option specifies the fundamental  sector  size  of
>               the filesystem.  The valid sector_size_option is:
> 
>                    size=value
>                           The  sector  size is specified with a value
>                           in bytes.  The default sector_size  is  512
>                           bytes. The minimum value for sector size is
>                           512; the maximum is  32768  (32  KiB).  The
>                           sector_size  must  be a power of 2 size and
>                           cannot be made larger than  the  filesystem
>                           block size.
> 
>                           To  specify any options on the command line
>                           in units of sectors, this  option  must  be
>                           specified  first so that the sector size is
>                           applied consistently to all options.

There was an update on the manpage past year which changed this section, the
usage is the same.

> 
> Thus the final command line was:
> 
> # mkfs.xfs -L ANameUnseen -s size=2048 /dev/mapper/cr_nombre

Looks correct.


But I apologize if it's a dumb question, but what do you expect to achieve by
setting the sector size here? You will be essentially writing the fs image file
over the BluRay Filesystem (which IIRC uses UDF), so, the sector size set on
your xfs filesystem image won't matter much, unless I'm missing something, which
is exactly why I'm asking it :)

Cheers

> meta-data=/dev/mapper/cr_nombre  isize=512    agcount=4, agsize=3054592 blks
>          =                       sectsz=2048  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=0, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=12218368, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=5966, version=2
>          =                       sectsz=2048  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> -- 
> Cheers / Saludos,
> 
> 		Carlos E. R.
> 		(from 15.0 x86_64 at Telcontar)
> 




-- 
Carlos
