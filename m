Return-Path: <linux-xfs+bounces-231-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D90517FCE5E
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 06:40:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2BD6EB2167C
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 05:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD4DE6FD5;
	Wed, 29 Nov 2023 05:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DEE19A6;
	Tue, 28 Nov 2023 21:40:27 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id C49A3227A87; Wed, 29 Nov 2023 06:40:24 +0100 (CET)
Date: Wed, 29 Nov 2023 06:40:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 09/13] iomap: don't chain bios
Message-ID: <20231129054024.GC1385@lst.de>
References: <20231126124720.1249310-1-hch@lst.de> <20231126124720.1249310-10-hch@lst.de> <20231129045951.GO4167244@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129045951.GO4167244@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 28, 2023 at 08:59:51PM -0800, Darrick J. Wong wrote:
> Well that's a nice code deflation!  And if I read this correctly,
> instead of chaining bios together, now we create a new ioend and add it
> to the ioend list, eventually submitting the entire list of them?

Yes. (although that changes a bit again later)


