Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EB27AEEE7
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Sep 2023 16:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjIZOz1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 26 Sep 2023 10:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234897AbjIZOz0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 10:55:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4483116
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 07:55:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAEBC433C8;
        Tue, 26 Sep 2023 14:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695740120;
        bh=UozyzOFL2CEx0/AaEb5BEQk+32KJY+xM/ijzd25lD/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zn1okHoGGUbw692yBZ101Yt16bd16wshDJWV3q7cSx7Cvph2TU7qvmYC8PExeNpdK
         0JygJRCRZKi543PCr7eaZKr9t+L0EgNdbZnIebDVM4Hzut1k3cnmU5OLKTgGEpzegn
         ofeT6UF96F1h/iuHjqBiWN8Zl3TSWnU7tY2nAQ2uVCQf9rHeIMjk4KD6s1yBmSsT/C
         qFJYOObv94ReWah0m+E9GrFYBuQ50grwdUimoblFeCbflk8gDsn85YLr+ctS9u8gNl
         B0wIJ6frF9iIc5EHUFwJNFzLGHVBvgLHtk5cO8y9DhKH1VvYeVKG1MNANPZZB9YTuE
         5XkPTzcoUJKqw==
Date:   Tue, 26 Sep 2023 07:55:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
        chandan.babu@oracle.com, dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <20230926145519.GE11439@frogsfrogsfrogs>
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2023 at 04:33:04PM +0800, Shiyang Ruan wrote:
> Hi,
> 
> Any comments?

I notice that xfs/55[0-2] still fail on my fakepmem machine:

--- /tmp/fstests/tests/xfs/550.out	2023-09-23 09:40:47.839521305 -0700
+++ /var/tmp/fstests/xfs/550.out.bad	2023-09-24 20:00:23.400000000 -0700
@@ -3,7 +3,6 @@ Format and mount
 Create the original files
 Inject memory failure (1 page)
 Inject poison...
-Process is killed by signal: 7
 Inject memory failure (2 pages)
 Inject poison...
-Process is killed by signal: 7
+Memory failure didn't kill the process

(yes, rmap is enabled)

Not sure what that's about?

--D

> 
> 
> --
> Thanks,
> Ruan.
> 
> 
> 在 2023/9/15 14:38, Shiyang Ruan 写道:
> > FSDAX and reflink can work together now, let's drop this warning.
> > 
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > ---
> >   fs/xfs/xfs_super.c | 1 -
> >   1 file changed, 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 1f77014c6e1a..faee773fa026 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -371,7 +371,6 @@ xfs_setup_dax_always(
> >   		return -EINVAL;
> >   	}
> > -	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
> >   	return 0;
> >   disable_dax:
