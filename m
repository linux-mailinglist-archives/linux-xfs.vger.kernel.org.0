Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96A61C74ED
	for <lists+linux-xfs@lfdr.de>; Wed,  6 May 2020 17:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgEFPcD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 May 2020 11:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbgEFPcB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:32:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641E5C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0NDtX6eWR00l7rgEcZGvi4BWHDqFZ7lvigpxACxFr7w=; b=eBwmmXVJB2fLyFLgiu/HHOZJMH
        47eVObQgUFXAfquwKvE8insQU51rfmK070gppDrGRGBrxTlZuF0Sx8X/+dIN66ctn7VdKaiXp4Zhk
        4SxGuXwobKKXubMLbi+FxfD4Y7rt9cSWIOYLiBpZ55mG7a6Xf1J5dMp/v7pJ/bBCL5SHxZ0iZZe7L
        jnSGUSwTHlJt+B50prt+Ukimp4OceEPOIOXdLeAuxbr2ceFAU0jdrLn4HoiSDUAeupBptGTZXutE6
        0JAgPtsXHgV+DbwDGszG4wotUvTv9YmbxxJmQ+h3BVmHWawt4VO20CTqJbIfXr9QFfRJC2NL6qe+f
        lyZ6EACg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWM1h-0005wG-A8; Wed, 06 May 2020 15:32:01 +0000
Date:   Wed, 6 May 2020 08:32:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/28] xfs: refactor intent item RECOVERED flag into the
 log item
Message-ID: <20200506153201.GB7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864117994.182683.5443984828546312981.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864117994.182683.5443984828546312981.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:12:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename XFS_{EFI,BUI,RUI,CUI}_RECOVERED to XFS_LI_RECOVERED so that we
> track recovery status in the log item, then get rid of the now unused
> flags fields in each of those log item types.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
