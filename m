Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D9B3167E6
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Feb 2021 14:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhBJNVx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Feb 2021 08:21:53 -0500
Received: from verein.lst.de ([213.95.11.211]:51102 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229806AbhBJNVj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Feb 2021 08:21:39 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id F2D596736F; Wed, 10 Feb 2021 14:20:55 +0100 (CET)
Date:   Wed, 10 Feb 2021 14:20:55 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        darrick.wong@oracle.com, dan.j.williams@intel.com,
        david@fromorbit.com, hch@lst.de, agk@redhat.com,
        snitzer@redhat.com, rgoldwyn@suse.de, qi.fuli@fujitsu.com,
        y-goto@fujitsu.com
Subject: Re: [PATCH v3 01/11] pagemap: Introduce ->memory_failure()
Message-ID: <20210210132055.GB30109@lst.de>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com> <20210208105530.3072869-2-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208105530.3072869-2-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 06:55:20PM +0800, Shiyang Ruan wrote:
> When memory-failure occurs, we call this function which is implemented
> by each kind of devices.  For the fsdax case, pmem device driver
> implements it.  Pmem device driver will find out the block device where
> the error page locates in, and try to get the filesystem on this block
> device.  And finally call filesystem handler to deal with the error.
> The filesystem will try to recover the corrupted data if possiable.

I'm not sure adding just a method without any of the support code
is a useful patch on its own.
