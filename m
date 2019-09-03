Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B19CA7764
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Sep 2019 01:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfICXBZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 Sep 2019 19:01:25 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58372 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbfICXBZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Sep 2019 19:01:25 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3B65D820298;
        Wed,  4 Sep 2019 09:01:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Hnd-0004yP-34; Wed, 04 Sep 2019 09:01:21 +1000
Date:   Wed, 4 Sep 2019 09:01:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] libfrog: create xfd_open function
Message-ID: <20190903230121.GZ1119@dread.disaster.area>
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
 <156713887587.386621.8656028056753211579.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156713887587.386621.8656028056753211579.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=GxzSHEd5abf5JOxQJ78A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:21:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a helper to open a file and initialize the xfd structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
....

>  
> +/* Open a file on an XFS filesystem.  Returns zero or a positive error code. */
> +int
> +xfd_open(
> +	struct xfs_fd		*xfd,
> +	const char		*pathname,
> +	int			flags)
> +{
> +	int			ret;
> +
> +	xfd->fd = open(pathname, O_RDONLY);

open(pathname, flags)

And, to handle all future uses, shouldn't it also pass a mode?
Though I think that can be done as a separate patch when we need
O_RDWR for open....

Otherwise it looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
