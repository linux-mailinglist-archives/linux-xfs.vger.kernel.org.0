Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2140B26D574
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 09:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIQH7c (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 03:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgIQH7Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:59:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8BAC061756;
        Thu, 17 Sep 2020 00:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6TC0rPhpvo00hqhE2ahNhF5DdZG0LLORMBYrL711Pc8=; b=edv+yf5v5/ZlDCrb8g7CCNz0L1
        R1YqQrycc4bCteRBCtkO08SpUSI73IJwgDbYn4ZNm4u/A4oVpJu65dReCcubQ7vwL04Ih0n1ZRFmp
        BMeXGwlZbsTbsPVtbqrAKxmWvquVxgY+5QH00tA76nepUATCnlVNwU5Zt3R7c5MCHDuAqq8ZqGDS6
        DXA+PHOT/oBqWXWyO+dUpYUefiCda1aZSlwdVmR1wZCsNheQ9GkTTyXF3YRMn7GyRL5XELQvq+JQN
        htt88Ls+V+dbW4nuSZtbTWbmJKemuWa8X8L7458s/Eg7T85tEuj8gQZuZalCL54ZuHYpFczwI+u/I
        CbnktqWQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIop9-0007Xw-OT; Thu, 17 Sep 2020 07:59:23 +0000
Date:   Thu, 17 Sep 2020 08:59:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 19/24] xfs/424: disable external devices
Message-ID: <20200917075923.GO26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013429643.2923511.17476130717295164051.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013429643.2923511.17476130717295164051.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:44:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This test uses an open-coded call to mkfs, so we need to disable the
> external devices so that _scratch_xfs_db doesn't get confused.  We also
> disable the post-check fsck because it's run by the parent ./check
> program, which won't know that we didn't use the external devices.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
