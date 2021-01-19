Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516E32FB29A
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Jan 2021 08:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbhASHM7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Jan 2021 02:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729933AbhASHMv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 02:12:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425B4C061573
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 23:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=sAkwAAwVbEynkU5pM3TYXD6EHd
        zVULBapPHKfwU8FBQfnAaYsaOqSVLEY7+GS70e+uuJ/qKQl5PpaMHQqj80AImA5+Cr1OYS2453gGO
        NAnwcEbyLZEmYBJ8dY1PzfHiTFwAuJc0rPZZT931cpZNcM8ohTQW1214k8ingXbzG9NMgE+BnO9T+
        nEviC8Po+CByeFzxw/985pxrohFEuMNFFo41ZvuQy4NlpnPDWJVt4oL8dqAzjLcaEbkXHCh/ad2Ub
        +WUEI056XSJ8OwPC/JWiu7Sk8sQGCU5c8RIRaq2sZELrBnLFa0IcdYK40OHTxFsttSX5BTjOwqkio
        3yVfyn1g==;
Received: from [2001:4bb8:188:1954:b440:557a:2a9e:a981] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1lAz-00DweX-R7; Tue, 19 Jan 2021 07:11:51 +0000
Date:   Tue, 19 Jan 2021 08:11:41 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: add a tracepoint for blockgc scans
Message-ID: <YAaGLUfKXQSkUtGW@infradead.org>
References: <161100791789.88816.10902093186807310995.stgit@magnolia>
 <161100796788.88816.11790817696681055920.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100796788.88816.11790817696681055920.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
