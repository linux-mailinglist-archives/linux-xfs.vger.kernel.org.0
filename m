Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C191934A172
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Mar 2021 07:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhCZGJ7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Mar 2021 02:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhCZGJx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Mar 2021 02:09:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095B0C0613AA
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 23:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AVDshHif2EO9cQch22MdFYhD4j2K8ziY66rEMFVlKaU=; b=u8xsRtakckhoQ0fM9qPgH6mxV9
        4sDgk6j0gImPopQl0JuX4ssQcvMWgU/cNEOc44kriMgVblvg5EJxajRXxImQYgbUM8eHO3i1tkZ/B
        NytO+j6yG6XilFWj/4wUrH383pggEhFWuIG6j1XQcBh+pMBvSsros9wikSssatLTCCjDccNyRzghe
        1nE8NlfVxsp646dew+EpqI/9xQtDTwd1bo+um5a9Al4BE0+qpcPYN8c3u8kABQHMHlfvaAGxDXa6J
        lajIw/oKIw9u7db6JOWmzwk4RJZ1uRz+HF3ZuWEYWvnSbuObbd8ZwsAmU3J4NMmXuYBv9GsVd3kDg
        3/0jBsYA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lPffH-00EN1w-Ka; Fri, 26 Mar 2021 06:09:47 +0000
Date:   Fri, 26 Mar 2021 06:09:47 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 4/6] xfs: pass struct xfs_eofblocks to the inode scan
 callback
Message-ID: <20210326060947.GE3421955@infradead.org>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
 <161671809523.621936.2714947336807513527.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161671809523.621936.2714947336807513527.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 05:21:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Pass a pointer to the actual eofb structure around the inode scanner
> functions instead of a void pointer, now that none of the functions is
> used as a callback.

Looks so good that it could be from me :)

Reviewed-by: Christoph Hellwig <hch@lst.de>
