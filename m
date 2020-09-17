Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C7026D56D
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 09:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIQH6c (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 03:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQH6b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:58:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423CAC06174A;
        Thu, 17 Sep 2020 00:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FNG3Pq9gvAzZuyW1QCtjQaJ9ZAkjI0it26WiOBFWJx4=; b=RJf36BDVsr9CNIMGuZC/4FEQLR
        2wAiWuWcYVgDkh0uRFNZLdteiaQxizpdCh8pn4ZhX/JpMlY7kjHqkTSh11vfIx2sodvXocQVbrZoO
        cGGgfRBwCfcJEmXNaUBi6QtlvPffdrZnf/4QRbWI3dRzRssfJROm9xmn6dkVyKjLA7Crs3WquGgbL
        qKzEXklyutaXPWHUS2SREW5vMAMvklTBOb1oQH+QR8l8gCzId79CkBWklJFdb1sk++OBG5p82ngGY
        lJj4s/KntN/ABjgPiimZJKsLwKwdyL5cyZlZoh1RtYarYsPhflMIukz8H9ZbAmOxY7MkJrWtB6Dwn
        8EUyE3hg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIooH-0007V3-5I; Thu, 17 Sep 2020 07:58:29 +0000
Date:   Thu, 17 Sep 2020 08:58:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 16/24] xfs/098: adapt to external log devices
Message-ID: <20200917075829.GM26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013427739.2923511.11743171089779718213.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013427739.2923511.11743171089779718213.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:44:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach this test to deal with external log devices correctly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
