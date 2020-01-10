Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F63136C54
	for <lists+linux-xfs@lfdr.de>; Fri, 10 Jan 2020 12:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgAJLwU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 Jan 2020 06:52:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgAJLwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jan 2020 06:52:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=t7yDZiI/Mrbo8/Hzp2G6aWT6MxFBFbGngD7E4cok43M=; b=fx6WBpxOXfc46PtTD8i74KdNu
        j0l1AV6KjFZluZ5b6FXbFv4SKg9+84GdGldJjgawV/6nSiG70aqVe/qEpuqeaNEPRYwh2RO1QdctD
        QzODKzxymfoXyONvoNtlWaPzVf8yEAVSGZsXuBkofkD/GMCVqYCBqIqFQWcd1LU7WXUM8QyP8Zj4T
        P5iKPlmSxYjMEglUNk9KaJmSzgytGS7GnKHer6Al7NYV6ojURwykPX4oNlPStfxEBp33VywDHGAGu
        iRTM32YFS9qdC34GTM+YL0AaKBQGwcJplkNZ4jf7dheDDNCmAx1a45c1qYL5bU8eDU2eOOwcJgw3r
        90S3fSJvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipspv-0005sI-F4; Fri, 10 Jan 2020 11:52:19 +0000
Date:   Fri, 10 Jan 2020 03:52:19 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: introduce XFS_MAX_FILEOFF
Message-ID: <20200110115219.GA19577@infradead.org>
References: <157859545662.163942.11245536419486956862.stgit@magnolia>
 <157859546284.163942.8882319204815065001.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157859546284.163942.8882319204815065001.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 09, 2020 at 10:44:22AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new #define for the maximum supported file block offset.
> We'll use this in the next patch to make it more obvious that we're
> doing some operation for all possible inode fork mappings after a given
> offset.  We can't use ULLONG_MAX here because bunmapi uses that to
> detect when it's done.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
