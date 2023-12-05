Return-Path: <linux-xfs+bounces-445-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC01804967
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Dec 2023 06:39:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24A8AB20C63
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Dec 2023 05:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA3AD26E;
	Tue,  5 Dec 2023 05:39:06 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EF9109
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 21:39:03 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6D7B7227A8E; Tue,  5 Dec 2023 06:39:01 +0100 (CET)
Date: Tue, 5 Dec 2023 06:39:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: elide ->create_done calls for unlogged
 deferred work
Message-ID: <20231205053901.GB30199@lst.de>
References: <170175456196.3910588.9712198406317844529.stgit@frogsfrogsfrogs> <170175457355.3910588.11459425968388525930.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170175457355.3910588.11459425968388525930.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

