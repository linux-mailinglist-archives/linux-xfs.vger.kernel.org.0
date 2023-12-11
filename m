Return-Path: <linux-xfs+bounces-623-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF8F80D99A
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Dec 2023 19:55:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3AFE1F210C4
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Dec 2023 18:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8491451C47;
	Mon, 11 Dec 2023 18:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uLVrYxB+"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D8C321B8
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 18:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E938BC433CA;
	Mon, 11 Dec 2023 18:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702320920;
	bh=336DT38qIk6gcYE5sAI0LFDEV69Ipiq68h7uaBB6giE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uLVrYxB+LqNr7a+Hu3hXIEZU1e8kkkyss8bxQj7HiN1EzDMoTWhnr+sOn/2uO8AHk
	 Cc/g+hovq2pdkXDC8ugHXWnyxQzQkAh3IKYiv/kwW19Le7pfmbVyLgDKZouUD6N5Dl
	 ojw9ktqGNe2tdv46+KAA8CvXtJsAIdU1940GWqDqRMC94umgx9cSdcOEtDsT9/19mw
	 BuUOYGGFJMD8B413lnwCiykQ2GI5VVLWnNLIr2WtH0rfv1Ivohr2l73MvzCXafxYzs
	 dAQ7XszlmS7fE44mZSeFHWOCPQQl+wEzpiHBAeWaeMPLQcpCJfvtvDU9O6Hu1StW+6
	 9Gr+/Z9e3Kavw==
Date: Mon, 11 Dec 2023 10:55:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: set XBF_DONE on newly formatted btree block
 that are ready for writing
Message-ID: <20231211185519.GR361584@frogsfrogsfrogs>
References: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
 <170191665178.1180191.7709444254217822674.stgit@frogsfrogsfrogs>
 <ZXFXbhzVv2wlBEbX@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXFXbhzVv2wlBEbX@infradead.org>

On Wed, Dec 06, 2023 at 09:26:06PM -0800, Christoph Hellwig wrote:
> On Wed, Dec 06, 2023 at 06:38:50PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The btree bulkloading code calls xfs_buf_delwri_queue_here when it has
> > finished formatting a new btree block and wants to queue it to be
> > written to disk.  Once the new btree root has been committed, the blocks
> > (and hence the buffers) will be accessible to the rest of the
> > filesystem.  Mark each new buffer as DONE when adding it to the delwri
> > list so that the next btree traversal can skip reloading the contents
> > from disk.
> 
> This still seems like the wrong place to me - it really is the caller
> that fills it out that should set the DONE flag, not a non-standard
> delwri helper that should hopefully go away in the future.

I'll move it to xfs_btree_bload_drop_buf then.

--D

