Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFA8195383
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Mar 2020 10:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgC0JE2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 Mar 2020 05:04:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42500 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgC0JE2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 05:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GmwokC6P2VtAWWVA4BKsM5ZZ4DiX3Tx0OxtG1VkDpFA=; b=ObjoWI9Jbmp0U6ZCaG7NwMRWL9
        CL1Ur2zXNDLfWQlSfCWKA918kFq0sCNnwRBPeNv/+QmuTu/WO3tlwVb9K8xWEyzpSGsgnOWqfQfIa
        ioN1068SNyOz82epQKy3rjV/4+dfYjKGW0h3spanv3hoq2ir+0lAXzqJ5+0SJzvpq4B+xxK9tbDQj
        rvfzvdxp6VooxHqR6ZES2F8vDDZVCzzOhNjtIRxLXLXXR9mvHxmyR2LPW+JC5zQEUpLPHBM8mYllc
        qcRNkpW/GrJ2Ak1jiLAN5et6I0adt48q3RRtbsspkCbp8RATF96str9LcFj05aYtT+lvcXkXKU2EL
        IyFZ5aaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHkuW-0003hd-SF; Fri, 27 Mar 2020 09:04:16 +0000
Date:   Fri, 27 Mar 2020 02:04:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove unnecessary judgment from xfs_create
Message-ID: <20200327090416.GA14052@infradead.org>
References: <1585287956-2808-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585287956-2808-1-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 27, 2020 at 01:45:56PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Since the "no-allocation" reservations for file creations has
> been removed, the resblks value should be larger than zero, so
> remove unnecessary judgment.

The patch looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although I would replace "judgement" with "condition" in the commit
log.
