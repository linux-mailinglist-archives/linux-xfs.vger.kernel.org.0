Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F725FE84F
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Oct 2022 07:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiJNFHS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Oct 2022 01:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiJNFHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 01:07:17 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 967E31946F1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 22:07:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D06BA1101B70;
        Fri, 14 Oct 2022 16:07:14 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ojCug-001l8X-9y; Fri, 14 Oct 2022 16:07:14 +1100
Date:   Fri, 14 Oct 2022 16:07:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: block map scrub should handle incore delalloc
 reservations
Message-ID: <20221014050714.GP3600936@dread.disaster.area>
References: <166473480864.1083927.11062319917293302327.stgit@magnolia>
 <166473480915.1083927.736458976932286147.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473480915.1083927.736458976932286147.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=6348ee82
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=UFsqSS1z8YH85jcf9OYA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Enhance the block map scrubber to check delayed allocation reservations.
> Though there are no physical space allocations to check, we do need to
> make sure that the range of file offsets being mapped are correct, and
> to bump the lastoff cursor so that key order checking works correctly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/bmap.c |   55 +++++++++++++++++++++++++++++++++------------------
>  1 file changed, 36 insertions(+), 19 deletions(-)

Seems reasonable to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
