Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B2EE82C2
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Oct 2019 08:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfJ2HuR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Oct 2019 03:50:17 -0400
Received: from verein.lst.de ([213.95.11.211]:38600 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfJ2HuQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Oct 2019 03:50:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5AC9E68AFE; Tue, 29 Oct 2019 08:50:15 +0100 (CET)
Date:   Tue, 29 Oct 2019 08:50:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 08/12] xfs: rename the XFS_MOUNT_DFLT_IOSIZE option to
 XFS_MOUNT_ALLOCISZE
Message-ID: <20191029075015.GB18999@lst.de>
References: <20191027145547.25157-1-hch@lst.de> <20191027145547.25157-9-hch@lst.de> <20191028171236.GQ15222@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028171236.GQ15222@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 10:12:36AM -0700, Darrick J. Wong wrote:
> s/ALLOCISZE/ALLOCSIZE/ in the subject
> 
> On Sun, Oct 27, 2019 at 03:55:43PM +0100, Christoph Hellwig wrote:
> > Make the flag match the mount option and usage.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> With that fixed,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Feel free to fix up when applying the patch :)
