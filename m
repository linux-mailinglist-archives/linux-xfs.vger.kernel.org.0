Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2273FD56D
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Sep 2021 10:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243110AbhIAIcp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Sep 2021 04:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242943AbhIAIcp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 04:32:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028E1C061575;
        Wed,  1 Sep 2021 01:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZKxlWfYNLkEldS05PXlPWavHryKn5rOh2+PP1UGYNas=; b=E0wVf3XUmo3uEHQaNTRd70NDzL
        apjHmqT/agbOZ8FzqObHlLG98Qt6Z4xmBSpuxMOMFK4TiU18N6yBLXPuROavmvW+okqB76gt214CZ
        7f83Q8jxIHBtJXcC6D2HfrSrgyVvRrtQTKXLIh7DRyPIJXVAU7ZR0erkkPGpUTLJ4h1ywFgTzmegj
        ts2ZC4phNOYovUzPFPCsh1mqNH2fts1ss3t3TUslnnE8yitjIIR+h4UtTGwVoSmkiJ2Y0noaVYdEr
        QPpyVE3yqog5/Vpwo3fUysQYJ68qD6Q6MP1848bFzvhNlRS47n9P3iBpePCajAOe36rAM6Rit1JR9
        MPl/c3/w==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLLe2-0022pM-Vs; Wed, 01 Sep 2021 08:31:11 +0000
Date:   Wed, 1 Sep 2021 09:30:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] common/xfs: skip xfs_check unless the test runner
 forces us to
Message-ID: <YS86PmKsItIM6APZ@infradead.org>
References: <163045507051.769821.5924414818977330640.stgit@magnolia>
 <163045507618.769821.3650550873572768945.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045507618.769821.3650550873572768945.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 05:11:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> At long last I've completed my quest to ensure that every corruption
> found by xfs_check can also be found by xfs_repair.  Since xfs_check
> uses more memory than repair and has long been obsolete, let's stop
> running it automatically from _check_xfs_filesystem unless the test
> runner makes us do it.
> 
> Tests that explicitly want xfs_check can call it via _scratch_xfs_check
> or _xfs_check; that part doesn't go away.

Awesome!

Reviewed-by: Christoph Hellwig <hch@lst.de>
