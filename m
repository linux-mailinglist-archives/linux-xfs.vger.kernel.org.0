Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B8A1C1B3C
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 19:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgEARIq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 13:08:46 -0400
Received: from verein.lst.de ([213.95.11.211]:47863 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbgEARIq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 May 2020 13:08:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 799F268C65; Fri,  1 May 2020 19:08:44 +0200 (CEST)
Date:   Fri, 1 May 2020 19:08:44 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: refactor xfs_inode_verify_forks
Message-ID: <20200501170843.GA21405@lst.de>
References: <20200501081424.2598914-1-hch@lst.de> <20200501081424.2598914-10-hch@lst.de> <20200501155724.GP40250@bfoster> <20200501164009.GB18426@lst.de> <20200501170227.GS40250@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501170227.GS40250@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 01:02:27PM -0400, Brian Foster wrote:
> The associated code replaced in this patch checks the attr fork pointer:
> 
> -               ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
> -               xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> -                               ifp ? ifp->if_u1.if_data : NULL,
> -                               ifp ? ifp->if_bytes : 0, fa);

Oh, true.  I'll fix this up to keep bisectability.
