Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67054AE1CC
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Sep 2019 03:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390710AbfIJBE2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 9 Sep 2019 21:04:28 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49231 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727115AbfIJBE2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Sep 2019 21:04:28 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5CAF6361CB5;
        Tue, 10 Sep 2019 11:04:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i7Ua1-0006sl-RY; Tue, 10 Sep 2019 11:04:25 +1000
Date:   Tue, 10 Sep 2019 11:04:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_scrub: refactor queueing of subdir scan work item
Message-ID: <20190910010425.GK16973@dread.disaster.area>
References: <156774083707.2643257.15738851266613887341.stgit@magnolia>
 <156774084332.2643257.12234848325153797756.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156774084332.2643257.12234848325153797756.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:34:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace the open-coded process of queueing a subdirectory for scanning
> with a single helper function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.


Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
