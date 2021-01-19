Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A574C2FB2ED
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Jan 2021 08:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbhASHY4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Jan 2021 02:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728538AbhASHY1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 02:24:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8F7C061573
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 23:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lRTWjwiauKRwkWEWso2+OuDL6i/kyfkQyQL0ejD6guQ=; b=nR6PRcoimomg6/e6ts2VXPa3cK
        jgnCkhwkALR3gmxypHG9fKNOc687wtTi/8N2q9Bwm1ULl41vGJCNAl0vTRSfHRXTvIf18QlpkAzcK
        rnwukirYLB47lsweiGiCreHr3Aq6z1HoXli1sIk1ipTrKqzmQGxCA9JFQV/KevkPPdJsnS4tnrztr
        PR7sKEd6p+VhiNPIg5yUy3G+2EfqbVHMwQmES8QAr2gDfwwb2hhdkFpc+HWN3bhNzzP9f1ZSYIjLa
        JtE5/IoKwPzpIILipkh+CRcKLByy4Jxk4E8qUMgGAypVaiUonCZysLfVXRPYY+h4F15/ZVgcaoLSl
        vINx6EpA==;
Received: from [2001:4bb8:188:1954:b440:557a:2a9e:a981] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1lFI-00Dx2J-U6; Tue, 19 Jan 2021 07:16:11 +0000
Date:   Tue, 19 Jan 2021 08:16:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: remove trivial eof/cowblocks functions
Message-ID: <YAaHOFlcJguhPrG5@infradead.org>
References: <161100798100.90204.7839064495063223590.stgit@magnolia>
 <161100800330.90204.7868136774892860968.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100800330.90204.7868136774892860968.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 02:13:23PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Get rid of these trivial helpers.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
