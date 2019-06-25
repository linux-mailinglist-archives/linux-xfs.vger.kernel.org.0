Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADBD54C79
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbfFYKlL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:41:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57296 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfFYKlL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:41:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Z/QGV1746uVB7WH9/odZ5Td6t
        bmdmp2ljC7VU1CwrE7Vf2GOhtFHn8oH5DXFjb3x0fSOvcOllOrIldq0opEarYzZE1hbExkYAI93bU
        7V55OHD6+hNxe6CUGDCrbE+BqxKOdsMsWXCgGAosziHmqC1mcw4PodqgoT8hhVdhv5F0lUqne9rkr
        Cm+P5lGbUbYURWv/xSTJLpKU0nTYI2I0yROl+IBYemsU6vfkEntc14huYjzxMpksBLnGFLvaUn4Ep
        cQ3S7eYD1T4vmyobSe1H+86xhTu8AOyTwvcT40bI7ainndx+H4hvmtgHUPcG3uk7Kz1BW2qZDosx/
        ZhBzc/kog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfisw-0003JD-Jy; Tue, 25 Jun 2019 10:41:10 +0000
Date:   Tue, 25 Jun 2019 03:41:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] libxfs: make xfs_buf_delwri_submit actually do
 something
Message-ID: <20190625104110.GG30156@infradead.org>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
 <156114705295.1643538.4760286307932278728.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156114705295.1643538.4760286307932278728.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
