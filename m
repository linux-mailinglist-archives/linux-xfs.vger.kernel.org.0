Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9107D38EC83
	for <lists+linux-xfs@lfdr.de>; Mon, 24 May 2021 17:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhEXPQI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 May 2021 11:16:08 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:55531 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235616AbhEXPLU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 May 2021 11:11:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UZyzSpv_1621868989;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UZyzSpv_1621868989)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 24 May 2021 23:09:50 +0800
Date:   Mon, 24 May 2021 23:09:48 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hsiangkao@aol.com, david@fromorbit.com
Subject: Re: [PATCH 1/1] xfs: check free AG space when making per-AG
 reservations
Message-ID: <YKvBvBABUDHfHFux@B-P7TQMD6M-0146.local>
References: <162181808760.203030.18032062235913134439.stgit@locust>
 <162181809311.203030.14398379924057321012.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162181809311.203030.14398379924057321012.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 23, 2021 at 06:01:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The new online shrink code exposed a gap in the per-AG reservation
> code, which is that we only return ENOSPC to callers if the entire fs
> doesn't have enough free blocks.  Except for debugging mode, the
> reservation init code doesn't ever check that there's enough free space
> in that AG to cover the reservation.
> 
> Not having enough space is not considered an immediate fatal error that
> requires filesystem offlining because (a) it's shouldn't be possible to
> wind up in that state through normal file operations and (b) even if
> one did, freeing data blocks would recover the situation.
> 
> However, online shrink now needs to know if shrinking would not leave
> enough space so that it can abort the shrink operation.  Hence we need
> to promote this assertion into an actual error return.
> 
> Observed by running xfs/168 with a 1k block size, though in theory this
> could happen with any configuration.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Many thanks for the fix!

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang
