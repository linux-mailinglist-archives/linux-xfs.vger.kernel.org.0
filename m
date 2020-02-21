Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B3416808B
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgBUOne (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:43:34 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43922 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgBUOne (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gaypOceMVp3+429H2vpgF5by9H1nD2uz8DhJhiDb7XQ=; b=MmaylsG6tqBuCfbmvu8ldycNTu
        Xn8STBDacXsf4EldmWaYd8RWhLmwr/vvNC7HyAjQn2MaJMA0oYziOz/8NzkAcZ14+a/lxZV08sxWW
        LxNC4eLagPlm32ghV8i1GW3UxLUAlg7F8HoP7ihv9sRTMuoNGVD/9udY9PvIq+D3+SLte2BUk7x5s
        QJ8iCisJemFBOXXDjrVHjjekgXEQMYYJD1kAzLqFdfhWyyR8aToNio3BF5HHOA2F1rWzqTTrICtoF
        rnfdY4ZKWaVwWO9umbDVkefHkaiM1eR/0lZxw3ZkZdNCkwaLkag4rFuDiVvbKfjrdSKCdPgrVIliF
        SRaXbhsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59We-00066y-QU; Fri, 21 Feb 2020 14:43:32 +0000
Date:   Fri, 21 Feb 2020 06:43:32 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/18] libxfs: replace libxfs_putbuf with libxfs_buf_relse
Message-ID: <20200221144332.GB15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216298043.602314.11584630332389192986.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216298043.602314.11584630332389192986.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:43:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Change all the libxfs_putbuf calls to libxfs_buf_relse to match the
> kernel interface, since one is a #define of the other.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
