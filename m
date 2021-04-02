Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2793526DA
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Apr 2021 09:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhDBHLJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Apr 2021 03:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhDBHLI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 03:11:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DBBC0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 00:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YjKKmzJ4blpR79cU4fI1GBDxl6y0oNfY3QmuHjUpXYQ=; b=mN9xqjAivzTZ10aEz+S9eXj8fl
        n/agWMMjfdSPiinF1yHTxGDv0xRDfmYiLFY59t+huKpyJrAWxWFdh5J0vL30ixuGUoPokByE7oJhS
        Di+nCZmfk3dSQ5bgbNqEem8BReoyaSW3Wxp8rnd3F+yBi7zN+oDciah9OGFkqSrJ1FsEwbS63bAtF
        HswEKc7/Alwei0RZiKFe9C5E0hy3uto3mltq6g6+4QMcEd4I8ZQJ3yfhKR3PyZfPDwO+U2y4yvtjc
        b91/ZAJ5GlaPl+fD3fZ6w0W875FRmxgdmQ/XvmzSZHD5j4XXayGG0M62I/afUxtELqhoyI4v6OFiR
        Knc9JhLQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSDxL-007K8l-Mp; Fri, 02 Apr 2021 07:11:00 +0000
Date:   Fri, 2 Apr 2021 08:10:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: precalculate default inode attribute offset
Message-ID: <20210402071059.GI1739516@infradead.org>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330053059.1339949-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 04:30:59PM +1100, Dave Chinner wrote:
> +unsigned int
> +xfs_bmap_compute_attr_offset(
> +	struct xfs_mount	*mp)
> +{
> +	if (mp->m_sb.sb_inodesize == 256)
> +		return XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
> +	return XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
> +}

There isn't really anything bmap about this function.  Maybe just merge
it into xfs_mount_setup_inode_geom?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
