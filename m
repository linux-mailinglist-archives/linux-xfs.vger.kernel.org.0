Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63100AFAE5
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Sep 2019 12:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfIKKzw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Sep 2019 06:55:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48786 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfIKKzw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Sep 2019 06:55:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zbyzMq2jlacLv5bIVwGow4B3wX3wjVniCJJU7qfAy1I=; b=UrFSl4fjYWHvNOPvpMjJt5Mhk
        irKCvsyfMkKzuKFBeW/pwpyNjM7Gx4swacB0AImEQ68UdTTyn/2vlBSf9Rn8mYLy9rH2a6UH6xYwa
        5G+3NyU3L+oNKC6RlfdP1fmnTHWdVLXJYBUFUSgbaz4s7EwtiLKX+11/aRZMm/O6UsrwcsOJWdh39
        ttmwMkSRDZbPDBBuIrVYJHN7xIlS8c8ZMOCy2kZdO51ZQsqwHZVgopkFvUh4prYecRvQRYQD2VlLq
        g/Mfg2mDf/ElV1kDw2r0bpeLsTSovSqLLQiBXIyT6O2ZGe3aQhPkgtET9+jv+Qscgk1BhhXAMQHNc
        tA4ZaM9Kg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i80Hv-0008A8-NZ; Wed, 11 Sep 2019 10:55:51 +0000
Date:   Wed, 11 Sep 2019 03:55:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH] [RFC] xfs: fix inode fork extent count overflow
Message-ID: <20190911105550.GA23676@infradead.org>
References: <20190911012107.26553-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911012107.26553-1-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

... and there went my hopes to eventually squeeze xfs_ifork into
a single 64-byte cacheline.  But the analys looks sensible.
