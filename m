Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D4E26D55D
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 09:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgIQH4I (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 03:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgIQHy6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:54:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81009C061756;
        Thu, 17 Sep 2020 00:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ClxxjmOXaAcW3X9TjJmnsSei6DYPvnDq6t5T5RfY6Ac=; b=e2ggqq//p/5fFHF6GFGHU3EVqJ
        pQ7KdW3Aa0tjhWPkhPRor0CScqG46zhsCApmSAAH+p0uoBh9H/UbP5j1F3aH9Nijmwpo1Szqy8iNR
        UenGZUjl0JMYVnzFATUk+m3dp6H+i7SLO8aWPN2owXL+ATGIlk9T458tcIs3eRWJnS0vfHHWJmeGc
        KaGCjrAqKOm/Gm0DWNu1z9e+BnZ8JQuou+OVIN0+APZ934neACeeTXJSjRUrjT5AsWDeTWh24EB/f
        xP6qWQIt/re9AfE9zKUB2ueZv35Dy49dRDNoMuhzLhpoD4wkW487nM+PpnqNTXdD2d3/IdTcOClab
        kieK+Weg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIoko-0007Ds-GN; Thu, 17 Sep 2020 07:54:54 +0000
Date:   Thu, 17 Sep 2020 08:54:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 08/24] xfs: replace open-coded calls to xfs_logprint with
 helpers
Message-ID: <20200917075454.GH26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013422703.2923511.4608245885181531356.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013422703.2923511.4608245885181531356.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:43:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the test/scratch xfs_logprint helpers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
