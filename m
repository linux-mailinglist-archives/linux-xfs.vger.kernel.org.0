Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D326519BD0B
	for <lists+linux-xfs@lfdr.de>; Thu,  2 Apr 2020 09:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgDBHtl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 Apr 2020 03:49:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41812 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgDBHtl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 03:49:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kqJkqWHRRonUo+dJxuMwQkk+85+ybLMx/4Jp6s1OX+g=; b=NYCNCvfyifWnqpNL44gB+OoRF1
        +Ca3XAmyW1l/bW4IwzBykO6HgmXem1y72aKll7BoQkkDDFfL7akuVMJCmU0llSLNpOuyJuezDp/pG
        qpk2z5t+XiLNdQKMkQzAqeLmIdFYDHNUE7PE/bHIFTP0ujQUOfrfyX1d439jKsAKJZ+HY82izci8+
        E3hNMegO5nnvhPNgOoxuHVcnu3bHZxPLYum73NYa/Gzf5V0l+49dqKH7TnVW7p8jXFkx1sEUYEARI
        EGMiKwbH3Flu8YRtc6DpxfrhrZqbG2rNzzsinVLlnk2ChZIzAXqwJc632A81VpWVbEmomt4XwIH1F
        4rKDA+qg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJubT-0004kh-5m; Thu, 02 Apr 2020 07:49:31 +0000
Date:   Thu, 2 Apr 2020 00:49:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: combine two if statements with same condition
Message-ID: <20200402074931.GA17191@infradead.org>
References: <1585794394-31041-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585794394-31041-1-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 02, 2020 at 10:26:34AM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The two if statements have same condition, and the mask value
> does not change in xfs_setattr_nonsize(), so combine them.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
