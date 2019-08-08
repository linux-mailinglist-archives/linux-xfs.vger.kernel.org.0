Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4125A858AD
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Aug 2019 05:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfHHDqa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Aug 2019 23:46:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40731 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbfHHDqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 23:46:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so43274980pfp.7
        for <linux-xfs@vger.kernel.org>; Wed, 07 Aug 2019 20:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pzXtPRlMum0DW21qy61NSwSMMERmj2eVuSmTIJ63eQQ=;
        b=lXBPS+B4PrcFGCY8VKGHWqGQfLbQn6mRh94CgrVmSTlcWMg1+TFfODouhyOniI895B
         PJ04kh+zKs9EZBZjCkUsYwcBEbxVVQ697cTokii1cOOajOhEn9h8WxFh+c+GLR6dLZgq
         Fb6qI75MxOUPPcUgGQoPwbvl93Rb+0MFOHC0bEq1hFdztatzTWR86BlXQFGJWdP5XGvm
         Kf86BihViVREIL7Dc3lL6TV6PCqlVJmQHczLg/sJlzNFpIStsbnedtKLzYQhTE4hBcV6
         rgjqbCpgj2fm9LdHvuKkKq2P4vXR1ItsgExK3qEYYzepoAJlghBKc5BhTHfHL61J4Ilg
         pZuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pzXtPRlMum0DW21qy61NSwSMMERmj2eVuSmTIJ63eQQ=;
        b=ESKIQAQjM+YmULrsWP7LqYZ2U6SfKg8/jvZ0bDaCfGAQnc0BDODfzXfZkCkDpEAYu8
         cAp3oUBxyfa59hiawlOoDHkz3fVkP27jHdbu0eRL4GWmvuJiwalQ2Vmba41BgfJKTHjT
         btptEJ82aRTMjYaC6AAHPNeqcb4X/kPh6HGtYjj4zVcNzD1orJwsFTawl3hpP9lH4bSe
         nHfIQMATcVbubKVpwhm/HH+ULOY7hcHe3d/UgMga8jJ2mpRGJp1Be2Y1EU9jtxTZWPeH
         9yoHltkchcJcJEM5YBywQPMBv9v65nYmAwmH/DBz+gI971m8UJbC+qrELgwZMDfDJcWK
         Wp0g==
X-Gm-Message-State: APjAAAXyjdBnPcWCWtK1ulOCXdpOlVXTXH10lK58z0Z2iqxLZN7hUrnz
        nsJJY8ugeEgieFM6PrIABoY=
X-Google-Smtp-Source: APXvYqyoeDARMatIQv2ibw2RT05rPz8mU+mmKmbD87Obsv7lm5AZQrpF6FT/bvBuydiJpmKCAwrmng==
X-Received: by 2002:a17:90a:2506:: with SMTP id j6mr1791042pje.129.1565235989435;
        Wed, 07 Aug 2019 20:46:29 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g66sm91229867pfb.44.2019.08.07.20.46.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 20:46:28 -0700 (PDT)
Date:   Thu, 8 Aug 2019 11:46:21 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>, Petr Vorel <pvorel@suse.cz>,
        Yang Xu <xuyang2018.jy@cn.fujitsu.com>, chrubis@suse.cz,
        ltp@lists.linux.it, linux-xfs@vger.kernel.org
Subject: Re: [LTP] [PATCH v7 3/3] syscalls/copy_file_range02: increase
 coverage and remove EXDEV test
Message-ID: <20190808034621.e7pqwazdqtsed2ew@XZHOUW.usersys.redhat.com>
References: <20190730110555.GB7528@rei.lan>
 <1564569629-2358-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
 <1564569629-2358-3-git-send-email-xuyang2018.jy@cn.fujitsu.com>
 <20190805065832.ti6vpoviykfaxcj7@XZHOUW.usersys.redhat.com>
 <5D47D6B9.9090306@cn.fujitsu.com>
 <20190805102211.pvyufepn6xywi7vm@XZHOUW.usersys.redhat.com>
 <20190806162703.GA1333@dell5510>
 <20190807101742.mt6tgowsh4xw5hyt@XZHOUW.usersys.redhat.com>
 <20190807121212.GM7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807121212.GM7777@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 07, 2019 at 10:12:12PM +1000, Dave Chinner wrote:
> On Wed, Aug 07, 2019 at 06:17:42PM +0800, Murphy Zhou wrote:
> > ccing linux-xfs@vger.kernel.org
> > 
> > Hi,
> > 
> > Tracked down this to be a xfs specific issue:
> > 
> > If we call copy_file_range with a large offset like this:
> > 
> > 	loff_t off = 9223372036854710270; // 2 ** 63
> > 	ret = copy_file_range(fd_in, 0, fd_out, &off, 65537, 0);
> 
> That's not 2**63:

Ya! I was looking too roughly.

> 
> $ echo $((9223372036854710270 + 65537))
> 9223372036854775807
> 
> $ echo $((2**63 - 1))
> 9223372036854775807
> 
> i.e. it's LLONG_MAX, not an overflow. XFS sets sb->s_maxbytes in
> xfs_max_file_offset to:
> 
> 	(1 << BITS_PER_LONG - 1) - 1 = 2**63 - 1 = LLONG_MAX.
> 
> So no matter how we look at it, this operation should not return
> EFBIG on XFS.
> 
> > (test programme cfrbig.c attached)
> > 
> > xfs has it done successfully, while ext4 returns EFBIG.
> 
> ext4 has a max file size of 2**32 * blocksize, so it doesn't support
> files larger than 16TB. So it will give EFBIG on this test.
> 
> /me compiles and runs the test program on his workstation:
> 
> $ ls -l foobar
> -rw------- 1 dave dave 10737418240 Apr 12 14:46 foobar
> $ ./a.out foobar bar
> ret 65537
> $ ls -l bar
> -rw-r--r-- 1 dave dave 9223372036854775807 Aug  7 22:11 bar
> $
> 
> That looks like a successful copy to me, not EINVAL or EFBIG...

Thanks Dave for the confirmation! This testcase needs some fix.

Murphy

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
