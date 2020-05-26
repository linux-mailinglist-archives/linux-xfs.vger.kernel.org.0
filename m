Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFBE1CC79E
	for <lists+linux-xfs@lfdr.de>; Sun, 10 May 2020 09:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgEJH10 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 10 May 2020 03:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgEJH1Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:27:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A05C061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hGNu1470RIJDcUP6Qd2lA7d+Q9jycFRawhT9GtQ2I+Q=; b=NmRaPnkNl1XbZLhCq2m8+np61a
        HHXRtcZ5vQKLAGgJAhUqKXvCMFbR96jJOMuCYuxTCd75p0umo+XNrykP2cEbzskQrehclUpanSgK0
        l9TVbkLWS2b1dXQwFA5xK/227v3Y+UaBX4wU33eLDdHUG/SIII+X3vHGg3PsgaI8Aw1O09fRrz0Ic
        nADkjKVTh/hQYVdhFQH8UFWEADa0I1gEbyVdqI7wQj7lZvNHmfRJ9M2oGD56NjeJsCqAtBReQdzzY
        LUInuHeOc22rLgKmXgL7olVZBkqdDi/CXtgEL4dCmTLX8lQvqRRYjfyDZIys4eQByj7v6lamXjBRv
        jlICE0LQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgMv-0007Vk-4L; Sun, 10 May 2020 07:27:25 +0000
Date:   Sun, 10 May 2020 00:27:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/16] xfs_repair: complain about any nonzero inprogress
 value, not just 1
Message-ID: <20200510072725.GG8939@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904189872.982941.14116905127710550275.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904189872.982941.14116905127710550275.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:31:38AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Complain about the primary superblock having any non-zero sb_inprogress
> value, not just 1.  This brings repair's behavior into alignment with
> xfs_check and the kernel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
