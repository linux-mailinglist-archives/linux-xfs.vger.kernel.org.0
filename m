Return-Path: <linux-xfs+bounces-416-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6561B803EF9
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 21:04:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F2B81F21105
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 20:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD27E3309F;
	Mon,  4 Dec 2023 20:04:49 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853CCCD
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 12:04:46 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1668E227A8E; Mon,  4 Dec 2023 21:04:43 +0100 (CET)
Date: Mon, 4 Dec 2023 21:04:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH, RFC] libxfs: check the size of on-disk data structures
Message-ID: <20231204200442.GA18274@lst.de>
References: <20231108163316.493089-1-hch@lst.de> <20231109195233.GH1205143@frogsfrogsfrogs> <20231110050846.GA24953@lst.de> <20231201020658.GU361584@frogsfrogsfrogs> <20231204043718.GA25793@lst.de> <20231204195306.GC361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204195306.GC361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 04, 2023 at 11:53:06AM -0800, Darrick J. Wong wrote:
> >  #define XFS_CHECK_VALUE(value, expected) \
> > -	BUILD_BUG_ON_MSG((value) != (expected), \
> > +	static_assert((value) == (expected), \
> 
> HAH LOL that's much better.  I think I even see that kernel code is
> using it now, and wonder why BUG_BUILD_ON still exists.

Yup:

hch@brick:~/work/linux$ git-grep static_assert | wc -l
840
hch@brick:~/work/linux$ git-grep BUILD_BUG_ON_MSG | wc -l
92

> Going back for another cup of koolaid now,

Haha.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks.  I was just getting ready to send out a series with this and
the xfs_ondisk.h move.


