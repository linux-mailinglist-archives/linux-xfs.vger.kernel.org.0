Return-Path: <linux-xfs+bounces-552-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA7E880806A
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 07:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 560921F21275
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 06:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF0511CB4;
	Thu,  7 Dec 2023 06:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jr1ke9tR"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4734D51
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 22:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cakKfzCJz64c36I61AH26K8Az/f1SHDhjyRfd6yRa9k=; b=Jr1ke9tRt3pFiWntMS5OcJ2te9
	4V3dx2Nbj7Br07ZxHTPphTKzJ4n3aTF3gPJHRuvedn6yLuBg27Lwl2etpdPMl41jtuUff/JVz7Tbf
	wZvZ3JK6tWReqETiAYgDm29UaPeYMZvWmC8EH9kSkGDMBuGJ5ytkunRSl6oVQPkGAfT5SX+wuRoL/
	LpyeHt7k4kFM/uhm/5ZKUr0RSdwPfIWKCdikIBiUnpKNdsNmM4LRl1JnzdRj8oqSoASD0OM+wIDX7
	+K+ysPaJ0iL2tAJeaeShMa447RR5Kw4KwVn1/l5y+uRA29UJsNdkJal3FH1Qjptxb6OOcexnRoUmd
	5D8ASKUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB7Qv-00Bwdf-26;
	Thu, 07 Dec 2023 06:00:25 +0000
Date: Wed, 6 Dec 2023 22:00:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: zap broken inode forks
Message-ID: <ZXFfeW715AvqptIq@infradead.org>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666188.1182270.114932269965181078.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191666188.1182270.114932269965181078.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good, although as mentioned on the next patch having the health
flag first would seem better.

