Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09009253E12
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Aug 2020 08:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgH0GpO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Aug 2020 02:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgH0GpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 02:45:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78EEC061264
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 23:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XXLVvxpZ8PzqRBuGV2q8vqrvl2JuN2rAMzSyw08s7ns=; b=TQongY1y4q/3Js1DpUSYPr6BBl
        H1EkVmzFe/Pccux0bid+Lv64WElVPgqcaMZ4nea8JIVZRu3Q6JS/98hMiKEENagW5xbXX7ZQfP3vc
        j4yN37ayst+OrhSu77G8iQjUEjlqQReyVXdYH2pRdde6Im5okHULIdztHPCdp3MDuaSbEiLl8zNQ9
        u3FsSPWmz/YF20dXAkaS6Y0WgTQRvaYrt5E+rPeFoJui8LG7OefJbL18vstNDrDf4djcmuihfEwef
        4TaiIfdzTnw43tbuFDHyoyx/ykM5+1J6NtmPKRxGu5TQhJ1aBtgr/iWk4cdskf/CPGOSon3aex2sB
        xxAxgkmQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBBek-0004QM-Kd; Thu, 27 Aug 2020 06:45:06 +0000
Date:   Thu, 27 Aug 2020 07:45:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 05/11] xfs: move xfs_log_dinode_to_disk to the log
 recovery code
Message-ID: <20200827064506.GF14944@infradead.org>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847953041.2601708.2391074537438610709.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159847953041.2601708.2391074537438610709.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 03:05:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move this function to xfs_inode_item_recover.c since there's only one
> caller of it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
