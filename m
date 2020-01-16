Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6CDA13D552
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jan 2020 08:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgAPHsJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jan 2020 02:48:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59656 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgAPHsI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 02:48:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5uT1T7OHY2oSWoDl6id7Ls2z0h82otyNbkz7vjm6/Fw=; b=U6Bp382SZ+KZVpTnC4pNxX5uK
        +R48XX7PpUjV58fQDLuxa+xcqDJyD6IsmyTWdc7cTyRTmZl/9zG4DiluEVBFHgdqVgsekB5ZRzfQS
        uuz6xUrXoXRndmii7CCdVoYBF34bYbgymjG9KRGnFHSJDbPsVGSU1SAAqs+wHgZAQtAOIIAjf9h5C
        iH9sVDPcOmxK90l2K+4PuuWfYibqrm0tbKeuACe0uMW+gn16BEdloI2+7G3KUl/Xn2CRFjiiEntDm
        ZdAd6PlYjo8L37Y5fqHmaRMtMCIfujFcCvTupWMuzQw+YNs4j+2etCxJz3XG2A2NM+uYGYNJPqmpX
        45IcTsHfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irzsu-0005dh-JX; Thu, 16 Jan 2020 07:48:08 +0000
Date:   Wed, 15 Jan 2020 23:48:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 3/7] xfs: streamline xfs_attr3_leaf_inactive
Message-ID: <20200116074808.GA18683@infradead.org>
References: <157910777330.2028015.5017943601641757827.stgit@magnolia>
 <157910779242.2028015.12106623745208393495.stgit@magnolia>
 <20200116014744.GE8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116014744.GE8247@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 05:47:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we know we don't have to take a transaction to stale the incore
> buffers for a remote value, get rid of the unnecessary memory allocation
> in the leaf walker and call the rmt_stale function directly.  Flatten
> the loop while we're at it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
