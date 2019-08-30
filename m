Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5958A2F28
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2019 07:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfH3Fpb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Aug 2019 01:45:31 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37171 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbfH3Fpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:45:31 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E293743F18E;
        Fri, 30 Aug 2019 15:45:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3Ziy-0003ri-83; Fri, 30 Aug 2019 15:45:28 +1000
Date:   Fri, 30 Aug 2019 15:45:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] man: document new fs summary counter scrub command
Message-ID: <20190830054528.GG1119@dread.disaster.area>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633310223.1215978.8971659233241451267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156633310223.1215978.8971659233241451267.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=8wW_cBRYeqbr_5JJRykA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 01:31:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Update the scrub ioctl documentation to include the new fs summary
> counter scrubber.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man2/ioctl_xfs_scrub_metadata.2 |    5 +++++
>  1 file changed, 5 insertions(+)

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
