Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8434322BD0
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 08:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbfETGFb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 02:05:31 -0400
Received: from verein.lst.de ([213.95.11.211]:49850 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727130AbfETGFb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 02:05:31 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 6211868CF0; Mon, 20 May 2019 08:05:10 +0200 (CEST)
Date:   Mon, 20 May 2019 08:05:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/20] xfs: stop using XFS_LI_ABORTED as a parameter
 flag
Message-ID: <20190520060509.GD31977@lst.de>
References: <20190517073119.30178-1-hch@lst.de> <20190517073119.30178-3-hch@lst.de> <c1e91d64-f770-3c17-c70e-d8fe6826752f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1e91d64-f770-3c17-c70e-d8fe6826752f@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:10:49AM -0500, Eric Sandeen wrote:
> On 5/17/19 2:31 AM, Christoph Hellwig wrote:
> > Just pass a straight bool aborted instead of abusing XFS_LI_ABORTED as a
> > flag in function parameters.
> 
> ...
> 
> >  out_abort:
> > -	xlog_cil_committed(ctx, XFS_LI_ABORTED);
> > +	xlog_cil_committed(ctx, true);
> >  	return -EIO;
> 
> Technically fine but I'm kind of on the fence about changes like this;
> doesn't it make the code less readable?  Passing a self-documenting
> flag makes code reading a lot easier than seeing "true" and having
> to cross-reference what the bool means.  What's your thought on how this
> helps?  Is it worth keeping things like this more self-documenting?

I hate this one because it passes a flag that is used for something
entirely different and then actually interpreted as an int in boolean
context later on.  Switching to a proper bool seems like the simplest
cleanup, but we could also add a different self describing flag if
it bothers you.  But it doesn't really seem like we'd ever grow another
flag here.
