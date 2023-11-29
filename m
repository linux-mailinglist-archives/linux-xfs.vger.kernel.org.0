Return-Path: <linux-xfs+bounces-230-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 663867FCE5C
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 06:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9797F1C20A59
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 05:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 235096FCB;
	Wed, 29 Nov 2023 05:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043E119B1;
	Tue, 28 Nov 2023 21:39:51 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id A430868AA6; Wed, 29 Nov 2023 06:39:48 +0100 (CET)
Date: Wed, 29 Nov 2023 06:39:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Ritesh Harjani <ritesh.list@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/13] iomap: treat inline data in iomap_writepage_map
 as an I/O error
Message-ID: <20231129053948.GB1385@lst.de>
References: <20231126124720.1249310-3-hch@lst.de> <87bkbfssb8.fsf@doe.com> <20231127063325.GB27241@lst.de> <20231129044057.GH4167244@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129044057.GH4167244@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 28, 2023 at 08:40:57PM -0800, Darrick J. Wong wrote:
> > I think they way it currently works for gfs2 is that writeback from the
> > page cache never goes back into the inline area.  
> > 
> > If we ever have a need to actually write back inline data we could
> > change this code to support it, but right now I just want to make the
> > assert more consistent.
> 
> Question: Do we even /want/ writeback to be initiating transactions
> to log the inline data?  I suppose for ext4/jbd2 that would be the least
> inefficient time to do that.

I think in general not, but it really depends on the file system
architecture.  In other words:  don't touch the current behavior unless
we have a good reason.  I just want to make the error check a little
saner..

