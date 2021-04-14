Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E8A35F7AB
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Apr 2021 17:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhDNP3w (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Apr 2021 11:29:52 -0400
Received: from verein.lst.de ([213.95.11.211]:59307 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352306AbhDNP3p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Apr 2021 11:29:45 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 410C868C7B; Wed, 14 Apr 2021 17:29:21 +0200 (CEST)
Date:   Wed, 14 Apr 2021 17:29:21 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove XFS_IFEXTENTS
Message-ID: <20210414152921.GA31516@lst.de>
References: <20210412133819.2618857-1-hch@lst.de> <20210412133819.2618857-8-hch@lst.de> <20210414003744.GU3957620@magnolia> <20210414055923.GA24575@lst.de> <20210414152718.GB3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414152718.GB3957620@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 14, 2021 at 08:27:18AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 14, 2021 at 07:59:23AM +0200, Christoph Hellwig wrote:
> > On Tue, Apr 13, 2021 at 05:37:44PM -0700, Darrick J. Wong wrote:
> > > <shrug> Seeing how we already had a go-round where Dave and stumbled
> > > over each other about the somewhat duplicative flags and format fields
> > > I'm inclined to take this sooner or later just to eliminate the
> > > ambiguity...
> > 
> > Do you want me to resend for the comment that Brian wants to see, or
> > do you want to just fold that in?
> 
> Hm?  I thought Brian was describing a comment that's already in
> xfs_btree_staging.c around line 195 as his reason for adding an RVB?

Oh, indeed.  I somehow misread his mail as asking to add this comment.
