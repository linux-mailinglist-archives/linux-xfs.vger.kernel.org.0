Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B86F1613EB
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgBQNuC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:50:02 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728617AbgBQNuC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:50:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DzayCEIHcUEmJvEolumwWjc6AZisShlKqCI0Q26JVK4=; b=E5VxlknsSY5kJM8zmFlbw3G1rZ
        wJ/PnCF1Pf192w06F906qcXMvq7RB5WbgHDPXV9JC4ChJ50yMYp227WFfxr/Xrr0PgeIZ8Rn9V3Vt
        rFti/YjQtubsgae8eLFsDqte7jmaLQ8scZS1jkSQZzFVboP2QOKQ738l0jR+4GY8kBGn9PcLzxrL6
        qL3bjQu7+K+xATeFiSat1kee7WWHopzWbRPmcl6Cm7O1t2cOe98Ag1XgzoyGxDKIjqHcx/70u2gaZ
        KYF4GJB0qxBttLAxewrimXwydV9Sw+MmN5LpT2WR54KFjMsXS5MFubhJKS78QgQF+v+q9EcsWQOcv
        mAlFyCAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gmf-0008PB-MR; Mon, 17 Feb 2020 13:50:01 +0000
Date:   Mon, 17 Feb 2020 05:50:01 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 1/7] xfs_repair: replace verify_inum with libxfs inode
 validators
Message-ID: <20200217135001.GE18371@infradead.org>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
 <158086360402.2079685.8627541630086580270.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086360402.2079685.8627541630086580270.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:46:44PM -0800, Darrick J. Wong wrote:
> This fixes a regression found by fuzzing u3.sfdir3.hdr.parent.i4 to
> lastbit (aka making a directory's .. point to the user quota inode) in
> xfs/384.

Is that a bug or a regression?  If the latter, what commit caused the
regression?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
