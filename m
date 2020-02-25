Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C894A16ECEE
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 18:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgBYRom (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 12:44:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57236 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgBYRom (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:44:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r0jL2tkyNp/G/aLcCF17O7ubWmJtW+hfw63dUA+PKv0=; b=eE5KcL8vdVymfThVo7U8l3PXVd
        9anqiqS3a8ScRGtlQeJUp4/nVZH2dKVToHyTGSKQiwd6M8OVtKhtJA471NFcLo9GI8bKXMRehU5E/
        GsFzEVDv/zHsuiE4OgWlLTBObNUt15mJ1HcF1Z3JkE+uuxSN9qYf9nno05a2Y9Ynaf0K7FFX1A7mT
        NlA0PR6YDydn1uv5p9G0hK/GCtWKwCt6wHKuwEbtnZFSJU0WKYzIgcv9Nl/mmiNT0MZl9pMITKNqO
        MirhO/gfc1+yIxeGVbXOAjCyv88cfrrLrrtWOdk3GiPmsgcOum0ulPgQUPRQbkjphX1scafBCvsHS
        tToZZlcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eG9-00065h-AD; Tue, 25 Feb 2020 17:44:41 +0000
Date:   Tue, 25 Feb 2020 09:44:41 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/25] libxfs: introduce libxfs_buf_read_uncached
Message-ID: <20200225174441.GK20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258955183.451378.11324668365381818225.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258955183.451378.11324668365381818225.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:12:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce an uncached read function so that userspace can handle them in
> the same way as the kernel.  This also eliminates the need for some of
> the libxfs_purgebuf calls (and two trips into the cache code).
> 
> Refactor the get/read uncached buffer functions to hide the details of
> uncached buffer-ism in rdwr.c.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
