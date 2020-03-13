Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783651845CF
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Mar 2020 12:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgCMLSc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Mar 2020 07:18:32 -0400
Received: from verein.lst.de ([213.95.11.211]:42060 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgCMLSc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Mar 2020 07:18:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0ADEF68BFE; Fri, 13 Mar 2020 12:18:30 +0100 (CET)
Date:   Fri, 13 Mar 2020 12:18:29 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/5] xfs: remove the unused return value from
 xfs_log_unmount_write
Message-ID: <20200313111829.GA8475@lst.de>
References: <20200312143959.583781-1-hch@lst.de> <20200312143959.583781-4-hch@lst.de> <20200312234916.GU8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312234916.GU8045@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 04:49:17PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 12, 2020 at 03:39:57PM +0100, Christoph Hellwig wrote:
> > Remove the ignored return value from xfs_log_unmount_write, and also
> > remove a rather pointless assert on the return value from xfs_log_force.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> AFAICT the lack of error returning is acceptable because the vfs doesn't
> care what failures we encounter while unmounting and xfs will log all of
> its complaints as it crashes out of the kernel?

Well, the only "errors" we get here are for the fact that the log has
been shut down.  Which aren't very helpful errors when you try to unmount
a file system..
