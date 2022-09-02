Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EC65ABA61
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Sep 2022 23:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiIBVzV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Sep 2022 17:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIBVzT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Sep 2022 17:55:19 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0237C57212
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 14:55:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-4-169.pa.nsw.optusnet.com.au [49.195.4.169])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E079510E9B61;
        Sat,  3 Sep 2022 07:55:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oUEdA-00346O-M0; Sat, 03 Sep 2022 07:55:16 +1000
Date:   Sat, 3 Sep 2022 07:55:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Creating written extents beyond EOF
Message-ID: <20220902215516.GX3600936@dread.disaster.area>
References: <877d2np6im.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877d2np6im.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=63127bc6
        a=FOdsZBbW/tHyAhIVFJ0pRA==:117 a=FOdsZBbW/tHyAhIVFJ0pRA==:17
        a=kj9zAlcOel0A:10 a=xOM3xZuef0cA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=f81itDO6iUBRiaN4Oa0A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 01, 2022 at 06:55:31PM +0530, Chandan Babu R wrote:
> Hi Dave,
> 
> 7684e2c4384d5d1f884b01ab8bff2369e4db0bff
> (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7684e2c4384d5d1f884b01ab8bff2369e4db0bff)
> is one of the commits that needs to be backported to 5.4.y stable kernel.
> 
> The commit message mentions that we could have written extents beyond EOF. I
> am unable to come up with a sequence of commands that could create such
> extents.
> 
> Can you please explain how a user could create a file having written extents
> beyond EOF?

That bug fix was committed in v5.5. We didn't convert delalloc to
use unwritten extents until v5.8 via commit a5949d3faedf.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
