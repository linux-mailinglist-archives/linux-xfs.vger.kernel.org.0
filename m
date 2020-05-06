Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0390E1C73A1
	for <lists+linux-xfs@lfdr.de>; Wed,  6 May 2020 17:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgEFPJ4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 May 2020 11:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgEFPJz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:09:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D448C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5Utj4CU3gLLwZT4XyK8+4eDpiqEwEoOfMabHn3X0U+s=; b=qnCVAOJnucqNmWJ8EYVV3ochTz
        oD9Cyjhg5u7jNJ/qfpsBWnFngqJlM2ws2oUkELRVCulkilcJromo6yUy32tugOzAnBGZcaEkhTYzV
        Zixyz3XQDVNQb1pBwpnWa08dnxhToxZjPxfcd3s96guLHssqa0m5wJboY8H2N/bylqVs/E0ZS84SC
        mIS0+UfqadHrLYpvy3wkvl4m2NW5U22V5wktP4OEIJ7iwZx6QbYChH+1682ax/Dfvj0zaBcRzmaQw
        hJ2/bPuIpI4vB689CE8a3yR0JynUXhWWHUvEX/7S0BUdfqc+IUYLrqGIWzfi2FwsgsaXqKvmSo+pq
        DIb7dSNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLgI-0005KV-Jf; Wed, 06 May 2020 15:09:54 +0000
Date:   Wed, 6 May 2020 08:09:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/28] xfs: refactor log recovery buffer item dispatch
 for pass2 commit functions
Message-ID: <20200506150954.GH7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864106385.182683.3260001158975713924.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864106385.182683.3260001158975713924.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:11:03PM -0700, Darrick J. Wong wrote:
> +	if (item->ri_ops && item->ri_ops->commit_pass2)
> +		return item->ri_ops->commit_pass2(log, buffer_list, item,
> +				trans->r_lsn);
> +

I don't think ri_ops can ever be NULL here, so the check should be
removed.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
