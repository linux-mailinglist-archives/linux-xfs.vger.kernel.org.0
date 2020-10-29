Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1C729E79D
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 10:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgJ2Jpg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 05:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgJ2Jpg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:45:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5CFC0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YoX+1iyeCRQK62u6x9r9BWWmQ+qwYu+5zKhs0PKko7Q=; b=Jn/AJBiX3JRqqSIRxpYohQzHC8
        TMPQhBb0S6pPfNE3YzG3F8kEPocq2LSGmMet6A+ZF+IMbOFw2FXVhQ6Zl9c+7jVxYxnOeewbXBxga
        Nb9AQLalYopH2cKLFmPiT27qGeHbPrhVfelQfVHH3vzWlczmnTKwmNQf9VI3Jex1g/ytW7dGJCAwS
        vd7qb1GWggbs5Jdnj5xK9NP+MYr03vTDjqN93hMmL4b5CFGp2GSNWvdaor+ZMWNXOkPJxh/AdBySn
        3+9V335CG1AToaQuSkpgsNrVf8FurU6J8IHX/EDFPjuj6akp2vR/Si7vkl4A5gFBWgSpX440cvDm5
        hcFsObog==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4Ut-0001P6-CB; Thu, 29 Oct 2020 09:45:31 +0000
Date:   Thu, 29 Oct 2020 09:45:31 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/26] libfrog: convert cvttime to return time64_t
Message-ID: <20201029094531.GG2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375527139.881414.6476607474654532506.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375527139.881414.6476607474654532506.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:34:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Change the cvttime function to return 64-bit time values so that we can
> put them to use with the bigtime feature.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
