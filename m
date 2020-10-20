Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3647B2845FA
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Oct 2020 08:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgJFG02 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Oct 2020 02:26:28 -0400
Received: from verein.lst.de ([213.95.11.211]:33170 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgJFG02 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Oct 2020 02:26:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7A2956736F; Tue,  6 Oct 2020 08:26:26 +0200 (CEST)
Date:   Tue, 6 Oct 2020 08:26:26 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, chandanrlinux@gmail.com
Subject: Re: [PATCH 2/2] xfs: fix deadlock and streamline xfs_getfsmap
 performance
Message-ID: <20201006062626.GC7033@lst.de>
References: <160192208358.2569942.13189278742183856412.stgit@magnolia> <160192209677.2569942.16673759463630442919.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160192209677.2569942.16673759463630442919.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 05, 2020 at 11:21:36AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_getfsmap to improve its performance: instead of indirectly
> calling a function that copies one record to userspace at a time, create
> a shadow buffer in the kernel and copy the whole array once at the end.
> On the author's computer, this reduces the runtime on his /home by ~20%.
> 
> This also eliminates a deadlock when running GETFSMAP against the
> realtime device.  The current code locks the rtbitmap to create
> fsmappings and copies them into userspace, having not released the
> rtbitmap lock.  If the userspace buffer is an mmap of a sparse file that
> itself resides on the realtime device, the write page fault will recurse
> into the fs for allocation, which will deadlock on the rtbitmap lock.
> 
> Fixes: 4c934c7dd60c ("xfs: report realtime space information via the rtbitmap")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
