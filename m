Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B9DF2916
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2019 09:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfKGI3u (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Nov 2019 03:29:50 -0500
Received: from verein.lst.de ([213.95.11.211]:55720 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbfKGI3u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Nov 2019 03:29:50 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3899C68B05; Thu,  7 Nov 2019 09:29:48 +0100 (CET)
Date:   Thu, 7 Nov 2019 09:29:48 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/34] xfs: devirtualize ->sf_get_ino and ->sf_put_ino
Message-ID: <20191107082948.GA9802@lst.de>
References: <20191101220719.29100-1-hch@lst.de> <20191101220719.29100-22-hch@lst.de> <20191104203334.GW4153244@magnolia> <20191107010555.GT4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107010555.GT4153244@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 05:05:55PM -0800, Darrick J. Wong wrote:
> > > +}
> > > +
> > > +void
> > > +xfs_dir2_sf_put_ino(
> 
> Also, I think these helpers can be static now...

xfs_dir2_sf_put_ino can and should be marked static.  xfs_dir2_sf_get_ino
is used elsewhere, though.
