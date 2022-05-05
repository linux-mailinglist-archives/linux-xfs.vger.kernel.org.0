Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA7B51B7DE
	for <lists+linux-xfs@lfdr.de>; Thu,  5 May 2022 08:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244206AbiEEGZO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 May 2022 02:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244257AbiEEGZL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 02:25:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BE73CA7B
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 23:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A831B828AC
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 06:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348D2C385A4;
        Thu,  5 May 2022 06:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651731690;
        bh=xA7b+/EnOSnWGGFeLjYontEK8283tv+mMh1RSgwgtjA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TKbs1RuXz38HwEZUIyk6jkkdGEo1cXoCTpzFKG2yJ15Akjho6PY79UP8CNLphIkKw
         lm7xCiMelFktA5CYn1N6bGeiIa4QBx0qo09MUwbUThptz8oox7as1+Y3DG4qCak82Q
         P3kTfvJt1Gzgv6FOlRXe1pG/dhK3xDdUEckh3DHJJruYxCtgeCALUJySS9ZOEf8nxE
         qd4TW0Y1muGXjn11W9rPkhVEoEnV+t51QFGrr978WZNZgzH2QqDBOv7uAgj+6EoFvg
         B88b3eJMINPhsi2FCxgnFCr/QoJyWqJQPAL65sv6Z+1olWjw8sqrQNw5D7a/LUa2FP
         VZtxJY7m1xpyA==
Date:   Wed, 4 May 2022 23:21:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 215927] kernel deadlock when mounting the image
Message-ID: <20220505062129.GC27195@magnolia>
References: <bug-215927-201763@https.bugzilla.kernel.org/>
 <bug-215927-201763-qVJPAGrN3y@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-215927-201763-qVJPAGrN3y@https.bugzilla.kernel.org/>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 05, 2022 at 05:46:45AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=215927
> 
> --- Comment #3 from Artem S. Tashkinov (aros@gmx.com) ---
> XFS maintainers? This looks like a serious issue.

Well then, you'd better help us triage and fix this.

"If you are going to run some scripted tool to randomly
corrupt the filesystem to find failures, then you have an
ethical and moral responsibility to do some of the work to
narrow down and identify the cause of the failure, not just
throw them at someone to do all the work."

--D

> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
