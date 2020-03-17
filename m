Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2133188D3C
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Mar 2020 19:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgCQSeE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Mar 2020 14:34:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44718 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgCQSeE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 14:34:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ljuPnWgWek1JpOOwQaIQzCzle+H69JeGgzWgmW9NW/c=; b=dfYmhpjQkIyz6eNbFFtPYx11uJ
        6lKZaN5iIJh/FDAdlqAoAib357hCiYrR0yo+111/DZkkiYevqDpBs4ZBD01mzpcqsG8dNrxsns2wg
        LnvuIOWH1G2ioseBFOYZb894I0gjQKZ6iuz1PW7ObjCYI/9me3LAJj9oM/TlhxauN5PwopXg9Tu9k
        DnImIBtj3LS4OedY7ViUPkviCzDaLSqQF/KJ877/8nI3RKqQsk6+DOLYzkVweW9JPF5d5OpTenHM3
        LFD9hft/ruf2ENzWVUQVVZ2jiU7T+WLGwrN/3Q/hSbaMvAjTc4sKbrgMPuiCTx5xZKmpAQcApLJv8
        V1N+E/rg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEH2R-0008DV-LA; Tue, 17 Mar 2020 18:34:03 +0000
Date:   Tue, 17 Mar 2020 11:34:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix incorrect test in xfs_alloc_ag_vextent_lastblock
Message-ID: <20200317183403.GB23580@infradead.org>
References: <20200316153155.GE256767@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316153155.GE256767@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 08:31:55AM -0700, Darrick J. Wong wrote:
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 337822115bbc..203e74fa64aa 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1514,7 +1514,7 @@ xfs_alloc_ag_vextent_lastblock(
>  	 * maxlen, go to the start of this block, and skip all those smaller
>  	 * than minlen.
>  	 */
> -	if (len || args->alignment > 1) {
> +	if (*len || args->alignment > 1) {
>  		acur->cnt->bc_ptrs[0] = 1;
>  		do {
>  			error = xfs_alloc_get_rec(acur->cnt, bno, len, &i);

The change definitivelly restores the old behavior.  Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
