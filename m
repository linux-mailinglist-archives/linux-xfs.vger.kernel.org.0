Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89F2528DC
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731775AbfFYKAp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:00:45 -0400
Received: from verein.lst.de ([213.95.11.211]:33322 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfFYKAp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 06:00:45 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 94B3268B05; Tue, 25 Jun 2019 12:00:14 +0200 (CEST)
Date:   Tue, 25 Jun 2019 12:00:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: [PATCH 1/2] xfs: simplify xfs_chain_bio
Message-ID: <20190625100014.GC1462@lst.de>
References: <20190624134315.21307-1-hch@lst.de> <20190624134315.21307-2-hch@lst.de> <20190624161750.GR5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624161750.GR5387@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 09:17:50AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 03:43:14PM +0200, Christoph Hellwig wrote:
> > Move setting up operation and write hint to xfs_alloc_ioend, and
> > then just copy over all needed information from the previous bio
> > in xfs_chain_bio and stop passing various parameters to it.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Uh, is this the same patch with the same name in the previous series?

Yes.  See the cover letter for details.
