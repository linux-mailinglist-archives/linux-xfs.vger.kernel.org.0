Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EF83B9D18
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Jul 2021 09:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhGBHuu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Jul 2021 03:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhGBHus (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 03:50:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92E8C061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 00:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+IrjHVDlbGz8wTBvijMcSLVethpIGEmvLZz3ziFTRH0=; b=YKLu6evQZv87hhCom0sP/2+G14
        QRYZMnZxHr1XC7CWP/ksQH5qSqoh8yTLJx1gRtXgXmtaHbp9JTs7KTwzJ+3IECIHoH1nwMFbv4yk2
        6aeLSbx6xHXFpLbcXTnag6eFgqcL/Q90pC17VQbABQ0zjq3A7xYgosg9u8AA9CcfZ7YUqCEvVfDdC
        MTtw2VkrWj2hYlzvVv+1AzLSXw1LInd7Jmum8zwZPWkSiQjBz8e54oblslmhtl25YJYRHgDYoIFOC
        Iew5cW6HkXZzXDlu6mpVbyNQTC1FMLYGfSEh1g/pCZ1CRBB1AkIHkC4I2K8EOBrHD5sAPm2Wfgz17
        9Azw7mdw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzDuB-007T8Q-4j; Fri, 02 Jul 2021 07:48:09 +0000
Date:   Fri, 2 Jul 2021 08:48:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: convert XLOG_FORCED_SHUTDOWN() to
 xlog_is_shutdown()
Message-ID: <YN7Et6kfwhGaVfEp@infradead.org>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630063813.1751007-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -366,7 +366,7 @@ xfs_log_writable(
>  		return false;
>  	if (xfs_readonly_buftarg(mp->m_log->l_targ))
>  		return false;
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	if (xlog_is_shutdown(mp->m_log))

This wasn't XLOG_FORCED_SHUTDOWN to start with.  Same for a few more
spots.
