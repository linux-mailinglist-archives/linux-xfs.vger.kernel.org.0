Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496922B2CC2
	for <lists+linux-xfs@lfdr.de>; Sat, 14 Nov 2020 11:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgKNKkz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 14 Nov 2020 05:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgKNKkz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 05:40:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662F2C0613D1
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 02:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MOghMOvbpfHm76b2/WePfYqER+wYudFERsU0ncqty6E=; b=puMm0yNqR7e42MV6z716knBIqU
        lKGDN36vWsg6/RWNpGnLk1u69tvtCJ2IWhF+tInXdIpQqTj6wGtPVsbspYjHVc2T9TfO7/0FtOc7k
        oNuD9Pgb0H0C+3+Z2BtZgvf2KGtuVNkKpGRrnejqXfBci57C18toxuO7iLrF36zN2SUtYYA4rJT8t
        4cw3OGu77G6QGMapJJ+NV8OTtBeIwAD8rI0t8qrTCFjH8SQP21Wywn8KJU/pp3b0wwrP4IV6+MNoc
        dnyTJgS3jIf5ls9XAF2IhcI4veQK7q4lFBKw82KvJTxJeryf32GptfNrjQrmCW/pVPhkDmO9epl44
        LD23Z21A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdszF-00032m-Ti; Sat, 14 Nov 2020 10:40:54 +0000
Date:   Sat, 14 Nov 2020 10:40:53 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 4/4] xfs: directory scrub should check the null bestfree
 entries too
Message-ID: <20201114104053.GC11074@infradead.org>
References: <160494585293.772802.13326482733013279072.stgit@magnolia>
 <160494587794.772802.11043398495774645870.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160494587794.772802.11043398495774645870.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 09, 2020 at 10:17:58AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach the directory scrubber to check all the bestfree entries,
> including the null ones.  We want to be able to detect the case where
> the entry is null but there actually /is/ a directory data block.
> 
> Found by fuzzing lbests[0] = ones in xfs/391.
> 
> Fixes: df481968f33b ("xfs: scrub directory freespace")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
