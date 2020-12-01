Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034C92C9EC1
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 11:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgLAKGd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 05:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgLAKGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:06:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD94DC0613CF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f3nqW1vb4555YHnF3HpSsqhG4ryY/ZBPfWVN69k/Q6c=; b=TO65Bk9NvVJIJKoj5hsJzlwYHi
        Rvuc/S3uSwQAxcFR2NEkm7V46Legb65nnNUcDEbV7atdo4fo4wi9EoS2gQqwXq7UDDDHl7lCJRqMK
        KxzNpFZFqH13ttdXuYwKsQ4TmYl6J57LROXTw6RzKuwMIENOxU5HveVXkjRaKN7LhxzSf6kmPCjAf
        2xGqF2FLgnk7nV+vrYqytvH0GH9HNkrrLYFalzUaRowWxeWIR/4blLIwGW0T0tMBOozImg9ZTsZ+A
        lryLZDXvR6HxOjogYeN5vz/bpgxfcdCjzMJQNA+r1R7+EchoTc1Ze4/ioOvChx6YDbOD1f0PyTJcf
        cO/f4Ncw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2Xf-0003AU-Cs; Tue, 01 Dec 2020 10:05:51 +0000
Date:   Tue, 1 Dec 2020 10:05:51 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: hoist recovered refcount intent checks out of
 xfs_cui_item_recover
Message-ID: <20201201100551.GF10262@infradead.org>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679389048.447963.5353838196502010594.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679389048.447963.5353838196502010594.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:38:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we recover a refcount intent from the log, we need to validate its
> contents before we try to replay them.  Hoist the checking code into a
> separate function in preparation to refactor this code to use validation
> helpers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
