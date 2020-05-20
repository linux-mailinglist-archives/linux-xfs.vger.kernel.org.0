Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BC81DAADF
	for <lists+linux-xfs@lfdr.de>; Wed, 20 May 2020 08:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgETGnQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 May 2020 02:43:16 -0400
Received: from verein.lst.de ([213.95.11.211]:47959 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETGnO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 02:43:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EAF2168B02; Wed, 20 May 2020 08:43:12 +0200 (CEST)
Date:   Wed, 20 May 2020 08:43:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 09/11] xfs: use bool for done in xfs_inode_ag_walk
Message-ID: <20200520064312.GI2742@lst.de>
References: <158993911808.976105.13679179790848338795.stgit@magnolia> <158993917464.976105.8225510964854349068.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993917464.976105.8225510964854349068.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 06:46:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This is a boolean variable, so use the bool type.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
