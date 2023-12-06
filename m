Return-Path: <linux-xfs+bounces-469-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD297806FAA
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Dec 2023 13:28:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27F00B20C48
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Dec 2023 12:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41904364D3;
	Wed,  6 Dec 2023 12:28:52 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659E3D41
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 04:28:47 -0800 (PST)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.54])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Slc6d2wctz1Q6Fg;
	Wed,  6 Dec 2023 20:24:57 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 6 Dec
 2023 20:28:44 +0800
Date: Wed, 6 Dec 2023 20:32:27 +0800
From: Long Li <leo.lilong@huawei.com>
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
CC: <djwong@kernel.org>, <chandanbabu@kernel.org>,
	<linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH 1/2] xfs: add lock protection when remove perag from
 radix tree
Message-ID: <20231206123227.GA3413285@ceph-admin>
References: <20231204043911.1273667-1-leo.lilong@huawei.com>
 <ZW6ofJp3zRn/X3Mc@infradead.org>
 <ZW+V4N5KcBiQa6//@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZW+V4N5KcBiQa6//@dread.disaster.area>
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected

On Wed, Dec 06, 2023 at 08:28:00AM +1100, Dave Chinner wrote:
> On Mon, Dec 04, 2023 at 08:35:08PM -0800, Christoph Hellwig wrote:
> > On Mon, Dec 04, 2023 at 12:39:10PM +0800, Long Li wrote:
> > > Look at the perag insertion into the radix tree, protected by
> > > mp->m_perag_lock. When the file system is unmounted, the perag is
> > > removed from the radix tree, also protected by mp->m_perag_lock.
> > > Therefore, mp->m_perag_lock is also added when removing a perag
> > > from the radix tree in error path in xfs_initialize_perag().
> > 
> > There really can't be anything we are racing with at this point.
> 
> I'm pretty sure that there can be racing operations. Lookups are
> fine - they are RCU protected so already deal with the tree changing
> shape underneath the lookup - but tagging operations require the
> tree to be stable while the tags are propagated back up to the root.
> 
> Right now there's nothing stopping radix tree tagging from
> operating while a growfs operation is progress and adding/removing
> new entries into the radix tree.
> 
> Hence we can have traversals that require a stable tree occurring at
> the same time we are removing unused entries from the radix tree
> which causes the shape of the tree to change...
> 
> Likely this hasn't caused a problem in the past because we are only
> doing append addition and removal so the active AG part of the tree
> is not changing shape, but that doesn't mean it is safe...
> 
> > That beeing said I think clearing locking rules are always a good
> > thing.  So maybe reword the above as:
> > 
> > "Take mp->m_perag_lock for deletions from the perag radix tree in
> >  xfs_initialize_perag to be consistent with additions to it even
> >  if there can't be concurrent modifications to it at this point"
> 
> I don't think it needs even that - just making the radix tree
> modifications serialise against each other is obviously correct...
> 

If my understanding is correct, it makes sense to add lock protection
when modifying the radix tree. So I will update the commit message in
the next version.

Thanks,
Long Li

