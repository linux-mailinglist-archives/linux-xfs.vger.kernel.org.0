Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D931A340CC
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 09:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfFDHys (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 03:54:48 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40618 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbfFDHyr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 03:54:47 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F31A8439FEE;
        Tue,  4 Jun 2019 17:54:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hY4HK-0005NS-ON; Tue, 04 Jun 2019 17:54:42 +1000
Date:   Tue, 4 Jun 2019 17:54:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: bulkstat should copy lastip whenever
 userspace supplies one
Message-ID: <20190604075442.GX29573@dread.disaster.area>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
 <155916880004.757870.14054258865473950566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155916880004.757870.14054258865473950566.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 29, 2019 at 03:26:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When userspace passes in a @lastip pointer we should copy the results
> back, even if the @ocount pointer is NULL.

Makes sense and the code change is simple enough, but this changes
what we return to userspace, right?  Does any of xfsprogs or fstests
test code actually exercise this case? If not, how have you
determined it isn't going to break anything?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
