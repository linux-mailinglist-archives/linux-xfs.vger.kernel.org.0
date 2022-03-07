Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074B14D0C52
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Mar 2022 00:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238578AbiCGXwm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 7 Mar 2022 18:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343980AbiCGXwl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 18:52:41 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CAF1104
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 15:51:44 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V6afqUw_1646697100;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0V6afqUw_1646697100)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Mar 2022 07:51:42 +0800
Date:   Tue, 8 Mar 2022 07:51:40 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     David Dal Ben <dalben@gmail.com>,
        Eric Sandeen <esandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: Inconsistent "EXPERIMENTAL online shrink feature in use. Use at
 your own risk" alert
Message-ID: <YiaajBcdSgOyIamT@B-P7TQMD6M-0146.local>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        David Dal Ben <dalben@gmail.com>,
        Eric Sandeen <esandeen@redhat.com>, linux-xfs@vger.kernel.org
References: <CALwRca2+UsEZMPwiCtecM87HVVMs27SdawdWXns+PU7+S-DFaQ@mail.gmail.com>
 <CALwRca3yS2q4XYr5aFaPWxNcGsYRFDWeU9je1q31KGguTeX6Rw@mail.gmail.com>
 <YiYIO2lJf123LA2c@B-P7TQMD6M-0146.local>
 <CALwRca2bZD5tXmL5kzCdL97LpqWGVhYXMNSWSvqn=FkMuMrbjQ@mail.gmail.com>
 <9f957f7a-0f08-9cb4-d8ff-76440a488184@redhat.com>
 <CALwRca2Xdp8F_xjXSFXxO-Ra96W685o2qY1xoo=Ko9OWF4oRvw@mail.gmail.com>
 <20220307233132.GA661808@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220307233132.GA661808@dread.disaster.area>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 08, 2022 at 10:31:32AM +1100, Dave Chinner wrote:
> On Tue, Mar 08, 2022 at 06:46:58AM +0800, David Dal Ben wrote:
> > This is where I get out of my depth. I added the drives to unraid, it
> > asked if I wanted to format them, I said yes, when that was completed
> > I started migrating data.
> > 
> > I didn't enter any XFS or disk commands from the CLI.
> 
> Is there any sort of verbose logging you can turn on from the
> applicance web interface?
> 
> > 
> > What I can tell you is that there are a couple of others who have
> > reported this alert on the Unraid forums, all seem to have larger
> > disks, over 14tb.
> 
> I'd suggest that you ask Unraid to turn off XFS shrinking support in
> the 6.10 release. It's not ready for production release, and
> enabling it is just going to lead to user problems like this.
> 
> Indeed, this somewhat implies that Unraid haven't actually tested
> shrink functionality at all, because otherwise the would have
> noticed just how limited the current XFS shrink support is and
> understood that it simply cannot be used in a production environment
> yet.
> 
> IOWs, if Unraid want to support shrink in their commercial products
> right now, their support engineers need to be testing, triaging and
> reporting shrink problems to upstream and telling us exactly what is
> triggering those issues. Whilst the operations and commands they are
> issuing remains hidden from Unraid users, there's not a huge amount
> we can do upstream to triage the issue...

I'm not sure if it can reproduce on other distribution or it's just a
specific behavior with unraid distribution, and it seems that this
distribution needs to be paid with $ to get more functionality, so I
assume it has a professional support team which can investigate more,
at least on the userspace side.

In the beginning, we've discussed informally if we needed to add
another "-S" option to xfs_growfs to indicate the new shrink behavior
for users. And the conclusion was unnecessary. And I think for the case
mentioned in the original thread, it didn't actually do anything.

Thanks,
Gao Xiang

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
