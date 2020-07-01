Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E712106C8
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jul 2020 10:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgGAI5A (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Jul 2020 04:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgGAI47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:56:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DBCC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K1khMx8Jgyv6f/JapXuBV8+KvuyHVsXHsuE/gmaycuM=; b=lP1MjZNMOVSvkwZWacMjrWzKfT
        Sc1Vdgr7sYNFClMjpPqcJLWi0/589g5NZSH4HHZUGa9AUpjrUe+taMhg0gj2b1KtE1SRwS+hCj3Mz
        S6u51ZQh7sdvEDeGL5jW4JT9hj6JnD3/cYMN5H8G/ZFcTPDWV1FZ6HrHSN2hMYJcWqqMqnsGxmSNU
        Gc5/MPTXI9mBqcCLq9oVuuZTMka1wxeV2xOBlGkRFIf+cdg4XA7UXG3mAETjXgDxTHxg6z4L6EDgc
        Y9mXSAcCyz1aNiJUd/M12IaioDVfNeRu/WPbI6nTVm3Kq4qg1b9Gw+XRkQy1p+7J9k2tt/hHyt6Bp
        itEo7sLg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYY5-0007xC-RP; Wed, 01 Jul 2020 08:56:57 +0000
Date:   Wed, 1 Jul 2020 09:56:57 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/18] xfs: refactor xfs_qm_scall_setqlim
Message-ID: <20200701085657.GO25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353180627.2864738.644970181923295002.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353180627.2864738.644970181923295002.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:43:26AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we can pass around quota resource and limit structures, clean
> up the open-coded field setting in xfs_qm_scall_setqlim.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
