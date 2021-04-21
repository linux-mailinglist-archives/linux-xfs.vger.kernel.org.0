Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F716366514
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Apr 2021 07:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhDUF4R (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 21 Apr 2021 01:56:17 -0400
Received: from verein.lst.de ([213.95.11.211]:53000 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230343AbhDUF4R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 01:56:17 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6C83468C4E; Wed, 21 Apr 2021 07:55:42 +0200 (CEST)
Date:   Wed, 21 Apr 2021 07:55:41 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH 2/7] xfs: clean up the EFI and EFD log format handling
Message-ID: <20210421055541.GA28961@lst.de>
References: <20210419082804.2076124-1-hch@lst.de> <20210419082804.2076124-3-hch@lst.de> <20210420170529.GH3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420170529.GH3122264@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 20, 2021 at 10:05:29AM -0700, Darrick J. Wong wrote:
> Hmm... so the behavior change here is that 32-bit kernels will start
> logging 16-byte xfs_extent structures (like 64-bit kernels)?

Yes.

> I see that
> xfs_extent_32 was added for 2.6.18; won't this break recovery on
> everything from before that?

Where everything is a 32-bit kernel that doesn't align properly, yes.

> Granted, 2.6.17 came out 15 years ago and the last 2.6.16 LTS kernel was
> released in 2008 so maybe we don't care, but this would seem to be a
> breaking change, right?  This seems like a reasonable change for all V5
> filesystems (since that format emerged well after 2.6.18), but not so
> good for V4.

Err, why?
