Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21E316ED12
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 18:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730911AbgBYRwf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 12:52:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59066 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730831AbgBYRwf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:52:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=flRMVp4kQE4mmB61N8rdsSc3NbgLMffvtsM5YDW0o4o=; b=kZC/4GAJq7KJfWoGETDVbyVQAA
        MUrB1cCBOcWvdWSrAPGyMIv6LExZ/hLA5Cj/3lo0l/m/669cY803rH/3OkLfpt+X1nqPW502raZQb
        9Id6Znv0n+U5UfPNm/UmmKBdmc0f1bUT4gP79zuFYjqmtOPAM9v/gCiMW3wAxWSCPmsNigJdjUnMC
        zJ+6bMX3sqxxvNn3MNNL1WLemVTzfaJkjNPW86vjogQwZqtR6CWnHimy63f4cGWnSVPs/aF0tQdMy
        TkE6Mq6kIAONP2w6WLaakxSG3uu79WdJOM6G/2G+hhG4FTHPg2Kt1uBiSxUh8FzCtKdJdi2NILP4d
        lBduBtkA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eNm-000128-M6; Tue, 25 Feb 2020 17:52:34 +0000
Date:   Tue, 25 Feb 2020 09:52:34 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/25] libxfs: remove dangerous casting between
 cache_node and xfs_buf
Message-ID: <20200225175234.GT20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258962280.451378.14849100198209417801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258962280.451378.14849100198209417801.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:13:42PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Get rid of all the dangerous casting between cache_node and xfs_buf
> since we can use container_of now.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
