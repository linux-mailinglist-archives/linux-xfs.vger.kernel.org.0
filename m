Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F0524C96F
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Aug 2020 03:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgHUBJR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Aug 2020 21:09:17 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:56437 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726819AbgHUBJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 21:09:15 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 2ABD510983F;
        Fri, 21 Aug 2020 11:09:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k8vYJ-0007nL-9i; Fri, 21 Aug 2020 11:09:07 +1000
Date:   Fri, 21 Aug 2020 11:09:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH v4 1/3] xfs: get rid of unused pagi_unlinked_hash
Message-ID: <20200821010907.GF7941@dread.disaster.area>
References: <20200724061259.5519-1-hsiangkao@redhat.com>
 <20200818133015.25398-1-hsiangkao@redhat.com>
 <20200818133015.25398-2-hsiangkao@redhat.com>
 <20200819005403.GB6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819005403.GB6096@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=iEncnyldMksTxxhp03IA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 05:54:03PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 18, 2020 at 09:30:13PM +0800, Gao Xiang wrote:
> > pagi_unlinked_hash is unused since no backref infrastructure now.
> > (it's better to fold it into original patchset.)
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 
> Yes, this should be folded into the other patch that gets rid of the
> rest of the rhash code.  Dave?

Oh, I must have missed that in a rebase conflict resolution...

I'll fold it into the appropriate patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
