Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA601DE007
	for <lists+linux-xfs@lfdr.de>; Fri, 22 May 2020 08:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgEVGh0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 22 May 2020 02:37:26 -0400
Received: from verein.lst.de ([213.95.11.211]:57894 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728012AbgEVGh0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 May 2020 02:37:26 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 614AC68C4E; Fri, 22 May 2020 08:37:24 +0200 (CEST)
Date:   Fri, 22 May 2020 08:37:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/12] xfs: remove flags argument from xfs_inode_ag_walk
Message-ID: <20200522063724.GA2445@lst.de>
References: <159011600616.77079.14748275956667624732.stgit@magnolia> <159011603978.77079.10531037194098683108.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011603978.77079.10531037194098683108.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:53:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The incore inode walk code passes a flags argument and a pointer from
> the xfs_inode_ag_iterator caller all the way to the iteration function.
> We can reduce the function complexity by passing flags through the
> private pointer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
