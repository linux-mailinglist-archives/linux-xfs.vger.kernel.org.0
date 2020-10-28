Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C7829D473
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Oct 2020 22:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgJ1VwM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Oct 2020 17:52:12 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbgJ1VwH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:52:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yxtC3uhLjYN73Pnw7PTWpbD/T7EiczbHg1CnySo/qoo=; b=tGZQvj/i9md86a2ZCZxcyTUHgX
        9LAEIgUl5Xo1Xi85YqRXocz/Nu8OPeT0T4Ity5yUDVqrN1yKc+vdNllu8O1JBZuc7mx/TQHVbW/6s
        ihsMah+MIjNebho4tQfUGpGLQjAvnxpDzg1hPkmlDdriQ9RHDMANRyujq9+xC/ixB6go9tLXxO6Ua
        ug/h74YjqTW6ZYx9AfEowF51MFVSYKJgdsdPvy/CqMtTtstF2Vj1a4B+dmHWne+OFikPVrE4NnePE
        R+q9uiPTvg5ZF4VyGVifWqpRr8hjeFw4bKDevyreP2MdhcHQdgS9yoSwP/68oBo3Sci9Oa3AJYXNj
        Ne1yjB6w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXg7D-0000rb-Pv; Wed, 28 Oct 2020 07:43:27 +0000
Date:   Wed, 28 Oct 2020 07:43:27 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs/030: hide the btree levels check errors
Message-ID: <20201028074327.GG2750@infradead.org>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382533506.1202316.2655281450906651514.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382533506.1202316.2655281450906651514.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:02:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Newer versions of xfsprogs now complain if the rmap and refcount btree
> levels are insane, so hide that error from the golden output.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
