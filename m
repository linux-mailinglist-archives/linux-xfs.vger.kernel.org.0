Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C834DE3B2
	for <lists+linux-xfs@lfdr.de>; Fri, 18 Mar 2022 22:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241202AbiCRVuA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 18 Mar 2022 17:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbiCRVtz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 17:49:55 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1C99220306
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 14:48:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5BB9E533F28;
        Sat, 19 Mar 2022 08:48:32 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nVKSV-0075pJ-0w; Sat, 19 Mar 2022 08:48:31 +1100
Date:   Sat, 19 Mar 2022 08:48:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] log I/O completion GPF via xfs/006 and xfs/264 on
 5.17.0-rc8
Message-ID: <20220318214831.GH1544202@dread.disaster.area>
References: <YjSNTd+U3HBq/Gsv@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjSNTd+U3HBq/Gsv@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6234fe30
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=eR1I91q_QiV69GDcuksA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 18, 2022 at 09:46:53AM -0400, Brian Foster wrote:
> Hi,
> 
> I'm not sure if this is known and/or fixed already, but it didn't look
> familiar so here is a report. I hit a splat when testing Willy's
> prospective folio bookmark change and it turns out it replicates on
> Linus' current master (551acdc3c3d2). This initially reproduced on
> xfs/264 (mkfs defaults) and I saw a soft lockup warning variant via
> xfs/006, but when I attempted to reproduce the latter a second time I
> hit what looks like the same problem as xfs/264. Both tests seem to
> involve some form of error injection, so possibly the same underlying
> problem. The GPF splat from xfs/264 is below.

On a side note, I'm wondering if we should add xfs/006 and xfs/264
to the recoveryloop group - they do a shutdown under load and a
followup mount to ensure the filesystem gets recovered before
the test ends and the fs is checked, so while thy don't explicitly
test recovery, they do exercise it....

Thoughts?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
