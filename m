Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116491680E3
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgBUOzE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:55:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgBUOzE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:55:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Fq4AzH0ZOH+JSuwxyAwBKXdK4XEXVvwJJhdmCwPsfdw=; b=IQRoeZ4QSWKswzFGgcBRa2p9zx
        b7T4Cn0aymxLtPOYwZ7qD306yn6mX4MNT+MPbN15E8WTf9dC6TpF93xQ1yb5RWP6TX2D8t2mrVEmp
        VDRTjAK0X5jY6sATjWPfRRbB6CNjSnxSnloOSLu8wXQuo9WlYqxwCtC6Wlbl0Pw5YyNNVntnqM2vv
        p2SsykXtVqXTQ3YKeQJU0Rl70/DjdacXGRPlOrKP0cLQqjo8WcHcURMEUaPw2ekrsP7lfJzvFQ2dx
        SIleIJFksWP1kv9g7Mq/xj5vMxKREfLzgW9pdP5FfwTrRgj+eJixNdzjaYLilj5ko24Li5z9XgT35
        44KTQCDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59hn-00041H-6x; Fri, 21 Feb 2020 14:55:03 +0000
Date:   Fri, 21 Feb 2020 06:55:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/18] libxfs: rename libxfs_getbuf_map to
 libxfs_buf_get_map
Message-ID: <20200221145503.GP15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216306760.602314.2873425161697294878.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216306760.602314.2873425161697294878.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:44:27PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename this function to match the kernel function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
