Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377EB330901
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Mar 2021 08:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhCHHzV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Mar 2021 02:55:21 -0500
Received: from verein.lst.de ([213.95.11.211]:54500 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231176AbhCHHzE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 02:55:04 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7A43368B02; Mon,  8 Mar 2021 08:55:02 +0100 (CET)
Date:   Mon, 8 Mar 2021 08:55:01 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH 4/4] xfs: drop freeze protection when running GETFSMAP
Message-ID: <20210308075501.GC983@lst.de>
References: <161514874040.698643.2749449122589431232.stgit@magnolia> <161514876275.698643.12226309352552265069.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161514876275.698643.12226309352552265069.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 07, 2021 at 12:26:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A recent log refactoring patchset from Brian Foster relaxed fsfreeze
> behavior with regards to the buffer cache -- now freeze only waits for
> pending buffer IO to finish, and does not try to drain the buffer cache
> LRU.  As a result, fsfreeze should no longer stall indefinitely while
> fsmap runs.  Drop the sb_start_write calls around fsmap invocations.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
