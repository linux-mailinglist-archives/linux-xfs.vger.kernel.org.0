Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA054228309
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Jul 2020 17:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgGUPEG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Jul 2020 11:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgGUPEG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 11:04:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF80C061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 08:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=U2asBgDCbVDl/yRNeMBjXAsYxmnYy5IKuoOBo55r6N8=; b=SJK+sgf2tiwXv5rQWTCRzCShzN
        UA972IDFVujOIMNTieIzzc2MgDsUvKph84B6ZslWTSJVnsimdmdt07/i340g8AhStPuswvSeTAOcJ
        ysG3ZxFGuxaflRbozWHQU5gKELyBOIoFNop0mfnO8KW9ioeuq/xDlgn+nNYKFmeJDu6osHn/nM9XD
        9iY+zTCS1nAU6F0jT0vwJIJBtL6jtzoHAleHirugXjMWVQofn2CMjbbmD72ewa9Ge2eIm0flZ5afZ
        Sz8BusjrKiuzd7WCcgN52JIJAqnLz7/lVSc745znynjQ3lwsa+M6Ixre2cuL6udeFvfpXHqQUWtZT
        CqFufkCg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxtoK-0002DA-Cr; Tue, 21 Jul 2020 15:04:04 +0000
Date:   Tue, 21 Jul 2020 16:04:04 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Bill O'Donnell <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@sandeen.net,
        darrick.wong@oracle.com
Subject: Re: [PATCH 1/3] xfsprogs: xfs_quota command error message improvement
Message-ID: <20200721150404.GA8201@infradead.org>
References: <20200715201253.171356-1-billodo@redhat.com>
 <20200715201253.171356-2-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715201253.171356-2-billodo@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 03:12:51PM -0500, Bill O'Donnell wrote:
> Make the error messages for rudimentary xfs_quota commands
> (off, enable, disable) more user friendly, instead of the
> terse sys error outputs.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

I think we should have one helper with the error message
instead of duplicating them three times.
