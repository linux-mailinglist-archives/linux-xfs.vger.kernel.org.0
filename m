Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B5358674
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 17:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfF0Py7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jun 2019 11:54:59 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42020 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfF0Py6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 11:54:58 -0400
Received: by mail-pg1-f195.google.com with SMTP id k13so1207209pgq.9
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jun 2019 08:54:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=udbte5nY2DT5VGMdOcG2M7x4xm7Yb8LgI97LBDM8qFY=;
        b=cC8Vof6C2zF35oZfhOdIv/ovX40Xtaq1FJWJ6HAU09hz4hQk3EBcLU4xZXHAfTbaYI
         hvkISYW6la0SoFhE8R3JLqvqEa0K2dKszQMFqCcEf4LSf+Wk7QHhA5ZMYW1b53iuXQcP
         rzjECGDxO7S7dmTwSln1hzcWi0wrGZzLOBhGz/iDtLY7kwyz6BFv998Cu/9EwTz89Ilf
         bS+PuQHvKwZDa52YSkl0IUu1x7jVUuqNLAS9+FA2koe0x6n7PNI9BEwMGERCOZU7HmGX
         V4LEg7LW3rpCWy2rtSjlTgrYT8Vq2p0NrkEYr6BXjxyhFk+m5SMLbe7LnJjMgNGWrrE0
         J1Ug==
X-Gm-Message-State: APjAAAXpkXWrNP6xSsbraTWmNmpGC8+ZppHEuxu9MqwYnVYVXXVNgZVR
        9UlPjD5lHfZCKSZ0WArDI5I=
X-Google-Smtp-Source: APXvYqyEX7QzMT53PMN3QPPzQ36Timt4l2wy4O6nrGKi+WuCBE7fKpdDwAK5qeSN+YwKr5IS6n4Mfw==
X-Received: by 2002:a17:90a:8a8e:: with SMTP id x14mr6687383pjn.103.1561650897452;
        Thu, 27 Jun 2019 08:54:57 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 135sm3384018pfb.137.2019.06.27.08.54.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 08:54:56 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 7A213403ED; Thu, 27 Jun 2019 15:54:55 +0000 (UTC)
Date:   Thu, 27 Jun 2019 15:54:55 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Alvin Zheng <Alvin@linux.alibaba.com>
Cc:     gregkh <gregkh@linuxfoundation.org>,
        linux-xfs <linux-xfs@vger.kernel.org>, bfoster@redhat.com,
        "joseph.qi" <joseph.qi@linux.alibaba.com>,
        caspar <caspar@linux.alibaba.com>
Subject: Re: [backport request][stable] xfs: xfstests generic/538 failed on
 xfs
Message-ID: <20190627155455.GA30113@42.do-not-panic.com>
References: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 27, 2019 at 08:10:56PM +0800, Alvin Zheng wrote:
> Hi,
> 
>     I  was using kernel v4.19.y and found that it cannot pass the
> generic/538 due to data corruption. I notice that upstream has fix this
> issue with commit 2032a8a27b5cc0f578d37fa16fa2494b80a0d00a. Will v4.19.y
> backport this patch?

Hey Alvin,

Thanks for Bringing this to attention.  I'll look into this a bit more.
Time for a new set of stable fixes for v4.19.y. Of course, I welcome
Briant's feedback, but if he's busy I'll still look into it.

  Luis
