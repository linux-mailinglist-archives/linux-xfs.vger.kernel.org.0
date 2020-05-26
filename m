Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2164919BD10
	for <lists+linux-xfs@lfdr.de>; Thu,  2 Apr 2020 09:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387585AbgDBHvJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 Apr 2020 03:51:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41930 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387565AbgDBHvJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 03:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ob+ccIPBzuf4AOBFITbmq0LQOQ9wS0Ztt/Q4mf6ztJk=; b=KNUAjKLJ7PtIJafRLPF6NBzHhd
        1qUrKq8+u6+hXGoHSNvACQfeyKMLxCXVMTaI+knWaGmPJH2Q0tTlkFG3lppePaXjlp/17oEdg69y+
        RgG+hOU2h1bcJ5rcC0E3j4C2GMfGqjaBevvNQVxh+yXZpCxWT9Zyo1Py+TrM3Xq2I8fTTe/5EocG7
        8phC0BpMI/mzQlywIUuQqpXYZPLIydrOLt9Rq6j8Kt99cAdtfBt6vPV1p/8i2poyNhINdWIGs1b2K
        HHv2Ejibbk9CmH0gy5BNZRZ2j1PuPxjDEG260yZDa1d24HwQ00w8TAA3pnFxD7sKK+YwMlfgzy01W
        trlcXPmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJud2-0007I2-LD; Thu, 02 Apr 2020 07:51:08 +0000
Date:   Thu, 2 Apr 2020 00:51:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reflink should force the log out if mounted with
 wsync
Message-ID: <20200402075108.GB17191@infradead.org>
References: <20200402041705.GD80283@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402041705.GD80283@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 01, 2020 at 09:17:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reflink should force the log out to disk if the filesystem was mounted
> with wsync, the same as most other operations in xfs.

Looks reasonable.  That being said I really hate the way we handle
this - I've been wanting to rework the wsync/dirsync code to just mark
as transaction as dirsync or wsync and then let xfs_trans_commit handle
checking if the file system is mounted with the option to clean this
mess up.  Let me see if I could resurrect that quickly.
