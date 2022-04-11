Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C271C4FB164
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Apr 2022 03:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbiDKBf5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 10 Apr 2022 21:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240223AbiDKBf4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 21:35:56 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 566A54131C
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 18:33:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 40A7453BA99;
        Mon, 11 Apr 2022 11:33:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndiw1-00GFYg-QN; Mon, 11 Apr 2022 11:33:41 +1000
Date:   Mon, 11 Apr 2022 11:33:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V9.1] xfs: Directory's data fork extent counter can never
 overflow
Message-ID: <20220411013341.GT1544202@dread.disaster.area>
References: <20220406061904.595597-16-chandan.babu@oracle.com>
 <20220409134721.471501-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409134721.471501-1-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62538577
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=XBDxVsr5D8Fr1aKvmF0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 09, 2022 at 07:17:21PM +0530, Chandan Babu R wrote:
> The maximum file size that can be represented by the data fork extent counter
> in the worst case occurs when all extents are 1 block in length and each block
> is 1KB in size.
> 
> With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
> 1KB sized blocks, a file can reach upto,
> (2^31) * 1KB = 2TB
> 
> This is much larger than the theoretical maximum size of a directory
> i.e. XFS_DIR2_SPACE_SIZE * 3 = ~96GB.
> 
> Since a directory's inode can never overflow its data fork extent counter,
> this commit removes all the overflow checks associated with
> it. xfs_dinode_verify() now performs a rough check to verify if a diretory's
> data fork is larger than 96GB.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
