Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60464F40DD
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2019 08:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfKHHFw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Nov 2019 02:05:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47514 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfKHHFv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:05:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=udWYGBLVX0fhGj7+Efyj8xFvyIaVfq6wrlZL5jfeKcE=; b=SL0TPcIbcIJwiUy3ssz1XZxB7
        cm7ZmUJ/N59omRw8ZtjcqLngEWc7Bo7rIDTNbsyyAzf8iGUq3WDsF6IzlKnktupxbfoomWQT61MTE
        evZ+tlDj0B0JRXmfnhRY3r6KCLirbDV1URZmCez46PgT3UuNIZQ2ui68ru0Wy/U8e6XWWQx7fZrd/
        t5GNPuhUyRHJBhNSrJPRirNLieDeHIjKA3KNa5NKN9MUh8t5zBsKe3DXzESO5OPKFql8gvIdQ9IRz
        PypMhB7B0CzshxnZgzKmTE2fWAs0Ugt36L1lOVYR5Qr6azLfXbVdwlY4WymsQTtJsgSVnWz+/JZEU
        s/wQmxhYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSyL9-0007ge-Jf; Fri, 08 Nov 2019 07:05:51 +0000
Date:   Thu, 7 Nov 2019 23:05:51 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: annotate functions that trip static checker
 locking checks
Message-ID: <20191108070551.GA29369@infradead.org>
References: <157319668531.834585.6920821852974178.stgit@magnolia>
 <157319669162.834585.14162759688911694187.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157319669162.834585.14162759688911694187.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 11:04:51PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add some lock annotations to helper functions that seem to have
> unbalanced locking that confuses the static analyzers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
