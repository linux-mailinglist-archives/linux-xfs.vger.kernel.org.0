Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E0C1DE009
	for <lists+linux-xfs@lfdr.de>; Fri, 22 May 2020 08:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgEVGiv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 22 May 2020 02:38:51 -0400
Received: from verein.lst.de ([213.95.11.211]:57901 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgEVGiv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 May 2020 02:38:51 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9B03068C4E; Fri, 22 May 2020 08:38:49 +0200 (CEST)
Date:   Fri, 22 May 2020 08:38:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 11/12] xfs: straighten out all the naming around incore
 inode tree walks
Message-ID: <20200522063849.GC2445@lst.de>
References: <159011600616.77079.14748275956667624732.stgit@magnolia> <159011607872.77079.14383762107157416126.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011607872.77079.14383762107157416126.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:54:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We're not very consistent about function names for the incore inode
> iteration function.  Turn them all into xfs_inode_walk* variants.

Looks ok, not that I had an issue with the previous names..

Reviewed-by: Christoph Hellwig <hch@lst.de>
