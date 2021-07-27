Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6357C3D825E
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jul 2021 00:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhG0WR0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Jul 2021 18:17:26 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44050 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232223AbhG0WR0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 18:17:26 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F106C104522A;
        Wed, 28 Jul 2021 08:17:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8VO6-00BWx4-UH; Wed, 28 Jul 2021 08:17:22 +1000
Date:   Wed, 28 Jul 2021 08:17:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: invalidate dirhash entry when junking dirent
Message-ID: <20210727221722.GW664593@dread.disaster.area>
References: <20210727191611.GI559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727191611.GI559212@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=8DDc4FTjGkHsdxAYwHIA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 12:16:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In longform_dir2_entry_check_data, we add the directory entries we find
> to the incore dirent hash table after we've validated the name but
> before we're totally done checking the entry.  This sequence is
> necessary to detect all duplicated names in the directory.
> 
> Unfortunately, if we later decide to junk the ondisk dirent, we neglect
> to mark the dirhash entry, so if the directory gets rebuilt, it will get
> rebuilt with the entry that we rejected.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
