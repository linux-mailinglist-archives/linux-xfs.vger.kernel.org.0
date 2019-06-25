Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6306953043
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfFYKhl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:37:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55850 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfFYKhk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:37:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=cy16i3cSV86689+W4WvLvlg1G
        /zJ66sh3MwbJhb+qXwrD2DEHHV16tOvqlz/r5j9917ppuzvjle9kiYHZf0MRzc9SZBuNDcRDUH+PK
        CU64NhA6pGL5n9rmWv9sluMd38X4xijnXDP2ndRFYFlfYzJmabj4NkLKWVxcd0fMoTVeiqck0wnQA
        CyzPZ4h0flFHgjE4lLD/UkuXCP1GArxxn28Sy/zTMiJiDvFKNYxjUDaTsiaBbQiAOvjbObULVqx+6
        83gAw4OW3H1nblYoqFaBWKeSfQUQeiAqlIQN8q7R0kk9RS/likm7WPI4F0LES9a8f+n2kDM0vjsaE
        Zja9sU/Nw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfipX-0001fg-DM; Tue, 25 Jun 2019 10:37:39 +0000
Date:   Tue, 25 Jun 2019 03:37:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 1/6] xfs: refactor free space btree record initialization
Message-ID: <20190625103739.GC30156@infradead.org>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
 <156114702011.1643538.11896501170862991755.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156114702011.1643538.11896501170862991755.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
