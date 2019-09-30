Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0BB0C1C59
	for <lists+linux-xfs@lfdr.de>; Mon, 30 Sep 2019 09:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfI3Hwl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 30 Sep 2019 03:52:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40792 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI3Hwk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 03:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=g/d23njJKEd4yL5befu7UJGZz
        9O+WOXk2dIvIR9N1MBS9veZJhzxPJWfp0KCL0hcucknazD4km2WPiY2rpMDbRIRODcLbWVKVo24On
        ng6eg7zYRNY0tPIl8XRH5ZIkz4NbgFeYEjsaslUylUKIQbrAV4ttX8sKDGkvk83h+SLNhaJNuTt21
        wMhZiTsZKF9VyuhyCT4R17xz9tB5jJG/x7xRGT41rlxRrPu0xXU/QhcM6Q+C83iHbHCzVjGTcpn7r
        PYyYO66VM6F41Vcd1FR7t+gnJgsXnQah0/TXvQtN84J+2NLYVnPUa4mwzHXAz3b9u5QqmwkAunK20
        GEB+xPPLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEqU4-0002Jp-1x; Mon, 30 Sep 2019 07:52:40 +0000
Date:   Mon, 30 Sep 2019 00:52:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] libfrog: convert bulkstat.c functions to negative
 error codes
Message-ID: <20190930075240.GF27886@infradead.org>
References: <156944760161.302827.4342305147521200999.stgit@magnolia>
 <156944762603.302827.13603687068573848955.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944762603.302827.13603687068573848955.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
