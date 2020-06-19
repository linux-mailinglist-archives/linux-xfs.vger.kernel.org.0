Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60F7200A33
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Jun 2020 15:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbgFSNcZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 19 Jun 2020 09:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgFSNcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 09:32:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D42C06174E
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jun 2020 06:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DSOOrdHZToroF+5V56lASZ3tXXvMksIFxXSvVyBUEgo=; b=W4ieGNUmlbT0qCcY/GiKrHWwuw
        vLPoSCkVPVokwNcnq5LdDaeVzbtwgNA8858+RX3NdUdi2ANkK8oOWUTLFnUlfG92VyMox91xMa4ar
        HG6BSKJ26FAiLye5UUTgnqmHaHILbM6qCrDAtQ9YfcqeBqxz4L9JxGyRUT2rKshmFFvttk70MUXGl
        XqFRSZsX3I+eC9/5ovkSs3cwx4Mjvrnz23L9Y3300Xfkhi5NL5boKMukGwxlD7XGNwrrVGEgyGQWx
        QaMPg1U7nut1bOx+616fjLh1GV2N7xtoFMOl9V5IY0OBTj4bog5+5vE5YnggrrMM5iUrgUD+w0rm6
        lFjr6pqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmH83-0008Ha-DJ; Fri, 19 Jun 2020 13:32:23 +0000
Date:   Fri, 19 Jun 2020 06:32:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/17] xfs_quota: fix unsigned int id comparisons
Message-ID: <20200619133223.GA19124@infradead.org>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
 <159107190741.313760.11195530788081068638.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159107190741.313760.11195530788081068638.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 09:25:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix compiler warnings about unsigned int comparisons by replacing them
> with an explicit check for the one possible invalid value (-1U).
> id_from_string sets exitcode to nonzero when it sees this value, so the
> call sites don't have to do that.
> 
> Coverity-id: 1463855, 1463856, 1463857
> Fixes: 67a73d6139d0 ("xfs_quota: refactor code to generate id from name")
> Fixes: 36dc471cc9bb ("xfs_quota: allow individual timer extension")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
