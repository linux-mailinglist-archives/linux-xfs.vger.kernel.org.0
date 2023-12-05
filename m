Return-Path: <linux-xfs+bounces-434-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B9D804890
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Dec 2023 05:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E101E1F2146F
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Dec 2023 04:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D016D274;
	Tue,  5 Dec 2023 04:31:50 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C547DA1
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 20:31:46 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 630ED68B05; Tue,  5 Dec 2023 05:31:43 +0100 (CET)
Date: Tue, 5 Dec 2023 05:31:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, leo.lilong@huawei.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: don't leak recovered attri intent items
Message-ID: <20231205043143.GA28309@lst.de>
References: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs> <170162989722.3037528.16617404995975433218.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162989722.3037528.16617404995975433218.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Based on my now existent but still vague understanding of the logged
attr code:

Reviewed-by: Christoph Hellwig <hch@lst.de>

