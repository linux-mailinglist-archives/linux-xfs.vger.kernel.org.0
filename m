Return-Path: <linux-xfs+bounces-222-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F5D07FCE11
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 05:51:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CED9A2826B4
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 04:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90C7567F;
	Wed, 29 Nov 2023 04:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9Q2u2FT"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF031104;
	Wed, 29 Nov 2023 04:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1A1C433C7;
	Wed, 29 Nov 2023 04:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701233470;
	bh=LjCh7gGBt9JjgxBK17JxGFEQRIX3TuII2+v/BsvnbJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h9Q2u2FTdq4eiJ74Hz2n3FRTB8QMRJ/EJ8YNXN1fGYznCqWWT/nuVaX561HZ0ROHJ
	 86fwRkYZ6+T2RfwF0VUKbykCrLNG3O1ewF9zlABxrCg8Oq4iljAlNV5s76LuGbEwyT
	 9HNWZ+p3TalIClQ+6GzmmOuIiVKHCdKtc4B6FKtRppH31D9Jzc4T+krF/4gqnKzqEV
	 +Vtj9fW4DbwTkkF6Tk/y6TiFPC/WLuEUs7TAm1TztoA7YOyLsRerwljhRxtFDlKx2Q
	 7HcbANDDVnWwwxgRBT57HPAWKNijzs/e5F2DRk5Cj7Y6uokiI59948TaKIk8w4fOPl
	 6AyiLziE0sROA==
Date: Tue, 28 Nov 2023 20:51:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/13] iomap: clean up the iomap_new_ioend calling
 convention
Message-ID: <20231129045109.GM4167244@frogsfrogsfrogs>
References: <20231126124720.1249310-8-hch@lst.de>
 <87ttp7r68u.fsf@doe.com>
 <20231127081343.GA30160@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127081343.GA30160@lst.de>

On Mon, Nov 27, 2023 at 09:13:43AM +0100, Christoph Hellwig wrote:
> On Mon, Nov 27, 2023 at 01:13:29PM +0530, Ritesh Harjani wrote:
> > Christoph Hellwig <hch@lst.de> writes:
> > 
> > > Switch to the same argument order as iomap_writepage_map and remove the
> > > ifs argument that can be trivially recalculated.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/iomap/buffered-io.c | 11 +++++------
> > >  1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> > Straight forward change. Looks good to me. Please feel free to add - 
> 
> Also the subject should be changed now that I'm reading your reply.
> I dropped the rename of this function that I had in earlier versions.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


