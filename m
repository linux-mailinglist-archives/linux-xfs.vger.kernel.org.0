Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA851DAAAF
	for <lists+linux-xfs@lfdr.de>; Wed, 20 May 2020 08:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgETGij (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 May 2020 02:38:39 -0400
Received: from verein.lst.de ([213.95.11.211]:47916 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgETGij (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 02:38:39 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7EF0B68B02; Wed, 20 May 2020 08:38:37 +0200 (CEST)
Date:   Wed, 20 May 2020 08:38:37 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 06/11] xfs: remove __xfs_icache_free_eofblocks
Message-ID: <20200520063837.GF2742@lst.de>
References: <158993911808.976105.13679179790848338795.stgit@magnolia> <158993915584.976105.10618142991104642219.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993915584.976105.10618142991104642219.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 06:45:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This is now a pointless wrapper, so kill it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
