Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E4329D47B
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Oct 2020 22:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgJ1VwU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Oct 2020 17:52:20 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgJ1VwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:52:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TrkgTSdz9Ch5XARf9KUEnaUkpHDOCnH/L0UNQYI5Ouw=; b=Rk2My/vzGX2B4cK9mXon1JR4FZ
        uMm9IFlGo1Vl3f8MllNop37rbaImvOzeQFTXbwF1ETgCufuXqxZR/BUPYzPxAn71j6Be4TrRGOqUh
        CCNY5E4q0CVGZVhbhalpkXffS9P9fMe2r6ahCQy1lqHOGxRDRxeHz0seSNNwdsmgDAcwzkQBa4Qbl
        agC1ONTD1FNPiBKI92TAEb8AQ6JsuUuYWbeeX0iMyZljUzGhZ5wM6jvMwgSm2d/Cxb5ypQCgW7HSn
        arn7iVxDgfvDeBoSZSgWp2/xo6VUzes3YFgiMgpB6DJtz+SBMuj8NXvE+Ir49caSCtnxgn6FWKTw5
        MT2a4CMw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXg6x-0000qM-MO; Wed, 28 Oct 2020 07:43:11 +0000
Date:   Wed, 28 Oct 2020 07:43:11 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs/27[26]: force realtime on or off as needed
Message-ID: <20201028074311.GF2750@infradead.org>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382532889.1202316.11271089772377137054.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382532889.1202316.11271089772377137054.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:02:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Certain tests have certain requirements where the realtime parameters
> are concerned.  Fix them all.

Certain tests sound like a lot for exactly two flags :)

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
