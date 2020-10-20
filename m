Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659AD28EEA9
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgJOIkk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgJOIkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:40:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0613C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5cjD5/yI9N7enge344A25ZNVOPDKtR8DmyhpvNPTKzk=; b=Wc40Be24WoDvBzUlGZ8MDtOxM3
        T/DLRDgGvcroPYMw5JAfQbc5iTv+Cl0y/ogpoXyL2r3/g8YJ7Usq7wolgh/Go+cMEIL3HZYPQJmmS
        15IpDZwNx+ptUJM3dE433mYdUkxLmcTaea+FPgzQBg7Qgp8pXvEhfN3TJ+UqkisczxOh6+W6gLnM7
        aovnIpTFLdTmumb3fBcqlRW2WxAmDn/BC42iZnCLsUx8fD6JzrKrrmLuXys1Ij8+vrWyrJoUSC9NR
        m+4oJaWx3A3l6kj7BuOeday47atqlcmHKYnjp2LLxZBpCCrHcEjgVP+BZIRrJOF657v3B1Usm2eTG
        +IyQ2Isw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyoQ-00028e-56; Thu, 15 Oct 2020 08:40:38 +0000
Date:   Thu, 15 Oct 2020 09:40:38 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V6 10/11] xfs: Introduce error injection to reduce
 maximum inode fork extent count
Message-ID: <20201015084038.GI5902@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-11-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012092938.50946-11-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 12, 2020 at 02:59:37PM +0530, Chandan Babu R wrote:
> This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
> userspace programs to test "Inode fork extent count overflow detection"
> by reducing maximum possible inode fork extent count to 10.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
