Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87FB560BDF
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jun 2022 23:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiF2Vhi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jun 2022 17:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiF2Vh0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 17:37:26 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E1643A187
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:37:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AFF8110E817A;
        Thu, 30 Jun 2022 07:37:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6fND-00CcfV-Oi; Thu, 30 Jun 2022 07:37:23 +1000
Date:   Thu, 30 Jun 2022 07:37:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: add in-memory iunlink log item
Message-ID: <20220629213723.GY227878@dread.disaster.area>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-10-david@fromorbit.com>
 <Yrv+gfvrtIFOwami@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrv+gfvrtIFOwami@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62bcc614
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=gRk84RL1sJYXP8R2vxUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 12:25:53AM -0700, Christoph Hellwig wrote:
> On Mon, Jun 27, 2022 at 10:43:36AM +1000, Dave Chinner wrote:
> > TO do this, we introduce a new in-memory log item to track the
> 
> s/To/To/
> 
> > This allows us to pass the xfs_inode to the transaction commit code
> > along with the modification to be made, and then order the logged
> > modifications via the ->iop_sort and ->iop_precommit operations
> > for the new log item type. As this is an in-memory log item, it
> > doesn't have formatting, CIL or AIL operational hooks - it exists
> > purely to run the inode unlink modifications and is then removed
> > from the transaction item list and freed once the precommit
> > operation has run.
> 
> Do we need to document the fact that we now have purely in-memory log
> items better somewhere?  I see how this works, but it its a little
> non-obvious.

We already have in-memory log items, just not explicitly named. That
is, the transaction delta structures for the superblock and dquot
modifications.

I eventually want to move them to in-memory log items to get all the
special case code for them out of the transaction commit path, and
then add in-memory log items for AGF and AGI header modifications so
that we can move away from AG header buffer locking to serialise AG
specific operations...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
