Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDE629E821
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 11:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgJ2KA7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 06:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgJ2KA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:00:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5346DC0613D4
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=qXOyPnK9OUVTpu7JKJOKncVaA4
        c19TmnrxGc7DMGbEHEpG0HzXluUBgIdz5xYngTdB7/iykj5Ay10sBTfZfDgvuFmnZAqL3vxY8Mmd2
        e0ZkjlCG/l4jwrx+s9zdNMmn7hkyiQsmTWBz9fveL0Y2Leb3/3K/EiRKl+2/aMipZiPBPmTUw9/53
        yjcPlhWbcfAqpKD3Gah17P0RpgS4L8tz5qF0TKjnJZY2TAsYuKqbcgcCy0qvC0FCcqNbQlUzq99dM
        aHuQGwiZWrWQWNF2AsKd1bjKF/+8rITlcPGSb1Fn2bkbeSTsnWgs6rNQ2vlPaFwVUO0cwMcdAPz47
        auHT61KA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4aO-0001li-4s; Thu, 29 Oct 2020 09:51:12 +0000
Date:   Thu, 29 Oct 2020 09:51:12 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/26] xfs_db: add bigtime upgrade path
Message-ID: <20201029095112.GQ2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375538851.881414.17245799256703762517.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375538851.881414.17245799256703762517.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
