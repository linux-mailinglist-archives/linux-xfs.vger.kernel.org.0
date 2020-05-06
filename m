Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B491C73B6
	for <lists+linux-xfs@lfdr.de>; Wed,  6 May 2020 17:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgEFPOX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 May 2020 11:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgEFPOX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:14:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28716C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WMWP+fbpBxSPA4UZm+QTmGgNacnekCV78lOkfaimON4=; b=FYhR9DMt81KUyMH349TxN4Tz6F
        HuM/sejnnvPEGkMwKEFlyZZufGScKiN2Asuv+HxbOt+/Xxzy7IfGrWcueOR8Q53L/5XNb2Ap9FHJK
        dxegkrQs3gfJUyc3lDElIx2xlDer8GxfnyjdgIWtyBSvlrONKfjXL/al6TE1cjQpIVzGWNiYdZjpt
        ejDO1efiGhoHwHZo6MSzT8AHbVVnjskZua3iEx9ufiDAPF+QCPcGlt5XWTqNCvCaNEP4BqWZhJFoi
        ng2Rzw47ZbGvwdUY+PR184rC7I3xEiMwyne+PEFbHJxREYZamavEsWOID/eoZnX3+cV/UjbVRN3bL
        HvH+QxSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLkd-0000EI-1P; Wed, 06 May 2020 15:14:23 +0000
Date:   Wed, 6 May 2020 08:14:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/28] xfs: refactor log recovery BUI item dispatch for
 pass2 commit functions
Message-ID: <20200506151423.GP7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864110754.182683.16207546218311436217.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864110754.182683.16207546218311436217.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:11:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the bmap update intent and intent-done pass2 commit code into the
> per-item source code files and use dispatch functions to call them.  We
> do these one at a time because there's a lot of code to move.  No
> functional changes.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
