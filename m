Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67BB535387
	for <lists+linux-xfs@lfdr.de>; Thu, 26 May 2022 20:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239715AbiEZSoh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 May 2022 14:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbiEZSog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 14:44:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BAC2ED45;
        Thu, 26 May 2022 11:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jHfzdIxXRjcU2OsXqBWbI31b/4/4HnK+RG6XqWc8nTw=; b=25rN3AKl7gpPJGe21jhnk5ThFa
        bopRbcWorKTkgPlYhwqRisULlLl/W2ywhk6f+MDbqYKqHCdAbbzGJvMmfS6yMHm5ETk8fGk7ApRWr
        kyYRRNQFO2N3UC6BW4jOykJduWKm3FseCbS6WI5XRnM0xlv9DguEsIj+DIGwgsax/Pmtiu7PhhTLN
        QU/v+nnMW048cA+qsljXu8UIL/TPAFLzqz3cMh+OdeScn4PpLGZNaQka/5BvOeGZtFvAIqPuKaTor
        rt/akJ+lYyshvnSs2eUaQvJIixENdMt3INQsI6AkSyHb8xO7SckMl/dZGDRbb1USa9M2ZE4lCcpp9
        RfbND/aw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nuITB-00Fdc3-6d; Thu, 26 May 2022 18:44:25 +0000
Date:   Thu, 26 May 2022 11:44:25 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>, Tso Ted <tytso@mit.edu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, Leah Rumancik <lrumancik@google.com>,
        masahiroy@kernel.org
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
Message-ID: <Yo/KibX8TOj+rZkV@bombadil.infradead.org>
References: <20220525111715.2769700-1-amir73il@gmail.com>
 <Yo+4jW0e4+fYIxX2@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo+4jW0e4+fYIxX2@magnolia>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 10:27:41AM -0700, Darrick J. Wong wrote:
> /me looks and sees a large collection of expunge lists, along with
> comments about how often failures occur and/or reasons.  Neat!
> 
> Leah mentioned on the ext4 call this morning that she would have found
> it helpful to know (before she started working on 5.15 backports) which
> tests were of the flaky variety so that she could better prioritize the
> time she had to look into fstests failures.  (IOWS: saw a test fail a
> small percentage of the time and then burned a lot of machine time only
> to figure out that 5.15.0 also failed a percentage of th time).

See my proposal to try to make this easier to parse:

https://lore.kernel.org/all/YoW0ZC+zM27Pi0Us@bombadil.infradead.org/

> We talked about where it would be most useful for maintainers and QA
> people to store their historical pass/fail data, before settling on
> "somewhere public where everyone can review their colleagues' notes" and
> "somewhere minimizing commit friction".  At the time, we were thinking
> about having people contribute their notes directly to the fstests
> source code, but I guess Luis has been doing that in the kdevops repo
> for a few years now.
> 
> So, maybe there?

For now sure, I'm happy to add others the linux-kdevops org on github
and they get immediate write access to the repo. This is working well
so far. Long term we need to decide if we want to spin off the
expunge list as a separate effort and make it a git subtree (note
it is different than a git sub module). Another example of a use case
for a git subtree, to use it as an example, is the way I forked
kconfig from Linux into a standalone git tree so to allow any project
to bump kconfig code with just one command. So different projects
don't need to fork kconfig as they do today.

The value in doing the git subtree for expunges is any runner can use
it. I did design kdevops though to run on *any* cloud, and support
local virtualization tech like libvirt and virtualbox.

The linux-kdevops git org also has other projects which both fstest
and blktests depend on, so for example dbench which I had forked and
cleaned up a while ago. It may make sense to share keeping oddball
efforts like thse which are no longer maintained in this repo.

There is other tech I'm evaluating for this sort of collaborative test
efforts such as ledgers, but that is in its infancy at this point in
time. I have a sense though it may be a good outlet for collection of
test artifacts in a decentralized way and also allow *any* entity to
participate in bringing confidence to stable kernel branches or dev
branches prior to release.

  Luis
