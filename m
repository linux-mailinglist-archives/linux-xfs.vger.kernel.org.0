Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF173DCBC5
	for <lists+linux-xfs@lfdr.de>; Sun,  1 Aug 2021 15:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhHANS5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 1 Aug 2021 09:18:57 -0400
Received: from out20-1.mail.aliyun.com ([115.124.20.1]:49222 "EHLO
        out20-1.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhHANS4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Aug 2021 09:18:56 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2355524|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.013003-0.00557617-0.981421;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047203;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.Ktqtd2p_1627823927;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Ktqtd2p_1627823927)
          by smtp.aliyun-inc.com(10.147.42.22);
          Sun, 01 Aug 2021 21:18:47 +0800
Date:   Sun, 1 Aug 2021 21:18:46 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCHSET 0/4] fstests: random fixes
Message-ID: <YQafNg4i1N2sYUKu@desktop>
References: <162743097757.3427426.8734776553736535870.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162743097757.3427426.8734776553736535870.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 05:09:37PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Here are the usual weekly fixes for fstests.

Thanks for all the fixes! I've queued all patches for update except the
fix for generic/570.

Thanks,
Eryu

> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
> ---
>  check             |    7 ++++++-
>  tests/generic/570 |    2 +-
>  tests/xfs/106     |    1 +
>  tests/xfs/106.out |    5 +++++
>  4 files changed, 13 insertions(+), 2 deletions(-)
