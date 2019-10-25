Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D12BE4B9E
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2019 14:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439480AbfJYM42 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Oct 2019 08:56:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438960AbfJYM42 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 08:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=O9EK5OQpeyEplhs5bGIy8bwausjxvHRd+9mmNRQ5TZc=; b=q3RyDjqxAfxHjvTjpWu2c1a5s
        9tofBHmDu9YpD8PVzNUWOEmVylRBN/V7PLK4ooqF++euvdSiYQwe/laWL5hdN+gWxJS/cFGibnkSB
        SSKSD/Z/vCP5T8MkJtBmv7FwZU3dEvN5DS9FoyVHF+OES6fwWAgqAYhT7IM1Y5/VIrxGQQ9TtPFBb
        jLWNJb12Ebec0tBPFxMSpKDc/Sgkv40VPZiw+xGOHX4HfCqfQ5cMDYRRD5v5Zz1DySJ8Fbno40oIn
        nQi9TEao5gd2AnHRyDnwAWB7xuRa+vubZr4E/xAnG4REUsQrmLPfkwy3MpURVWDjbR3xPuIooE8Aj
        oRW6X4AZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNz8m-0000rE-8J; Fri, 25 Oct 2019 12:56:28 +0000
Date:   Fri, 25 Oct 2019 05:56:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: namecheck directory entry names before listing
 them
Message-ID: <20191025125628.GD16251@infradead.org>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198050564.2873445.4054092614183428143.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157198050564.2873445.4054092614183428143.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 10:15:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Actually call namecheck on directory entry names before we hand them
> over to userspace.

This looks sensible:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Note that we can remove the check for '/' from xfs_dir2_namecheck for
currentl mainline, given that verify_dirent_name in common code now has
that check.
