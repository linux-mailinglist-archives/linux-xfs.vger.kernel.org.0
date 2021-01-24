Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC74301AE1
	for <lists+linux-xfs@lfdr.de>; Sun, 24 Jan 2021 10:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbhAXJmS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 24 Jan 2021 04:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbhAXJmQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jan 2021 04:42:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC424C061573
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jan 2021 01:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MvWeUeyAOTjFVD3e7YU+OTGORSxonlGYn/QHee/D+SU=; b=ZlJx/8AWE+GEgFIxDukeOtE0m2
        wPLZqHSNoNDSkLaWebQ8d2+acl8T4h9k2CGohVIDuEvma6viOrC9FiqVi4lMvAa7xOd7GV7y5jKHO
        kXbjkT2nkKSp5xr0vtVXhP1XwHWTnPmcy8FbhRy+u2SgJLhrG4opKWz+SWuyn48fJY2ZTEiwcSENN
        2Dou66IApeF6G8N9aD/JdNzCayH7rU/ZpYx974ElYe7QAInEGZ4SdDmWCnqtgCNU768AtSThfR611
        psXJ8aAoEhLvAFvNsMwZyPn+kLknNPkSaXzdpzw7LYAaF7UDU0QmAujLuT015vBnm1C/55G9IIkvY
        C5SQvK4g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l3btT-002owv-Tk; Sun, 24 Jan 2021 09:41:21 +0000
Date:   Sun, 24 Jan 2021 09:41:15 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 10/11] xfs: refactor xfs_icache_free_{eof,cow}blocks call
 sites
Message-ID: <20210124094115.GD670331@infradead.org>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142797509.2171939.4924852652653930954.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142797509.2171939.4924852652653930954.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:52:55AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In anticipation of more restructuring of the eof/cowblocks gc code,
> refactor calling of those two functions into a single internal helper
> function, then present a new standard interface to purge speculative
> block preallocations and start shifting higher level code to use that.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
