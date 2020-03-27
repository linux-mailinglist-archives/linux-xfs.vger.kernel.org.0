Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3945D195398
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Mar 2020 10:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgC0JJY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 Mar 2020 05:09:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42640 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgC0JJY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 05:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mnvSjiOZKWxIqIoutPV07XMVUm5MgYdE1mGyu1sk+2s=; b=QrVfRIBEmEvubyZstPhDmHCSuv
        1mQkddNnsqbvgu4mBe6DhV7TX/bf0GK1bXGl5tp5XEmHWNrxfeI9Y1kQlEgvKlExOl8EL3xtJAwnu
        eawgB6fY6eW3fUtZ5dc0ef+X0Em7YjJCb8hbbh82568noJC1cOgW+GVCQFnMpdbqwYtRzDifrMa45
        7akM52Wi5GuzuQbUWdbfJQadaToXrHuvyHHxwP7MK1zKQI9n9+Mqwuly1M4PW/w+iUfkijwyDI2AY
        Ox2wd+TRSehhUFeHgdzrUKi4+3hlw8TnhBSSgNMfN6q0+Z3iuuO2hcPN8YngXWL1c+xFufzRHCeJn
        H3iz05JA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHkzU-0005Lw-B7; Fri, 27 Mar 2020 09:09:24 +0000
Date:   Fri, 27 Mar 2020 02:09:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't flush the entire filesystem when a buffered
 write runs out of space
Message-ID: <20200327090924.GD14052@infradead.org>
References: <20200327014558.GG29339@magnolia>
 <20200327090800.GC14052@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327090800.GC14052@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 27, 2020 at 02:08:00AM -0700, Christoph Hellwig wrote:
> FYI, independ of the discussion what to flush, using
> filemap_fdatawait_keep_errors is a very obvious and important bug fix.
> Can you split that out and apply it with a Fixes tag so that it gets
> backported ASAP?

Sorry, -ENOCOFFEE.  We didn't have a previous call that comsumed the
errors, so the above doesn't make any sense.  Please ignore it.
