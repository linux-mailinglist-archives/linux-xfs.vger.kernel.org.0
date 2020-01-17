Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6CB140425
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Jan 2020 07:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgAQGvL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 Jan 2020 01:51:11 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51342 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgAQGvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:51:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gaIg4HiHO9/2GIHyai6ndovZ3+fJFN1o7HCOV05FQ0Y=; b=AX5mYKZJqp9hzP2HOiQGRgWat
        AJUk9xheSscIyX0AkZqoEY+yKaBDa/Gnogt7g548+jfeRAVtXD9XE/tNzpmTdo+qzlDT81o6K/fem
        FW5TzLbEewhSuQbFhfP946Q8gm23lbkDix4m32nmCsvv7iCSiRG0oWsvmTmXg1vzvmnEoAYccJgr8
        GE6+ZOhoVz1x9fi++Jc/fInGWCw06M9jbRZUaJY7BRhxdEPrRTijA2WhARNIgrUrn4NlPYq6e7OAg
        jUDNPy7T9H/zClif5st3uVhetvXmCuHTwhwcco9xZYZHnBWNhl9bbSh4niuKMbcW4o/I2B07DWz2S
        M3W2MMs8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isLTK-00059Q-OC; Fri, 17 Jan 2020 06:51:10 +0000
Date:   Thu, 16 Jan 2020 22:51:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 09/11] xfs: remove the xfs_btree_get_buf[ls] functions
Message-ID: <20200117065110.GB26438@infradead.org>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
 <157924227544.3029431.5427347623373035367.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157924227544.3029431.5427347623373035367.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 10:24:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove the xfs_btree_get_bufs and xfs_btree_get_bufl functions, since
> they're pretty trivial oneliners.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
