Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7982A528D3
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 11:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbfFYJ7t (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 05:59:49 -0400
Received: from verein.lst.de ([213.95.11.211]:33304 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbfFYJ7t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 05:59:49 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id E4D3868B02; Tue, 25 Jun 2019 11:59:17 +0200 (CEST)
Date:   Tue, 25 Jun 2019 11:59:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] shared/011: run on all file system that support cgroup
 writeback
Message-ID: <20190625095917.GB1462@lst.de>
References: <20190624134407.21365-1-hch@lst.de> <20190624150839.GB6350@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624150839.GB6350@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 11:08:39AM -0400, Theodore Ts'o wrote:
> Per my comments in another e-mail thread, given how many of the
> primary file systems support cgroup-aware writeback, maybe we should
> just remove the _supported_fs line and move this test to generic?
> 
> Whether we like it or not, there are more and more userspace tools
> which assume that cgroup-aware writeback is a thing.
> 
> Alternatively, maybe we should have some standardized way so the
> kernel can signal whether or not a particular mounted file system
> supports cgroup-aware writeback?

I'm fine with moving the patch to generic as said.  I'm fine saying
we assume cgroup wb support for block device based file systems,
xfs was the only major one missing, and the support is pretty trivial
as well.
