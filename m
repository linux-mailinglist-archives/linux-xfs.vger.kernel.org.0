Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E846C2106B4
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jul 2020 10:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGAItS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Jul 2020 04:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgGAItR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:49:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D26C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7pzpKhGkysdjVxYDN55Qd9fX5cGpgc07J+JW7VH+uP8=; b=Ekb/beKqNH+mdhSmCvlbjpAoIV
        qoMy7//ob+qiEGw2VNTFfvo+mUBdpWIqHnkp/crKqi8SLzj/fMSd0Xfn+y7oryT5BMI19KmvWfRVQ
        hfKOqiEM4U4S4gHOF4uIwZcnUBPg8zZcWIaeGo32pOeSfZ4+G7/WcPAgKLRZjsCreIHmx5hfXkO9V
        Yz5AD4GPOgHDW+3ysKCYNhbhkoIQSTHqUFFpk6cz59ABm9ONi+NXmuFnsOh2SYyi5z2gOfqU4KJw3
        V/fGttcvEuuPqOFFYYJ83OPgzZVIquF8hJ3Fxeki7kecAMEF0DVTARoae/LU9HLp8NtZZ1s+ZYwQc
        DHxTgkYw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYQd-0007Y8-7o; Wed, 01 Jul 2020 08:49:15 +0000
Date:   Wed, 1 Jul 2020 09:49:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/18] xfs: use a per-resource struct for incore dquot
 data
Message-ID: <20200701084915.GF25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353174945.2864738.16786596402939892293.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353174945.2864738.16786596402939892293.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:42:29AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new struct xfs_dquot_res that we'll use to track all the
> incore data for a particular resource type (block, inode, rt block).
> This will help us (once we've eliminated q_core) to declutter quota
> functions that currently open-code field access or pass around fields
> around explicitly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
