Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107E23AFB57
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Jun 2021 05:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFVDTH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 21 Jun 2021 23:19:07 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:43721 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229546AbhFVDTH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 23:19:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0UdHLACY_1624331478;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UdHLACY_1624331478)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 22 Jun 2021 11:11:20 +0800
Date:   Tue, 22 Jun 2021 11:11:18 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix endianness issue in xfs_ag_shrink_space
Message-ID: <YNFU1lOpVJMf/8lv@B-P7TQMD6M-0146.local>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
References: <20210621223436.GF3619569@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210621223436.GF3619569@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 21, 2021 at 03:34:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The AGI buffer is in big-endian format, so we must convert the
> endianness to CPU format to do any comparisons.
> 
> Fixes: 46141dc891f7 ("xfs: introduce xfs_ag_shrink_space()")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

LGTM,
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

