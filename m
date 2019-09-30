Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13ED3C1C54
	for <lists+linux-xfs@lfdr.de>; Mon, 30 Sep 2019 09:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfI3HwH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 30 Sep 2019 03:52:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40774 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI3HwH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 03:52:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=pj+4I92RkV41NHBvoHc6SNHrs
        BqfkEQtceWLqbqus32IckB+chiLwARz6UVFfYaZF/f+E+XZT3KkmdISt9yK+MO74L0uHHz7Pgiu2l
        zVhkz2kzlO/BP1qJBbcQDNso29qVz4KLCDyaIQ8XCXCJpdiE4GtDQpF+1DW6/4m/jYbemT6iLgXCB
        eF0tRCAAxSMWd1Gtji2w+XMTe7BKU5e55B5rSRXj0EFvm0l0RyQE/BqHCgU+BxhAkBC7dbdBdXPi3
        pgID7+G8e5VuzJsJ11n6/1Pr31M3HAyDFsczKFhGv4fEy36ZesaxeYy5GrJyZWD/D00nQkam9mpD2
        pkr6kApGw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEqTW-0002HI-Bk; Mon, 30 Sep 2019 07:52:06 +0000
Date:   Mon, 30 Sep 2019 00:52:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] libfrog: convert fsgeom.c functions to negative
 error codes
Message-ID: <20190930075206.GE27886@infradead.org>
References: <156944760161.302827.4342305147521200999.stgit@magnolia>
 <156944761997.302827.16411723774344852077.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944761997.302827.16411723774344852077.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
