Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CBE2C9E91
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 11:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgLAKDb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 05:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgLAKDb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:03:31 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089FAC0613CF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hpr91XZb9rsZwYujyWPDrUaTJ+sEKU2OIDWFXU6oEdE=; b=L91Gqcxe7TdjW9xAvCwiB8xuc7
        U5Kt0Qtxi7krfGWsq5HbaRc0CrUmRgI0ppwBxMvOOos+SCQvlyDN3qVZNYQL0p4rK18OMcNZge1Ti
        UqYPHe5xXQ4YXAtALBVexNdQ+lg48KPQW3/Dln2f6iALjbhR9LHh2Hdx6ytBodrKM6L5+2/QIQglf
        Sd+HzU7ebJAhTCph1MSgp05YEKvGG8tsvdt3pvtGQmiTVY7YHarDZ8GhsS6C+VBTW95geWx8fzghl
        qpEbwfLQEujvB8+k+0f7legt2ueY/cdi2vCf2CskJjjbSc5TM0eR7DxbmTW1PO03pRYlCTq/dszt3
        oNbFBoug==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2Uj-0002mU-NB; Tue, 01 Dec 2020 10:02:49 +0000
Date:   Tue, 1 Dec 2020 10:02:49 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: hoist recovered bmap intent checks out of
 xfs_bui_item_recover
Message-ID: <20201201100249.GB10262@infradead.org>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679386612.447963.1918698861734333230.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679386612.447963.1918698861734333230.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:37:46PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we recover a bmap intent from the log, we need to validate its
> contents before we try to replay them.  Hoist the checking code into a
> separate function in preparation to refactor this code to use validation
> helpers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
