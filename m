Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9720E30A772
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Feb 2021 13:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhBAMTe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Feb 2021 07:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhBAMTc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Feb 2021 07:19:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF543C06174A
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 04:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zjoD4sUhKNhTVfqNwfBB9K8MLNv/mW+srBagQTj0GHA=; b=AjFQK5toEPC2KVuy47wTHQcHSq
        DDFBbBs3m1fFwyRvP8wmQZgMQsbUewa1TRVy4ufOtfXA6W9Xj+IvCqCvBC35gAZDcyVA0ie1SsEiM
        qexdaiHqS/7TVsXisOs01H4kxVuXMLLcJzp6EuZW87A4rJ20jI/xX6YHIxZf6t5v83tVgQX8YzJi6
        GTkoPRN3V3omuh0ggk3prTrl/0DTlsKk4FyRNj31P6wt7uBm6MdA0h9ZZ/WGtrcBQm4EKvLuU+zYU
        5v9NEE/mtpoWgcTJCdZ3x7txirBTjpk4S/c0kuajEBWka+clrbd04swiKGFraSzzqsPXobOm7MF+L
        YMhCB0AQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6YAL-00DkTj-5s; Mon, 01 Feb 2021 12:18:49 +0000
Date:   Mon, 1 Feb 2021 12:18:49 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 15/17] xfs: rename code to error in xfs_ioctl_setattr
Message-ID: <20210201121849.GD3271714@infradead.org>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
 <161214511286.139387.10118392312750611346.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214511286.139387.10118392312750611346.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 31, 2021 at 06:05:12PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Rename the 'code' variable to 'error' to follow the naming convention of
> most other functions in xfs.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
