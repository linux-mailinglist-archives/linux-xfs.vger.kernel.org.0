Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB82A29E78A
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 10:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgJ2Jj7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 05:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgJ2Jj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:39:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0176DC0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=84lU/etqQ4/bxZYjDyxYzvbJRww5VL0hBfprbPOIy8g=; b=qASbSuFcIeorpAmySe2Y4wCwvf
        gVH9UiHlfWha17T5yuP+F9SxMjUQJojpTzA08crqEl1H51DpsEVWRRru8BBiIyr1JzshF31BJzcc4
        QuApJLytGxBy1XdRKwhyDd3z3254Lj5zo635X25MP7x35kOFpIv9mY4Pc/qzyj/JFV6U73kC3E1Ee
        Lm582wZjBF9xEH+dmj+jE7X8k3axSSCBGgbLOYjUnf1iojoUGwesAHQrIfmE9ZMMIPsu2p2svVjpV
        ZHPSSiW2TzL3K2LShXtJ+/ukloZcWpIHMQOZMx7oiKMdGr51USfCI83rwn2FWX2HTYv4rQ8iUhfs0
        UN9q2yvA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4PV-0000yV-Km; Thu, 29 Oct 2020 09:39:57 +0000
Date:   Thu, 29 Oct 2020 09:39:57 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] repair: don't duplicate names in phase 6
Message-ID: <20201029093957.GB2091@infradead.org>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022051537.2286402-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -	xfs_ino_t 		inum;		/* inode num of entry */
> +	xfs_ino_t		inum;		/* inode num of entry */

spurious unrelated whitespace change?

> +	/* Set up the name in the region trailing the hash entry. */
> +	memcpy(p + 1, name, namelen);
> +	p->name.name = (const unsigned char *)(p + 1);
> +	p->name.len = namelen;
> +	p->name.type = ftype;

just add a

	char namebuf[];

to the end of struct dir_hash_ent and use that.  This has the same
memory usage, but avoids the cast and pointer arithmetics magic.
