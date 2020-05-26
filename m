Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965151CC797
	for <lists+linux-xfs@lfdr.de>; Sun, 10 May 2020 09:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgEJHYs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 10 May 2020 03:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEJHYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:24:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CC9C061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=goQ3bEBwokd96z59JS6jx4xFmuwbmj9DfljoQUVs+GQ=; b=or3ki3IpKAZa+wZyMNvnkViIXH
        BVvE/O+zbzyEB9Aq+PR2PPm1f4rTF2wkmW2+ih8gk4/WiyGiZTVD8unddLV6+N4jkCWwQ8DunWphP
        /GX+rmdDpcbEQoVL3/VXGFcIbVOrTN/FDgzntPhLHs/0oIoETbrMXymI/YF6VG6AxpKSwQ0ihoaal
        VtIe++jK0fO7Mvq8+F2ozHuZB0TZryGu7sJOgKxrPwKLrB9AsXiOXGYuqm12AB0NWG9Dcs3MDMGge
        DNEWz5KNJQoZ/6JM/ypYi/XinDsyDNgIwNpRzodJP9uXVFl0ojBHlzOgHU3ccM2uMN4aj+Z0R2IUx
        xUxL2hqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgKM-0004xs-Gc; Sun, 10 May 2020 07:24:46 +0000
Date:   Sun, 10 May 2020 00:24:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/16] xfs_repair: remove verify_dfsbno
Message-ID: <20200510072446.GB8939@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904186786.982941.13402008407746781785.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904186786.982941.13402008407746781785.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:31:07AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace this homegrown helper with its libxfs equivalent.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
