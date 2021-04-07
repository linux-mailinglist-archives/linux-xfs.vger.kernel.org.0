Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AAB357018
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Apr 2021 17:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhDGPYB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Apr 2021 11:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353483AbhDGPXn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Apr 2021 11:23:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31FEF61007;
        Wed,  7 Apr 2021 15:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617809014;
        bh=36BhoV8y18nQyobSa0n4cK/hp9uQtTozwmInF8Qz85I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GhRjJ9KDWFanHDo/NouTSMMtAO1QGM2ZhIoyJh30UuBd57ZYDMRZqYlsRTWm0UedM
         UlOPu8g7DMhDIsAasuAk/+iQdyX821TWcI9E3Tz1B0zsDZzNnJqhy3BbAGyJHJWJti
         YMoVjuFunKQj7bRu24MrnEx0/xApkFn0MVNdhLBuZl1CjBvC7HjIWjSs9/selquV3f
         zVuBsPDtoD8enIgW0rMcm6DH/b5CU7U5wDQEmF9PJXjY1+DrQqV58rfcUY8nnimOBf
         /42SCUnxbScBRtW4X0H/Erl3aUiijoeJz7iIgBgo4e3l4F3CXd0F9gDpCi3Yzl0DJg
         09YMEW2IyWxRQ==
Date:   Wed, 7 Apr 2021 08:23:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: open code ioend needs workqueue helper
Message-ID: <20210407152334.GH3957620@magnolia>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-3-bfoster@redhat.com>
 <20210407063440.GC3339217@infradead.org>
 <YG2WXd9lR908lK/1@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG2WXd9lR908lK/1@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 07, 2021 at 07:24:13AM -0400, Brian Foster wrote:
> On Wed, Apr 07, 2021 at 07:34:40AM +0100, Christoph Hellwig wrote:
> > On Mon, Apr 05, 2021 at 10:59:01AM -0400, Brian Foster wrote:
> > > Open code xfs_ioend_needs_workqueue() into the only remaining
> > > caller.
> > 
> > This description would all fit on a single line.
> > 
> 
> I've used 68 character wide commit log descriptions for quite some time,
> to which this seems to be wrapped accurately. This is the same as the
> immediately previous patch for example, with the much longer
> description. I don't care much about changing it, but is there a
> canonical format defined somewhere? I've always just thought 68-72 was
> acceptable.

I set email to wrap at 72 and C code to wrap at 79 columns.

Though as I've said in the past, I don't enforce /any/ of those rules
with any specificity so long as they're not being abused.  (e.g.
wrapping at column 5 or 500)

--D

> Brian
> 
> > Looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> 
