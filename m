Return-Path: <linux-xfs+bounces-114-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF947F92D2
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Nov 2023 14:15:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9E22280FE4
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Nov 2023 13:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2185D26E;
	Sun, 26 Nov 2023 13:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="slCy+hh0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BEEDD
	for <linux-xfs@vger.kernel.org>; Sun, 26 Nov 2023 05:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=slCy+hh09vJAY0Zf/iM03+DnFJ
	im6VEIikWLbHNU0FZNnLx1otMlDvb9cj5CiaLqjKx1OCXOB7zzlrKWFOQtuIQz8eWgG2njhWGzV4s
	YWSrTIXyg9NMgKIYtWt3wj2OmjWGj3f5MX/mdJWirEzCAB4BbyDUxT4L/di3x4KZb3RQ4OeLfNh4G
	LwhXpFyPYi1FnoT1Nwl7xYds8bh1aoMUBJDZAQ0S240LY8dlQqShueadGPYYx1doGE1ZjwLWYpBID
	1ydptwAF+9QcAbDmmSzry7a8y2HyCfBg84ZPG4mzxvceE1oqRO77iGTiiKj1ESMtu7Wsvvcyjl6QL
	Wn258BpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7Eyn-00BKqX-2G;
	Sun, 26 Nov 2023 13:15:21 +0000
Date: Sun, 26 Nov 2023 05:15:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: log EFIs for all btree blocks being used to
 stage a btree
Message-ID: <ZWNE6Wi/ZqeW3ESf@infradead.org>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
 <170086926222.2768790.3545458743634941117.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926222.2768790.3545458743634941117.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

