Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9046133BFC
	for <lists+linux-xfs@lfdr.de>; Wed,  8 Jan 2020 08:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgAHHEj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 Jan 2020 02:04:39 -0500
Received: from verein.lst.de ([213.95.11.211]:47767 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgAHHEi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Jan 2020 02:04:38 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2989168C65; Wed,  8 Jan 2020 08:04:36 +0100 (CET)
Date:   Wed, 8 Jan 2020 08:04:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: attr fixes
Message-ID: <20200108070435.GA2973@lst.de>
References: <20200107165442.262020-1-hch@lst.de> <20200107232346.GH917713@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107232346.GH917713@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 03:23:46PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 07, 2020 at 05:54:38PM +0100, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series contains a bunch of fixes for nasty bugs in the attr interface.
> 
> Hm, do you want to throw in the ATTR_INCOMPLETE killing patch (#5 in the
> old series) too?

That isn't really an urgent fix.  With the kernel-only flags clearing
it can't cause any harm.
