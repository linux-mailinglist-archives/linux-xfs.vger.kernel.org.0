Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDC27E648C
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Nov 2023 08:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbjKIHke (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 Nov 2023 02:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbjKIHkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 02:40:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F219A2D69
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 23:39:46 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5683BC433C8;
        Thu,  9 Nov 2023 07:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699515586;
        bh=VlSIsIgqyWIBkdurEt7sHqt+bxDyaPIL6Ehg14Nv8EE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l0iDPaVwOPkiUAMuAF76Caf6nQ2TSirlXjCU+GVDKr4ppi4lb3ovbJCcrhNkpEpJc
         rAkadLtTwPdR3ODwh9m1DoiJpciTp7OUFwzhdr9HbRcLLqMoZQh7T+1I/XrGlJcP7d
         YW9V+m/GvB08pZZKhf4rZvVvR2BHPD4/NvB/1a3+czxRDkR6+4w10y9dUIZ4i5QM87
         ThFnfyH7hI9USvUK4S9ciFDSOAZiQ7JDaw2bmkuREZxjS1aF1JtBsn2WVHvCsljGoI
         CCuTeoFZi6FFVF0kSvKe/b/k1LN0o6I6u6a7qW4nHC3WYkWSvFOWRO5Nxpi5gk2Eav
         8h50eh6G9QU0w==
Date:   Wed, 8 Nov 2023 23:39:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Chandan Babu R <chandanbabu@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        catherine.hoang@oracle.com, cheng.lin130@zte.com.cn,
        dchinner@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, osandov@fb.com
Subject: Re: [GIT PULL] xfs: new code for 6.7
Message-ID: <20231109073945.GE1205143@frogsfrogsfrogs>
References: <87fs1g1rac.fsf@debian-BULLSEYE-live-builder-AMD64>
 <CAHk-=wj3oM3d-Hw2vvxys3KCZ9De+gBN7Gxr2jf96OTisL9udw@mail.gmail.com>
 <20231108225200.GY1205143@frogsfrogsfrogs>
 <20231109045150.GB28458@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109045150.GB28458@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 05:51:50AM +0100, Christoph Hellwig wrote:
> On Wed, Nov 08, 2023 at 02:52:00PM -0800, Darrick J. Wong wrote:
> > > Also, xfs people may obviously have other preferences for how to deal
> > > with the whole "now using tv_sec in the VFS inode as a 64-bit sequence
> > > number" thing, and maybe you prefer to then update my fix to this all.
> > > But that horrid casts certainly wasn't the right way to do it.
> > 
> > Yeah, I can work on that for the rt modernization patchset.
> 
> As someone who has just written some new code stealing this trick I
> actually have a todo list item to make this less horrible as the cast
> upset my stomache.  But shame on me for not actually noticing that it
> is buggy as well (which honestly should be the standard assumption for
> casts like this).

Dave and I started looking at this too, and came up with: For rtgroups
filesystems, what if rtpick simply rotored the rtgroups?  And what if we
didn't bother persisting the rotor value, which would make this casting
nightmare go away in the long run.  It's not like we persist the agi
rotors.

--D
