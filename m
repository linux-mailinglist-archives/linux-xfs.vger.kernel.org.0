Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABEA2ADE6C
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Nov 2020 19:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgKJSew (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 Nov 2020 13:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKJSew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:34:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32173C0613D1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 10:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qsuYPQrdMj4FYfFMkdbw8/iv04hQnEsgHA71fx7QtRU=; b=VQDghZnUAjv2m+v5kgr9RhP3D8
        FNhr7+rOG02Z7+b19p/6bZHsV5l23d91ACKiWyYi8SoDvJ0aNKJWa5vRG0ABFwMB1XWda6Lm6/tHf
        Oh5EEyJEChAJgRoU3zUGNzmzBCaKqQ3OdA43rPzWqY5zNtcdb9EjjMiBWRw2ofch7JIUAl9MD9VU0
        1CHmqjuAEnSfESU/mX9p3zQ29DFIbj2NkhcZKrZSve+II4jI9DbdLj3v8lezWy558Gi5yGrKTz0JK
        eHmWDIw2vzS/EIc0pxlWeC/aQLmdfsALnFj50Pz+vFQ8lPm/Tc9jXG5Iubd1KwA0tC23AmLJEDfAj
        Uc4f4a9A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcYTi-0002WA-Ja; Tue, 10 Nov 2020 18:34:50 +0000
Date:   Tue, 10 Nov 2020 18:34:50 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: fix rmap key and record comparison functions
Message-ID: <20201110183450.GC9418@infradead.org>
References: <160494582942.772693.12774142799511044233.stgit@magnolia>
 <160494584816.772693.2490433010759557816.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160494584816.772693.2490433010759557816.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 09, 2020 at 10:17:28AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Keys for extent interval records in the reverse mapping btree are
> supposed to be computed as follows:
> 
> (physical block, owner, fork, is_btree, is_unwritten, offset)
> 
> This provides users the ability to look up a reverse mapping from a bmbt
> record -- start with the physical block; then if there are multiple
> records for the same block, move on to the owner; then the inode fork
> type; and so on to the file offset.
> 
> However, the key comparison functions incorrectly remove the

s/remove/removes/ ?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
