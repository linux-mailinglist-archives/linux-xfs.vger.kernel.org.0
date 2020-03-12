Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750951827D5
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Mar 2020 05:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgCLEh1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Mar 2020 00:37:27 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51331 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726678AbgCLEh1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 00:37:27 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B1D677EAB34;
        Thu, 12 Mar 2020 15:37:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jCFb1-0006zO-8X; Thu, 12 Mar 2020 15:37:23 +1100
Date:   Thu, 12 Mar 2020 15:37:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/7] xfs: add a function to deal with corrupt buffers
 post-verifiers
Message-ID: <20200312043723.GI10776@dread.disaster.area>
References: <158388763282.939165.6485358230553665775.stgit@magnolia>
 <158388763904.939165.1796274155705134706.stgit@magnolia>
 <20200311182533.GI8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311182533.GI8045@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=8IrUwMeyzzsAe_jHYGEA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 11:25:33AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a helper function to get rid of buffers that we have decided are
> corrupt after the verifiers have run.  This function is intended to
> handle metadata checks that can't happen in the verifiers, such as
> inter-block relationship checking.  Note that we now mark the buffer
> stale so that it will not end up on any LRU and will be purged on
> release.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: drop the (broken) dirty buffer check

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
