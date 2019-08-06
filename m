Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8F282EA5
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Aug 2019 11:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732367AbfHFJY3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Aug 2019 05:24:29 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42515 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732361AbfHFJY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 05:24:28 -0400
Received: from dread.disaster.area (pa49-181-167-148.pa.nsw.optusnet.com.au [49.181.167.148])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9A2862AD0FE;
        Tue,  6 Aug 2019 19:24:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1huvgc-0000Si-KG; Tue, 06 Aug 2019 19:23:18 +1000
Date:   Tue, 6 Aug 2019 19:23:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Kinky Nekoboi <kinky_nekoboi@nekoboi.moe>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: XFS segementation fault with new linux 4.19.63
Message-ID: <20190806092318.GE7777@dread.disaster.area>
References: <e0ca189e-2f96-6599-40ce-a4fc8866d8d1@nekoboi.moe>
 <20190806070806.GA13112@infradead.org>
 <cbe57554-ed5f-6163-d48c-9069aa2dcc7b@nekoboi.moe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbe57554-ed5f-6163-d48c-9069aa2dcc7b@nekoboi.moe>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=gu9DDhuZhshYSb5Zs/lkOA==:117 a=gu9DDhuZhshYSb5Zs/lkOA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 06, 2019 at 09:10:57AM +0200, Kinky Nekoboi wrote:
> Addional info:
> 
> this only occurs if kernel is compiled with:
> 
> CONFIG_XFS_DEBUG=y
> 
> running 4.19.64 without xfs debugging works fine

I'm guessing 4.19 doesn't have commit c08768977b9a ("xfs: finobt AG
reserves don't consider last AG can be a runt")....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
