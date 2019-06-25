Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D48528E3
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfFYKB3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:01:29 -0400
Received: from verein.lst.de ([213.95.11.211]:33341 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfFYKB2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 06:01:28 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 0265668C65; Tue, 25 Jun 2019 12:00:58 +0200 (CEST)
Date:   Tue, 25 Jun 2019 12:00:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: [PATCH 2/2] xfs: implement cgroup aware writeback
Message-ID: <20190625100057.GD1462@lst.de>
References: <20190624134315.21307-1-hch@lst.de> <20190624134315.21307-3-hch@lst.de> <20190624162215.GS5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624162215.GS5387@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 09:22:15AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 03:43:15PM +0200, Christoph Hellwig wrote:
> > Link every newly allocated writeback bio to cgroup pointed to by the
> > writeback control structure, and charge every byte written back to it.
> > 
> > Tested-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
> 
> Was this tested by running shared/011?  Or did it involve other checks?

I verified it with shared/011 and local frobbing.  Stefan can chime
in on what testing he did.
