Return-Path: <linux-xfs+bounces-635-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B484B80E3D8
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Dec 2023 06:35:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E56081C21AF0
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Dec 2023 05:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA064154AA;
	Tue, 12 Dec 2023 05:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MrSOqFNS"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEABCE
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 21:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wc+b/YDC+WvJLxXmmSxfNabUSskJ+ZezjKpszu+B9Bc=; b=MrSOqFNSBuURUyn2Yk49KSKGmX
	+owP6xYbwVqhyoRyicgr72hKpS1SGKCkam10hAB0wI84KMLuIb9/MLPkUSv++B7P6t0oW20jdbQFC
	qfNrdR3vtomI3typePXWOWxgZckpEDb3PNz+MT0dm4RoFeZ5rFzDb1DKHn/RLaNEy6Mgp/SqYFJra
	kc3gNU166Mn/QkypEFCx1CalzBBMZ/K47/scMpZUALbZRvEoRKfV934ktelJePw1Y3xdPzedgy9Kp
	jt0vBBZNap0lWfVfbezNEgzT2kAzSTWz5oPKA7XmXWa1izMboKxtzxOisxlDW8i1OP4rHM8ynGuw7
	wzHjiQMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rCvQf-00AniW-1a;
	Tue, 12 Dec 2023 05:35:37 +0000
Date: Mon, 11 Dec 2023 21:35:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: repair obviously broken inode modes
Message-ID: <ZXfxKX+eg/EeMeY1@infradead.org>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666254.1182270.6610873636846446907.stgit@frogsfrogsfrogs>
 <ZXFhuNaLx1C8yYV+@infradead.org>
 <20231211221926.GX361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211221926.GX361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 11, 2023 at 02:19:26PM -0800, Darrick J. Wong wrote:
> block/char/special files... I guess those can just turn into zero length
> regular files.

Ys, and I don't think that is much of a problem.

> Would this NAK remain even if there were external corroborating
> evidence?
> 
> For example, what if we read the dirents out of the first directory
> block, seek out parent pointers in the alleged children, and confirm a
> 1:1 match between the alleged dirents and pptrs?  Unprivileged userspace
> can certain create a regular file N that looks like a dirent block, but
> it cannot create dangling pptrs back to N to trick the verification
> algorithm.

That does look like I a good enough evinde as you said userspace can't
fake up the parent pointer.

