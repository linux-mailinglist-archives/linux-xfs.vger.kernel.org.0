Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF4828EE55
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387797AbgJOIQy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387764AbgJOIQx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:16:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B05FC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MD8cvBkVWmDHlpi1fPRIeps+qZu16P+A8Fk34Ik7uKI=; b=A0C0zgtVwrDsVggDd2xrI0RfiB
        ZrXzEB8C3gw2uPo8xce2DDUha/KyU6SgDbtoB6xioqx5dsQR8C19AmEQFgEOaCNFz5Dt+RHtIP3DH
        HkdcJhvweJVqwSBqqlvGQCQjeTauc2VLgkcwQ+Y+3zG/3EAzpJ8yNcALSdxjnDJgaEuYv+DHLJPQh
        KZHRAgR9+AFJ8P2W93GSr3olluyWoUjSq3abSBpvb0Vq5VfTdclNNKSYwGQak9b5s3iOpeSGREptE
        ruUhJCzcxjeEDUp+rr7ZudG/cl8Tt9WCKchrRZzrQ2H5TyRqk5d6dKa/boTcmjgA94KDj4KSVo6J6
        umlXldCQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyRI-0000f5-HM; Thu, 15 Oct 2020 08:16:44 +0000
Date:   Thu, 15 Oct 2020 09:16:44 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs_scrub: don't use statvfs to collect filesystem
 summary counts
Message-ID: <20201015081644.GA1882@infradead.org>
References: <20201005163737.GE49547@magnolia>
 <20201009111812.GA769470@bfoster>
 <20201009113225.GB769470@bfoster>
 <20201009153741.GT6540@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009153741.GT6540@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 08:37:41AM -0700, Darrick J. Wong wrote:
> > whereas the ioctl looks like it just reads
> > our internal counter (which IIRC is a subset of physically allocated
> > inode chunks). Do we care about that semantic here either way?
> 
> Nope.  The one caller that cares (scrub/phase7.c) only wants to know the
> number of inodes in use (f_free - f_files), which is unaffected by the
> logic in xfs_fs_statfs.
> 
> I suppose I could trim the parameter list even further to return only
> the file count...

Please do.  Or just kill the helper entirely and open code the trivial
ioctl call in the two callers.
