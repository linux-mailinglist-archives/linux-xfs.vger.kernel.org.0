Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA9D253DFF
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Aug 2020 08:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgH0GmS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Aug 2020 02:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgH0GmO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 02:42:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBBDC061263
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 23:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=o86+CF9RW4kO+xOqCIpX7dxz1NQhSkwe62VQCwtdifg=; b=JCa97FrAVaAeFNGhUNThYanCyF
        Ay5LVz1N0k5RUTQXD8f8FVbrlz5ONP3P3CCRwpva0Y/hFefR9tSJ8yvdCbsdljG67hIXztCVCu4p7
        /+C/zWbAk1LXq6IO5yQ8f7oTOoU9URUl63CXvxm3XKEs4Uoq8SqPv3H4imbdD5LnrA6WuPlXLMrY1
        gUIbNm3X+M83hQ9gtHBN/W7mY9R5KioQah0bxb1LjMdCTNyAky+ZNilF9GTodHD76jKyraBJKn54k
        F/9S5ejSMwWXkCUgB293FqGKH2UnMVXpDwZ87NqHbAQGCnO/O6Sx74ywoJUgDlerf3tPFEmOcEzDF
        uY2bFx4g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBBbv-0004BD-KT; Thu, 27 Aug 2020 06:42:11 +0000
Date:   Thu, 27 Aug 2020 07:42:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org,
        Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 01/11] xfs: explicitly define inode timestamp range
Message-ID: <20200827064211.GB14944@infradead.org>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847950453.2601708.10180221593902060367.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159847950453.2601708.10180221593902060367.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 03:05:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Formally define the inode timestamp ranges that existing filesystems
> support, and switch the vfs timetamp ranges to use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
