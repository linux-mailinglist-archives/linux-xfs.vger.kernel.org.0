Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4B9257E45
	for <lists+linux-xfs@lfdr.de>; Mon, 31 Aug 2020 18:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgHaQKj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 31 Aug 2020 12:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgHaQKj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:10:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4B4C061573
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 09:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PH1CpQ+3RUs4thbU5yaE9Qh+GTqY0H1ZOCXqBo4MPMA=; b=BpjaBiGqHEIZ/wqDahYOE7zkw3
        V9nP6ciqcvaG+QAnC8IqK3sgO8qdWl24Xhavnt5ayDXvuD7vYoR08Sts/qjqWWTld1/YyPJpjGVw6
        /Nm3hdXz+cLA0SC2AaiQgRQOYU4PljdAW5iuafe3LpkAJg3580q0klVtd1Ybp/GWzETkZQdTA0anc
        rn3unboUe4ddBubJX7EOfw0gkb3QKbXcPtJrkd82nqAPxeOkGsb5W3fhu2XPt7awoeF2e0jbRIr7K
        tMmSIoeFkt9yJQjg1YjCjdK3utg3y0nkUY55Jk1eUVAAirn0H+kBSEdgZ5jKwIkAC6HYmvm6w1FXy
        3m5XsFDw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCmOB-0002PO-G6; Mon, 31 Aug 2020 16:10:35 +0000
Date:   Mon, 31 Aug 2020 17:10:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org,
        Amir Goldstein <amir73il@gmail.com>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH 11/11] xfs: enable big timestamps
Message-ID: <20200831161035.GD7091@infradead.org>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885407932.3608006.12834647369484871421.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159885407932.3608006.12834647369484871421.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:07:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Enable the big timestamp feature.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
