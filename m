Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB40BBC0C
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Sep 2019 21:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfIWTKC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 23 Sep 2019 15:10:02 -0400
Received: from verein.lst.de ([213.95.11.211]:43963 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbfIWTKC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Sep 2019 15:10:02 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AEACF227A81; Mon, 23 Sep 2019 21:09:59 +0200 (CEST)
Date:   Mon, 23 Sep 2019 21:09:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix userdata allocation detection regression
Message-ID: <20190923190959.GA6383@lst.de>
References: <20190920021943.26930-1-hch@lst.de> <20190923124836.GC6924@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923124836.GC6924@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 23, 2019 at 08:48:36AM -0400, Brian Foster wrote:
> Prior to this change (and commit 1baa2800e62d), something like an xattr
> remote value block would not be considered user data. As of this change,
> that is no longer the case. That seems reasonable on first thought (it
> is user data after all), but I'm not so sure it's appropriate once you
> look through some of the ways xfs_alloc_is_userdata() is used.

True.  Let's just revert the original patch for now, and sort out the
mess of these flags properly later.
