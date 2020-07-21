Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AF02282E7
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Jul 2020 16:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgGUO5d (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Jul 2020 10:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGUO5d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 10:57:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154DDC061794
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 07:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YdrKvduHjHqqWoSSNcAG9N4vD8vU5hDdTkta3jm06jE=; b=iDhl75YqH1KObjGfLKYin76nmi
        2T1ZPsVDPIsTblrSxcBOAz5yl9rnkkoxC/3PYgIj18xxOGnhnypdzdy+o6KaZL3Cqlve91KqrBr91
        lf/IoXr39+4LwY0eSogRTw17Gi3oCeFEZUDLDMAqNtdmrh9s19jEkh8JXJwTI5Wdfh8E4XeGsY7vl
        DFvoA8Rc+ASqchTY8Q3cf+HzxtVIOFSvV8vjJZvnlSywGinGM9+2zTpgFwYRpLklaAJy9zcyk81q4
        Op/7lZP8MojdYpMuw5HS2qJOs3/7E63YfC8Rj1x+h2fnxb0VYibKKUMAmh5Un87Eo8cnBdBmz/SZo
        KdvnZ4AA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxthy-0001rs-V5; Tue, 21 Jul 2020 14:57:31 +0000
Date:   Tue, 21 Jul 2020 15:57:30 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: replace a few open-coded XFS_DQTYPE_REC_MASK
 uses
Message-ID: <20200721145730.GH6208@infradead.org>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488197022.3813063.2727213433560259185.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488197022.3813063.2727213433560259185.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:46:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix a few places where we open-coded this mask constant.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
