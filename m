Return-Path: <linux-xfs+bounces-539-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BCF3807FF6
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 06:07:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16EFF281F2D
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 05:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353A310793;
	Thu,  7 Dec 2023 05:06:55 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2744410CE
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:06:31 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1662B227A87; Thu,  7 Dec 2023 06:06:28 +0100 (CET)
Date: Thu, 7 Dec 2023 06:06:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: recompute growfsrtfree transaction
 reservation while growing rt volume
Message-ID: <20231207050627.GA16149@lst.de>
References: <170191563642.1133893.14966073508617867491.stgit@frogsfrogsfrogs> <170191563659.1133893.4605821704716263615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191563659.1133893.4605821704716263615.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

