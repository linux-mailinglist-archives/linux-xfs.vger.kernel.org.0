Return-Path: <linux-xfs+bounces-2786-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79D7582C3EB
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jan 2024 17:48:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1A081C21A9D
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jan 2024 16:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F287762B;
	Fri, 12 Jan 2024 16:48:23 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2F86DD08
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9B52D68CFE; Fri, 12 Jan 2024 17:48:17 +0100 (CET)
Date: Fri, 12 Jan 2024 17:48:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libxfs: remove the unused fs_topology_t typedef
Message-ID: <20240112164817.GC16766@lst.de>
References: <20240112044743.2254211-1-hch@lst.de> <20240112044743.2254211-2-hch@lst.de> <20240112164450.GU722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112164450.GU722975@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 12, 2024 at 08:44:50AM -0800, Darrick J. Wong wrote:
> Dumb nit: the ampersand in the comment can go away too ^

It'll go away in the next patch.


