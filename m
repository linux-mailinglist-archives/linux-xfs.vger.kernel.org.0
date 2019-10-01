Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7F3C2D76
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Oct 2019 08:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfJAGYa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Oct 2019 02:24:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36728 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfJAGYa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Oct 2019 02:24:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1I7ps7S2ZXOCoEWGAuZjQKdvaNmM5UyXNDy6LvSHe3o=; b=o2dsE1uhGwWrEhR29Ld7cLmEH
        GUsOHVMkWH9I0mB6/dlitjGNbLrl8/luvFBsO9bXSOlHdh9C24YTDXDiLpcNUNDWS3I9oEt6djQM7
        ZVkLARDWZNapq9ZyilJbjX9HW3lHZF32yzWUdfSOyTgod2iEE5czJSIwXzWqX7bmdDMaBQy8ouJX/
        V6LT9z8dKRZNKE71W++Jmz2RRzPX4jbyWDIGnCT7dSRl7qBt+3MvaFXXg0M8KyG3KdY2ltIgadmD+
        0ch+A11xE8fdo877emzpTuTJo7HQUhHOcc8WgVJ6Pxi/20kUzAAQ+zp1+pvMNxOKUleNy27wVd2gY
        STWgaeXMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iFBaC-0006UQ-9w; Tue, 01 Oct 2019 06:24:24 +0000
Date:   Mon, 30 Sep 2019 23:24:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: calculate iext tree geometry in btheight
 command
Message-ID: <20191001062424.GA24722@infradead.org>
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765991.303060.7541074919992777157.stgit@magnolia>
 <20190926214102.GK16973@dread.disaster.area>
 <20190930075854.GK27886@infradead.org>
 <20190930161151.GA13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930161151.GA13108@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 30, 2019 at 09:11:52AM -0700, Darrick J. Wong wrote:
> > Is the command supposed to deal with the on-disk or in-memory nodes?
> > The ones your quote are the in-memory btrees, but the file seems
> > (the way I read it, the documentation seems to be lacking) with the
> > on-disk btrees.
> 
> It started as a command for calculating ondisk btree geometry but then
> we were discussing the iext tree geometry on irc so I extended it to
> handle that too.

I think mixing the on-disk trees an an in-memory structure in the same
command is a really bad idea.  In fact I'm not sure what use the
calculation for the iext tree is.  It is an implementation detail that
can (and did) change from release to release, unlike the other trees
that not going to change without an on-disk format change.
