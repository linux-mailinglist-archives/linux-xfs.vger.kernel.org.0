Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D22F1CC2CF
	for <lists+linux-xfs@lfdr.de>; Sat,  9 May 2020 18:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgEIQhR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 9 May 2020 12:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbgEIQhR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:37:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1130EC061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 09:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=rg0FQW2+/sybv784cQuRxrTcFK
        2kNZqZ7Os3wz2MSGw6uovAVd1VSSmgJtPfk8qtmzibtiKfV3nVrMa7idRdfpjT0F9urvzEtUjD20F
        PYpXtcli1GGeYsM49G2oYiVZBbYiPWu6e029x1EXG3QIN2TVU/+lGDIq7lQMFRbQyzb+lvl3uF0Sz
        QrwjVuClkEEXSmACRCTrF/kgmnvjTer8ajXLOvIjRVd1LLoFHj2Y95sDczzEh0h9H8guSbFKaYE/q
        IH+pJiaxRqXqm12XyBNCmiL5bghr8arbxcDAtRrBtR+LNL3zn7qve9jI0Dc2+D4FRfvvZl99xVvSI
        l03KN5Ug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSTU-0000BR-7z; Sat, 09 May 2020 16:37:16 +0000
Date:   Sat, 9 May 2020 09:37:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_db: bounds-check access to the dbmap array
Message-ID: <20200509163716.GD23078@infradead.org>
References: <158904177147.982835.3876574696663645345.stgit@magnolia>
 <158904178997.982835.3080374978418485288.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904178997.982835.3080374978418485288.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
