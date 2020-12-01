Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7B62C9EF6
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 11:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgLAKRX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 05:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbgLAKRX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:17:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC11C0613D6
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=m+4l6BDTGPIzhhaFz/GRN21llu
        67D90WCO7+bRWFolXGvnUSVXPnapwqXYWxsmkaT60nYr8Yz1Eb8dY6iKwSTpi3B0NMEgxHpvWGhym
        VASqtm5sOLQk204vhOHzDLbNTiXyKsjMRI9HRTnWJtFNwzeJ0S9dlzmjMF/0g2U5kb0cYj5iqdBg7
        w4Dj7FW+4X/u9cxIgMgGp25/0yrHjCDJDb1wp2ORBqakR56zHxrMHX805fd/ytvkAXDY7rhu7P5QK
        i/vSK0NFdp8DaWjU7ldNUxSnNg1bB39J65mndgNV3bSocUq2OJSm0889oMGjQUP1xR1cRaS4Gmeiv
        QqTlIcvw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2i6-0003re-SA; Tue, 01 Dec 2020 10:16:38 +0000
Date:   Tue, 1 Dec 2020 10:16:38 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: add a directory path lookup command
Message-ID: <20201201101638.GA12730@infradead.org>
References: <160633671056.635630.15067741092455507598.stgit@magnolia>
 <160633671661.635630.4898407665487829.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160633671661.635630.4898407665487829.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
