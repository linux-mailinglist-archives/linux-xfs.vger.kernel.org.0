Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5C22282DF
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Jul 2020 16:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgGUOzC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Jul 2020 10:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGUOzB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 10:55:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0F6C061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 07:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+Mjq58qljuo2nY3WQj6WXm3nB4Pt+fobTLMC8bUFC9g=; b=P3WgWHn8Mt5aalvPw7aBLBgmi3
        7SRrbPmrb9+N44CeSXEHNWQ94vNKgXXHuOgr601fh65Mm72uX3A8lXeOZJeobcyxVhHXDRh1dhzBb
        2UY/TWpBdRz3cng0+UnFN/Zk9px9TcGJrDJ8c243hsYduq6Zw0HanORODlxmrDDLSN2CQmPFqwIOJ
        aoCqzkkVU7RMxPli+B+T4g1XUUFyb3epuB3TFUSE1E02WXWtoeb/CzStpc2E0GbPnVH06ZY5p2PKU
        Ewb1STKQE0/rEuPJLRt4LpIwTNdvGoFbKjV/2IWGxshToKf4+Yi+Ks+HdON09trCvK9nBmNdccl+q
        GqbabUwQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxtfY-0001f7-2t; Tue, 21 Jul 2020 14:55:00 +0000
Date:   Tue, 21 Jul 2020 15:55:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: refactor testing if a particular dquot is
 being enforced
Message-ID: <20200721145500.GC6208@infradead.org>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488193887.3813063.5488114906141814243.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488193887.3813063.5488114906141814243.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:45:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a small helper to test if enforcement is enabled for a
> given incore dquot and replace the open-code logic testing.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
