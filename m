Return-Path: <linux-xfs+bounces-11-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 042927F5879
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 07:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8906BB20E4F
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 06:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9FD125AB;
	Thu, 23 Nov 2023 06:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EXT1iUVF"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433C7E7
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EXT1iUVFklCaCk1Uik6tLn1zCe
	slb8NJiVmF34FXZaWer0VCMyl9nob05IlToe9T+KR7jZY7IQk/zT/bceOeFfG4Hx9OQib/ji+5bzY
	hqAVpXOD496YuGDgpvnpUpMjBA09vlyC7Z75rrS6VxQBFBX6cfW6o0lc+h2DaU33Ym+15/UQ0Ujiz
	XfI7nHt/CwXxIfeyUE6Bt0riFFbouAgf+gdF6eMw+MXPSzsvRrdUqQ++nXvwP6Oq0z3HbX0ApOpyl
	h3r6TWs5qC/4VqpOSX2CVY2ZUZ/bb17v4LQZyBZDuLbgdynU12IiyEOL2eOukAKGSuIp6qksEUz5H
	WWoL8WUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63P8-003w07-0V;
	Thu, 23 Nov 2023 06:41:38 +0000
Date: Wed, 22 Nov 2023 22:41:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs_mdrestore: fix uninitialized variables in
 mdrestore main
Message-ID: <ZV70ItTFJ/iXfsbA@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069444236.1865809.11643710907133041679.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069444236.1865809.11643710907133041679.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

