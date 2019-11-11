Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509E2F6F60
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Nov 2019 09:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfKKIFE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Nov 2019 03:05:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36266 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfKKIFE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 03:05:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hmEMSvUAArrqtrVudbVLMGWNrx7DqV3A0QEABiVZLuQ=; b=Zp+2qgZeugdXGJ8VmYPCzkX+R
        40AmGINQaAXPCOdnvIZXaCP+u5m026hjC0N9mZ7SIBJnFKTNSONVBnR5FLhbjeJi06uXVd0W65QPO
        8q7N0arBa5T+P0SRYUTVDNlM9XVosVI98cq+2W6ywbZ3smuxTVZh2oWgRcRU7xKMXJxQ9sjUoMVjG
        AiFO+7/iNmDtfY5LUBxFg1ap0tifnqCM1UsHCVJ+C7nT1byT+PJP3Nn1kRiSqX20ddUnm4QQwOZQg
        i6xJKWbSV6bYReNGxGcbuyTIf9dogyVwpfF67cEDEjz/+xkqNMkhFDJ0U6m0pqqCZ3+kMPRQRnCWS
        IOVONvReA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iU4h5-0004Px-R4; Mon, 11 Nov 2019 08:05:03 +0000
Date:   Mon, 11 Nov 2019 00:05:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/3] xfs: attach dquots before performing xfs_swap_extents
Message-ID: <20191111080503.GC4548@infradead.org>
References: <157343509505.1948946.5379830250503479422.stgit@magnolia>
 <157343511427.1948946.2692071497822316839.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157343511427.1948946.2692071497822316839.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 10, 2019 at 05:18:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure we attach dquots to both inodes before swapping their extents.
> This was found via manual code inspection by looking for places where we
> could call xfs_trans_mod_dquot without dquots attached to inodes, and
> confirmed by instrumenting the kernel and running xfs/328.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, for  while I've been wondering if we could just get rid of the
concepts of attached dquots.  With the radix-tree/xarray looks up
are be fairly cheap, and could be done lockless using RCU.  So we could
try to just kill the concept of attaching the dquot to the inode and
just look it up once per operation, where operation preferally is
something high-level like the actual file/inode operation and not a
low-level thing inside xfs.
