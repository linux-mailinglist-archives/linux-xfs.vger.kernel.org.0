Return-Path: <linux-xfs+bounces-450-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F4F80498B
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Dec 2023 06:56:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 239D02815C8
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Dec 2023 05:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8944FD2EC;
	Tue,  5 Dec 2023 05:56:48 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624B211F
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 21:56:45 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6C30F68B05; Tue,  5 Dec 2023 06:56:42 +0100 (CET)
Date: Tue, 5 Dec 2023 06:56:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: document what LARP means
Message-ID: <20231205055642.GA30465@lst.de>
References: <170175456196.3910588.9712198406317844529.stgit@frogsfrogsfrogs> <170175456779.3910588.8343836136719400292.stgit@frogsfrogsfrogs> <20231205053842.GA30199@lst.de> <20231205055028.GL361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205055028.GL361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 04, 2023 at 09:50:28PM -0800, Darrick J. Wong wrote:
> How about these last couple of sentences?
> 
> /*
>  * The "LARP" (Logged extended Attribute Recovery Persistence) debugging knob
>  * sets the XFS_DA_OP_LOGGED flag on all xfs_attr_set operations performed on
>  * V5 filesystems.  As a result, the intermediate progress of all setxattr and
>  * removexattr operations are tracked via the log and can be restarted during
>  * recovery.  This is useful for testing xattr recovery prior to merging of the
>  * parent pointer feature which requires it to maintain consistency, and may be
>  * enabled for userspace xattrs in the future.
>  */

Oooh.  So all the logged attrs work is preparation for parent pointers?
That makes a whole lot of sense, but I've missed it so far.  Yes, the
above comment is great.

With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>

