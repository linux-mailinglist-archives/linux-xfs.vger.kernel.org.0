Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA01C32E3AC
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Mar 2021 09:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCEIae (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Mar 2021 03:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhCEIaK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 03:30:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C9EC061574
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 00:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lSKqtSMQHt7iNIZI0IVPJnyFcEzmxC7l0cPGCiCM9o8=; b=YRkUVDzhFTr6W6i61AQKPC1wns
        vj1JHo05c+C1RvB5mn+xd1XKHwnH9JVIOXNucOREqPKUG1imRUS5YbzF+XLZY061Bc4+BUI7isbZi
        XJgXsHzlfbdEpo9zRbRPwu7VujlJ13vhcJ78U1toVCZtA9jSgeRgsdZJfzlCcyMmDMjroV2YrNGBt
        k9IMYfYbHllMDtsaNGz7pz86x4wcj+JXb7DQydc6CzKZrpN5TSF9MiZxVZMVxiu7I6/M0mPOIUmy9
        ziT9kMjA2q35Qs2uMUU2GyGw81woyIJbCQRNyBHunhE8YRU534R0RFJa7XnPvGZoujTVG3ZLBYqVz
        R+4oUoCg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lI5qH-00Aq2b-IR; Fri, 05 Mar 2021 08:29:59 +0000
Date:   Fri, 5 Mar 2021 08:29:49 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: validate ag btree levels using the precomputed
 values
Message-ID: <20210305082949.GG2567783@infradead.org>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
 <161472415607.3421582.13410103932115410995.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161472415607.3421582.13410103932115410995.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 02:29:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use the AG btree height limits that we precomputed into the xfs_mount to
> validate the AG headers instead of using XFS_BTREE_MAXLEVELS.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
