Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B5134A16C
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Mar 2021 07:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhCZGJZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Mar 2021 02:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhCZGJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Mar 2021 02:09:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7768C0613AA
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 23:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hz7fFMhii5bckRh2TwCToaLLYp3yONsGIanFtnhZynI=; b=v3XWhzZqj14D0d6v6sJj/E0jgV
        zoSrRbHK0pq7Zf+inlZeAdx4q5RUh+nxy+VettL57YoV+aA9HBxtWwEL494xeJg36TKlCZoMXLqKW
        AwKtzm80gSR4eAIKF4IgHTrHMaGsvW1x28wdO+QLZ7YuytV0tbh7fkLASFDv5cPPucauG9SAZCKhh
        ZXk1larRhjKUVBAsaD6Qy5fPVgTCfJBj0zPcN+Y0idKovk8Ob2/J7PMD/dyoTmEnzZeF7JITIxYgi
        v3jw6Lf4s3QDcMMckyMQ9k7vDie7NFvbdDp/akmldW12Yz6C/rNKG6kMoRhAJxUfLQF2qse7D4ID2
        v6PyXiLA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lPfeJ-00EMzq-Ax; Fri, 26 Mar 2021 06:08:53 +0000
Date:   Fri, 26 Mar 2021 06:08:47 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/6] xfs: remove indirect calls from xfs_inode_walk{,_ag}
Message-ID: <20210326060847.GD3421955@infradead.org>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
 <161671808966.621936.3793779587892431825.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161671808966.621936.3793779587892431825.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +/* Forward declarations to reduce indirect calls */
> +static int xfs_blockgc_scan_inode(struct xfs_inode *ip, void *args);

While we try to avoid forward declarations I don't think we really need
a comment justifying it.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
