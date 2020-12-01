Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7182C9EFD
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 11:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgLAKSz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 05:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgLAKSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:18:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827C1C0613CF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Eq6QiAZWE1ToTO9OoKXosvX4e7
        3uUE2lwdDn6EGs5yYaxnYFWHHIuDtCqHRGAes2JB+ChwmxtlvlovhC1ZgYPSMhcUTcjDKLq4esiAa
        9WSPX+FqC8VaAzlr0LXAqG262ZLhdE56/0acWwjG+40793OWqWiaTomi5pN+7XOsvBSjFQUQqq28J
        gx8sPV11fPgyNt8j5mnC6OTJC6i9bFMPI1rVB9kj4DlvEAKpMNMjADz88vTAq5yg1I4o2NxyOsMFp
        Yx2MtT9+Aj0205JZvPQrXiYSPoFZlicJJ9eMHFp7jlcTvhlcwaYBlOexVJWdmd7ZlTUxJo1SAAF4S
        edmsRxNw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2jc-0003yz-Uc; Tue, 01 Dec 2020 10:18:12 +0000
Date:   Tue, 1 Dec 2020 10:18:12 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] libxfs: add realtime extent reservation and usage
 tracking to transactions
Message-ID: <20201201101812.GD12730@infradead.org>
References: <160633667604.634603.7657982642827987317.stgit@magnolia>
 <160633669427.634603.6917592828334064504.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160633669427.634603.6917592828334064504.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
