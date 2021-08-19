Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC433F12D2
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Aug 2021 07:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhHSFiw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 Aug 2021 01:38:52 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:58609 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229451AbhHSFiw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 01:38:52 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 4FD93107DAF;
        Thu, 19 Aug 2021 15:38:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGakl-002OwC-Is; Thu, 19 Aug 2021 15:38:11 +1000
Date:   Thu, 19 Aug 2021 15:38:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 10/15] xfs: disambiguate units for ftrace fields
 tagged "count"
Message-ID: <20210819053811.GH3657114@dread.disaster.area>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924378705.761813.11309968953103960937.stgit@magnolia>
 <20210819034536.GQ12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819034536.GQ12640@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=4DFFEGXgmgDggj-gf6YA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 18, 2021 at 08:45:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Some of our tracepoints have a field known as "count".  That name
> doesn't describe any units, which makes the fields not very useful.
> Rename the fields to capture units and ensure the format is hexadecimal
> when we're referring to blocks, extents, or IO operations.
> 
> "fsbcount" are in units of fs blocks
> "bytecount" are in units of bytes
> "ireccount" are in units of inode records
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: rename the count units
> ---
>  fs/xfs/xfs_trace.h |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Looks good, though ireccount is not used anywhere...

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
