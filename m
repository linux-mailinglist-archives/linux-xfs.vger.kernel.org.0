Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3927D414D9B
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Sep 2021 17:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhIVQBZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 Sep 2021 12:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhIVQBZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Sep 2021 12:01:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FAC46109E;
        Wed, 22 Sep 2021 15:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632326395;
        bh=kVdS0orM0414d7J3/DIKfIngWOtHYwz/rZZ5n/pHN0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JoukCL4uXDIvTLxrwh3mTezFVgpll0CuTPB7zI1CSnrG3fWnvuM33MnQJsf5EZBKO
         WFhPCJ9Le/cL9gtALzOx9JkAYV94b/rNVw+5tdXa0YodvLIiebJtGiA9Ldibop3pDL
         mPqm8fiJeyJbSHH5lxRfi47imKqekcpMlU4lOQHQh/SMwmoV+XqVgfzrWL7tktIy/1
         ZT2I9PE2I0rzrH4jfUHe0wDFlW9ITCu9uDUgS6DRuXVtqE4eWkODbJ90wrzS/LF7QD
         xIqE1WiFMPaW9NtDzFlXCCbx1NBJSiNNPLHLb2qTvRNriZkcrECzYPrdCEgDR3YJZR
         yXxI81qnot/9Q==
Date:   Wed, 22 Sep 2021 08:59:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/14] xfs: fix maxlevels comparisons in the btree
 staging code
Message-ID: <20210922155955.GF570615@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192859919.416199.9790046292707106095.stgit@magnolia>
 <YUmeIkK4aBCW1lJK@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUmeIkK4aBCW1lJK@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 21, 2021 at 09:56:02AM +0100, Christoph Hellwig wrote:
> On Fri, Sep 17, 2021 at 06:29:59PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The btree geometry computation function has an off-by-one error in that
> > it does not allow maximally tall btrees (nlevels == XFS_BTREE_MAXLEVELS).
> > This can result in repairs failing unnecessarily on very fragmented
> > filesystems.  Subsequent patches to remove MAXLEVELS usage in favor of
> > the per-btree type computations will make this a much more likely
> > occurrence.
> 
> Shouldn't this go in first as a fix?

It probably should, though I haven't seen any bug reports about this
fault.  I'll move it to the front of the patchset.

--D

> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
