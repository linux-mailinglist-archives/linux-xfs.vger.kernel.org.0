Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEFB535750
	for <lists+linux-xfs@lfdr.de>; Fri, 27 May 2022 03:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbiE0B1S (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 May 2022 21:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiE0B1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 21:27:17 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4773513CF8
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 18:27:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8AF7053452C;
        Fri, 27 May 2022 11:27:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nuOl1-00Gq7m-F5; Fri, 27 May 2022 11:27:15 +1000
Date:   Fri, 27 May 2022 11:27:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/5] xfs: warn about LARP once per mount
Message-ID: <20220527012715.GQ1098723@dread.disaster.area>
References: <165337058023.994444.12794741176651030531.stgit@magnolia>
 <165337059702.994444.2041987003230901021.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165337059702.994444.2041987003230901021.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=629028f4
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=kJqN0VjnlxRaLWXffaMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 10:36:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since LARP is an experimental debug-only feature, we should try to warn
> about it being in use once per mount, not once per reboot.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log.c   |    4 ++--
>  fs/xfs/xfs_mount.h |    5 ++++-
>  2 files changed, 6 insertions(+), 3 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
