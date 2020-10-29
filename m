Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFD029E799
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 10:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgJ2JoL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 05:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgJ2JoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:44:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0970C0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GgyOTM41H5yfwWE5ApKNHMOeF+4L1AidiprfC8DQzTQ=; b=mZhGEu8cv29tf1fl/GQJmVKtCt
        trg+w6QF/mTMfsmwGfTRKDZYYAQOcM3MS/OSQ2AKpaXW/nFi+133AXBu/CaZeqbPmSjLXt/VLBpsw
        RwX94c1ArU/HqNNpfsrMBvfkKkkKFopwA59MyEjEvuBUA+IGKKRDY0pqkJEz4B5pSMJfhbgO407FX
        YK9A8skkmXU4SsoMHvXnM+nYzomYbVEqMM7PddugyX4afckaV0Ove+IgOdbUS+XGcMWG2cHldyvvm
        /c1U8qk83ohmS/hcZZMH0sLLwK2yM36AHy2/DxujpQDUDo1KYAXyzXuLJN9qTw753g32zd5fXf15O
        H4PJBgVw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4TV-0001Gt-CL; Thu, 29 Oct 2020 09:44:05 +0000
Date:   Thu, 29 Oct 2020 09:44:05 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, Amir Goldstein <amir73il@gmail.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/26] libxfs: create a real struct timespec64
Message-ID: <20201029094405.GD2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375525297.881414.4918118774537695755.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375525297.881414.4918118774537695755.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:34:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a real struct timespec64 that supports 64-bit seconds counts.
> The C library struct timespec doesn't support this on 32-bit
> architectures and we cannot lose the upper bits in the incore inode.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
