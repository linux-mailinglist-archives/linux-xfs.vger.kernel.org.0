Return-Path: <linux-xfs+bounces-14-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 250CC7F587D
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 07:43:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA402B20D16
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 06:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12650125AC;
	Thu, 23 Nov 2023 06:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WNqucVpN"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DC3AD
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TRm++4c8rA5R1rEPEDByHTQkVxmOq40MRif0n1HGxEk=; b=WNqucVpNVI5c0nHQvZmVtjkrKE
	+EjGqsbgCRAdhkVdoA2xIH6UAxHzMl/8HsTZ2ezOGmlteXSiHaGHlUtUFGLzjDsocogqhc+7buvJw
	8UX2wjJRdINjopYQFNREr1n7UZ9CbhPkukKxhl/m87sLcc1lN4E2o7O3Tnknhb4kB7UOsQnMRG8wZ
	qm3iFKq8OJePV3h75e+UWFCp8KRReWcALvxmTFrX5txaW7hTeIiS8g0vi74MjPbXKtb+GfRd2YPvC
	Szd7VJoRmqsSVLebnGSZMDcWs6GF5i38eKoapTpfgLv8IKb82zqjNFkcWfPh9+rwZ3SFpCGswjVFt
	Hbkf8V5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63QQ-003w4Q-2B;
	Thu, 23 Nov 2023 06:42:58 +0000
Date: Wed, 22 Nov 2023 22:42:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_mdrestore: EXTERNALLOG is a compat value, not
 incompat
Message-ID: <ZV70cjzx7Dg5Px5Q@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069445376.1865809.6391643475229742760.stgit@frogsfrogsfrogs>
 <ZV70YNvPWauYckC4@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZV70YNvPWauYckC4@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 22, 2023 at 10:42:40PM -0800, Christoph Hellwig wrote:
> Nit: overly long line.  Trivially fixable by just inverting the
> conditions :)

s/invert/reorder/


