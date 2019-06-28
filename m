Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596055A6E8
	for <lists+linux-xfs@lfdr.de>; Sat, 29 Jun 2019 00:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfF1WcD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jun 2019 18:32:03 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38060 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfF1WcD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 18:32:03 -0400
Received: by mail-pg1-f196.google.com with SMTP id z75so3195895pgz.5
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 15:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q5Whm5AvHc88FSOPhiKRqOZTLaCCREjrCmAbszikxLw=;
        b=QzR/MqtmFnd4xJ58lIKJ8JiUtnZK8sYgITNF+Kj5HO94QRCwo3EojMexXJ2y4hC/Yj
         8FlBY/5bxy3LZKNnlBIwqTV+VA4X1DdK+58+cZNffWCsNr7JrQuk11f/9nBF9Ib8Z+Du
         UNIX+atXPZsSTRFBN/28xPKGJtxSKxEF0H72JvL+bVu5wVJW/9Kn1bedu//zJArAp5va
         nwegLG6YK1sye0cGDglDUctxw4bSgVldX7eKo6lmUeg6kRAR2+vvZ1GbWhIZRtIEJh3P
         ATJ0mQ9OSXyngiSivTxnbd1wqxwCxaXNFcGM55SPGaRcn7L/kpFkY7V2SQTl+IjCU4j/
         x2Bw==
X-Gm-Message-State: APjAAAXQjRrrybammvoFt26cJAsxu4bb82oD2JApg+xwD7lZWtkTlODV
        Uay0rDjLqiC2rv3UltGmxqc=
X-Google-Smtp-Source: APXvYqxAwUpq+5Wfx0oq8vd+4hvEcw8YD9jCbHUQXLAdOf63dgbg+RbG8eyzMA2OGOVmKhb/PTK8gw==
X-Received: by 2002:a17:90a:36e4:: with SMTP id t91mr15444050pjb.22.1561761122667;
        Fri, 28 Jun 2019 15:32:02 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id y68sm3740691pfy.164.2019.06.28.15.32.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 15:32:01 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id E0ECE402AC; Fri, 28 Jun 2019 22:32:00 +0000 (UTC)
Date:   Fri, 28 Jun 2019 22:32:00 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix iclog allocation size
Message-ID: <20190628223200.GO19023@42.do-not-panic.com>
References: <20190627143950.19558-1-hch@lst.de>
 <20190628220253.GF30113@42.do-not-panic.com>
 <20190628221914.GD1404256@magnolia>
 <20190628222310.GL19023@42.do-not-panic.com>
 <20190628222548.GE1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628222548.GE1404256@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 28, 2019 at 03:25:48PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 28, 2019 at 10:23:10PM +0000, Luis Chamberlain wrote:
> > On Fri, Jun 28, 2019 at 03:19:14PM -0700, Darrick J. Wong wrote:
> > > On Fri, Jun 28, 2019 at 10:02:53PM +0000, Luis Chamberlain wrote:
> > > > On Thu, Jun 27, 2019 at 04:39:50PM +0200, Christoph Hellwig wrote:
> > > > > Properly allocate the space for the bio_vecs instead of just one byte
> > > > > per bio_vec.
> > > > > 
> > > > > Fixes: 991fc1d2e65e ("xfs: use bios directly to write log buffers")
> > > > 
> > > > I cannot find 991fc1d2e65e on Linus' tree, nor can I find the subject
> > > > name patch on Linus' tree. I'm probably missing some context here?
> > > 
> > > This patch fixes a bug in for-next. :)
> > 
> > I figured as much but the commit in question is not even on linux-next
> > for today, so I take it that line would be removed from the commit log?
> 
> It looks like it is to me...
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20190628&id=991fc1d2e65e381fe8db9038d9a139d45c948f4f

Yes but commits on linux-next make no sense for Linus' tree, as they change
day to day, is my point. So if merged eventually as-is on Linus' tree,
someone looking at the git history would not find 991fc1d2e65e, and
could also throw errors on scripts which scrape for these tags. Yes,
they exist, and distros do use them to evaluate possible fixes.

In this case I think just referring to the subject would do it.

Unless it just so happens to be that what is on for-next *does* always
maintain the same commit IDs one it goes to Linus' tree? Does that
actually happen?

  Luis
