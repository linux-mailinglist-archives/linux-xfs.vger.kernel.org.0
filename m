Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A83325308
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 17:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbhBYQF5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Feb 2021 11:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233481AbhBYQFl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Feb 2021 11:05:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0A6664ED3;
        Thu, 25 Feb 2021 16:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614269096;
        bh=VHTsGwWoLE4ba13wdx7wE8SN9LtMB/0lc89yb9bEG+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WuTj5vJbB557Gx001JjcKLG3S2R11U0jXEiDtNxhyn/RMnio8xDWk3TdInp+8iFiE
         bcw2PTtJEkRP6T6DFaJkG4tH5AXXpSEZBTIAw3BoHVG96YbEtnXPD+uJanBj1X0MMS
         CzhEe3ULmB/+acj6W93OlDA5B8iuUJjPeiKW1yPlQZPsM/DrGm5LTvACpUGT7j/w6u
         nS+tRbcMFqf8iHuy4vR0EPrLsdidKebiNWGuX2DVwfyYezpLy6Hh8Vwpse5a1x51+g
         h6NXdQUMRJloeBb2Y37WnvOki+YouEB5mGbFrI7730EjLwjwnAyPRoOsiWfrCsBnR9
         HZKy2fuwu3ZCQ==
Date:   Thu, 25 Feb 2021 08:04:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs/122: embiggen struct xfs_agi size for inobtcount
 feature
Message-ID: <20210225160456.GJ7272@magnolia>
References: <161319441183.403510.7352964287278809555.stgit@magnolia>
 <161319442288.403510.14136573891346236052.stgit@magnolia>
 <20210225073848.GC2483198@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225073848.GC2483198@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 07:38:48AM +0000, Christoph Hellwig wrote:
> On Fri, Feb 12, 2021 at 09:33:42PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make the expected AGI size larger for the inobtcount feature.
> 
> Is embiggen really a word?  Otherwise looks good:

Yes.

Original source: https://youtu.be/FcxsgZxqnEg?t=65

Legitimate source: https://www.merriam-webster.com/dictionary/embiggen

:D

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
