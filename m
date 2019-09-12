Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21741B16CE
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Sep 2019 01:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbfILX4W (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Sep 2019 19:56:22 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35808 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728258AbfILX4W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Sep 2019 19:56:22 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A31B536299C;
        Fri, 13 Sep 2019 09:56:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i8Ywk-00083j-Hk; Fri, 13 Sep 2019 09:56:18 +1000
Date:   Fri, 13 Sep 2019 09:56:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_scrub: batch inumbers calls during fscounters
 calculation
Message-ID: <20190912235618.GU16973@dread.disaster.area>
References: <156774093859.2644581.13218735172589605186.stgit@magnolia>
 <156774097106.2644581.12925257167258478461.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156774097106.2644581.12925257167258478461.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:36:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Improve the efficiency of the phase 7 inode counts by batching requests,
> now that we have per-AG inumbers wrappers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
