Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE8D1DAAAB
	for <lists+linux-xfs@lfdr.de>; Wed, 20 May 2020 08:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgETGfD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 May 2020 02:35:03 -0400
Received: from verein.lst.de ([213.95.11.211]:47908 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgETGfD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 02:35:03 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6A58A68B02; Wed, 20 May 2020 08:35:01 +0200 (CEST)
Date:   Wed, 20 May 2020 08:35:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/11] xfs: remove xfs_inode_ag_iterator_flags
Message-ID: <20200520063501.GD2742@lst.de>
References: <158993911808.976105.13679179790848338795.stgit@magnolia> <158993914319.976105.18105362179838631438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993914319.976105.18105362179838631438.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 06:45:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Combine xfs_inode_ag_iterator_flags and xfs_inode_ag_iterator_tag into a
> single wrapper function since there's only one caller of the _flags
> variant.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
