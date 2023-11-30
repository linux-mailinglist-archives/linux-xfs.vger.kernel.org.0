Return-Path: <linux-xfs+bounces-282-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54EEB7FE88E
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 06:16:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 850431C20A39
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 05:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C725F13AF9;
	Thu, 30 Nov 2023 05:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O9lFYQGc"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E68D10D7
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 21:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=O9lFYQGc4qF93XDMfJgCHfzGmG
	rhJQfh7OAmuyMCzkzZ9vaUXVe6Y9c4DrMQiWAe2jdDtEW29wDztxbbb/aSdp3TVoVIb+ezrbJ1bcP
	AWZB9SCQfYMS6qCnzEQUfE2K+INYZTwlt4d+SxYqVFHmtevaBl8cD4yzii+9YdvKokcxc8k9Vx851
	5mcm9BAcDX2uNK0ABBeq9/wlDVmPCemD6whLMalWEL5tUV6QfKOgHlmZX0vO/DGCFhVZlhjDsD3PT
	TI95BeFevJjt9HyCIanuNxm3VpOSZUSUdDooFaVMwYKyp2faZRboz47yk9OOU8lzRBgG91+QPaoRp
	Lpnj7dTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8ZPf-009xL0-0P;
	Thu, 30 Nov 2023 05:16:35 +0000
Date: Wed, 29 Nov 2023 21:16:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: online repair of realtime bitmaps
Message-ID: <ZWgas26sH9PpuBhm@infradead.org>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928439.2771542.8593836559546727999.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086928439.2771542.8593836559546727999.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

