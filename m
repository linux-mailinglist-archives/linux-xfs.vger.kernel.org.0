Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FDD1CC787
	for <lists+linux-xfs@lfdr.de>; Sun, 10 May 2020 09:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgEJHLG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 10 May 2020 03:11:06 -0400
Received: from verein.lst.de ([213.95.11.211]:59173 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgEJHLG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 10 May 2020 03:11:06 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7573C68C7B; Sun, 10 May 2020 09:11:04 +0200 (CEST)
Date:   Sun, 10 May 2020 09:11:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] db: cleanup attr_set_f and attr_remove_f
Message-ID: <20200510071104.GA17094@lst.de>
References: <20200509170125.952508-1-hch@lst.de> <20200509170125.952508-5-hch@lst.de> <e7c3ed39-d007-8d9c-d718-ed5c60f92225@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7c3ed39-d007-8d9c-d718-ed5c60f92225@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 12:23:42PM -0500, Eric Sandeen wrote:
> On 5/9/20 12:01 PM, Christoph Hellwig wrote:
> > Don't use local variables for information that is set in the da_args
> > structure.
> 
> I'm on the fence about this one; Darrick had missed setting a couple
> of necessary structure members, so I actually see some value in assigning them
> all right before we call into libxfs_attr_set .... it makes it very clear what's
> being sent in to libxfs_attr_set.

But using additional local variables doesn't help with initialing
the fields, it actually makes it easier to miss, which I guess is
what happened.  I find the code much easier to verify without the
extra variables.
