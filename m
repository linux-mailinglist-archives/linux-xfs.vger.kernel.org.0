Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBEC348C1F
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Mar 2021 10:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhCYJBj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Mar 2021 05:01:39 -0400
Received: from verein.lst.de ([213.95.11.211]:40245 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhCYJBP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 05:01:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CA7B668BEB; Thu, 25 Mar 2021 10:01:12 +0100 (CET)
Date:   Thu, 25 Mar 2021 10:01:11 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/18] xfs: use a union for i_cowextsize and i_flushiter
Message-ID: <20210325090111.GA29134@lst.de>
References: <20210324142129.1011766-1-hch@lst.de> <20210324142129.1011766-14-hch@lst.de> <20210325030628.GA4090233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325030628.GA4090233@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 08:06:28PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 24, 2021 at 03:21:24PM +0100, Christoph Hellwig wrote:
> > The i_cowextsize field is only used for v3 inodes, and the i_flushiter
> > field is only used for v1/v2 inodes.  Use a union to pack the inode a
> > littler better after adding a few missing guards around their usage.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Hmm, so this patch caused a regression on V4 filesystems xfs/051.  It
> looks like the flush iter gets set to zero and then log recovery forgets
> to replay the inode(?)
> 
> The following patch fixes it for me, FWIW...

Indeed.  I've folded something similar in.
