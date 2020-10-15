Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D8928EE76
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgJOI3y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgJOI3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:29:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F8CC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SAm3ygmYG5mR1kg+ndf0KkSBRNrx3+O+9Fxp+RHtxcQ=; b=pgkE/6OOEPxvekUybVOnv5yy5W
        CucufnEu26NyuG3Hokr+1rOaud8ggU/X2PUWpuyx8Z+03IZfWFHBCnAx4BbdPN8fObSQ4j5Gu8uFB
        otifKYxzqsd99Qc6MOZNwqqu29RPqZ5WLMQfy6OfZ/obHQ6JHWQd6uscy6d3rHQ9GCmgTgVyfKJBm
        GasEF4wDv2Yu6DDm8/vaBBNVV8EueFGqbqUALwOSSU8m291a4m6wdbnLKGFeeQWMA7dQNSSOCnMAE
        ZkZg28L3HOsPQTomsynKbIMO65wHu+sZp4H63ob881PGw7quUOVohZK17iHV8kILBXoWJuo1UOsmV
        JkSdk5/g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSydq-0001MW-ED; Thu, 15 Oct 2020 08:29:42 +0000
Date:   Thu, 15 Oct 2020 09:29:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [RFC PATCH] xfs: remove unnecessary null check in
 xfs_generic_create
Message-ID: <20201015082942.GD4450@infradead.org>
References: <1602232150-28805-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602232150-28805-1-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 04:29:10PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The function posix_acl_release() test the passed-in argument and
> move on only when it is non-null, so maybe the null check in
> xfs_generic_create is unnecessary.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
