Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEBA6FBD91
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Nov 2019 02:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKNBkM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Nov 2019 20:40:12 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36295 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbfKNBkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 20:40:12 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 220943A0661;
        Thu, 14 Nov 2019 12:40:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iV47F-0000X2-2b; Thu, 14 Nov 2019 12:40:09 +1100
Date:   Thu, 14 Nov 2019 12:40:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 5/5] Replace function declartion by actual definition
Message-ID: <20191114014009.GA4614@dread.disaster.area>
References: <20191112213310.212925-1-preichl@redhat.com>
 <20191112213310.212925-6-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112213310.212925-6-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 10:33:10PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c | 140 ++++++++++++++++++---------------------
>  1 file changed, 66 insertions(+), 74 deletions(-)

subject line needs updating but otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
