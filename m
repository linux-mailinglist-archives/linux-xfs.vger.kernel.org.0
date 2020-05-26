Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CC01D8132
	for <lists+linux-xfs@lfdr.de>; Mon, 18 May 2020 19:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgERRpp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 18 May 2020 13:45:45 -0400
Received: from verein.lst.de ([213.95.11.211]:39584 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729961AbgERRpo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 May 2020 13:45:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A06E068B02; Mon, 18 May 2020 19:45:41 +0200 (CEST)
Date:   Mon, 18 May 2020 19:45:41 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: dinode reading cleanups v2
Message-ID: <20200518174541.GA21023@lst.de>
References: <20200508063423.482370-1-hch@lst.de> <20200518064859.GA19510@lst.de> <20200518173622.GE17627@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518173622.GE17627@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 10:36:22AM -0700, Darrick J. Wong wrote:
> On Mon, May 18, 2020 at 08:48:59AM +0200, Christoph Hellwig wrote:
> > As there were some conflicts due to the code moves for the log
> > refactoring I've pushed out a new v3 branch here:
> > 
> >     git://git.infradead.org/users/hch/xfs.git xfs-inode-read-cleanup.3
> > 
> > Gitweb:
> > 
> >     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-inode-read-cleanup.3
> > 
> > The only other change is extra indentation for the local fork verifiers.
> > I don't think it is worth reposting for that, unless you want me to.
> 
> I already pulled in the v2 series (with the indentation changes); are
> there any additional changes in v3?  I didn't see any changes diffing
> your branch to mine, so I think everything is fine.

As said - just the indent change, and resolving the conflicts vs
the log recovery refactor.
