Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688851DF6E7
	for <lists+linux-xfs@lfdr.de>; Sat, 23 May 2020 13:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbgEWLjD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 23 May 2020 07:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730372AbgEWLjC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 07:39:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20C5C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 04:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1n6nMPM4eZeBBwWBHf3oHXoo3zuv4fH6t9fG+Xq5Q7E=; b=BF9qzW+BQ70CM5wvsetP314O7H
        gtYMBZraelnm6OGVH0AOUFnlbLx0XzeH1yiKKZ2CwNlJbM0HSO2Lz2OcZSLhp6vyiSvnal3zJKhfI
        GeW8V0WUwGTYA+wC8N0EW6riS7FcUkfeYGQ+1ALCJU+1sbFZmQzdeK7SrfyNdEC1je+lNJSqaZYL6
        QrwWKbSJevSoQElm8Lx4rkSnkYNtysRs2hDgGq1YOTxtrVIw+UULRVkTPTdLvSiA3uOAlZVUbdt+R
        LA3O4IaPIa7z/jI/tZKVPbGbgg+vVcY/kXzStvpIKR1r8uq3xifKVC5g/fbIVDG3vFjhJ9ZB4p5MK
        a5iM92UQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcSUY-0006xW-Br; Sat, 23 May 2020 11:39:02 +0000
Date:   Sat, 23 May 2020 04:39:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/24] xfs: rework xfs_iflush_cluster() dirty inode
 iteration
Message-ID: <20200523113902.GA24042@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-23-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-23-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:27PM +1000, Dave Chinner wrote:
> +		if (XFS_FORCED_SHUTDOWN(mp)) {
> +			xfs_iunpin_wait(ip);
> +			/* xfs_iflush_abort() drops the flush lock */
> +			xfs_iflush_abort(ip);
> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +			error = EIO;
>  			continue;
>  		}

This looks suspicious.  For one it assigns a postitive errno value to
error. But also it continues into the next iteration, which will then
usually overwrite error again, unless this was the last inode to be
written.
