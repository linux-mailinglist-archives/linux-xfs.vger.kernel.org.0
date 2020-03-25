Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4011921A7
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Mar 2020 08:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgCYHNs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Mar 2020 03:13:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59170 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgCYHNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 03:13:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PFgnxWVBjkUuIa9bLU7yg+DUK58K5PZftjxtFum9U2Q=; b=UE5q+V0uBLm1Ib8b+1lxLK9+Qa
        EvQQ5CzHbNV3C7MuL8TcvGoEOKSRK9VsGRer2g1xCo31AeYMyhW1sgIdWRyL2HwErKABcwqcL/Irs
        6F48AiyORXLZShdIKQ9G00MK9AfeTm9o6SotqsqZ2Z7etOF4ZJoy2718+vYo+K9FCWox/KBfAf4aU
        W9Q60bX60YJUMGzxsoQf5lVI6KObHSzpyMI3qMMpo13y6sjU86C0MaH5A2E/kCxKcMl839wiRdUWo
        wUUEFSTuK0q4a1qn3xLEMVnuLqgGZOtdBHGqqzMxeRXsAb1uIUuBVa0R71UemLljQlu4A+ZzVEisB
        JC2+vdxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jH0EW-0006Wt-0w; Wed, 25 Mar 2020 07:13:48 +0000
Date:   Wed, 25 Mar 2020 00:13:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs_db: clean up the salvage read callsites in set_cur()
Message-ID: <20200325071348.GC17629@infradead.org>
References: <20200324210956.GS29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324210956.GS29339@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 02:09:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Clean up the LIBXFS_READBUF_SALVAGE call sites in set_cur so that we
> use the return value directly instead of scraping it out later.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
