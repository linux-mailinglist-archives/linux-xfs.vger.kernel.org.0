Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C8A1CEED6
	for <lists+linux-xfs@lfdr.de>; Tue, 12 May 2020 10:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgELIJ3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 May 2020 04:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbgELIJ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 04:09:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C3BC061A0C
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 01:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2FL4XatdMYXFNaViDoikwLcDQEDqJSW2Lp2rzyRGqSk=; b=XOrDe+RbL81ALCn3IaUosJAeWz
        0Gf7ukwobAQokAX3HETNt311kz4nMtISNP3m9MVthM9+25xTWcjrAt1pyL1KDN4ClBtMQuvPrxwrw
        qzUSPhfP1HYPzRSLvkiIo5gWWkH8gqp76QjxfLooRp83NlHcorXn5fMgFAo7QecMWtXONjOyFqeBn
        Xm2vDfkwFciGkhZI4KqQYxQWFGzn4FQrYwvSdulSeUpdPeIIU9cjmCfczcXOQjL7E4TSt7+5JyD9I
        O5B9HVLhTJw4mNhQ67mkTi3ZGmc0T2e0BzPNyXlheJejW9K75E5XAiHK+nyIdRXotxoox4kquIqqx
        9DEFWzzg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYPyj-0007d0-1Y; Tue, 12 May 2020 08:09:29 +0000
Date:   Tue, 12 May 2020 01:09:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs_quota: refactor code to generate id from name
Message-ID: <20200512080929.GA28206@infradead.org>
References: <8b4b7edb-94b2-3bb1-9ede-73674db82330@redhat.com>
 <b5668fd4-7070-4afc-f556-8445ef41fab7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5668fd4-7070-4afc-f556-8445ef41fab7@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +static uint32_t
> +id_from_string(
> +	char	*name,
> +	int	type)
> +{
> +	uint32_t	id = -1;
> +	const char	*type_name = "unknown type";

Any reason to align the arguments different from the local variables?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
