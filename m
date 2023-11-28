Return-Path: <linux-xfs+bounces-157-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB8B7FB141
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 06:32:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A459C281D5D
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 05:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D86B10792;
	Tue, 28 Nov 2023 05:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1F11B8
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:32:21 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3440567373; Tue, 28 Nov 2023 06:32:19 +0100 (CET)
Date: Tue, 28 Nov 2023 06:32:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: clean up the xfs_reserve_blocks interface
Message-ID: <20231128053219.GB16579@lst.de>
References: <20231126130124.1251467-1-hch@lst.de> <20231126130124.1251467-4-hch@lst.de> <20231128020933.GS2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128020933.GS2766956@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 27, 2023 at 06:09:33PM -0800, Darrick J. Wong wrote:
> > +	spin_lock(&mp->m_sb_lock);
> > +	fsop.resblks = mp->m_resblks;
> > +	fsop.resblks_avail = mp->m_resblks_avail;
> > +	spin_unlock(&mp->m_sb_lock);
> 
> Hm.  I sorta preferred keeping these details hidden in xfs_fsops.c
> rather than scattering them around and lengthening xfs_ioctl.c, but
> I think the calling convention cleanup is worthy enough for:

If you prefer I can keep a helper to fill in a xfs_fsop_resblks
structure under m_sb_lock in fsops.c, but I'm not sure that's worth it.


