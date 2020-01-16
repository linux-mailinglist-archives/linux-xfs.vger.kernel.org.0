Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7141B13E025
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jan 2020 17:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgAPQbL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jan 2020 11:31:11 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgAPQbL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:31:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qyNREiztyd4k29cJ19BKhvur5g/8iTLOfS2Ykdvg2zY=; b=iZ+bYUcq/HGAqZ3AyO94PpTM7
        FKBiNpMSGuhi+AxJdO9NXTJWS0r0nVfBXCudjQyrGpJ9RYmlN8hq/VYaRnJaSqXLFlkNRc/P/QZ3I
        t9K8pjz5aEU6hxXlIm+GUT31D0LXq9z/4GIHllWFqLqN2/GMV5MWvuVLemCQgn2Noegke1I5mqho5
        81RBVVaBOgVyvGiQZUVIgowFBt3elYIiJC31zndhoQ8AEaCK6r5nfJMOExsV8UOca9yD+9WX2DCiC
        44GNfdViXokIpdmdnLkQffZif7at4QxSfGtHw7+S8FASQSLjJAaYm1Akn8y3gcWpGrm/CxdpWZjxQ
        GcphrzcsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is835-00022l-Eu; Thu, 16 Jan 2020 16:31:11 +0000
Date:   Thu, 16 Jan 2020 08:31:11 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 8/9] xfs: make xfs_trans_get_buf return an error code
Message-ID: <20200116163111.GH3802@infradead.org>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910787174.2028217.6154423239671718522.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157910787174.2028217.6154423239671718522.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:04:31AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert xfs_trans_get_buf() to return numeric error codes like most
> everywhere else in xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
