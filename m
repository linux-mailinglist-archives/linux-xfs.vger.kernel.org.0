Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D49012A0EE
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Dec 2019 12:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfLXL4T (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Dec 2019 06:56:19 -0500
Received: from verein.lst.de ([213.95.11.211]:59140 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbfLXL4T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Dec 2019 06:56:19 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B131368B20; Tue, 24 Dec 2019 12:56:16 +0100 (CET)
Date:   Tue, 24 Dec 2019 12:56:16 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 01/33] xfs: clear kernel only flags in
 XFS_IOC_ATTRMULTI_BY_HANDLE
Message-ID: <20191224115616.GA30689@lst.de>
References: <20191212105433.1692-1-hch@lst.de> <20191212105433.1692-2-hch@lst.de> <20191218212608.GD7489@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218212608.GD7489@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 01:26:08PM -0800, Darrick J. Wong wrote:
> >  	for (i = 0; i < am_hreq.opcount; i++) {
> > +		ops[i].am_flags &= ATTR_KERNEL_FLAGS;
> 
> The only flags we allow from userspace are the internal state flags?
> Is this supposed to be am_flags &= ~ATTR_KERNEL_FLAGS?

Yes.  I switched back a few times between enumerating kernel only or
user flags and finally settled on this one.  The sad part is that a full
xfstests run didn't catch this.  In fact xfsprogs or xfstests seem to
have no direct calls to XFS_IOC_ATTRMULTI_BY_HANDLE and its two wrappers
in libhandle.  xfsdump does, but probably not in a way that is exercises.
