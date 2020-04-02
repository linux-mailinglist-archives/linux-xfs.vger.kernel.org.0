Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D1819C5AF
	for <lists+linux-xfs@lfdr.de>; Thu,  2 Apr 2020 17:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388908AbgDBPUQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 Apr 2020 11:20:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52648 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388781AbgDBPUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 11:20:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oTR2pcyExCARlGtg2y4UnHk/kyxLZ9Aj1K6fq4+yXmI=; b=KXT0ZGa4UIGtsc/O9Pn2nhwMrK
        d+k/l9t3OIOd3RiITX54vTn/9/sNF3+1y0sjLwqZg3wqhqn1KxzJKQQI09IlHcwy4WSejjzW+WALB
        ZAk1kgnouGGTgoRf7y1SwZj11CXy6r09OaX/XYkUhS+c0S/GIUO571B9v3vTEkGs3+b+KvhBuafrc
        EftiNsHRa8CQLzliLbj95RQFa14KbEB18152wz7hOsKUiWju+cz8we2uBnZBJ94M2Kbjp57fyysOf
        /mgmOLGnOUfFYqzflrQE3kTMYhVQ0LVRCnDA0IkCQ2pmG6uaK8Iy4Ae6sf6VUSyM+0golqYsaQHNr
        FiSA15Gw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jK1dg-0005c7-Dk; Thu, 02 Apr 2020 15:20:16 +0000
Date:   Thu, 2 Apr 2020 08:20:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reflink should force the log out if mounted with
 wsync
Message-ID: <20200402152016.GA19701@infradead.org>
References: <20200402041705.GD80283@magnolia>
 <20200402075108.GB17191@infradead.org>
 <20200402084930.GA26523@infradead.org>
 <20200402145344.GE80283@magnolia>
 <20200402145648.GA23488@infradead.org>
 <20200402151431.GG80283@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402151431.GG80283@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 02, 2020 at 08:14:31AM -0700, Darrick J. Wong wrote:
> This isn't enough because this is only the last transaction in the
> reflink sequence if we have to set the destination inode's size.  If
> (say) we're reflinking a range inside EOF of two files that were already
> sharing blocks, we still won't force the log out.
> 
> The other thing I thought of was simply invoking fsync after dropping
> the iolock, but that seemed like more work than was strictly necessary
> to land the reflink transactions on disk.

Well, we have a lightweight version of fsync doing just that.  In
fact we have the same lightweight version twice: xfs_dir_fsync and
xfs_fs_nfs_commit_metadata.
