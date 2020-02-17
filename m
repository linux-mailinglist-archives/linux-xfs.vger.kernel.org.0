Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E179D161402
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgBQNzL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:55:11 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59290 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgBQNzK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cFN5QhG5RI6LcgYCqQWPwnsLL7aQYznAJwVWUQYgHPc=; b=qYmEWsLjN1889eoSFU+1WlLPte
        pXrthgpa48ZwdndKcyRjBNh3cXR3uKyv/PFe0cDICZMDJK+ZdhGUZ6NiWgSv4z846Z7MOf0FIEmtX
        7y5rMtzPcbEaRB2N+rygK5RJ84w8ELMwK6myUhFJW5a9i18Fln+1lXJYIJKlFIcovpJgMWHqrND6O
        myUEXfYRVKzuGuba8RNd0hEJE0EuvfvTt8ep/uGakQKdtWCRgF9x8ftYn5uuZGDz+gJdkvKJjGHj3
        vtgbHTTZEGivKslTzr2XAbyyxuEzvN6U8+MA8nMpIDf5/DvT60K0+GQCrBqMeoqqaHNbaH/56So+0
        DsiiBkIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gre-0002Mq-2J; Mon, 17 Feb 2020 13:55:10 +0000
Date:   Mon, 17 Feb 2020 05:55:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 7/7] xfs_repair: try to correct sb_unit value from
 secondaries
Message-ID: <20200217135510.GK18371@infradead.org>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
 <158086364145.2079685.5986767044268901944.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086364145.2079685.5986767044268901944.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:47:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the primary superblock's sb_unit leads to a rootino calculation that
> doesn't match sb_rootino /but/ we can find a secondary superblock whose
> sb_unit does match, fix the primary.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
