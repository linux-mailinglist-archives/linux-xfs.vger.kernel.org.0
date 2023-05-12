Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719147011FC
	for <lists+linux-xfs@lfdr.de>; Sat, 13 May 2023 00:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbjELWBn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 May 2023 18:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238499AbjELWBm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 May 2023 18:01:42 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0567D8A
        for <linux-xfs@vger.kernel.org>; Fri, 12 May 2023 15:01:39 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-643aad3bc41so9674105b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 May 2023 15:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683928899; x=1686520899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tswq+u/7DnQKUWsxaX/TPusQBjaxLqyKXFCG1j3y7qs=;
        b=aeXAEAA56W6n0qLu8KBmP6FMNpeolNOZVZzCJeUznOjWaq2WwaDBSoC4NoM35QJW0P
         S6Ydo8TmmOWNnSP7i9cUEVhnSf3XErAs/UM/LYCDYqKDaaxemTxDPmv4wOxQE2eheJx3
         UctwHZtqKmEIhSLCCY4RQNsUwpigdpdBdkQW1z6L5/42PSi3ewXC7YEiQBFXEgy3qMLk
         KDkl8BHJH7ey4gJyCqHTAhW5qc5uuMPRANRHl2KSClA6dxbiYrV1PwDej/4HKWqEYn7Z
         Y7FpjPQy5yxbMTnYzYJFvIiQ458bVEpIC6X2smSH8+8N9DH//62QLEq+0YuJbBaxJFlp
         IeNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683928899; x=1686520899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tswq+u/7DnQKUWsxaX/TPusQBjaxLqyKXFCG1j3y7qs=;
        b=mBy9YWPB4dZGCktWclxeJ6b1iHt36+/WFion9Va5L+kgMVSsAZXMjz36XQltZdUR/n
         X8C4pO52EJuLQTms1cK5S0YsLQLyjnfyy8Bx9uecIvrO4noHgrwnHr2ijn3R8C4noJa2
         UMXfw1mZ7JsVtrfB357p9wkXsCekN/hDejt3sStS5cfjmvT64EO7SB94o75ZDKFQ4IZ2
         ux95OuopUD7JkCaqtYdRnx3TBKGH9tbdhStBj3v48VgHN/FUSTXno5uveugFz2yeJpwp
         OcJS+s4hquvS/xWONY+zo2+DIe6KQrSi3m/cAGwAiAalSoYYnXTZlIrU3mE1vQ1Cn5qB
         GSeQ==
X-Gm-Message-State: AC+VfDzVcNzN4wTF5qTxZ7ZQyyNehlMAoAYmfAXobFQDq8PYp1eoEzxl
        a6kG6ksCty7poojxvzHKJeb+fg==
X-Google-Smtp-Source: ACHHUZ7gpXTI4xiDKS4rdqI8l/6UtG47tQalVy5J0Mz1ARWISM9ZhsPVRya1x5qOWqWPAIlmQ+a+Vw==
X-Received: by 2002:a05:6a00:cc3:b0:63b:84a4:7b0 with SMTP id b3-20020a056a000cc300b0063b84a407b0mr34888943pfv.30.1683928899318;
        Fri, 12 May 2023 15:01:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id j23-20020aa79297000000b00642e9b3c868sm7482384pfa.59.2023.05.12.15.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 15:01:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pxapT-00EYwR-20; Sat, 13 May 2023 08:01:35 +1000
Date:   Sat, 13 May 2023 08:01:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Tycho Andersen <tycho@tycho.pizza>
Cc:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tycho Andersen <tandersen@netflix.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] xfs: don't do inodgc work if task is exiting
Message-ID: <20230512220135.GD3223426@dread.disaster.area>
References: <20230511151702.14704-1-tycho@tycho.pizza>
 <20230512014547.GA3223426@dread.disaster.area>
 <ZF5YVNdeVNSoG08p@tycho.pizza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZF5YVNdeVNSoG08p@tycho.pizza>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 12, 2023 at 09:16:36AM -0600, Tycho Andersen wrote:
> On Fri, May 12, 2023 at 11:45:47AM +1000, Dave Chinner wrote:
> > 
> > Yeah, this is papering over the observed symptom, not addressing the
> > root cause of the inodegc flush delay. What do you see when you run
> > sysrq-w and sysrq-l? Are there inodegc worker threads blocked
> > performing inodegc?
> 
> I will try this next time we encounter this.
> 
> > e.g. inodegc flushes could simply be delayed by an unlinked inode
> > being processed that has millions of extents that need to be freed.
> > 
> > In reality, inode reclaim can block for long periods of time
> > on any filesystem, so the concept of "inode reclaim should
> > not block when PF_EXITING" is not a behaviour that we guarantee
> > anywhere or could guarantee across the board.
> > 
> > Let's get to the bottom of why inodegc has apparently stalled before
> > trying to work out how to fix it...
> 
> I'm happy to try, but I think it is also worth applying this patch.
> Like I said in the other thread, having to evac a box to get rid of an
> unkillable userspace process is annoying.

If inodegc is stuck, then it's only a matter of time before the
filesystem will completely lock up and you'll have to cycle the
machine anyway.  This patch merely kicks the can down the road a few
minutes, it doesn't change anything material.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
