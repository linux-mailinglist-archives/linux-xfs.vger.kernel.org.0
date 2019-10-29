Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E63E7FF7
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Oct 2019 06:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731874AbfJ2F4J (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Oct 2019 01:56:09 -0400
Received: from verein.lst.de ([213.95.11.211]:38036 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731519AbfJ2F4J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Oct 2019 01:56:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C273A68AFE; Tue, 29 Oct 2019 06:56:05 +0100 (CET)
Date:   Tue, 29 Oct 2019 06:56:05 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: build failure after merge of the xfs tree
Message-ID: <20191029055605.GA16630@lst.de>
References: <20191029101151.54807d2f@canb.auug.org.au> <20191028231806.GA15222@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028231806.GA15222@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 04:18:06PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 29, 2019 at 10:11:51AM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the xfs tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> 
> <groan> Yeah, that's the same thing reported by the kbuild robot an hour
> ago.  FWIW I pushed a fixed branch but I guess it's too late for today,
> oh well....
> 
> ...the root cause of course was the stray '}' in one of the commits,
> that I didn't catch because compat ioctls are hard. :(

Weird.  My usual builds have compat ioclts enabled, and I never got
any report like this.
