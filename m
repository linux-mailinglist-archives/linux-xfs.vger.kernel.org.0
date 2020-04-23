Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A603F1B534D
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Apr 2020 06:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgDWEJM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 Apr 2020 00:09:12 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39680 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725562AbgDWEJM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 00:09:12 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BF3603A444F;
        Thu, 23 Apr 2020 14:09:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jRTAh-0000Am-Kl; Thu, 23 Apr 2020 14:09:07 +1000
Date:   Thu, 23 Apr 2020 14:09:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 01/13] xfs: refactor failed buffer resubmission into
 xfsaild
Message-ID: <20200423040907.GF27860@dread.disaster.area>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-2-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=DhvvQXkdXMoQHAluRbsA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:17PM -0400, Brian Foster wrote:
> Flush locked log items whose underlying buffers fail metadata
> writeback are tagged with a special flag to indicate that the flush
> lock is already held. This is currently implemented in the type
> specific ->iop_push() callback, but the processing required for such
> items is not type specific because we're only doing basic state
> management on the underlying buffer.
> 
> Factor the failed log item handling out of the inode and dquot
> ->iop_push() callbacks and open code the buffer resubmit helper into
> a single helper called from xfsaild_push_item(). This provides a
> generic mechanism for handling failed metadata buffer writeback with
> a bit less code.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
