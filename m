Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89E0513DFB8
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jan 2020 17:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgAPQN2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jan 2020 11:13:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37722 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbgAPQN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:13:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=caZJfY7uIjYHcsxZ1wLqnThUz4mwTHFd5TfukJ63goQ=; b=YGBC21+uN7+6nbVPHNi31dHeF
        i+ixlhTIvbz9w5k9aZZQVQLaPRb/6tOlJa6kYSEph6nI1xpc/z2Kfltr3cSvnNygo3f94cJZBFHQF
        2JbC0sop8T+Njj92jhRk+sVbzub6xkdNVSW5C+/b/18dfbOTOtDQSj6ODnj7FVK4lpfO/u/Ca2tkh
        CpJn1nLErcdiPmY+D0MOVt03x8RKlxYJAFxGl3NBIDkG94tN4DO3a14NXPVHckncEIZa+yqHblyBw
        3rOxCZsZOigooWCpfCFDbGBidnyNYFq1UkM0WTbEtIxoe0xRPeYBc/+dX7ezKVoom4QH6hkV0L29a
        QiY/fUueQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is7lv-000126-II; Thu, 16 Jan 2020 16:13:27 +0000
Date:   Thu, 16 Jan 2020 08:13:27 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/9] xfs: make xfs_buf_alloc return an error code
Message-ID: <20200116161327.GA3802@infradead.org>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910782597.2028217.5043572462444167802.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157910782597.2028217.5043572462444167802.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:03:46AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert _xfs_buf_alloc() to return numeric error codes like most
> everywhere else in xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
