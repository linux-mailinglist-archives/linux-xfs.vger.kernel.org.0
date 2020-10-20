Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAB928EDB6
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 09:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgJOH3U (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 03:29:20 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55511 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727427AbgJOH3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:29:20 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A101058C550
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:29:16 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxhM-000iC1-2w
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:29:16 +1100
Date:   Thu, 15 Oct 2020 18:29:16 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/27] [RFC, WIP] xfsprogs: xfs_buf unification and AIO
Message-ID: <20201015072916.GG7391@dread.disaster.area>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=7-415B0cAAAA:8
        a=AXTNrXSCQ_MhNiO1YOIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 06:21:28PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> Big rework. Aimed at unifying the user and kernel buffer caches so
> the first thing to do is port the kernel buffer cache code and hack
> it to pieces to use userspace AIO.

Just a quick addition - this seems to be smoke testing on fstests
just fine at the moment. It looks like there is nothing
catastrophically broken in the conversion (apart from discontiguous
buffers w/ AIO).

The xfsprogs base is the current for-next tree (5.9.0-rc1, IIRC),
and it applies on top of the config file patchset I posted earlier.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
