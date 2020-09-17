Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEAA26D564
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 09:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgIQH4q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 03:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIQH4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:56:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC54C06174A;
        Thu, 17 Sep 2020 00:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5AZ9TG3YwRrskJFF5R/En9uxzz8iVrJS52xp829jnMA=; b=o0eYwUgjGIk0di7kU1DRoGjVyA
        e73rt7XwRzd8qoUXw1xq3aOUg2xUI/Ar0HQ4BFYf4Y45MWsoeWEGBIlWu8DWcMf5tGJArzVAik7Pb
        aubONDbprFmWUm9sppe4RVMOOjeBPcdeeQQOcMgoDJ6GDwrEapslGVFO2qNujJBcQzgxRXylOKb9/
        rFyh5T/9VtHbyeS2A+whusBx9R5W1tvbKXcB41krpdCVVp7F4WtB8df06m7djesuFZARGQ2z8N2iy
        8kmEfZuf/5TWMLTchVVvDo1YS2EWBPFBOFnWFh4Pgnj5Ocp9Nk37i4jhogdDa3CWPOzH3mcsAFPmS
        YLJwIxUA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIomR-0007PW-Ol; Thu, 17 Sep 2020 07:56:35 +0000
Date:   Thu, 17 Sep 2020 08:56:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 13/24] generic/204: don't flood stdout with ENOSPC
 messages on an ENOSPC test
Message-ID: <20200917075635.GK26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013425839.2923511.10488499486430760605.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013425839.2923511.10488499486430760605.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:44:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This test has been on and off my bad list for many years due to the fact
> that it will spew potentially millions of "No space left on device"
> errors if the file count calculations are wrong.  The calculations
> should be correct for the XFS data device, but they don't apply to other
> filesystems.
> 
> Therefore, filter out the ENOSPC messages when the files are not going
> to be created on the xfs data device (e.g. ext4, xfs realtime, etc.)

Should this move to an xfs specific test instead?
