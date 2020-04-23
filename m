Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B3B1B53CC
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Apr 2020 06:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgDWErW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 Apr 2020 00:47:22 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52764 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725961AbgDWErW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 00:47:22 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A6923820233;
        Thu, 23 Apr 2020 14:47:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jRTlc-0000P9-Pf; Thu, 23 Apr 2020 14:47:16 +1000
Date:   Thu, 23 Apr 2020 14:47:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>, g@dread.disaster.area
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 06/13] xfs: fix duplicate verification from
 xfs_qm_dqflush()
Message-ID: <20200423044716.GJ27860@dread.disaster.area>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-7-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=VdMx8Iukme_eiLev_7kA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:22PM -0400, Brian Foster wrote:
> The pre-flush dquot verification in xfs_qm_dqflush() duplicates the
> read verifier by checking the dquot in the on-disk buffer. Instead,
> verify the in-core variant before it is flushed to the buffer.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
