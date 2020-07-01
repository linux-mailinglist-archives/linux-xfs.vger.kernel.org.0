Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075132106B0
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jul 2020 10:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgGAIsU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Jul 2020 04:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgGAIsU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:48:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C4CC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HbH+z79TsRD/6ZKielLofyMEQDwnnA+/KkNTfpBGH+U=; b=OhdjxQ7YlC4yRKcoMT4bEnah2h
        ugrrWTeIi7NJhUuDBpuVhmhWJKzKszChmfwpp73qYexu18okrkLpnqHbSldCHMdH9DQ9pHg9KR7Cb
        hWCoh3Jc/Y3iKmHvB9NFt5Hzsh9PTsDPDrvggyH3XXr9OR4NKJBsZB8wTDFAxFt5II1Wt7igXR0vZ
        MoSzX6T8QdQXQzJL1Lw2tlXEqyUKdjdkh2UkOdYZ1elfD3DAm0XFwO0vrHPJkvODX+/cNZhJKfA2r
        iPJ2aP+QEuAYZa6R1gxwwpAdItmAVzPNf1S9xv8pRfUCdWjkAWS2348HGZhnYhx4ZQ83jp5HPBltO
        zyIpJ9yg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYPi-0007VO-F3; Wed, 01 Jul 2020 08:48:18 +0000
Date:   Wed, 1 Jul 2020 09:48:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/18] xfs: stop using q_core.d_id in the quota code
Message-ID: <20200701084818.GE25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353174298.2864738.13894827380600479929.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353174298.2864738.13894827380600479929.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:42:23AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a dquot id field to the incore dquot, and use that instead of the
> one in qcore.  This eliminates a bunch of endian conversions and will
> eventually allow us to remove qcore entirely.
> 
> We also rearrange the start of xfs_dquot to remove padding holes, saving
> 8 bytes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
