Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A242B3326
	for <lists+linux-xfs@lfdr.de>; Sun, 15 Nov 2020 10:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgKOJNi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 15 Nov 2020 04:13:38 -0500
Received: from out20-63.mail.aliyun.com ([115.124.20.63]:44908 "EHLO
        out20-63.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgKOJN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Nov 2020 04:13:27 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.31313|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.013626-0.00129578-0.985078;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047202;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.IwxUCR7_1605431573;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.IwxUCR7_1605431573)
          by smtp.aliyun-inc.com(10.147.40.44);
          Sun, 15 Nov 2020 17:12:53 +0800
Date:   Sun, 15 Nov 2020 17:12:53 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 0/4] xfstests: fix compiler warnings with fsx/fsstress
Message-ID: <20201115091253.GJ3853@desktop>
References: <160505547722.1389938.14377167906399924976.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160505547722.1389938.14377167906399924976.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 10, 2020 at 04:44:37PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Fix all the compiler warnings emitted when building fsstress and fsx.

I've taken the first 3 patches, and left the last one for now :)

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
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-fsx-and-fsstress-warnings
> ---
>  ltp/fsstress.c |  102 ++++++++++++++++++++++++++------------------------------
>  ltp/fsx.c      |    5 +--
>  2 files changed, 50 insertions(+), 57 deletions(-)
