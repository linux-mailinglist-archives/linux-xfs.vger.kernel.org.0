Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE904F71AC
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Apr 2022 03:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbiDGBpX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 Apr 2022 21:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239132AbiDGBol (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 21:44:41 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 377C61C2334
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:42:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 21B1510E5719;
        Thu,  7 Apr 2022 11:42:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ncH9v-00EflI-LU; Thu, 07 Apr 2022 11:42:03 +1000
Date:   Thu, 7 Apr 2022 11:42:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V9 18/19] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
Message-ID: <20220407014203.GH1544202@dread.disaster.area>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-19-chandan.babu@oracle.com>
 <20220407012912.GT27690@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407012912.GT27690@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=624e416d
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=BC6goKnVEaZnpyYE9XkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 06, 2022 at 06:29:12PM -0700, Darrick J. Wong wrote:
> > diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> > index 2cf3872fcd2f..0150fd53d18e 100644
> > --- a/fs/xfs/xfs_itable.h
> > +++ b/fs/xfs/xfs_itable.h
> > @@ -19,6 +19,8 @@ struct xfs_ibulk {
> >  /* Only iterate within the same AG as startino */
> >  #define XFS_IBULK_SAME_AG	(1 << 0)
> >  
> > +#define XFS_IBULK_NREXT64	(1 << 1)
> 
> Needs a comment here.
> 
> /* Fill out the bs_extents64 field if set. */
> #define XFS_IBULK_NREXT64	(1U << 1)
> 
> (Are we supposed to do "1U" now?)

Apparently so. I'm not concerned by this specific patchset right now
because we've got so many unsigned bit fields that need bulk
updates.

I'm slowly working through the ones that are used in__print_flags
macros right now (that'll be 16-17 patches by itself), and once
those are done we can worry about the rest as ongoing individual
cleanups...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
