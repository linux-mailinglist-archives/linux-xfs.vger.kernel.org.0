Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D7F136CA2
	for <lists+linux-xfs@lfdr.de>; Fri, 10 Jan 2020 12:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgAJL7i (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 Jan 2020 06:59:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45620 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727735AbgAJL7i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jan 2020 06:59:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tCI6kPFo3kZR0h8MlulTn8D7YLgba1IxclwFXAy8oZw=; b=CHmQI7e4PzBL7c9JdN3I9LFWB
        vUK6QWDimw0P+EmHpNG2Ov3mHJmxctyxw9xpoE7PXVbUy+GMYG2ejHDvahtPLYGX2+mM2PA8GSlL1
        G5GTYJ+5GVpDcYLp2eCoIslass7mw5wajIMoc7hw6YpSPhHjGekLyI8Of9YUpouRoEgNMKgUl4MpM
        Vjj7oUDXBtdcsqb0qGXLbIeMRE2CGYNiB7623NWE3BpmKld+Ap+6GS7KbjO0Nm8OQMZCuDwSrHEvP
        UA/+akMiJ5lYLLzx8UcjuRiwgPlPhQ1n7/Twe0W9m0a7gJHmpRKqLPBZRFzdZ4iX9Z7LlRjIFmDIK
        RtV7ZTCFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipsx0-0003xI-89; Fri, 10 Jan 2020 11:59:38 +0000
Date:   Fri, 10 Jan 2020 03:59:38 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: make struct xfs_buf_log_format have a
 consistent size
Message-ID: <20200110115938.GG19577@infradead.org>
References: <157859548029.164065.5207227581806532577.stgit@magnolia>
 <157859551417.164065.16772455171549647070.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157859551417.164065.16772455171549647070.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 09, 2020 at 10:45:14AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Increase XFS_BLF_DATAMAP_SIZE by 1 to fill in the implied padding at the
> end of struct xfs_buf_log_format.  This makes the size consistent so
> that we can check it in xfs_ondisk.h, and will be needed once we start
> logging attribute values.

Isn't this an incompatible change in the on-disk format for 32-bit
systems?
