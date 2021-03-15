Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFBF33C636
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Mar 2021 19:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhCOS4Z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Mar 2021 14:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhCOS4X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 14:56:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4706EC06174A
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 11:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0eaukA6mwYOe9UcOG+tGRtEKJC2fMH2+a8MJvb/WI/c=; b=TrESPHbLKfpLFsqvaNuHFiL4R4
        4iOp7Wz/2UmqiwDUe1wuSNZLwj5+TTJXmYeCu5DeGMWmEF/Xh4ewHY5CZ32LgSZH/1LHUSZ+A1r7B
        3k3FbresRjV/G01d0F0ZVeHItS3PmmZaAzD2GbdZFFlFObgqYNg+A2kz7byLjbqi60pzHK4mQUq52
        uBJI8kF5TDxjawMZU3YjzxoOBXlOwh2/m2PiMa2lY8UUrXG8IKp4oJvTgdO/Lx/CHcy7uyDZH3ZxC
        9jcYVEN9zRHOiBOrs1+P4G2YgpKWnXYcVmAZPUeFhvSQ5LSMEldEi7ZHHdGqvClUJC66nuk0LpnDJ
        HazZ4z8Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lLsNb-000cmM-GM; Mon, 15 Mar 2021 18:55:57 +0000
Date:   Mon, 15 Mar 2021 18:55:51 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: parallelize inode inactivation
Message-ID: <20210315185551.GF140421@infradead.org>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543199635.1947934.2885924822578773349.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543199635.1947934.2885924822578773349.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 07:06:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Split the inode inactivation work into per-AG work items so that we can
> take advantage of parallelization.

Any reason this isn't just done from the beginning?  As-is is just
seems to create a fair amount of churn.
