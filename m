Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC4A1D9032
	for <lists+linux-xfs@lfdr.de>; Tue, 19 May 2020 08:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgESGkU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 May 2020 02:40:20 -0400
Received: from verein.lst.de ([213.95.11.211]:42595 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbgESGkU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 May 2020 02:40:20 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9D45C68B02; Tue, 19 May 2020 08:40:17 +0200 (CEST)
Date:   Tue, 19 May 2020 08:40:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: inode iterator cleanups
Message-ID: <20200519064017.GA24876@lst.de>
References: <20200518170437.1218883-1-hch@lst.de> <20200519012337.GE17635@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519012337.GE17635@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 06:23:37PM -0700, Darrick J. Wong wrote:
> On Mon, May 18, 2020 at 07:04:31PM +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series cleans up a bunch of lose ends in the inode iterator
> > functions.
> 
> Funny, I was going to send a series next cycle that refactors a fair
> amount of the incore inode iterators and then collapses the
> free_cowblocks/free_eofblocks code into a single worker and radix tree
> tag that takes care of all the speculative preallocation extent gc
> stuff...
> 
> incore walks:
> https://lore.kernel.org/linux-xfs/157784075463.1360343.1278255546758019580.stgit@magnolia/

Except for the last few those seem non-brainers tat would could merge
ASAP..

The rest also doesn't look bad, so I'll happily defer this series.
OTOH the first on really should go in, either your or my version :)
