Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEA72C24FE
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Nov 2020 12:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733085AbgKXLvq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Nov 2020 06:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733083AbgKXLvq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 06:51:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF501C0613D6;
        Tue, 24 Nov 2020 03:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UX8cRRymouOvZ6Oa32+nXpuTvbitXtsyLjlmpwjgQyY=; b=FpLKZmgaaCAalC16+8nlAMLvVw
        j6btFCUG2nmLwR5z5JLJ6c42vN+ZN0PnPTMo6BaDZ9M0yMp4Y2uwKU/13xvXslHdgok4GUygocuC3
        kwckLtL1ZTSMerdVE0vJsHxRM8j8t58fo4fc3zElLK0yaQC/jFoQTOxy+n215WiApv/b1Ox1ehPvp
        SY+Ly5qt3nINcWaXaMumWp1xspANkJDqgIsyez7mcIZZWplK2M+y7yqpQ5uKgSzh2thNt7ZbbwXPl
        FZlc5GeMP5mZPdjRpgXeOx6lmEMDCemHqEnRaQVAGvuvTR/aMEhzsuL5ldnqnKRuFq65fkcySk4O+
        uKaz0WMA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khWr6-0000Oh-06; Tue, 24 Nov 2020 11:51:32 +0000
Date:   Tue, 24 Nov 2020 11:51:31 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: check the return value of krealloc()
Message-ID: <20201124115131.GB32060@infradead.org>
References: <20201124104531.561-1-thunder.leizhen@huawei.com>
 <20201124104531.561-2-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124104531.561-2-thunder.leizhen@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 24, 2020 at 06:45:30PM +0800, Zhen Lei wrote:
> krealloc() may fail to expand the memory space. Add sanity checks to it,
> and WARN() if that really happened.

What part of the __GFP_NOFAIL semantics isn't clear enough?
