Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9F5162949
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Feb 2020 16:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgBRPT3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Feb 2020 10:19:29 -0500
Received: from verein.lst.de ([213.95.11.211]:38696 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgBRPT3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Feb 2020 10:19:29 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5524768BE1; Tue, 18 Feb 2020 16:19:27 +0100 (CET)
Date:   Tue, 18 Feb 2020 16:19:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/31] xfs: remove the ATTR_INCOMPLETE flag
Message-ID: <20200218151927.GA21275@lst.de>
References: <20200217125957.263434-1-hch@lst.de> <20200217125957.263434-3-hch@lst.de> <20200217215124.GG10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217215124.GG10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 08:51:24AM +1100, Dave Chinner wrote:
> >  		if ((entry->flags & XFS_ATTR_INCOMPLETE) &&
> > -		    !(context->flags & ATTR_INCOMPLETE))
> > +		    !context->allow_incomplete)
> >  			continue;		/* skip incomplete entries */
> 
> While touching this code, can you fix the trailing comment here to
> be a normal one before the if() statement, or remove it because it's
> largely redundant?

Yes, the comment is rather pointless so I'll remove it.
