Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1271680A8
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgBUOqe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:46:34 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46978 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728611AbgBUOqd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:46:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dHSqM6s4A7nkZWJS1Ap+5+t9DJ1hX1I4kfKHSA6Ehh4=; b=dokXJ3VEpMIeMSooMhG1BYBA8R
        nlBCx4UUVWgANT/MBFmuG8qeCrHIVHUw1Q8k61jl4NLq2ozOQupiWvjfWtervQgJ1nk4AJ5+vRIhj
        ZmfEFbm5V5ESo+TrPeOjN0w5I//fqxbi959xU9hOL+KEJ/XWckSrImbdONyVv3I3VQ3AzYAU5oRTc
        cjekRILMbvS9ScS6c0m3gjf3wkrZWkzsIibUyrzBYMAmc02/FW2ySGyfguSvfr4mRf6nnEVYMugHX
        kRJhBJbCm1NrEsfbKNExC49PnBTcUFg+EpdleMUd18RovGwH6sOfXRATS56hyO3DGR5HzYqMpaEX3
        FcmeAdQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59ZZ-0008Gb-6E; Fri, 21 Feb 2020 14:46:33 +0000
Date:   Fri, 21 Feb 2020 06:46:33 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/18] libxfs: make libxfs_readbufr stash the error value
 in b_error
Message-ID: <20200221144633.GG15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216301140.602314.6904049540452018739.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216301140.602314.6904049540452018739.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:43:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make libxfs_readbufr stash the error value in b_error, which will make
> the behavior consistent between regular and multi-mapping buffers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
