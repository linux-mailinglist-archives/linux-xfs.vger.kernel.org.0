Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D737321EAC1
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jul 2020 10:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgGNIAL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jul 2020 04:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgGNIAH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 04:00:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31C7C061755
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8F2okqhmBSu63/cCnJBNr6eCBGuk+6+BbBmGNQ+GSJA=; b=JBhnae+tXhqVrIVWEzB4mGz7Lj
        LE4cJmzx453S7MJWBkDrxyfRas2U2WXVDWCXGd8g/YxY8CBk0XSknXUFCm7ddadL7y3FkaO5EdRMG
        SYYtw+Xwqp6YiYOP26BTqIhTrjJm8HxOS9PjBRVTxEfm9Q6zHYpMrXcxt5V9uFTpZXTg/XX9SGgwK
        t58cjuFQ1Vkfu2wtflXQOC/FnJM8vlYnBBY3V4jYruPLK7wYEijKsdI0JygcyADPYxp5xTD8tSbpf
        7r8g4RsjMiOq37Xl0m2JLx/xsdnTxF9Q1nca76BKPwYPMjP9Hu0aw+A9yfZblgcUqIhF5/CGU9gb4
        0wVn0cZQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvFrB-0006yQ-Mq; Tue, 14 Jul 2020 08:00:05 +0000
Date:   Tue, 14 Jul 2020 09:00:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/26] xfs: rename dquot incore state flags
Message-ID: <20200714080005.GD19883@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469033295.2914673.15913112198887429156.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469033295.2914673.15913112198887429156.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 06:32:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename the existing incore dquot "dq_flags" field to "q_flags" to match
> everything else in the structure, then move the two actual dquot state
> flags to the XFS_DQFLAG_ namespace from XFS_DQ_.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
