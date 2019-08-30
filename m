Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B361A2F44
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2019 07:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfH3F67 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Aug 2019 01:58:59 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35775 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbfH3F67 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:58:59 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 306B136113E;
        Fri, 30 Aug 2019 15:58:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3Zvz-00041W-8T; Fri, 30 Aug 2019 15:58:55 +1000
Date:   Fri, 30 Aug 2019 15:58:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs_db: remove db/convert.h
Message-ID: <20190830055855.GJ1119@dread.disaster.area>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633312041.1215978.17289300639793819044.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156633312041.1215978.17289300639793819044.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=DW0orOty-bdQTP9caeEA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 01:32:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> db/convert.h conflicts with include/convert.h and since the former only
> has one declaration in it anyway, just get rid of it.  We'll need this
> in the next patch to avoid an ugly include mess.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/Makefile  |    4 ++--
>  db/command.c |    1 -
>  db/command.h |    1 +
>  db/convert.c |    1 -
>  db/convert.h |    7 -------
>  5 files changed, 3 insertions(+), 11 deletions(-)
>  delete mode 100644 db/convert.h

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
