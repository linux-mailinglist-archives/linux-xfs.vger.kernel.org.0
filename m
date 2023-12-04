Return-Path: <linux-xfs+bounces-373-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D046802B38
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 06:08:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEC4B1C20975
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 05:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A20B1873;
	Mon,  4 Dec 2023 05:08:09 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D146ECA
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 21:08:06 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA9A0227A8E; Mon,  4 Dec 2023 06:08:03 +0100 (CET)
Date: Mon, 4 Dec 2023 06:08:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: don't set XFS_TRANS_HAS_INTENT_DONE when
 there's no ATTRD log item
Message-ID: <20231204050803.GI26073@lst.de>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs> <170162990183.3037772.16569536668272771929.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162990183.3037772.16569536668272771929.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Dec 03, 2023 at 11:02:57AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> XFS_TRANS_HAS_INTENT_DONE is a flag to the CIL that we've added a log
> intent done item to the transaction.  This enables an optimization
> wherein we avoid writing out log intent and log intent done items if
> they would have ended up in the same checkpoint.  This reduces writes to
> the ondisk log and speeds up recovery as a result.
> 
> However, callers can use the defer ops machinery to modify xattrs
> without using the log items.  In this situation, there won't be an
> intent done item, so we do not need to set the flag.

Understanding the logged attrs code is till on my TODO list, but
the patch looks obviously correct in that we shouldn't set
XFS_TRANS_HAS_INTENT_DONE if there is no done items.  I'm still
confused how it can log an intent item without a done item,
though.

Cautiously and superficially:

Reviewed-by: Christoph Hellwig <hch@lst.de>

