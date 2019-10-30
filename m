Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 722E9EA2D7
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Oct 2019 18:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfJ3R4P (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Oct 2019 13:56:15 -0400
Received: from verein.lst.de ([213.95.11.211]:47034 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbfJ3R4P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Oct 2019 13:56:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2CE7568C7B; Wed, 30 Oct 2019 18:56:14 +0100 (CET)
Date:   Wed, 30 Oct 2019 18:56:14 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: don't log the inode in xfs_fs_map_blocks if
 it wasn't modified
Message-ID: <20191030175614.GA19244@lst.de>
References: <20191025150336.19411-1-hch@lst.de> <20191025150336.19411-5-hch@lst.de> <20191028161245.GD15222@magnolia> <20191029075843.GD18999@lst.de> <20191030161248.GI15222@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030161248.GI15222@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 09:12:48AM -0700, Darrick J. Wong wrote:
> > Actually even for !write we should not see delalloc blocks here.
> > So I'll fix up the assert in a separate prep patch.
> 
> <shrug> I could just fix it, unless you're about to resend the whole series?

I have the series ready to resend.
