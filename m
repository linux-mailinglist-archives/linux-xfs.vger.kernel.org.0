Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A474520F100
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jun 2020 10:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731781AbgF3I5i (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jun 2020 04:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731639AbgF3I5i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 04:57:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26BFC061755;
        Tue, 30 Jun 2020 01:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kE9wxlddwelBGVB/Y6TI6m2LRXPO5/frNH3uoUED72o=; b=ShU9An0u1w5AzvipJCcUbeNI9b
        MdhYFhcrV+E2X+p4a4ql+tl2fHf7oObOwZZCNPKx7lte4sB4MCcz0lpcjos2oopZP9i7GKJcfiyeb
        QqoCkYF/OQOH4YvwiZB8s9Wh4ObnqHh6fn0bCA7YWTlm/gp/utUCOuMGkPhKhhD3iSRtJ8bS2qZhH
        /hhMIr73JitY6j+4inkz/lTwsn+ScghAXKKHGBAYPDtknH1stNAHWi8DBSKPl8T291T73hD0VXVDM
        abP3QH5s5Fw44qXOOZmxmP6RtRRtNdjafgjohbQt4B6sNZ/PsNpUjMHYoBIk6IuKKfswPF6oeJ0y4
        vd+OfvVw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqC59-0001ow-Ed; Tue, 30 Jun 2020 08:57:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B0DEC305B36;
        Tue, 30 Jun 2020 10:57:32 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9A69421405126; Tue, 30 Jun 2020 10:57:32 +0200 (CEST)
Date:   Tue, 30 Jun 2020 10:57:32 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [Bug, sched, 5.8-rc2]: PREEMPT kernels crashing in
 check_preempt_wakeup() running fsx on XFS
Message-ID: <20200630085732.GT4817@hirez.programming.kicks-ass.net>
References: <20200626004722.GF2005@dread.disaster.area>
 <20200626073345.GI4800@hirez.programming.kicks-ass.net>
 <20200626223254.GH2005@dread.disaster.area>
 <20200627183042.GK4817@hirez.programming.kicks-ass.net>
 <20200629235533.GL2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629235533.GL2005@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 09:55:33AM +1000, Dave Chinner wrote:
> Sure, but that misses the point I was making.
> 
> I regularly have to look deep into other subsystems to work out what
> problem the filesystem is tripping over. I'm regularly
> looking into parts of the IO stack, memory management, page
> allocators, locking and atomics, workqueues, the scheduler, etc
> because XFS makes extensive (and complex) use of the infrastructure
> they provide. That means to debug filesystem issues, I have to be
> able to understand what that infrastructure is trying to do and make
> judgements as to whether that code behaving correctly or not.
> 
> And so when I find a reproducer for a bug that takes 20s to
> reproduce and it points me at code that I honestily have no hope of

20s would've been nice to have a week and a half ago, the reproduce I
debugged this with took days to trigger.. a well, such is life.

> understanding well enough to determine if it is working correctly or
> not, then we have a problem.  A lot of my time is spent doing root
> cause analysis proving that such issues are -not- filesystem
> problems (they just had "xfs" in the stack trace), hence being able
> to read and understand the code in related core subsystems is
> extremely important to performing my day job.
> 
> If more kernel code falls off the memory barrier cliff like this,
> then the ability of people like me to find the root cause of complex
> issues is going to be massively reduced. Writing code so smart that
> almost no-one else can understand has always been a bad thing, and
> memory barriers only make this problem worse... :(

How about you try and give me a hint about where you gave up and I'll
try and write better comments?
