Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441B477565
	for <lists+linux-xfs@lfdr.de>; Sat, 27 Jul 2019 02:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbfG0AYn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Jul 2019 20:24:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44310 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbfG0AYn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jul 2019 20:24:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id t16so25208371pfe.11
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jul 2019 17:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9a3V63BDipljKyO2MTJ+y2rWOXpMDzYhLg5PVd8g11s=;
        b=oXAYtTQS7H3OJEPmI6nlVLgFrL7jZACZjVQipetErZU7EVleGY/C8jk3HunOmr0ufI
         dRWiKpadpATjdmPh9Rw4f0SXaRHFdsNk1dlMCTKMSZnZo7REsByU/fshz6qtYbjKLUUb
         oMV0z0nwk7PQEl/4jvf9vmGvY9uRmIwF1gnc7vDDeTp2TstSqO/SdC+MxgBHqDt65Lzg
         XRjEcW0MbBR+Q2A/2nX0oKK6Cz6tNjkKbfWaqLlC7dVgGBMA3+vuhib8mUUw08EaSA4N
         NQabaGXgeyRCH1isB3T63DvbJ66Ds1D54XAnBMs9tNbZQ8/JNep5UTO13M85xHW9Za2n
         BvgA==
X-Gm-Message-State: APjAAAXKz22i+rn+E7jf7aClEk+w+iQXX4U8PjkqLsc30uaXTgYsLShd
        /c8u13sY662d5EDK7QCulMnCCmB3
X-Google-Smtp-Source: APXvYqxWp21Ws95hvWYP0m0QMmj1NejgwkgpxtiiCm/i2EWvKbaIPyOBihS6dsV2kdcQHkNsdE31gw==
X-Received: by 2002:a17:90a:33c4:: with SMTP id n62mr103295181pjb.28.1564187082232;
        Fri, 26 Jul 2019 17:24:42 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id s15sm54119223pfd.183.2019.07.26.17.24.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 17:24:40 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id E00EE40256; Sat, 27 Jul 2019 00:24:39 +0000 (UTC)
Date:   Sat, 27 Jul 2019 00:24:39 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Unmountable XFS file system after runnig stress-ng
Message-ID: <20190727002439.GS30113@42.do-not-panic.com>
References: <b92674c4-488e-15ec-2052-eb69e4f80b7e@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b92674c4-488e-15ec-2052-eb69e4f80b7e@molgen.mpg.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 07:21:43PM +0200, Paul Menzel wrote:
> Dear Linux folks,

Hey Paul, thanks for reporting this!

> With Linux 4.19.57

v4.19.57 lacks a series of fixes I posted a few days ago.
They were merged on v4.19.61. You can try that. If that fails
another small series of fixes were posted recently which are
not merged yet ons table v4.19.y, but you can use this git
branch:

https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-stable.git/log/?h=20190726-linux-xfs-4.19.y-v1

> I ran `sudo ./stress-ng -a 10` [1], and it looks like the
> file system got corrupted.

Which version of  stress-ng did you use?

Can you try also on the latest Linus' tree?
If brave enough, you can try the xfs for-next branch
as well:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/log/?h=for-next

If the issue is still creeping up on the above stable kernels
can you create a bug entry on bugzilla.kernel.org to track this?

  Luis
