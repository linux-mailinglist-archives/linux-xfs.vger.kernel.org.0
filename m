Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB6F211BFB
	for <lists+linux-xfs@lfdr.de>; Thu,  2 Jul 2020 08:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgGBGaZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 Jul 2020 02:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgGBGaY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 02:30:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5746DC08C5C1
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 23:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yeonsVgtyNCw0JqSFd5LTX/qOMU8rK0ax/F8eY6181Q=; b=grzFhg45zrA4WBjcv++EC6DG+Y
        f5V6galWN68Z/nsWLjixDTB/GJDAslGMerZbm/ZxMcEMANGQsrn4piVdnkwVgD3MvX7MBhgUArBbo
        aetaJduphL6jvI9W49CRP8GcXXASIF/QhFsz6H5rz1r0wKhNa71SSYPqZ2fAEaSymmp9QNaKor6a3
        KtoEsuLnBsLsbA+/R/QGPybY4FUkbJhSROhG3u1n6HaVGFYc0lYayK+4qwG5JiEBtbjQr6Yrt74Ar
        UTuxspXgLXLSAjfT7Sd//LqjiEG5Edn/XCd2L80vGr11L9pcFKznjFSyRLBcjLoe1ih3r6hX87jjY
        VGr/rSng==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqsjl-0002to-Qv; Thu, 02 Jul 2020 06:30:21 +0000
Date:   Thu, 2 Jul 2020 07:30:21 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/18] xfs: validate ondisk/incore dquot flags
Message-ID: <20200702063021.GA10046@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353172899.2864738.6438709598863248951.stgit@magnolia>
 <20200701084208.GC25171@infradead.org>
 <20200701182508.GV7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701182508.GV7606@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 11:25:08AM -0700, Darrick J. Wong wrote:
> > 	/*
> > 	 * Ensure we got the type and ID we were looking for.  Everything else
> > 	 * we checked by the verifier.
> > 	 */
> > 	if ((ddqp->d_flags & XFS_DQ_ALLTYPES) != dqp->dq_flags ||
> > 	    ddqp->d_id != dqp->q_core.d_id)
> 
> Sounds good to me.  I'll make that change.

We also don't need the mask on the on-disk flags, as it never contains
anything but the type, so this can be further simplified.
