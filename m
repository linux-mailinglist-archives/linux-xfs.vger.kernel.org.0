Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342212FB20A
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Jan 2021 07:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbhASGug (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Jan 2021 01:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbhASGuP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 01:50:15 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C12C0613C1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 22:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EVEr2M29Xsg0aPKOCEksqG7McT+Blxv9JB/fEnY5yM0=; b=jnMpa3c4+R0gNksVOt9X36AavL
        afdtxYBhwdxGyXZ0kNYSh7FR8iIjVAH0LaCD06rxI2HtPYiJx05ZuppokMdC8sVPZWmy5rljLUUyW
        7uwhx9ldcEG7VXyU2HA0573ByHgq1gaSiwY++pqGwUpvxLIlu9DaZHqB2HXfHYPm+j9zO43tnU29D
        uvPkXwybI9boit3uDcrcJRhApNxwj2eYZd57RI/LcdtBAgJ91jNC1PeNhK4z1CV7pv4beoaPgx2OJ
        89/jsIfg5mfr18eLY7S0VPxAZE/h7/NsluRLUJOGrp9TgkJiVgBmhutNgomzhcl8ogggUPv8jDWgg
        uk2o9WZA==;
Received: from 089144206130.atnat0015.highway.bob.at ([89.144.206.130] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1koo-00Dv9h-Tq; Tue, 19 Jan 2021 06:49:04 +0000
Date:   Tue, 19 Jan 2021 07:46:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: clean up icreate quota reservation calls
Message-ID: <YAaASyN9AUBZN2Dj@infradead.org>
References: <161100789347.88678.17195697099723545426.stgit@magnolia>
 <161100791592.88678.7280544229099188181.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100791592.88678.7280544229099188181.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 02:11:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a proper helper so that inode creation calls can reserve quota
> with a dedicated function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
