Return-Path: <linux-xfs+bounces-375-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA94802B3B
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 06:11:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F1161C20987
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 05:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17AA31FD8;
	Mon,  4 Dec 2023 05:11:20 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB3BF3
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 21:11:16 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 52EB4227A8E; Mon,  4 Dec 2023 06:11:14 +0100 (CET)
Date: Mon, 4 Dec 2023 06:11:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: collapse the ->finish_item helpers
Message-ID: <20231204051114.GK26073@lst.de>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs> <170162990215.3037772.6031433086898908600.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162990215.3037772.6031433086898908600.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


