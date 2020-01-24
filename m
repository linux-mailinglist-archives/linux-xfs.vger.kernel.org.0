Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEA714919A
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Jan 2020 00:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbgAXXIZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 Jan 2020 18:08:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42122 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729293AbgAXXIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 18:08:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Vi/OE8GORXi8+QSk2ZwTWWhs31Ieu2aAQwegBysRNvM=; b=P32tz9G74Cx4KKR5BurWh747K
        KdQMWoJ3zQMyV34+qsAkRT+0Ta4BYGRFHPRz3BBDqz1YHE64AaYLz00jrhci6cJU4zOcKxg50hJNu
        yDT/qVFrUgxHmkf47+GCI7VcUzYW8TmNGqtMddy5UHPQ86iCTvxV+DhXucXdOwSBNUTjSqFvjT/U9
        GOamv7ChEIPQjOL6WYexOo/YSOcL1sd/N6IP8EA3lLROhkzYOVeC96CTsbY+BHnEs5qQxQmKCp2oZ
        0SmBVCu2qCXhFySlpr6LaSBnxmYAkcKreJjyMLpH6XsrjV+SY154TpJsT/jE9xACqSyk77tfykL3x
        zsca/RJEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iv83t-0003CO-1Y; Fri, 24 Jan 2020 23:08:25 +0000
Date:   Fri, 24 Jan 2020 15:08:25 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 06/12] xfs: make xfs_buf_read return an error code
Message-ID: <20200124230825.GC20014@infradead.org>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
 <157984317522.3139258.12286918099052261683.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157984317522.3139258.12286918099052261683.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 09:19:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert xfs_buf_read() to return numeric error codes like most
> everywhere else in xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
