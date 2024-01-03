Return-Path: <linux-xfs+bounces-2454-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B2F46822681
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jan 2024 02:21:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FEAE1F230DC
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jan 2024 01:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3289ED7;
	Wed,  3 Jan 2024 01:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDYkgZvh"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9496ED3
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 01:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38008C433C8;
	Wed,  3 Jan 2024 01:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704244901;
	bh=mukBuDCsCUeQEy+jSeAqAb6x1VwlV6GT6pMhhnLm7uw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SDYkgZvhnVv5XJJJflFDzz78bkzdyNlY1wMeBwZvfJIY0mwumCzyrWhYEy6ZWpoDe
	 C8m4MsQ9cCuSUjdDEXvFS+Yf3YyInZpP2mYsPKQnWlUSBSQ4UysZdZ2NAnzJIg+YLH
	 N/J+2+A3XrySJEGoq/0Ir3gj4td2CQ1fylCmXKnVxveRw+V5q1Y6sUs8oD5RX0fdbB
	 leLlzZjCuN7cnpiG2+3pXvBOlwViorAwLdj/mHwlk/7TedcssL6ksvt170IcxQblRT
	 KDp9xOFkXcZfffaD+lRTmakDLA3vC1TtmlnjOS7Zs0ymIPjGXmwm85tzQ2UKuGb7Q1
	 0DuCkT2oXxF2w==
Date: Tue, 2 Jan 2024 17:21:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: reuse xfs_bmap_update_cancel_item
Message-ID: <20240103012140.GC361584@frogsfrogsfrogs>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
 <170404831504.1749708.16128807281068864794.stgit@frogsfrogsfrogs>
 <ZZPpNymYGUa2UuK1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZPpNymYGUa2UuK1@infradead.org>

On Tue, Jan 02, 2024 at 02:45:11AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:21:38PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Reuse xfs_bmap_update_cancel_item to put the AG/RTG and free the item in
> > a few places that currently open code the logic.
> > 
> > Inspired-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Isn't this actually pretty much exactly my patch?

Yeah, but with some non-trivial alterations, so that's why I went with
the tagset presented here.

> Either way this looks (obviously :)) good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D

