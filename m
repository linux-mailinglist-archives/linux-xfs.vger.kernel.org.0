Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22581680B2
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgBUOse (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:48:34 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48238 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbgBUOse (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:48:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CH0/YhiKMkBosFbRbQ+VpMkD61IlW6ZAXNWElZcdr74=; b=qI/QkeADuHsjnCb1H5eP5Ej1q4
        Us+5FUXQrfFQM7leYDYauVZQdbVZg/nuB3SYONQi7Z7KSaVDUBJixGEE6sMup6rjWoofs4vT8KMML
        S0hCAKIQW8H6Q3OTEfQJySNsJjdIXnNp2q7cXyUC/MsBvVpLJCsFQ3LhmfeGvQqQ4VPkIb4pIN/Hh
        qelOIHixOJBTtRUYJNXlSSTkrekWdgccKz66rvlzCJrYv0hdzKVBrDO+uXjliBJMWb1kYIvw/HMHZ
        S1CswBq9wmwBmsKAe+AwVezHfPH98maONu8X2RuYc9BPGgxrE44muUZTtbJgElXjPoS34vnwsIdtB
        ve1MGaJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59bV-0000VC-40; Fri, 21 Feb 2020 14:48:33 +0000
Date:   Fri, 21 Feb 2020 06:48:33 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/18] libxfs: introduce libxfs_buf_read_uncached
Message-ID: <20200221144833.GH15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216301746.602314.17789861786273491972.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216301746.602314.17789861786273491972.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:43:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce an uncached read function so that userspace can handle them in
> the same way as the kernel.  This also eliminates the need for some of
> the libxfs_purgebuf calls (and two trips into the cache code).
> 
> Refactor the get/read uncached buffer functions to hide the details of
> uncached buffer-ism in rdwr.c.

Split this into one patch adding the functionality to libxfs and
one each to convert db and copy over with a good rationale for the
switch in each case?
