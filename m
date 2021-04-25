Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB1A36A9C3
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Apr 2021 00:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhDYWvw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 25 Apr 2021 18:51:52 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:41662 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231247AbhDYWvw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Apr 2021 18:51:52 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id A642180A8C3;
        Mon, 26 Apr 2021 08:51:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lanao-007ged-4K; Mon, 26 Apr 2021 08:51:10 +1000
Date:   Mon, 26 Apr 2021 08:51:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't check agf_btreeblks on pre-lazysbcount
 filesystems
Message-ID: <20210425225110.GD63242@dread.disaster.area>
References: <20210425154659.GA3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210425154659.GA3122264@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_f
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=-n9jqdyYVGtZ78cYKhwA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 25, 2021 at 08:46:59AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The AGF free space btree block counter wasn't added until the
> lazysbcount feature was added to XFS midway through the life of the V4
> format, so ignore the field when checking.  Online AGF repair requires
> rmapbt, so it doesn't need the feature check.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
