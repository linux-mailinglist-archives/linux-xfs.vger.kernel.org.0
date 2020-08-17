Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE241245CB1
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Aug 2020 08:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgHQGxv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Aug 2020 02:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgHQGxv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 02:53:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EFDC061388
        for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2020 23:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=P+H/2trxthQAzw9OMbINIj3sq7n5BKywrhcsgyt3c2k=; b=A4jFK6/ILl3bQjGGPbSLBwAL7v
        JrTfWZki/HBXb2R4qVZnQU2dJFOSVuu9XGNor3k5Flfyl1kLZGo35zOSTw7uLv1XlxxnbeipsjENk
        BhZ54Qpb/hBEJeH7UOMY36vrcwSKkOMxYN+78kZoD5SIp9FFJ39TKjeabyOvl+ZnILLjEi9Sz52xC
        iLzYTdx+O02ICxZFzHteiobQ6Z7Y5e4qUPqYsq3dOvrGZvcbxMwIEucL7SMCPbL/p5dnapZH76RqJ
        78QNlRVYUgK4+7Mz9/Jt9ujh08jfrQ9n7qGOeYGkuC1/+qC2zgYaVoqPR/gtz2oco2QJ3uZkKpblL
        XeUfHhPw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7Z1g-0006ZY-4h; Mon, 17 Aug 2020 06:53:48 +0000
Date:   Mon, 17 Aug 2020 07:53:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_db: report the inode dax flag
Message-ID: <20200817065348.GD23516@infradead.org>
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
 <159736124924.3063459.16692986145242990855.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159736124924.3063459.16692986145242990855.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 04:27:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Report the inode DAX flag when we're printing an inode, just like we do
> for other v3 inode flags.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
