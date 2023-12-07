Return-Path: <linux-xfs+bounces-553-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18CAD80806C
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 07:01:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BC961F211BE
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 06:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 358A0125CD;
	Thu,  7 Dec 2023 06:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UPtVyAoo"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0DF110
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 22:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ddecu0jNmt0iaz52H2+Mj22ldshdlfHfO4cFfgAgz5o=; b=UPtVyAooA/1gnyP++t0z6Adt45
	vvhKNpQ2aL5bojOhcmVGM6CntoQ9EHoCyXcr1zieAtTkLMDMavmDGTWFzZ5dFnVcHEE+D2whV08fb
	Q+1AYF8u4zAMM7Ngol2pGT2HoDKZadtsVMJj5Pb+cQzQlUD1WKmI4VtieRfVbCaICVm+V1BA2MlsQ
	ANmFyaindadKhhwfGH0VDWO24VQ4VJmpmWPxzgAolNd0aPkDfVXG1rAG7g7i1TL+3TU4i5Vfuevr9
	JmpvRBjjoMFAM7n7/XOl7AT/GU1X1RC3VJMVcFy9LfdjPdMyc5pARAD56tbx3R9aib9c4bDrcdcxh
	uAFwvi8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB7RV-00Bwg6-1V;
	Thu, 07 Dec 2023 06:01:01 +0000
Date: Wed, 6 Dec 2023 22:01:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: zap broken inode forks
Message-ID: <ZXFfnaaPBBjTEW4S@infradead.org>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666188.1182270.114932269965181078.stgit@frogsfrogsfrogs>
 <ZXFfeW715AvqptIq@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXFfeW715AvqptIq@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 06, 2023 at 10:00:25PM -0800, Christoph Hellwig wrote:
> Looks good, although as mentioned on the next patch having the health
> flag first would seem better.

And I guess this means:

Reviewed-by: Christoph Hellwig <hch@lst.de>

