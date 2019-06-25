Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C5C551B4
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 16:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbfFYO3p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 10:29:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46898 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbfFYO3p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 10:29:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=S3q1DulA1RvQxatKqB87xTMyBPxTeVXyH+R8B7jrsJk=; b=aBfXRnw98owQV4nllcZx5D7KV
        iR26U1Ml5pgaBsEFg+qWomO2P2W2T6G9Dj81ru4Ua1D3AKbbrDO3WNf1cXnSDozFNJfRRGiUTvHCO
        f4MQPVC98jcIO706qWtL5i3LowV4mFDTJ5kVuoDn6m8a5QOjdtPOC41wlbJaXwCZko27w7vVwLJ6u
        jX5yb20k4Iz4BWypzLYIcC7gSuvSgWz8lHQokWbnyp3hI0p/jfhZlYCwz9L9MpdOwH9o/jcZsglj+
        5CcQs+OfkSNXkVxAsQu+1xr53AHT1RGLxWfG45v+HjcusupkBs1PKn5tKefwBygIeaVzY/A/4uBSc
        lCLkPKyaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfmRn-0003xz-CS; Tue, 25 Jun 2019 14:29:23 +0000
Date:   Tue, 25 Jun 2019 07:29:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: move xfs_ino_geometry to xfs_shared.h
Message-ID: <20190625142923.GB11059@infradead.org>
References: <20190618205935.GS5387@magnolia>
 <20190619011309.GT5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619011309.GT5387@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 18, 2019 at 06:13:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The inode geometry structure isn't related to ondisk format; it's
> support for the mount structure.  Move it to xfs_shared.h.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
