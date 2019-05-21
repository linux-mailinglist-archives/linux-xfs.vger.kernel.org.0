Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F3E24A72
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 10:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfEUIdQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 04:33:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51142 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfEUIdQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 04:33:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ikQaEDNGm6WE53B8+IanowZD1
        jqDtJefR62WtYUbS3q+j1D2O2ZxnRZSM9r/V++pINCoYdtunxoaeNoDgqO10xUH+dvf1zm2T/UIVJ
        xRVHILWJdCmmf6zCnOrmvBtYEcRv2aljzsc0rWyIMxBEFqTJAXkXd8xKQk7degGRXwlNunWaUKVmw
        2SWoTy+CarP5D/KV9xfyHAprgdYXifMyto96t6VvSJZbw/gkF76u5aTkwDJhju+SO+dcNaFfo9ak3
        JeydwTMQWGWV3GAsiFzoVQOKvcXcMfNr9WdEKebPL07nN2H5vpliXog3Dg6T/cDqEwnZ6d5Ruchkg
        FsfnOKN9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hT0Cx-0000QA-IT; Tue, 21 May 2019 08:33:15 +0000
Date:   Tue, 21 May 2019 01:33:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] libxfs: Remove XACT_DEBUG #ifdefs
Message-ID: <20190521083315.GA533@infradead.org>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
 <1558410427-1837-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558410427-1837-2-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
