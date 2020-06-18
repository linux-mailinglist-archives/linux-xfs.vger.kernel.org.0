Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619381FFE81
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Jun 2020 01:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgFRXR6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 18 Jun 2020 19:17:58 -0400
Received: from [211.29.132.97] ([211.29.132.97]:48061 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1727037AbgFRXR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 19:17:58 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 8AB831101EA;
        Fri, 19 Jun 2020 09:17:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jm3mm-00016K-7Y; Fri, 19 Jun 2020 09:17:32 +1000
Date:   Fri, 19 Jun 2020 09:17:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3] xfs_copy: flush target devices before exiting
Message-ID: <20200618231732.GL2005@dread.disaster.area>
References: <20200618181825.GY11245@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618181825.GY11245@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=rZuaV0MKladM0RaQuvsA:9 a=CjuIK1q_8ugA:10
        a=XTfQIuIyIrcA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 11:18:25AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Flush the devices we're copying to before exiting, so that we can report
> any write errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks ok. Flushing in check_errors() is a bit nasty, but it's a copy
completion path that is called from many places so there's no
obvious alternative...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
