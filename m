Return-Path: <linux-xfs+bounces-411-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B89B803E80
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 20:36:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8975228113E
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 19:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3594931748;
	Mon,  4 Dec 2023 19:36:11 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463DEF0
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 11:36:06 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id B8F1E227A8E; Mon,  4 Dec 2023 20:36:03 +0100 (CET)
Date: Mon, 4 Dec 2023 20:36:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandanbabu@kernel.org,
	leo.lilong@huawei.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: pass the xfs_defer_pending object to
 iop_recover
Message-ID: <20231204193603.GA17599@lst.de>
References: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs> <170162989753.3037528.15154705573817500020.stgit@frogsfrogsfrogs> <20231204050426.GE26073@lst.de> <20231204183153.GX361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204183153.GX361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 04, 2023 at 10:31:53AM -0800, Darrick J. Wong wrote:
> On Mon, Dec 04, 2023 at 06:04:26AM +0100, Christoph Hellwig wrote:
> > Not sure if I missed it in my first round of review, or if this is new
> > in this version, but this now generats a warning when asserts are
> > disabled, given that the lip variable in xlog_recover_process_intents
> > is only used in asserts.  We'll need to remove it and just open code
> > the dereference in the two asserts that use it.
> 
> Yeah, that's the last patch, and I forgot to address that warning
> because the kbuild robot only sends email to my Outlook now.  Clearly
> I'm not doing CONFIG_XFS_DEBUG=n builds on my development box...

You're getting email quickly from the bot then, for me these kinds of
reports usually show up days later..


