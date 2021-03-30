Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6774134EF8F
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Mar 2021 19:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhC3Rdh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Mar 2021 13:33:37 -0400
Received: from verein.lst.de ([213.95.11.211]:59944 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231794AbhC3Rdb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 13:33:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E782168B05; Tue, 30 Mar 2021 19:33:29 +0200 (CEST)
Date:   Tue, 30 Mar 2021 19:33:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/20] xfs: remove the di_dmevmask and di_dmstate
 fields from struct xfs_icdinode
Message-ID: <20210330173329.GB14827@lst.de>
References: <20210329053829.1851318-1-hch@lst.de> <20210329053829.1851318-6-hch@lst.de> <20210330152811.GQ4090233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330152811.GQ4090233@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 08:28:11AM -0700, Darrick J. Wong wrote:
> Do you want to put dmevmask/dmstate preservation on the deprecated list
> too, seeing as the only (out of tree) user wrote in on the last
> submission to say that they're not supporting it past 2022 and have
> never supported mounting those XFSes with upstream kernels?
> 
> Granted, the difficulty there is how do you deprecate something that
> isn't there? 8)

Yeah.  I'm not sure what to really do about this.  In practice I
suspect v5 file systems with these flags simply do not exist.  The
cost to maintain the flag is pretty low, so I'm not sure the
deprecation is that important.  I'd rather just reuse the flags
next time we add a new incompat feature that needs them, at which
point we have our normal feature mechanism take care of it.
