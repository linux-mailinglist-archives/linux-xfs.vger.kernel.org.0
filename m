Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CDF1CC31B
	for <lists+linux-xfs@lfdr.de>; Sat,  9 May 2020 19:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgEIRMu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 9 May 2020 13:12:50 -0400
Received: from verein.lst.de ([213.95.11.211]:57527 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgEIRMu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 9 May 2020 13:12:50 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D403E68C7B; Sat,  9 May 2020 19:12:47 +0200 (CEST)
Date:   Sat, 9 May 2020 19:12:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] db: validate name and namelen in attr_set_f and
 attr_remove_f
Message-ID: <20200509171247.GA31924@lst.de>
References: <20200509170125.952508-1-hch@lst.de> <20200509170125.952508-6-hch@lst.de> <20200509170909.GS6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509170909.GS6714@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 10:09:09AM -0700, Darrick J. Wong wrote:
> On Sat, May 09, 2020 at 07:01:22PM +0200, Christoph Hellwig wrote:
> > libxfs has stopped validating these parameters internally, so do it
> > in the xfs_db commands.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> IIRC the VFS checks these parameters so that libxfs doesn't have to,
> right?

Yes.  But we don't have the VFS in xfsprogs :)
