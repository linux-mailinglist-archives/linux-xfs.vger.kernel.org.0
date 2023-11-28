Return-Path: <linux-xfs+bounces-156-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E68A7FB13A
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 06:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D7EB1C20BF4
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 05:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C87B7EACF;
	Tue, 28 Nov 2023 05:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD43E1
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:30:52 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6997067373; Tue, 28 Nov 2023 06:30:49 +0100 (CET)
Date: Tue, 28 Nov 2023 06:30:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: clean up the XFS_IOC_FSCOUNTS handler
Message-ID: <20231128053049.GA16579@lst.de>
References: <20231126130124.1251467-1-hch@lst.de> <20231126130124.1251467-3-hch@lst.de> <20231128015812.GR2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128015812.GR2766956@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 27, 2023 at 05:58:12PM -0800, Darrick J. Wong wrote:
> 	struct xfs_fsop_counts	out = {
> 		.allocino = percpu_counter_read_positive(&mp->m_icount),
> 		.freeino  = percpu_counter_read_positive(&mp->m_ifree),
> 		.freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
> 						xfs_fdblocks_unavailable(mp),
> 		.freertx  = percpu_counter_read_positive(&mp->m_frextents),
> 	};
> 
> Nit: Would you mind lining up the columns?

Sure.  I need to respin for the __user annotation anyway.


