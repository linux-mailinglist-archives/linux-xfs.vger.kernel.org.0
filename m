Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BB3A9575
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Sep 2019 23:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfIDVr7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Sep 2019 17:47:59 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59083 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbfIDVr7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 17:47:59 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A68E7362B78;
        Thu,  5 Sep 2019 07:47:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5d88-0007ip-0y; Thu, 05 Sep 2019 07:47:56 +1000
Date:   Thu, 5 Sep 2019 07:47:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: fix missed wakeup on l_flush_wait
Message-ID: <20190904214755.GJ1119@dread.disaster.area>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-3-david@fromorbit.com>
 <20190904060751.GB12591@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904060751.GB12591@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 11:07:51PM -0700, Christoph Hellwig wrote:
> Looks good.  I vaguely remember reviewing this before, though.

Probably, but no one but me commented on it the first time, and I
don't recall anyone reviewing it specifically when I posted it as
part of the nonblocking inode reclaim RFC. SO yeah, maybe seen, not
sure it if was reviewed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
