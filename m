Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47523533416
	for <lists+linux-xfs@lfdr.de>; Wed, 25 May 2022 01:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239884AbiEXXs1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 May 2022 19:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiEXXs0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 19:48:26 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8BB862120;
        Tue, 24 May 2022 16:48:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 15A16534768;
        Wed, 25 May 2022 09:48:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nteGG-00G18N-Bz; Wed, 25 May 2022 09:48:24 +1000
Date:   Wed, 25 May 2022 09:48:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, Eryu Guan <guaneryu@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/545: check for fallocate support before running test
Message-ID: <20220524234824.GS2306852@dread.disaster.area>
References: <Yo03czi2EzyKy2/c@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo03czi2EzyKy2/c@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=628d6ec9
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=plh0Ri2L7ldcXiGuxk8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 12:52:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test fails when alwayscow mode is enabled:
> 
> --- xfs/545.out
> +++ xfs/545.out.bad
> @@ -1,4 +1,5 @@
>  QA output created by 545
> +fallocate: Operation not supported
>  Creating directory system to dump using fsstress.
> 
> Fix this by checking for fallocate support first.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
