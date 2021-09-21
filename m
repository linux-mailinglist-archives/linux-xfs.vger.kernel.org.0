Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710EC41303C
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Sep 2021 10:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhIUIjD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Sep 2021 04:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhIUIi4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Sep 2021 04:38:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AADC061574
        for <linux-xfs@vger.kernel.org>; Tue, 21 Sep 2021 01:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=t85mbtiZll6ZDcQZWD1Bym94Qb
        mOAsSjqT902L75sv7cw6UgRzCjby9dm5+kjqnd0baqB+0Uu134lBSVVbpSxHHDgZE6SnFvsMv6lhB
        dYOBi4hEUB73W/lfoM79PQq23HcCv2k3m1H5QGDij4ab1BrFBUSwXuf2vk/wQ/WG6orJVmqPWU1Y9
        u2aUvNcqr2ydYdfog8997nB3dZy+budslF4WT8dD1FdcUpbe0xbtVfMUYFnndPOYTdJiJlxnlCe+n
        PIfMjyhZm4QF/cDonklxePa6xKKciwuwyZvobDkpAneqd9EXnQQzJ06YcH9ZaIHY0TjLsn5JYOHA6
        MKm5GnTg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSbGb-003dot-JF; Tue, 21 Sep 2021 08:36:51 +0000
Date:   Tue, 21 Sep 2021 09:36:41 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] xfs: remove xfs_btree_cur_t typedef
Message-ID: <YUmZmUOa8UnlAcjj@infradead.org>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192855540.416199.17796390757325316141.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163192855540.416199.17796390757325316141.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
