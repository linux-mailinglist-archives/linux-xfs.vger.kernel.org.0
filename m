Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139C21B53DA
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Apr 2020 06:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgDWEzQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 Apr 2020 00:55:16 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47326 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbgDWEzQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 00:55:16 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E03013A40C3;
        Thu, 23 Apr 2020 14:55:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jRTtI-0000Tt-Cc; Thu, 23 Apr 2020 14:55:12 +1000
Date:   Thu, 23 Apr 2020 14:55:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 10/13] xfs: combine xfs_trans_ail_[remove|delete]()
Message-ID: <20200423045512.GL27860@dread.disaster.area>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-11-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-11-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8
        a=aqCgzhVM4RVg147SOz0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:26PM -0400, Brian Foster wrote:
> Now that the functions and callers of
> xfs_trans_ail_[remove|delete]() have been fixed up appropriately,
> the only difference between the two is the shutdown behavior. There
> are only a few callers of the _remove() variant, so make the
> shutdown conditional on the parameter and combine the two functions.
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
