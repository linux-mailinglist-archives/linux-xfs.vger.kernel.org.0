Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4C321A104
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Jul 2020 15:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgGINjL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 Jul 2020 09:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgGINjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 09:39:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E8AC08C5CE;
        Thu,  9 Jul 2020 06:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=kF+/LFj6cRZ3i3eEh43CqvcZb5
        fu3d1sxuEhwrJeTcKSOMK54drnqSvpybExoc7nU9vbjP1PRhWYHP1pXNy7+n91bGUepZ+6CtPRvBA
        9pZvN3GvGQHkUO0XrkK5GG6PD1FugvlJ136tno/aLCPHxZacmPeSCbM937RIgAVlB7y2pDchK9xgy
        +5Mf6knE0ZCUVYiKQ5Nk5FdOEOiwyWW/T+O55NmIUBe2Fjx3KM1ywXWcifNW6lAgpYS4jC89duuyx
        wO2YgGo+YrLoNWMKtFaAAoARPblYe+crUAlpbmXW/j8CZOwsvnDoOOhRFRavBeQ63TPK4h2/3hCxN
        9heAbS9A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtWlW-00015J-0y; Thu, 09 Jul 2020 13:39:06 +0000
Date:   Thu, 9 Jul 2020 14:39:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Waiman Long <longman@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v6] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
Message-ID: <20200709133905.GB3860@infradead.org>
References: <20200707191629.13911-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707191629.13911-1-longman@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
