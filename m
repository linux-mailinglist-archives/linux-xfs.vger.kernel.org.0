Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAE523FF33
	for <lists+linux-xfs@lfdr.de>; Sun,  9 Aug 2020 18:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgHIQWp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 9 Aug 2020 12:22:45 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:59014 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726382AbgHIQWk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Aug 2020 12:22:40 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0U5D0Fnn_1596990144;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0U5D0Fnn_1596990144)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 10 Aug 2020 00:22:24 +0800
Date:   Mon, 10 Aug 2020 00:22:24 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     Eryu Guan <guan@eryu.me>
Cc:     Bill O'Donnell <billodo@redhat.com>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        darrick.wong@oracle.com, sandeen@redhat.com
Subject: Re: [PATCH] xfs/518: modify timer/state commands to remove new g,p
 timer output
Message-ID: <20200809162224.GC80581@e18g06458.et15sqa>
References: <20200731173739.390649-1-billodo@redhat.com>
 <20200809154143.GK2557159@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200809154143.GK2557159@desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 09, 2020 at 11:41:43PM +0800, Eryu Guan wrote:
> On Fri, Jul 31, 2020 at 12:37:39PM -0500, Bill O'Donnell wrote:
> > New xfs_quota kernel and xfsprogs add grace timers for group and project,
> > in addition to existing user quota. Adjust xfs/518 to accommodate those
> > changes, and avoid regression.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> 
> This looks good to me. But it'd be great if the kernel & xfsprogs
> commits that change the behavior could be mentioned in the commit log as
> well.

Not a big deal, I'll take it this time :)

Thanks,
Eryu
