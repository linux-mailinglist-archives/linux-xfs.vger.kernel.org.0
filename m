Return-Path: <linux-xfs+bounces-6-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 790867F5843
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 07:34:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32E472817AC
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 06:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C828FF9F0;
	Thu, 23 Nov 2023 06:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H72/1C6h"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCDF189
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zT4mSG7Tj3R3ZGpKGxL1AFHYqog1ka6j+MD2Ivz6ftM=; b=H72/1C6h2vLlo3XpYbpZqucG0B
	GPx9GnAo3E3LvYKsgDxXshd7vpZA5yrj8diU8d/WjKHepagDyP5mdfAb/XFaM9u8UP9PGGQz/abz7
	cLDICE60rOhhWV5Q9y2YveWiQP/66sH0zSt7pGHWvTWTkmmd7NdluXd+oIf1LPC5p3f4mvRf7ALw8
	fzN2w6vHYjUtqDkL5uun8k8toMACZ9dQ35LF+sKKsB8BliLwfEJn5qCQMRpDFndHzp3x4wwOBMO7H
	1M+UoQ6MbX7WSlXTK12BoKtiIA5u0hWjH/gNnDBI3mbiUE8jdxfTK8Lekjv0RHkqZvBa8SQBRrrS/
	l+gQLwtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63Ho-003uwq-0m;
	Thu, 23 Nov 2023 06:34:04 +0000
Date: Wed, 22 Nov 2023 22:34:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] libfrog: move 64-bit division wrappers to libfrog
Message-ID: <ZV7yXF8hZfWe/DG2@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069441404.1865809.15599372422489523965.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069441404.1865809.15599372422489523965.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

.. I so wish we get rid of the stupid 64-bit division helpers in the
kernel..

But until then:

Reviewed-by: Christoph Hellwig <hch@lst.de>

