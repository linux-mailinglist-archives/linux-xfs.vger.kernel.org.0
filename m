Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAFE75F24
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jul 2019 08:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfGZGh3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Jul 2019 02:37:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40486 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfGZGh3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jul 2019 02:37:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xnjMx/d9wrWdbf9l+jwcl30ugcQwCq4yJiWS93oOANA=; b=lmn8GTsMsJfoxW+qxB8Aggyrd
        jQg5qDrn+fwoX/4WlXFq8uaH11POYyU7TXl/Dq4QJ79BJydgvioqL4MREIioiCHpcNw1NWGFg87Lm
        1oS+k6UnnbJOctekMJ2wwbNdHjuq8/gTb8NBUaixg4z3RDbvCv2TAvnHmtyrjLMZ0XUOpKkM166/O
        hOWzTOR8DnaRpQTYCoKV8U02JiiPzXzt2JohirAl1lALf1JZKl4vFttkEcnfHZosT/2H4aqG3rrWT
        aUjM47VFYQuqr068xKALyjRqRwOyL6sVNk8FYiM8SvzDNGEj4N17ewf+6Uh6Yp019BEnGz5hZaG3d
        z36hE4+Xg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hqtr7-0001Qt-27; Fri, 26 Jul 2019 06:37:29 +0000
Date:   Thu, 25 Jul 2019 23:37:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfs: fix stack contents leakage in the v1 inumber
 ioctls
Message-ID: <20190726063728.GA316@infradead.org>
References: <20190725175346.GF1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725175346.GF1561054@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 10:53:46AM -0700, Darrick J. Wong wrote:
> Explicitly initialize the onstack structures to zero so we don't leak
> kernel memory into userspace when converting the in-core inumbers
> structure to the v1 inogrp ioctl structure.  Add a comment about why we
> have to use memset to ensure that the padding holes in the structures
> are set to zero.
> 
> Fixes: 5f19c7fc6873351 ("xfs: introduce v5 inode group structure")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: add comments, use memset this time

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
