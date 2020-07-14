Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BBE21EACA
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jul 2020 10:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgGNIA7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jul 2020 04:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgGNIA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 04:00:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29ADC061755
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1vbPeFwqe4/swz411Aoan9htqj+b30zWlDp0QV3eCzM=; b=B+EuiU+MjX3qaIUPjm5RHCdxtS
        cwlz1O7h+YuuSK3F7vV10kcOmEebFQCRuSsctAXwWgw3qewPrE9G21JJh405T3Fh5KixVQcTb6d6I
        B+ZXqRZkMkD0y5MNgd3A/d64mEj1OrCtcwSHOtbXG65TuAbNOtfcn4RvTm6L+5qTzwYetWUq3UmDI
        0FnS4DZMlnuMKKUasWkQcSlCOeiulG3EjWVNwdkzCbLF2c0TVxNo3222G41V/fjp1zpGiHdEfY0i+
        JWj0IhZ07f4Axn6cicMQCIYu84Tk+90MyItNjWAqSHZErF3oXFF6Byzsh/VHXo8zyyDknidQ0P9Y6
        R/rg9sEg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvFs1-000707-KX; Tue, 14 Jul 2020 08:00:57 +0000
Date:   Tue, 14 Jul 2020 09:00:57 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/26] xfs: stop using q_core.d_flags in the quota code
Message-ID: <20200714080057.GE19883@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469035171.2914673.12819820447339965343.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469035171.2914673.12819820447339965343.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 06:32:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the incore dq_flags to figure out the dquot type.  This is the first
> step towards removing xfs_disk_dquot from the incore dquot.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
