Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C882CEBE7
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Dec 2020 11:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387624AbgLDKMH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 4 Dec 2020 05:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387621AbgLDKMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 05:12:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA38EC061A4F
        for <linux-xfs@vger.kernel.org>; Fri,  4 Dec 2020 02:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=aw/TBJwhyq8Yu/bCtSytylvXoQ
        C1oG7wANaj8wx+1mBCJk4KKOE7tgOdRYiP2yHOWTU+s/tnWz2Xacv01jVvHujVKmcKCItIvavLU2t
        2Foq5yEnc5pRiIoH/hWn8ZhSJCuEK27wnU4wymC97BoaCVibYq2lb0uVioBgdspVHqGvYABV7lnAv
        FdKCGG1ouV4BiQPv5pupHfjI6/Re2wRu6Xbjp2VnfQrYGPsTZDFcw84dy6dBaRzrt5wTjkD+Fdjcq
        vR9LO7d8mXgmHBrLewGuwOBkPToJFhyT/x1rIpH8wJqbgctmLlogC/Soa+V282x6qTOrmfToLY/0f
        FdanLqDA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kl83c-0000gq-Da; Fri, 04 Dec 2020 10:11:20 +0000
Date:   Fri, 4 Dec 2020 10:11:20 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: remove unneeded return value check for
 *init_cursor()
Message-ID: <20201204101120.GD1734@infradead.org>
References: <1607050104-60778-1-git-send-email-joseph.qi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607050104-60778-1-git-send-email-joseph.qi@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
