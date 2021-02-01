Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C907C30A777
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Feb 2021 13:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhBAMVh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Feb 2021 07:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhBAMVh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Feb 2021 07:21:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C1CC06174A
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 04:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=tL/G0Hw7wLDAAIEtypReTgvijw
        4Iq7zklq2ARQsgWrWqaoqxavdPY93Y/kUgvhXfQtGiLk0wC3wefci9HZTrNhXc2J82SU8Rez4zCEC
        7H8bvT+uqVs23+tafidNdz92MjVV4Ys9Tg2Xtb0HW2TXZLb2DL8NdYW8Vwoi1pYGynyX2b22dUUHs
        VuHiZIjJbwzPfuMK45Bz/G816N2pCiOqYr9AtUUjjIB+JDy4+5E+VGiglez6U1GFYqWAvRN7DORUX
        /Et3654ek0W24jaxHl69XY4Z3b1nw76T+Rx7671fqIXqocMP1GDDVT/QfUGnj2gBMn38jHAjicx5w
        Sf7Uh3kA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6YCL-00DkdO-K9; Mon, 01 Feb 2021 12:20:53 +0000
Date:   Mon, 1 Feb 2021 12:20:53 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 17/17] xfs: shut down the filesystem if we screw up quota
 errors
Message-ID: <20210201122053.GF3271714@infradead.org>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
 <161214512408.139387.13662700404311748382.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214512408.139387.13662700404311748382.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
