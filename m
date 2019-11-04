Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29D6EE841
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Nov 2019 20:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfKDTXT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Nov 2019 14:23:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51688 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729461AbfKDTXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 14:23:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XTpv26HKT7kqS0UvNiEmjrfWjpBCne2L1nxwombeQTU=; b=P+WynXsBuJC8pJyviKe39XUCA
        bbmLsGCBvZJRuA0mpxjj6Qjzp+NJBb181Wp6HsvXAFVH3ZqfgNbNT/6dvczJLNyv7rBT3DTb4koF1
        sT6rROHfSD1KBWex5M2AbA51/sUwAHqIgw7oHniqwvHoKhyhTweQ+7ohBTSmxmkxt+6M8uk817S9T
        +jbwaBAlydGKAgGn0GLfLjl9C1iK78CNHMx8Qyr1jDlXZzI1ablLzU60U6uS2owN1u4za5nDuM5xW
        HhxC4G+Fr3JOVzodKASrw/cS0rOAd78ufGeYNrpUQOMa8/epkITu4OE53hmPHxcPg4swfVkwiXVUk
        o2C6ucOUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRhwc-00072X-HA; Mon, 04 Nov 2019 19:23:18 +0000
Date:   Mon, 4 Nov 2019 11:23:18 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: relax shortform directory size checks
Message-ID: <20191104192318.GA25903@infradead.org>
References: <157281982341.4150947.10288936972373805803.stgit@magnolia>
 <157281982989.4150947.13552708841526849932.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157281982989.4150947.13552708841526849932.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 03, 2019 at 02:23:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Each of the four functions that operate on shortform directories checks
> that the directory's di_size is at least as large as the shortform
> directory header.  This is now checked by the inode fork verifiers
> (di_size is used to allocate if_bytes, and if_bytes is checked against
> the header structure size) so we can turn these checks into ASSERTions.

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
