Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E63261378
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Sep 2020 17:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgIHP1e (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 8 Sep 2020 11:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730329AbgIHPZG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 11:25:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE97C08EAD2
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bDZmVWpFQkTaksUiNc/OdzeBR3qmYpgHqw2dFg8RAEc=; b=b8om9VaUhbGlNkPY8jLyHGEv2a
        ISByyNV7fJjfMkrMhML6aGBSLUDG0Wj9EpxfpE2sFqA23RmT+tAHMbpR8+Ev1nE4xWruMcKeptjrZ
        ghx5ozpLv0UBfwFpvf44/+p/NVOUlhc7Kb+GjQeuwtPVTidH4BFCjubJeeYOa2aWqCs6yF3+se6Mf
        mXpfJMRECwn418WMmY+ZZE80GX3IF1qhFm41Uhen+ezlFWFm4QzTcdSPZOtc+McmfRmgTjv4VCT1t
        1wXTwJrtDGDli6t68TK6pq/ut7vHi5iLUKU/Q6xlR/nUNKAUxUgQQB5cbR0F8UbNFNWzpjVnljT6Z
        ZBb38MyQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFel5-00025P-91; Tue, 08 Sep 2020 14:38:20 +0000
Date:   Tue, 8 Sep 2020 15:38:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] mkfs: fix reflink/rmap logic w.r.t. realtime devices
 and crc=0 support
Message-ID: <20200908143806.GD6039@infradead.org>
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
 <159950110896.567664.15989009829117632135.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950110896.567664.15989009829117632135.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 10:51:49AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> mkfs has some logic to deal with situations where reflink or rmapbt are
> turned on and the administrator has configured a realtime device or a V4
> filesystem; such configurations are not allowed.
> 
> The logic ought to disable reflink and/or rmapbt if they're enabled due
> to being the defaults, and it ought to complain and abort if they're
> enabled because the admin explicitly turned them on.
> 
> Unfortunately, the logic here doesn't do that and makes no sense at all
> since usage() exits the program.  Fix it to follow what everything else
> does.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
