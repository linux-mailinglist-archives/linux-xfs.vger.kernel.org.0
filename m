Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFCA25A6DD
	for <lists+linux-xfs@lfdr.de>; Sat, 29 Jun 2019 00:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfF1WXO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jun 2019 18:23:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45321 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfF1WXN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 18:23:13 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so3651030pfq.12
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 15:23:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TXibxTFHNtqmSqvoqYFkIRL6F8qP8JCVEIWbZdvkdQo=;
        b=rjIHkBlgQq1xLIveHjzwrLCXZj4en7Fp3nqVSPOjJs6+ONexfYuXjrZCzX2iykd6oG
         UncjMN3O++/ZaoAzZehIXhPOaytzlBsJaDh9apNtQRllvNYcGwIT5jXKEqTeUol6gX6A
         FNJZqeQMfM8d1f+BKYyGgP7PoHJIdt5jmg3DvDppHJv4xnDWUwRFZdyziBd9NgQbqJGC
         AjQ2u9zOk2hUqqwe/GpuG3lZzplKkWGajRDU63tHupq/lu7oXZYnMCnzbT8Mv5kV5rfX
         sMtepxzBa+e5oh9KrsjwFW0PSTmPWYC57huNgLwcVd0BwRvPj+jjjhmgvT5QMEwfqtFr
         AqLQ==
X-Gm-Message-State: APjAAAXmHxCaktu+YOgMXTqteW+gFWL7ZVNEd52CLkL1YOnE4uEq/wT3
        Mfdsta6ga1JzNWA0UsJGoBUQ7EqMtU8=
X-Google-Smtp-Source: APXvYqx9exKiB/VFDdthjkkw+vk50RO7EnGwirqu59lHCwV0MxQ+dNOGTiCmqzc9JIAihVVenmBUEA==
X-Received: by 2002:a63:6a49:: with SMTP id f70mr11232436pgc.55.1561760592606;
        Fri, 28 Jun 2019 15:23:12 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id e16sm2607538pga.11.2019.06.28.15.23.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 15:23:11 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id C7435402AC; Fri, 28 Jun 2019 22:23:10 +0000 (UTC)
Date:   Fri, 28 Jun 2019 22:23:10 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix iclog allocation size
Message-ID: <20190628222310.GL19023@42.do-not-panic.com>
References: <20190627143950.19558-1-hch@lst.de>
 <20190628220253.GF30113@42.do-not-panic.com>
 <20190628221914.GD1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628221914.GD1404256@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 28, 2019 at 03:19:14PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 28, 2019 at 10:02:53PM +0000, Luis Chamberlain wrote:
> > On Thu, Jun 27, 2019 at 04:39:50PM +0200, Christoph Hellwig wrote:
> > > Properly allocate the space for the bio_vecs instead of just one byte
> > > per bio_vec.
> > > 
> > > Fixes: 991fc1d2e65e ("xfs: use bios directly to write log buffers")
> > 
> > I cannot find 991fc1d2e65e on Linus' tree, nor can I find the subject
> > name patch on Linus' tree. I'm probably missing some context here?
> 
> This patch fixes a bug in for-next. :)

I figured as much but the commit in question is not even on linux-next
for today, so I take it that line would be removed from the commit log?

  Luis
