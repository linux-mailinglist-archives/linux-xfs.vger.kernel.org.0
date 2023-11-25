Return-Path: <linux-xfs+bounces-77-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 630AE7F886B
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 06:05:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D5AD2811BF
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 05:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889D823B0;
	Sat, 25 Nov 2023 05:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TcKIGQXm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D6F1710
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 21:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=TcKIGQXm8vVgKZmPtL/AK/WRhL
	l5bSDCurICiDswu7UQGjaWCRBB1/BrBsizZBcJ/3q3yuT5qNLqEWhcvFLBtyMv8ozqbx/U+xzA+HR
	ow8lk8EAm/Q2t8PzTZFKvBygTKvneL+rMPdYP8R3C9tnA4BTS7M799xaOVAdKrqMgc8LEoe9ENoSO
	1yr4XGNxB9kM3EjFScuRZmVk8gXxOiW29qubQTa3cUwlKpkL1am2/woyQAohZ/40AysuhFeDUiNga
	uCRVQqePjEXOrcIQvxZNDjgKljXrjz5iy2bjbvDR3cH03LPkN/sp4Yfaw07PoqqerxvvDONVsJ6yp
	yjK9DDCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6kqx-008ZrN-2L;
	Sat, 25 Nov 2023 05:05:15 +0000
Date: Fri, 24 Nov 2023 21:05:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: allow pausing of pending deferred work items
Message-ID: <ZWGAi9KZM/Gv7k4F@infradead.org>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
 <170086926160.2768790.13588639927943819972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926160.2768790.13588639927943819972.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


