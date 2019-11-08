Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D2FF4013
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2019 06:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfKHFnp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Nov 2019 00:43:45 -0500
Received: from verein.lst.de ([213.95.11.211]:32985 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfKHFnp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 00:43:45 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 79A6A68BE1; Fri,  8 Nov 2019 06:43:43 +0100 (CET)
Date:   Fri, 8 Nov 2019 06:43:43 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/46] xfs: cleanup xfs_dir2_data_entsize
Message-ID: <20191108054343.GB29959@lst.de>
References: <20191107182410.12660-1-hch@lst.de> <20191107182410.12660-42-hch@lst.de> <20191108010558.GI6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108010558.GI6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 05:05:58PM -0800, Darrick J. Wong wrote:
> > +static inline int
> > +xfs_dir2_data_entsize(
> > +	struct xfs_mount	*mp,
> > +	int			namelen)
> 
> Why not unsigned int here?  Neither names nor entries can have negative
> length.  Other than that, looks fine...

Ok, updated.
