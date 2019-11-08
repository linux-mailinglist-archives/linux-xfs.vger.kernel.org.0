Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3864CF40C6
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2019 07:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfKHGue (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Nov 2019 01:50:34 -0500
Received: from verein.lst.de ([213.95.11.211]:33141 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbfKHGue (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 01:50:34 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id AB16968BE1; Fri,  8 Nov 2019 07:50:32 +0100 (CET)
Date:   Fri, 8 Nov 2019 07:50:32 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove XFS_IOC_FSSETDM and
 XFS_IOC_FSSETDM_BY_HANDLE
Message-ID: <20191108065032.GA30861@lst.de>
References: <20191108052303.15052-1-hch@lst.de> <20191108064801.GM6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108064801.GM6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 10:48:01PM -0800, Darrick J. Wong wrote:
> On Fri, Nov 08, 2019 at 06:23:03AM +0100, Christoph Hellwig wrote:
> > Thes ioctls set DMAPI specific flags in the on-disk inode, but there is
> > no way to actually ever query those flags.  The only known user is
> > xfsrestore with the -D option, which is documented to be only useful
> > inside a DMAPI enviroment, which isn't supported by upstream XFS.
> 
> Hmm, shouldn't we deprecate this at least for one or two releases?
> 
> Even if it's functionally pointless...

It sets a value we can't even retreive.  Not sure what the deprecation
would help with.
