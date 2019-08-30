Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5F8A310D
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2019 09:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfH3Hb6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Aug 2019 03:31:58 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37836 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726655AbfH3Hb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 03:31:58 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2E35B43ED1E;
        Fri, 30 Aug 2019 17:31:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3bNy-0004b9-FK; Fri, 30 Aug 2019 17:31:54 +1000
Date:   Fri, 30 Aug 2019 17:31:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Initialize label array properly
Message-ID: <20190830073154.GO1119@dread.disaster.area>
References: <20190830053707.GA69101@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830053707.GA69101@LGEARND20B15>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=5bCHpZppJwO2KMCyn_0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 02:37:07PM +0900, Austin Kim wrote:
> In case kernel stack variable is not initialized properly,
> there is a risk of kernel information disclosure.
> 
> So, initialize 'char label[]' array with null characters.

Can you describe the information disclosure vector here? I can't see
any, mostly because this is the "set label" function and that
doesn't return anything to userspace.

We also zero the on-disk label before we copy the user label into
it, so I don't see that anything can leak onto disk, either...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
