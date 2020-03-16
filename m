Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5400186DC1
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Mar 2020 15:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgCPOrl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Mar 2020 10:47:41 -0400
Received: from verein.lst.de ([213.95.11.211]:54747 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731445AbgCPOrl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Mar 2020 10:47:41 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 126CC68BFE; Mon, 16 Mar 2020 15:47:39 +0100 (CET)
Date:   Mon, 16 Mar 2020 15:47:38 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: add a new xfs_sb_version_has_large_dinode
 helper
Message-ID: <20200316144738.GA19966@lst.de>
References: <20200312142235.550766-1-hch@lst.de> <20200312142235.550766-2-hch@lst.de> <20200316131649.GE12313@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316131649.GE12313@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 09:16:49AM -0400, Brian Foster wrote:
> A comment would be useful here to indicate what this means (i.e., we can
> assume v3 inode format).

Sure.

> The function name is a little vague too I
> suppose (will the inode ever get larger than large? :P). I wonder if
> something like _has_v3_inode() is more clear, but we can always change
> it easily enough and either way is better than hascrc() IMO.

I'm not too fond of the v3 name as the check also guards any newer
version (but then again I hope we never need to rev the version..)
