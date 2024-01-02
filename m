Return-Path: <linux-xfs+bounces-2436-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03E56821A59
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jan 2024 11:48:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABA561F2241E
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jan 2024 10:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1598BD304;
	Tue,  2 Jan 2024 10:48:17 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E02E57E
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E666668B05; Tue,  2 Jan 2024 11:48:04 +0100 (CET)
Date: Tue, 2 Jan 2024 11:48:04 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>,
	Neal Gompa <neal@gompa.dev>, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v29.0 34/40] xfs_scrub: fixes for systemd services
Message-ID: <20240102104804.GA9125@lst.de>
References: <20231231181215.GA241128@frogsfrogsfrogs> <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Can we somehow expedite these plumbing fixes for the next xfsprogs
release instead of just hiding them in the giant patchbomb?


