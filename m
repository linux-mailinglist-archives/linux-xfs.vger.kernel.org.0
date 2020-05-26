Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502611CC317
	for <lists+linux-xfs@lfdr.de>; Sat,  9 May 2020 19:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgEIRLk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 9 May 2020 13:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRLk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:11:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F2BC061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2VLq5SzJmMEDnfdDcNi9AwTqPtP7yxRMBE5RNp9DTok=; b=YcDjg8ysJy11Wz8LDR2nVw31t5
        8CJy5dIjEo5LmcqDtNoCKNA4fAsQ9p9JeAhg/Q/Bw3AriLhcmctcXg7Y5oyLb0bmZUfVH/qeejaQN
        5xEt/toc8dsw+C8f8tXdgmHJoV/hfqglASxdIRz35hGWUs23FD+s4KQyEwy9luhz8V9zIf9Fcj2Kq
        aeWB2W08adclD5KIFtFqsG/3zE6rKG2vIjCTbY0hlPR1TtBUUrJRqxj+R1BraalxO9VdhfTICHifo
        vDzUkmLfolCpOTly+ukVE1FVE9i+E1s/ZPSoAefwPQcn3O2l/Q5virX3hA1eAeGVmYb/j/N8KASRz
        M5d6+OLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXT0l-0003aA-Hf; Sat, 09 May 2020 17:11:39 +0000
Date:   Sat, 9 May 2020 10:11:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/16] xfs_repair: check for out-of-order inobt records
Message-ID: <20200509171139.GE12777@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904182463.982941.12723858451786554882.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904182463.982941.12723858451786554882.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:30:24AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that the inode btree records are in order.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
