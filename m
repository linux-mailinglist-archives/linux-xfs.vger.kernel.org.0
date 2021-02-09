Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D52A314B31
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Feb 2021 10:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhBIJMe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Feb 2021 04:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbhBIJIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:08:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C25AC061786
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=iTHKPZjfmcbXW5sq4gCpwq450Z
        xtDlrJuc2GFvEh5Hl3j+Yt11m47nN/EdTjWRIINxfyIBbhr4OCN6wAS8dPVEJAxVYY6HBa19TCOGU
        kCTkKLSeqRcfXsvW2po1TYrp2PTvuGkmvFhiANLiLm99WS4ZXUqjA/dWkwmetK/Oscs/Qn/m6HgcF
        yTrj3OIr37ERkjQezfnqWchMSmoBIU0dcsezs1/WXg4+uL7Ht0L+/GTiByUID3Ai/GcBlgUp4XnZf
        trbZ8vvT9g2JHP+ciKfRFcnw09NFdSgk4zIh+jNaMDNO0iJOsjf3U0ozXmdnPlYa04gQ91lkBhEca
        VbKOPkAQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9Ozz-007D0X-LQ; Tue, 09 Feb 2021 09:07:55 +0000
Date:   Tue, 9 Feb 2021 09:07:55 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs_admin: clean up string quoting
Message-ID: <20210209090755.GA1718132@infradead.org>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284380981.3057868.13051897080577307586.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284380981.3057868.13051897080577307586.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
