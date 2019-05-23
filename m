Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D45328D49
	for <lists+linux-xfs@lfdr.de>; Fri, 24 May 2019 00:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387599AbfEWWja (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 18:39:30 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40530 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387546AbfEWWja (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 18:39:30 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B167643A1BD;
        Fri, 24 May 2019 08:39:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hTwMw-00050F-7i; Fri, 24 May 2019 08:39:26 +1000
Date:   Fri, 24 May 2019 08:39:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/20] xfs: don't use REQ_PREFLUSH for split log writes
Message-ID: <20190523223926.GS29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-7-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:28PM +0200, Christoph Hellwig wrote:
> If we have to split a log write because it wraps the end of the log we
> can't just use REQ_PREFLUSH to flush before the first log write,
> as the writes might get reordered somewhere in the I/O stack.  Issue
> a manual flush in that case so that the ordering of the two log I/Os
> doesn't matter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yup, we clear the flush flag from the second buffer so this is
actually necessary. Very subtle, nice catch.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
