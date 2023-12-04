Return-Path: <linux-xfs+bounces-413-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80E81803EAB
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 20:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36C161F211D0
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 19:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3473218E;
	Mon,  4 Dec 2023 19:46:32 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7067C1
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 11:46:29 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 41952227A8E; Mon,  4 Dec 2023 20:46:27 +0100 (CET)
Date: Mon, 4 Dec 2023 20:46:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: collapse the ->create_done functions
Message-ID: <20231204194626.GB17769@lst.de>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs> <170162990294.3037772.8654512217801085122.stgit@frogsfrogsfrogs> <20231204052403.GD26448@lst.de> <20231204185131.GZ361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204185131.GZ361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 04, 2023 at 10:51:31AM -0800, Darrick J. Wong wrote:
> > always ->dfp_intent and I don't think that can be NULL.  No other
> > implementation of ->create_done checks for it either.
> 
> If xfs_attr_create_intent returns NULL, then xfs_attr_create_done won't
> create a done item either.  xfs_defer_finish_one will walk through the
> state machine as always, but the operation won't be restarted by
> recovery since the higher level operation state was not recorded in the
> log.

So - why do we even call into ->create_done when  ->dfp_intent is
NULL?


