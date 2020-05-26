Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E211DE00A
	for <lists+linux-xfs@lfdr.de>; Fri, 22 May 2020 08:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgEVGj0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 22 May 2020 02:39:26 -0400
Received: from verein.lst.de ([213.95.11.211]:57903 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgEVGj0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 May 2020 02:39:26 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AFB2068C4E; Fri, 22 May 2020 08:39:24 +0200 (CEST)
Date:   Fri, 22 May 2020 08:39:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 12/12] xfs: rearrange xfs_inode_walk_ag parameters
Message-ID: <20200522063924.GD2445@lst.de>
References: <159011600616.77079.14748275956667624732.stgit@magnolia> <159011608512.77079.1442881398167792783.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011608512.77079.1442881398167792783.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:54:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The perag structure already has a pointer to the xfs_mount, so we don't
> need to pass that separately and can drop it.  Having done that, move
> iter_flags so that the argument order is the same between xfs_inode_walk
> and xfs_inode_walk_ag.  The latter will make things less confusing for a
> future patch that enables background scanning work to be done in
> parallel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
