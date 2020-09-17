Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE7426D565
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 09:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIQH5B (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 03:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgIQH47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:56:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23095C06174A;
        Thu, 17 Sep 2020 00:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7pV5opP8am2gG+DjUhqMnL2wavHHisHhL9ZkquDNbg0=; b=dhkkld2E2PVG2pGL+WQiu36jqD
        NScwX6iAtI2TzJAShLmXtID9rPXkhp4N9oh2BKHwkgr1WvDFCsiq3APf9cH5yiNKW9yV0tDR72WLj
        xXGH6ZwVMsEtdUq9qD2mUWyC0z2jFxOWZ9ljBP+19ryzzLT/BckXsokzEpbYLCvnO6xxosI2ysc1b
        vrJg/qPOT+hxJ+siXghXT/mbC50lsEb9jv9GUS3OATV7S1qFwVogQlhQ0G7xpesRTXf60GhJB/ynH
        XrQ5+pR/T7b41Ye7KI5/CWKPBHGROl+o4H3PHrCE7qa0x+5HiRufmgH+UdxKchuzpsnn14uPlWjnU
        ugbhIEqw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIomn-0007Rw-9F; Thu, 17 Sep 2020 07:56:57 +0000
Date:   Thu, 17 Sep 2020 08:56:57 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 14/24] common/xfs: extract minimum log size message from
 mkfs correctly
Message-ID: <20200917075657.GL26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013426483.2923511.15242915902031465698.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013426483.2923511.15242915902031465698.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:44:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Modify the command that searches for the minimum log size message from
> mkfs to handle external log devices correctly.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
