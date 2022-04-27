Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B78511054
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Apr 2022 06:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237234AbiD0E7d (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 27 Apr 2022 00:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345295AbiD0E7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 00:59:32 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1AD7E0BF
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 21:56:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8A8B910E6029;
        Wed, 27 Apr 2022 14:56:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njZiu-0051kr-FQ; Wed, 27 Apr 2022 14:56:20 +1000
Date:   Wed, 27 Apr 2022 14:56:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: factor and move some code in xfs_log_cil.c
Message-ID: <20220427045620.GN1098723@dread.disaster.area>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-6-david@fromorbit.com>
 <20220427031530.GE17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427031530.GE17025@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6268ccf6
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=sOxkKjT2bXPzriMPn8gA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 08:15:30PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 27, 2022 at 12:22:56PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > In preparation for adding support for intent item whiteouts.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks like a straight hoist?

Yup, I pulled this from the CIL scalability patchset because it
provides better isolation for the upcoming whiteout changes in this
code.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
