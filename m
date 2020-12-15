Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7122C2DAF96
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Dec 2020 16:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgLOO5X (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Dec 2020 09:57:23 -0500
Received: from sandeen.net ([63.231.237.45]:38386 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729908AbgLOO5X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Dec 2020 09:57:23 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0B6B14CDD41;
        Tue, 15 Dec 2020 08:55:47 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
References: <20201208181027.GB1943235@magnolia>
 <20201208191913.GB1685621@bfoster> <20201209032624.GH1943235@magnolia>
 <20201209041950.GY3913616@dread.disaster.area>
 <20201209155211.GB1860561@bfoster> <20201209170428.GC1860561@bfoster>
 <20201209205132.GA3913616@dread.disaster.area>
 <20201210142358.GB1912831@bfoster>
 <20201210215004.GC3913616@dread.disaster.area>
 <20201211133901.GA2032335@bfoster> <20201211233507.GP1943235@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <eeab4862-e41f-d32c-24a7-4de336ca0c3c@sandeen.net>
Date:   Tue, 15 Dec 2020 08:56:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201211233507.GP1943235@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/11/20 5:35 PM, Darrick J. Wong wrote:
>>> Finally, no, we can't have a truly empty log while the filesystem is
>>> mounted because log transaction records must not be empty. Further,
>>> we can only bring the log down to an "empty but not quite clean"
>>> state while mounted, because if the log is actually marked clean and
>>> we crash then log recovery will not run and so we will not clean up
>>> files that were open-but-unlinked when the system crashed.

> Whatever happened to Eric's patchset to make us process unlinked inodes
> at mount time so that freeze images wouldn't require recovery?

It suffered a fate typical of my patches.  You observed an issue in a test,
Dave did some brief triage, and I haven't gotten back to it.

I'd still like to do that if we can, the requirement to run recovery and/or
use xfs-specific mount options to get a snapshot mounted is still a weird wart.
Pretty sure I've seen at least one user who thought we completely failed
to generate consistent snapshots because "the log was dirty" and
"I had to run repair."

So it'd still be nice to get rid of that behavior IMHO.

-Eric
