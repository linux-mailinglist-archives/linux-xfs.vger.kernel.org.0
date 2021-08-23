Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E0D3F4B38
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Aug 2021 14:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbhHWM7J (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 23 Aug 2021 08:59:09 -0400
Received: from verein.lst.de ([213.95.11.211]:47818 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235731AbhHWM7I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Aug 2021 08:59:08 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A97B367357; Mon, 23 Aug 2021 14:58:24 +0200 (CEST)
Date:   Mon, 23 Aug 2021 14:58:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
        dan.j.williams@intel.com, david@fromorbit.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nvdimm@lists.linux.dev, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject: Re: [PATCH v7 5/8] iomap: Introduce iomap_iter2 for two files
Message-ID: <20210823125824.GB15536@lst.de>
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com> <20210816060359.1442450-6-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816060359.1442450-6-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 16, 2021 at 02:03:56PM +0800, Shiyang Ruan wrote:
> Some operations, such as comparing a range of data in two files under
> fsdax mode, requires nested iomap_begin()/iomap_end() on two files.
> Thus, we introduce iomap_iter2() to accept two iteraters to operate
> action on two files.

We really should not need both.  We should be able to be in two
nested loops, just operating on the part that both cover (for which
a helper might be useful).
