Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E389529E7CF
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 10:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgJ2Jwj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 05:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgJ2Jwj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:52:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D6DC0613D6
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=kLO3rNto/YFrj+xRREQ8+iT73C
        G4k80GbvDqAGEdVMimbFRMoDxWeaDyX0/XBKjUkOQM9ZRyjHqUfRtpneQnXpIc7+wK/E9G59np70B
        zpUK46pRroVqAExlv4eC/KKb1u79moWISfwP0o47Ux/xMiRx78tctvFkK/hi4gVytAwN1WHSUaR4s
        Kddre5VVnuX2SBIFHWuYES0lC0tB0R0XbsYCc41+Fcq+U+oLNu8/9RWgrnGnPBmBHntrdiNLsWrBt
        uXbr/a6g4u8vUqF18/HDrP/MiYyNtWGEREsy1/HE0gkSsACW+xfitfw5+PBeqCNWOWEIQkQG5OMKg
        VGugc2Gg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4bJ-0001oz-9E; Thu, 29 Oct 2020 09:52:09 +0000
Date:   Thu, 29 Oct 2020 09:52:09 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/26] xfs_repair: support bigtime timestamp checking
Message-ID: <20201029095209.GS2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375540080.881414.4537898211020466512.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375540080.881414.4537898211020466512.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
