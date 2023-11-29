Return-Path: <linux-xfs+bounces-243-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 069D57FCEF0
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 07:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B44FB21696
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 06:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0DEDDB2;
	Wed, 29 Nov 2023 06:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95950B0
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 22:18:09 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2FA4568AA6; Wed, 29 Nov 2023 07:18:06 +0100 (CET)
Date: Wed, 29 Nov 2023 07:18:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: XBF_DONE semantics
Message-ID: <20231129061805.GA1987@lst.de>
References: <20231128153808.GA19360@lst.de> <ZWZW1bb+ih16tU+5@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWZW1bb+ih16tU+5@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 29, 2023 at 08:08:37AM +1100, Dave Chinner wrote:
> > But places that use buf_get and manually fill in data only use it in a
> > few cases. 
> 
> Yes. the caller of buf_get always needs to set XBF_DONE if it is
> initialising a new buffer ready for it to be written. It should be
> done before the caller drops the buffer lock so that no other lookup
> can see the buffer in the state of "contains valid data but does not
> have XBF_DONE set".

That makes sense, but we do have a whole bunch of weird things going
on as well:

 - xfs_buf_ioend_handle_error sets XBF_DONE when retrying or failing
 - xfs_buf_ioend sets XBF_DONE on successful write completion as well
 - xfs_buf_ioend_fail drops XBF_DONE for any I/O failure
 - xfs_do_force_shutdown sets XBF_DONE on the super block buffer on
   a foced shutdown
 - xfs_trans_get_buf_map sets XBF_DONE on a forced shutdown

So there's definitively a bunch of weird things not fully in line
with the straight forward answer.


