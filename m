Return-Path: <linux-xfs+bounces-9-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E62877F5876
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 07:41:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FF9E281725
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 06:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B6C11C90;
	Thu, 23 Nov 2023 06:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qIGW8uGP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EC9DD
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=78/j0crQF+aUVbq/R2ZMUmjrT0uMbEznGYXUqAqBG3Y=; b=qIGW8uGPNd/PZ33Je9mVDFH6UD
	UBnmoBPyJaTQ8tMnxYSvMLmN6gK9wCoDjpQ4Nu4T8SgutBp+rYdIBFhUtJ15EgqMRvCv9dEyIrcPC
	v7c0fhAHcadu5KQ87hPVOoYOMKEtTrEfdV8XY46JojAgsUWnD4YhiUS942XFY9s2/V6W/bXLvQS7O
	U3SvwKR42ejE3/AT6JzN/gjNBwrl4eOP4ePkmcNWB14An6XzgEXbNlr1EXt7YOGo4ZrGxv4uYx1x0
	wO1NC8ehFLGoD/cznUxbg1SttY0klNeEuOjiaPWO4m3URrwatoR/zIYA3iJbyvCDkisGVWlnD4hAx
	r3DkJA1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63Of-003vwe-10;
	Thu, 23 Nov 2023 06:41:09 +0000
Date: Wed, 22 Nov 2023 22:41:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs_db: report the device associated with each io
 cursor
Message-ID: <ZV70BSL4TBfVZdVA@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069443096.1865809.13119575401747000666.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069443096.1865809.13119575401747000666.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 22, 2023 at 03:07:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When db is reporting on an io cursor, have it print out the device
> that the cursor is pointing to.

This looks very useful.  But I wonder if it risks breaking a lot
of scripts?


