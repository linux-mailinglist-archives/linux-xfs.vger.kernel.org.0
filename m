Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139D53167ED
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Feb 2021 14:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBJNWa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Feb 2021 08:22:30 -0500
Received: from verein.lst.de ([213.95.11.211]:51121 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhBJNWX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Feb 2021 08:22:23 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9C95C68B02; Wed, 10 Feb 2021 14:21:39 +0100 (CET)
Date:   Wed, 10 Feb 2021 14:21:39 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        darrick.wong@oracle.com, dan.j.williams@intel.com,
        david@fromorbit.com, hch@lst.de, agk@redhat.com,
        snitzer@redhat.com, rgoldwyn@suse.de, qi.fuli@fujitsu.com,
        y-goto@fujitsu.com
Subject: Re: [PATCH v3 02/11] blk: Introduce ->corrupted_range() for block
 device
Message-ID: <20210210132139.GC30109@lst.de>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com> <20210208105530.3072869-3-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208105530.3072869-3-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 06:55:21PM +0800, Shiyang Ruan wrote:
> In fsdax mode, the memory failure happens on block device.  So, it is
> needed to introduce an interface for block devices.  Each kind of block
> device can handle the memory failure in ther own ways.

As told before: DAX operations please do not add anything to the block
device.  We've been working very hard to decouple DAX from the block
device, and while we're not done regressing the split should not happen.
