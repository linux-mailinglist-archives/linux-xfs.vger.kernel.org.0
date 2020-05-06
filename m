Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C571C74FF
	for <lists+linux-xfs@lfdr.de>; Wed,  6 May 2020 17:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbgEFPem (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 May 2020 11:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgEFPel (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:34:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5207C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9yUOr8O6iyQBi2RmkmywrCLPLv7bakVNz1gCpQLFm/w=; b=byN1zni/fa/31IXt02W8GhIVZU
        wmw19AeUxIp1hr/cEhXdha2Lmxa6QxbY5uKtwbD3zir/YrcIn7mBLe6ayFw0g/DO029a4BWePRjda
        OTskOX/Ynr1QQO0jt9j5Iy99liv8e1yJ4yHDfWpKGrQSRBqKuqI0gKp403vyuuwmLpxwmHKaxIg6r
        mQ6zQZbS4peow8vrXDgN6CQQiwhEDFfY6HY5qIC8yd+mmHxtuaN1Yh9SU9tpbDqKvh1B/NPq71HfX
        wtNI+/Hk2kskTGtX670gl8X57o9ne0//knnbERJXPO3xJUzB/0EbrT/5Zoxqh87sRYBo3RdapjnDj
        hYb3hDRQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWM4H-0007Hk-Jj; Wed, 06 May 2020 15:34:41 +0000
Date:   Wed, 6 May 2020 08:34:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/28] xfs: refactor intent item iop_recover calls
Message-ID: <20200506153441.GA27850@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864118627.182683.12692460464900065895.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864118627.182683.12692460464900065895.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:13:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've made the recovered item tests all the same, we can hoist
> the test and the ail locking code to the ->iop_recover caller and call
> the recovery function directly.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
