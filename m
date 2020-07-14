Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB01921EAD7
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jul 2020 10:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgGNICp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jul 2020 04:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgGNICo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 04:02:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9A9C061755
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9Rb8rdJLP+L0SEJgZHQO0oCM2/adoKuZ3Vg7v5M0Uz4=; b=QNTSBdFNbqniNW3ELFfeanyg55
        DP5eIXw+DABlV+0k/7InUz/1stMMXiEtK0YBXuXjks3n2lxUWBhxrklvYl3IluhYeu75K5l2ZlJ2B
        7ayU6ycuDkVX8/5uFXsUvJcbIoEeAO6Oed+7rqyI8wHLTBzVnnGSE2ufc+NmSJB7XMdvjli2sek4y
        3kaMCGbTxjPIq5AMt8hSEsvCEKHch6lOHxAw1/tet8xkbxaNaal3LW13hQ/BklJUab71DP+IMqbqx
        08wSGFjirAQNWdCIMbNTbRqlZsfhmOU8po/GnzXWoG1D1fCHU5v6FlGewb2KwncdXatoN1arolcFx
        HuP6Tlgw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvFtj-00074W-6d; Tue, 14 Jul 2020 08:02:43 +0000
Date:   Tue, 14 Jul 2020 09:02:43 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/26] xfs: assume the default quota limits are always
 set in xfs_qm_adjust_dqlimits
Message-ID: <20200714080243.GI19883@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469044233.2914673.9887253692124252095.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469044233.2914673.9887253692124252095.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 06:34:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We always initialize the default quota limits to something nowadays, so
> we don't need to check that the defaults are set to something before
> using them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
