Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDD7324B88
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 08:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbhBYHwA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Feb 2021 02:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbhBYHv7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 02:51:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD74C06174A
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 23:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7sfyuctXB8uYi0FN6PBIixfUNABRRtAAM6RgncSFAQ0=; b=i8RrSbtDN8CBTNku/YsT0XFpKT
        jdBJIND4mEtCdan9tqH6B3PgwTDZLHfqipulaBtIylB2wbmTS2tSvBhspJcuZJrE53QLKe7+H0GRq
        TFaHlEUx5DIOlD6+CsmBaQC4yDKIvVD/i84BuFITVJ7Oh52rzF+2t2uMK4PEvA2gXiaVcWvZzXEZR
        S0uGB8Splg1PmeZMdQ26eVd/ENJVA/IbIPOpzCJhcO06CdcLJN2JXP0SHSLevvZR0+Z07TMHDd/wU
        5bT2qqWwXoIMLidAIXhKxQBkEZzwJHDVI+Tg2+O2gYttbXDzRNLFJDKlpZbyuq8QHjoFiYp6f7tr7
        +nyx28JA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBQP-00AQqj-IQ; Thu, 25 Feb 2021 07:51:10 +0000
Date:   Thu, 25 Feb 2021 07:51:05 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
Message-ID: <20210225075105.GG2483198@infradead.org>
References: <20210222153442.897089-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222153442.897089-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As a quick fix this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

That beeing said we really need to go back and look into this,
especially due to discards.  For SSDs it is generlly much better to
quickly reuse freed blocks rather than discarding them later.
