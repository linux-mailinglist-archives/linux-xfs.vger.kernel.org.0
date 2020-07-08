Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351F5217FC7
	for <lists+linux-xfs@lfdr.de>; Wed,  8 Jul 2020 08:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbgGHGqb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 Jul 2020 02:46:31 -0400
Received: from casper.infradead.org ([90.155.50.34]:55918 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgGHGqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 02:46:31 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2020 02:46:30 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=N6j4eDs2IJa0y1NmHDQQvONVNZvdLUJXdGKTAthK0wg=; b=r4gK+6TUIn5yGRvfDoETeTtLnb
        aibMd1Yj17IeyJNDnUiDReFmTycwuv6revr79tmWhLYf2vQnxsOMLiVDQvXfLCkYzpocRlA/H3Z6Y
        5ffE1Ukj4cPbjm88QfiZkhM349DGfXy5IRQiify9OZ40NTjJ1ObT84hw8KClfUjMb8R5niZZoaWk4
        YA4HRhw8ayg80t5x+teSOHgnS73swZKmLTmPhUCodUBtgXp4zchdKGXa7g8hSCOV1rtl0SHxsOG8W
        N7NbpbpdWsf7UdeTI/8G7pH4rwH+kG5xAQxIgRMnrPZdagOb+ADUW7zuAUUSmkOgZ+n5yBG4AplE/
        vla2XwXg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jt3kv-0002hV-RO; Wed, 08 Jul 2020 06:41:22 +0000
Date:   Wed, 8 Jul 2020 07:40:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_repair: simplify free space btree calculations
 in init_freespace_cursors
Message-ID: <20200708064032.GB9080@infradead.org>
References: <159370361029.3579756.1711322369086095823.stgit@magnolia>
 <159370362331.3579756.9359456822795462355.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159370362331.3579756.9359456822795462355.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 08:27:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a summary variable to the bulkload structure so that we can track
> the number of blocks that have been reserved for a particular (btree)
> bulkload operation.  Doing so enables us to simplify the logic in
> init_freespace_cursors that deals with figuring out how many more blocks
> we need to fill the bnobt/cntbt properly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
