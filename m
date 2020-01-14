Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3B813A302
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jan 2020 09:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbgANIaq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jan 2020 03:30:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53114 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgANIaq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 03:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KHHaWym2L2V+H+3OXvyrSHS5HD+5SBHxQ3TVRpq+mxs=; b=kn++jMSDGQA8nd7yalS2/LT3t
        pEImORXIEmW3fXixFDamft2RLgzAryukQeCdCkh/176yKV+1l8enlzWg3406PDlekWis1ttsBE6ac
        ESIPZUTVLDKfmdj50q2m4Yt1H+AN62q5ASC5OHcVXBzyLxxDe/O1SEU3Khf45LKpu2+mwgYEyPt7H
        GMack/9MMxl6dcfl2XLZaqHzaDRyDOVELsVK9S+sUh4jKGHrS252aT7veV/ItuJEqqaPrjGs4ppqB
        KQ+zh5hD835ADi9nKCMk+5KEuK4XRru/iEtjt6U2Z4p8hT9DHeJHArMbCdjYIw8EoPGl3LrsTy4xs
        I9efUuKmQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irHb3-00059f-Ny; Tue, 14 Jan 2020 08:30:45 +0000
Date:   Tue, 14 Jan 2020 00:30:45 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/6] xfs: refactor remote attr value buffer invalidation
Message-ID: <20200114083045.GA10888@infradead.org>
References: <157898348940.1566005.3231891474158666998.stgit@magnolia>
 <157898349585.1566005.1902604375024932956.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157898349585.1566005.1902604375024932956.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 13, 2020 at 10:31:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hoist the code that invalidates remote extended attribute value buffers
> into a separate helper function.  This prepares us for a memory
> corruption fix in the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
