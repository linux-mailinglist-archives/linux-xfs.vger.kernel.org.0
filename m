Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BDC21EADC
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jul 2020 10:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgGNIFd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jul 2020 04:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgGNIFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 04:05:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C69C061755
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BkA95QGuVJ5mUtrdDbXwFL/kE7nP8u8mHS3oEhznYk0=; b=N5oPqY2pLP3gCh6HtMiMqpAfbj
        VO8++JXJ+eoogqVGs5jDx4R8yqMH0fH3YvEKFGxmWx40MVlnIH/fvOxLjICX58iP+2av6OdalHzGS
        9Bo2TVqDcnQdvBgX4IUDFxdogeG7CzzuUfIp/UCon0gAaI4ZYAdJ9vWSB+Jz5beS06ccCpw5v3r8R
        jUAeTg6AuTGukzP0bz5HJHDcb6OSJil12LMbhJtffxveUA0lC+UblFQs3Jm3MZqiSOYFGCpSls+88
        woC+1g8aeopmna+tXFzLA53t+gwLKYsP5TWR11CAvtZJsXYDBN2WRl7HuXlcAhtxbSWhMcOvQAGhP
        VoHVKJRg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvFwQ-0007F0-OK; Tue, 14 Jul 2020 08:05:30 +0000
Date:   Tue, 14 Jul 2020 09:05:30 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/26] xfs: move the ondisk dquot flags to their own
 namespace
Message-ID: <20200714080530.GL19883@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469033930.2914673.6332873477280477365.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469033930.2914673.6332873477280477365.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +/*
> + * flags for q_flags field in the dquot.
> + */
> +#define XFS_DQFLAG_DIRTY	0x0008		/* dquot is dirty */
> +#define XFS_DQFLAG_FREEING	0x0010		/* dquot is being torn down */

I think it might make sense to start with the first available flag
here.
