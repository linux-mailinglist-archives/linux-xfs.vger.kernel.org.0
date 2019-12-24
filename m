Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B04129F35
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Dec 2019 09:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfLXIjR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Dec 2019 03:39:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36174 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfLXIjR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 03:39:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7RtsRvXL/OT5R4i1kB+q/MHMarLarNN508wCa6Na1T8=; b=TbW2PnNl96TvsWRoVq0UW2DCA
        HW25YfXwZ9rWtRWC8P0COso55C0BUlMfhiTw/Z28N63VExbQvrDMXAYrMDmLxx2qgPtKGdkdJX/VX
        GiiBaBnX0lUnOw1HqKx6R9nztFV9iefTTbdyP9pixp0Od95nzNyUt1f4jnpqJO68VA4m6L4pi6bRa
        Mk03gyBJGwJFjbDK4o6N6s0L6wTmMcYif+li6c5DpgkbrPhMdQmbpyS/6NnnZzenY5vxDUaJx9Mqg
        yRsD7zv2T9o249dEW9i5YBfm40Q2UVVglbSsUnzWNRzGVGLVmzSrFqklUcnVcKS23cycT8k2V+iWX
        9Nn6Knv+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijfii-0000wR-RB; Tue, 24 Dec 2019 08:39:12 +0000
Date:   Tue, 24 Dec 2019 00:39:12 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, y2038@lists.linaro.org,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Allison Collins <allison.henderson@oracle.com>,
        Nick Bowler <nbowler@draconx.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: rename compat_time_t to old_time32_t
Message-ID: <20191224083912.GB1739@infradead.org>
References: <20191218163954.296726-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218163954.296726-1-arnd@arndb.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 05:39:28PM +0100, Arnd Bergmann wrote:
> The compat_time_t type has been removed everywhere else,
> as most users rely on old_time32_t for both native and
> compat mode handling of 32-bit time_t.
> 
> Remove the last one in xfs.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
