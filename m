Return-Path: <linux-xfs+bounces-376-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0338802B3C
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 06:11:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97EE0280CA0
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 05:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2AC54415;
	Mon,  4 Dec 2023 05:11:50 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445F6CC
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 21:11:48 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id BFDF868AFE; Mon,  4 Dec 2023 06:11:45 +0100 (CET)
Date: Mon, 4 Dec 2023 06:11:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: hoist ->create_intent boilerplate to its
 callsite
Message-ID: <20231204051145.GL26073@lst.de>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs> <170162990231.3037772.4009995462926348210.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162990231.3037772.4009995462926348210.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

