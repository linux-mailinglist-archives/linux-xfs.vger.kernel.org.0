Return-Path: <linux-xfs+bounces-928-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 405F08173BB
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Dec 2023 15:37:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE31028230C
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Dec 2023 14:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E9333A1B7;
	Mon, 18 Dec 2023 14:36:51 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C5D3787E
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 14:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 73B0268AFE; Mon, 18 Dec 2023 15:36:45 +0100 (CET)
Date: Mon, 18 Dec 2023 15:36:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/23] libxfs: making passing flags to libxfs_init less
 confusing
Message-ID: <20231218143645.GA17178@lst.de>
References: <20231211163742.837427-1-hch@lst.de> <SV4SBZXoEqe0LKj1iYaB-dsaCotVVcjFLIBtvgAW8xsKK6fwdjbaWX0bUdMUsvGdUu7Y9AwZaAAxcGKLsYGB1g==@protonmail.internalid> <20231211163742.837427-15-hch@lst.de> <dljog33g6n2pxb4z74qpc3vor7yutlhmbgpunqwrvj7xu4nndy@jea7hfno5qhr>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dljog33g6n2pxb4z74qpc3vor7yutlhmbgpunqwrvj7xu4nndy@jea7hfno5qhr>
User-Agent: Mutt/1.5.17 (2007-11-01)

Btw, please add my mising:

Signed-off-by: Christoph Hellwig <hch@lst.de>

here.

