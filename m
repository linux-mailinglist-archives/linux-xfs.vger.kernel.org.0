Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865AF397E41
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Jun 2021 03:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhFBBxz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Jun 2021 21:53:55 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:57549 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230193AbhFBBxz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 21:53:55 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 1F4891AFE5A;
        Wed,  2 Jun 2021 11:52:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loG3G-007vdd-JQ; Wed, 02 Jun 2021 11:52:10 +1000
Date:   Wed, 2 Jun 2021 11:52:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 06/14] xfs: move xfs_inew_wait call into xfs_dqrele_inode
Message-ID: <20210602015210.GN664593@dread.disaster.area>
References: <162259515220.662681.6750744293005850812.stgit@locust>
 <162259518565.662681.11590996146177657551.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162259518565.662681.11590996146177657551.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=EvlOBHq32hjNzslds6oA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 01, 2021 at 05:53:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the INEW wait into xfs_dqrele_inode so that we can drop the
> iter_flags parameter in the next patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
