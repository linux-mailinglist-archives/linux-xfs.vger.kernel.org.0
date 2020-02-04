Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D97471515D5
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Feb 2020 07:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgBDGVT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Feb 2020 01:21:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42548 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgBDGVS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 01:21:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AcTjHjytwbpXs2cyVFZ6AhRBU4hrLn/+5+2FyavVu08=; b=emUtNWAErCtDWyMoknF67P3wlO
        WkUO2/eGvK7CVSVQ1KGOzCyvyPvOrYihQGW+s4K8HnFxAJxbIJzpNwrlcgQbYUsCnAJpAAOxogOq5
        T9fh2oKjoj585e7YzX6ZjVa5gAo72+THk6n0Kssb5tB+vTn3BOkVjf3MZzK8xIW4CHToIooX61b4p
        2PFq4vyTkKu81mD/zyLRYEPu9GxarX2M2oKMWUn/D/5nNxHgksF0bdtZDrF7j1l8zb5qbnxcriE/i
        17czpUmZ9RKaOu5ho38MTB2Bvof5Cz0abyFm3j36P1dC4O+9uwIDEOtTQGQJ4VLBbr5XRxmtYHImh
        IYV5g6lg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iyraI-0004qh-Bi; Tue, 04 Feb 2020 06:21:18 +0000
Date:   Mon, 3 Feb 2020 22:21:18 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 2/7] xfs: Update checking excl. locks for ilock
Message-ID: <20200204062118.GB2910@infradead.org>
References: <20200203175850.171689-1-preichl@redhat.com>
 <20200203175850.171689-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203175850.171689-3-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));

I think this is a very bad interface.  Either we keep our good old
xfs_isilocked that just operates on the inode and lock flags, or
we use something that gets the actual lock passed.  But an interface
that encodes the lock in both the function called and the flags, and
one that doesn't follow neither the XFS lock flags conventions nor
the core kernel convention is just not very useful.
