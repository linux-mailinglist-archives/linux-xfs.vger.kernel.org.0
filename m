Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224BA136C91
	for <lists+linux-xfs@lfdr.de>; Fri, 10 Jan 2020 12:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgAJL6E (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 Jan 2020 06:58:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37298 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbgAJL6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jan 2020 06:58:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UxDXlcFh1UotoHn329UeW6yJ4xasCEA896EXa6CuQNI=; b=eFUc0zYVO0tOwRl4cwTjitTno
        CjeQF6Xhxcj/a3vyHbb2ug4JSARMYEtlIp38LPT5tQfohNgQFZ2WmSe1rB0EGDqDXb31vGJ4j+a+W
        ZC1FWCul+bZHV3tJuTZKtIUMgAK3naz5HHZaKIhSio8z2ejno0zFcBW/jAzEovhMcSsURpGeHkU0t
        RrjanjylQ+rGQOQen+LjMSD2/F0XF+W1UOaFwUyzBiRV1p0Or55klUV/2Rg/v6w3X8eusfuH/G5hB
        vELKf/fR7ML4yq3H/e5b2h0mtp4Xo1V29darWmAeAgP++tXEApYQnjM5Um/4WKxEHgy23rZus86k2
        3IPkux/EQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipsvT-0002VC-MV; Fri, 10 Jan 2020 11:58:03 +0000
Date:   Fri, 10 Jan 2020 03:58:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: clean up xfs_buf_item_get_format return value
Message-ID: <20200110115803.GE19577@infradead.org>
References: <157859548029.164065.5207227581806532577.stgit@magnolia>
 <157859550017.164065.4715415441588345394.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157859550017.164065.4715415441588345394.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 09, 2020 at 10:45:00AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The only thing that can cause a nonzero return from
> xfs_buf_item_get_format is if the kmem_alloc fails, which it can't.
> Get rid of all the unnecessary error handling.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
