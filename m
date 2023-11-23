Return-Path: <linux-xfs+bounces-10-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5A977F5878
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 07:41:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 600E1281729
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 06:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F5A11C80;
	Thu, 23 Nov 2023 06:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UEUnpD5f"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E47C1
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UEUnpD5f3cOCRDmap2cFyHDHoy
	hkcNXT/MZs4/Mc3g22dYGfQk0HIWBJCs68YzHQas8gNeEYc8wB/sU61UWgzW3p7eE4qPI84ra7TfM
	STp6bFBIARbt6WX3MgVLZX/09ZERuTb+ZkfbARMHPNkwxR3ZL+WW1nz13ftjyBTfXPKHV/T8WN2m7
	gTJj+2PMCXKnh7UlpWq9cAsrN7N7ZM88xstMuGxKKKR8sReM2SLoRgQZCbfRfreIhZgIrNFd4vxAj
	GzT4wjbCa3Z+JrCAFxgCod8MA8/6kEnS5xAXC+Wic1+nRiOxGDNkjAywgZa7LLwQV/VHYYtSlK19j
	6ePfAGpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63Os-003vyD-0l;
	Thu, 23 Nov 2023 06:41:22 +0000
Date: Wed, 22 Nov 2023 22:41:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs_metadump.8: update for external log device
 options
Message-ID: <ZV70ErpbpBvwo2wr@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069443670.1865809.2265862857261044359.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069443670.1865809.2265862857261044359.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

