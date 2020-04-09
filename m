Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5531A3060
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Apr 2020 09:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgDIHoP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 Apr 2020 03:44:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51666 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgDIHoP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 03:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ebs/thzWHNWHdsSbFhQNw1Ubqi
        YUyP/QQed+WD7cRdAO/F4fqxkio4KjZbOH8HJSk0epHHKbGxycVIkjCJTCjuGjlnfgGgL1u4xWAQF
        srNGMcnaLIW33e5Y0rcHuHMesY32W/snyPBl0cXrMWBBTX8vUiMqMdIq5G+EjL66aO0q2m+9odxds
        gZlJGRWe/7Ev33D6exRJg/oKBTIfsJFmg57aXFSciigr3Aa+KXOU/DQzcboi0D46CWJY73NQEExZz
        t533NWfiH4CgSaHjkeO56uLx15FUEKIamtDV1eQvkFJvgggSIJAWnEmaaSf008WplugQIjzWf0hbI
        Jy0B0Tkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMRrC-0000H8-Hk; Thu, 09 Apr 2020 07:44:14 +0000
Date:   Thu, 9 Apr 2020 00:44:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_repair: fix dir_read_buf use of
 libxfs_da_read_buf
Message-ID: <20200409074414.GG21033@infradead.org>
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
 <158619916916.469742.10169263890587590189.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158619916916.469742.10169263890587590189.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
