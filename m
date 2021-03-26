Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045A734A167
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Mar 2021 07:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhCZGFI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Mar 2021 02:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhCZGE7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Mar 2021 02:04:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CABC0613AA
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 23:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=blUPq0teoga+gleb2/Og7dc0uamwV2l5HCHxhpsqFgk=; b=P4ldYwXvaHp+jeuq8jW8dkDYt1
        ZossG+9shtjDv3vsE/ZeCqzRiFvTsjRChiSYfkOMwRKgVO8I2J1X6F4IhhhIULILTDN9hdbkkAtX9
        zk41ahHrLtsTWq0Tz2mtn8UMRKML4DlTTCb9fbiO1RLC8R1SgRDAUTFByylI1ONR6hpzq55btXMx0
        5edKBgO+yXyHhpBZRj3C3VFaoggso4k5ZEiI/X8S47oOb8tF1RSXINtpC5LIUsGPTFRcn9SYthV3h
        FxYknLlnvVhR1KESGtcE4gQynZPxkrrm3dHP+mAqOAYU+6mRz0FzUOIArV8WwdyYlGiyDLG72ZBX1
        l9x9lchg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lPfa5-00EMiO-Ab; Fri, 26 Mar 2021 06:04:52 +0000
Date:   Fri, 26 Mar 2021 06:04:25 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/6] xfs: remove iter_flags parameter from
 xfs_inode_walk_*
Message-ID: <20210326060425.GC3421955@infradead.org>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
 <161671808412.621936.9290234722714661435.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161671808412.621936.9290234722714661435.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 05:21:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The sole iter_flags is XFS_INODE_WALK_INEW_WAIT, and there are no users.
> Remove the flag, and the parameter, and all the code that used it.
> Since there are no longer any external callers of xfs_inode_walk, make
> it static.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
