Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E8B1D667C
	for <lists+linux-xfs@lfdr.de>; Sun, 17 May 2020 09:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgEQH6M (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 17 May 2020 03:58:12 -0400
Received: from verein.lst.de ([213.95.11.211]:34277 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgEQH6M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 17 May 2020 03:58:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5165968C4E; Sun, 17 May 2020 09:58:10 +0200 (CEST)
Date:   Sun, 17 May 2020 09:58:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: refactor xfs_inode_verify_forks
Message-ID: <20200517075810.GB30453@lst.de>
References: <20200508063423.482370-1-hch@lst.de> <20200508063423.482370-10-hch@lst.de> <20200516174927.GY6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516174927.GY6714@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 16, 2020 at 10:49:27AM -0700, Darrick J. Wong wrote:
> > +int
> > +xfs_ifork_verify_local_data(
> >  	struct xfs_inode	*ip)
> >  {

> > +	if (fa) {
> > +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
> > +			ip->i_df.if_u1.if_data, ip->i_df.if_bytes, fa);
> 
> Needs more indent, but I could fix this on merge...

Sure.  It seems like that is the only outstanding comment on this series,
so maybe you should just pick it up and I shouldn't bother to resend it?
