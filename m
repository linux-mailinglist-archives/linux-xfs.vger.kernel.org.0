Return-Path: <linux-xfs+bounces-2545-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D1E823C39
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jan 2024 07:25:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD8D2B24AFD
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jan 2024 06:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FCC31BDD6;
	Thu,  4 Jan 2024 06:25:27 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAA41865A
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 219FE68AFE; Thu,  4 Jan 2024 07:25:23 +0100 (CET)
Date: Thu, 4 Jan 2024 07:25:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 11/15] xfs: use shmem_get_folio in xfile_get_page
Message-ID: <20240104062522.GD29215@lst.de>
References: <20240103084126.513354-1-hch@lst.de> <20240103084126.513354-12-hch@lst.de> <20240104001251.GE361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104001251.GE361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 04:12:51PM -0800, Darrick J. Wong wrote:
> > +	if (error)
> > +		return error;
> > +
> > +	page = folio_file_page(folio, pos >> PAGE_SHIFT);
> > +	if (PageHWPoison(page)) {
> > +		folio_put(folio);
> 
> We need to unlock the folio here, right?

On the error return?  Yes.

