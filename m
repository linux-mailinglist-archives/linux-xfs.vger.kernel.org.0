Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA612C9EC3
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 11:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbgLAKG5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 05:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbgLAKG5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:06:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33150C0613D6
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XCmCUzZdIPLbabAM8g7/FYCmen0JwvKS3DRhgbjEGqQ=; b=oYTJcbmP+piwfOQv1dMwy+5TH/
        /OOGVwa4S/AKYmMSSXAx4Q03PykoKsU2Fo28BP3G6yLHboiuCh9v1hfO6R2MRuo9iq/VJ6q2+Gp/g
        De7y1xvHxu1o1tOc7ooty9R8n4KNBCPIzPTrVrlNUGTGm0/bn6SMRKXz0hKZY/DTehoPNxNVMrink
        PTaX+DamLmxAszPeWIEYOUrmNyjWPhI417FUMrMtc5PPwwu0yuwaijteciq9ogozM6STrSR5+RSxU
        yjSAWiUhxFSZzEPxpYAWcMTntU1h57EYJmImkDT2p6E/cpvcrirOXP1Eb32Q03bnoBtCTFLDYJ7iV
        c2PyHJEA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2Y3-0003BZ-Tk; Tue, 01 Dec 2020 10:06:15 +0000
Date:   Tue, 1 Dec 2020 10:06:15 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: improve the code that checks recovered
 refcount intent items
Message-ID: <20201201100615.GG10262@infradead.org>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679389653.447963.16793899927769871684.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679389653.447963.16793899927769871684.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good (minus the same nitpick as for the other one):

Reviewed-by: Christoph Hellwig <hch@lst.de>
