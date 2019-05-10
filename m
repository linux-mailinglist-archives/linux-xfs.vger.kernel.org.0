Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83EA1199DC
	for <lists+linux-xfs@lfdr.de>; Fri, 10 May 2019 10:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfEJIr2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 May 2019 04:47:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33225 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfEJIr1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 May 2019 04:47:27 -0400
Received: by mail-pf1-f194.google.com with SMTP id z28so2878065pfk.0;
        Fri, 10 May 2019 01:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WqCXTNkuQG1i3mARsjRWF5vIr29cQXpm6UafewnDp24=;
        b=MGOre1dmn5ojm/Scv86X33BJGTR6VVet4K6CquGu5yr6R8L5hrXvEw47gWUIpCGfyQ
         kqALGxiMLQh9OPh6WxXM+SerViFzsz4lCyJ2obbwq+i4AmkNtvhvocCTBcJ9z/Zb3+Ye
         J4a/0mZNuY+hYJvKx+cs5nwUgQPid9YFQ5b87tblOaPU5416DmK+1HSgEohu49bV+1xm
         st75BhOkEjlx++SzLS15aQPvLi4rJfW+Ioko+5sQs4dTZ02lsX1OXZELjxsHFkWMnOAK
         XIxrWUImVVWyip9Q2nWexlCxx7Eybn2KCo17DRZUhuLxHVLyMLemSYj31VDtOXU6zZnF
         srbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WqCXTNkuQG1i3mARsjRWF5vIr29cQXpm6UafewnDp24=;
        b=mBTG3bNz3IrUupCwy8f4yyjWHoHYlkCXl+/+nzLIAdltqjTSIf0l+8l3956QiNzEIV
         x5DuJEypKWJBzBAr8qP0FkSnVICTYsz3SF+6MpYZbT6NS/dggR3biLNdFtgRWq/qZnlq
         mkddBezs+vC5O3HmC8C38aPjyJrzqQr23kgSqRaVEP7lsLe/tcG7qLp8qAFkZMhUcNEw
         jcb8V7I1xzrV0vWZl28r/i9kjM0fbdmqTvHk35Y5YRQX2k9DW7AVcXW5sg7RjC0Ic359
         W7UQq+x0vTlUgF4Dcc8qR+2+vDeZdS22zE8bNT7in79hHTj+tloHSS2cahktae7Sdlu8
         85xw==
X-Gm-Message-State: APjAAAWRyNKScv6ng/W8H3DvWbCTsrxP7vwKn9uPMHZseYiSf/zzko8l
        dgws4FpMyWWHtGsPDEyKmx9SXi9raOK/rg==
X-Google-Smtp-Source: APXvYqw8S1bZgn0TNkOdO1MfKlAYMb3ifMs2ivqdiOXlOk8q4eKkN7tZCkAOJQq3xIZxJ3QHh9/DFQ==
X-Received: by 2002:a62:5653:: with SMTP id k80mr12037585pfb.144.1557478047038;
        Fri, 10 May 2019 01:47:27 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id s11sm7073166pga.36.2019.05.10.01.47.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 01:47:26 -0700 (PDT)
Date:   Fri, 10 May 2019 16:47:20 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     xuyang <xuyang2018.jy@cn.fujitsu.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 0/3] fstests: various fixes
Message-ID: <20190510084720.GG15846@desktop>
References: <155724821034.2624631.4172554705843296757.stgit@magnolia>
 <5CD38E98.8000705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5CD38E98.8000705@cn.fujitsu.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 09, 2019 at 10:21:12AM +0800, xuyang wrote:
> on 2019/05/08 0:56, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Here are three patches fixing various regressions in xfstests when
> > mkfs.xfs defaults to enabling reflink and/or rmap by default.  Most of
> > the changes deal with the change in minimum log size requirements.  They
> > weren't caught until now because there are a number of tests that call
> > mkfs on a loop device or a file without using MKFS_OPTIONS.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
> > 
> > 
> > 
> Hi
> 
> Tested-by: Yang Xu<xuyang2018.jy@cn.fujitsu.com>

Thanks for the testing! Just want to make sure that you tested all the
three patches so that I can add your Tested-by tag too all of them?

Thanks,
Eryu
